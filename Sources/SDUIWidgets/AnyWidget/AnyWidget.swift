//
//  AnyWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUICore

public struct AnyWidget: WidgetProtocol {
    public typealias Data = Never
    public var data: Never { fatalError("AnyWidget.data should not be accessed directly.") }
    
    nonisolated public init(data: Never) {
        fatalError("AnyWidget.init(data:) should not be called.")
    }
    
    let widget: any WidgetProtocol
    
    // !!!: Order-sensitive!
    static let supportedWidgetTypes: [any WidgetProtocol.Type] = [
        LabelWidget.self,
        ForegroundColorWidget.self,
        ColorWidget.self,
        SystemImageWidget.self,
        ShapeWidget.self,
        ButtonWidget.self,
        PaddingWidget.self,
        BackgroundWidget.self,
        ClipShapeWidget.self,
        BorderWidget.self,
        TabWidget.self,
        TransitionWidget.self,
        ScaffoldWidget.self,
        FrameWidget.self,
        ImageWidget.self,
        TextWidget.self,
        LayoutWidget.self,
        ListSectionWidget.self,
        TimerWidget.self,
    ]
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(widget)
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        for widgetType in (WidgetRegistrar.shared.widgetTypes + AnyWidget.supportedWidgetTypes) {
            if let widget = try? container.decode(widgetType) {
                self.widget = widget
                return
            }
        }
        throw WidgetError.unsupportedWidgetType
    }
    
    public init(_ widget: any WidgetProtocol) {
        if let anyWidget = widget as? AnyWidget {
            self = anyWidget
        } else {
            self.widget = widget
        }
    }
    
    public func `as`<T>(_ widgetType: T.Type) -> T? where T: WidgetProtocol {
        widget as? T
    }
}

extension AnyWidget: ExpressibleByStringLiteral {
    nonisolated public init(stringLiteral value: String) {
        self.init(TextWidget(stringLiteral: value))
    }
}

extension AnyWidget: ExpressibleByStringInterpolation {
    nonisolated public init(stringInterpolation: DefaultStringInterpolation) {
        self.init(TextWidget(stringInterpolation: stringInterpolation))
    }
}

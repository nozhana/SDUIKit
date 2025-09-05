//
//  AnyWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUICore

/// A type-erased widget.
public struct AnyWidget: WidgetProtocol {
    public typealias Data = Never
    public var data: Never { fatalError("AnyWidget.data should not be accessed directly.") }
    
    nonisolated public init(data: Never) {
        fatalError("AnyWidget.init(data:) should not be called.")
    }
    
    let widget: any WidgetProtocol
    
    // !!!: Order-sensitive!
    static let supportedWidgetTypes: [any WidgetProtocol.Type] = [
        StatefulWidget.self,
        ToggleWidget.self,
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
    
    /// Erase a widget's type by converting it to an ``AnyWidget``.
    /// - Parameter widget: Any widget.
    ///
    /// ```swift
    /// let myWidget = MyWidget(data: .init(foo: "bar"))
    ///
    /// let anyWidget = AnyWidget(myWidget)
    /// ```
    public init(_ widget: any WidgetProtocol) {
        if let anyWidget = widget as? AnyWidget {
            self = anyWidget
        } else {
            self.widget = widget
        }
    }
    
    /// Initialize an ``AnyWidget`` using a ``WidgetContentBuilder``.
    /// - Parameter content: A ``WidgetContentBuilder`` function generating a single widget.
    public init(@WidgetContentBuilder content: @escaping () -> AnyWidget) {
        self = content()
    }
    
    /// Initialize an ``AnyWidget`` using a ``WidgetEnum``.
    /// - Parameter widgetEnum: A widget enum.
    public init(_ widgetEnum: WidgetEnum) {
        self.init(widgetEnum.widget)
    }
    
    /// Cast the inner widget type to a given widget type conditionally.
    /// - Parameter widgetType: The widget type to cast the inner widget as.
    /// - Returns: The resulting widget, if the inner widget can be successfully cast as the given type.
    ///
    /// ```swift
    /// let myWidget = MyWidget(data: .init(foo: "bar"))
    /// let anyWidget = AnyWidget(myWidget)
    /// let castWidget = anyWidget.as(MyWidget.self)!
    ///
    /// // myWidget == castWidget
    /// ```
    public func `as`<T>(_ widgetType: T.Type) -> T? where T: WidgetProtocol {
        widget as? T
    }
}

public extension WidgetProtocol {
    /// Erase this widget to an ``AnyWidget`` type.
    /// - Returns: The erased ``AnyWidget``.
    ///
    /// Refer to: ``AnyWidget/init(_:)-(WidgetProtocol)``
    func eraseToAnyWidget() -> AnyWidget {
        .init(self)
    }
}

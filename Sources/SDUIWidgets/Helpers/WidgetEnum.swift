//
//  WidgetEnum.swift
//  SDUIKit
//
//  Created by Nozhan A. on 9/3/25.
//

import Foundation
import SDUICore

/// A helper to represent a widget instance in a ``WidgetContentBuilder`` tree.
public enum WidgetEnum {
    case text(_ content: String, properties: TextWidget.Data.Properties? = nil)
    case image(_ url: URL, ratio: Double? = nil, resizeMode: ResizeMode? = nil)
    case icon(_ name: String, resizeMode: ResizeMode? = nil)
    case button(action: ButtonAction, style: ButtonStyle? = nil, label: AnyWidget)
    case color(_ hex: String)
    case label(title: AnyWidget, icon: AnyWidget)
    case shape(_ shape: Shape, fill: String? = nil)
    case timer(deadline: Date? = nil, countdown: Int? = nil, properties: TextWidget.Data.Properties? = nil)
    case padding(_ padding: Double, edges: Edges? = nil, content: AnyWidget)
    case row(alignment: VerticalAlignment? = nil, spacing: Double? = nil, items: [AnyWidget])
    case column(alignment: HorizontalAlignment? = nil, spacing: Double? = nil, items: [AnyWidget])
    case stack(alignment: Alignment? = nil, items: [AnyWidget])
    case frame(width: Double? = nil, height: Double? = nil, alignment: Alignment? = nil, content: AnyWidget)
    case scaffold(_ title: String, inline: Bool? = nil, toolbar: [AnyWidget]? = nil, destinations: [String: ScaffoldDestinationWidget]? = nil, content: AnyWidget)
    
    case custom(AnyWidget)
    
    public static func button(action: ButtonAction, style: ButtonStyle? = nil, @WidgetContentBuilder label: @escaping () -> AnyWidget) -> WidgetEnum {
        .button(action: action, style: style, label: label())
    }
    
    public static func label(@WidgetContentBuilder title: @escaping () -> AnyWidget, @WidgetContentBuilder icon: @escaping () -> AnyWidget) -> WidgetEnum {
        .label(title: title(), icon: icon())
    }
    
    public static func padding(_ padding: Double, edges: Edges? = nil, @WidgetContentBuilder content: @escaping () -> AnyWidget) -> WidgetEnum {
        .padding(padding, edges: edges, content: content())
    }
    
    public static func row(alignment: VerticalAlignment? = nil, spacing: Double? = nil, @WidgetContentBuilder items: @escaping () -> [AnyWidget]) -> WidgetEnum {
        .row(alignment: alignment, spacing: spacing, items: items())
    }
    
    public static func column(alignment: HorizontalAlignment? = nil, spacing: Double? = nil, @WidgetContentBuilder items: @escaping () -> [AnyWidget]) -> WidgetEnum {
        .column(alignment: alignment, spacing: spacing, items: items())
    }
    
    public static func stack(alignment: Alignment? = nil, @WidgetContentBuilder items: @escaping () -> [AnyWidget]) -> WidgetEnum {
        .stack(alignment: alignment, items: items())
    }
    
    public static func frame(width: Double? = nil, height: Double? = nil, alignment: Alignment? = nil, @WidgetContentBuilder content: @escaping () -> AnyWidget) -> WidgetEnum {
        .frame(width: width, height: height, alignment: alignment, content: content())
    }
    
    public static func scaffold(_ title: String, inline: Bool? = nil, destinations: [String: ScaffoldDestinationWidget]? = nil, @WidgetContentBuilder toolbar: () -> [AnyWidget]? = { nil }, @WidgetContentBuilder content: @escaping () -> AnyWidget) -> WidgetEnum {
        .scaffold(title, inline: inline, toolbar: toolbar(), destinations: destinations, content: content())
    }
    
    public static func custom(@WidgetContentBuilder content: @escaping () -> AnyWidget) -> WidgetEnum {
        .custom(content())
    }
    
    var widget: any WidgetProtocol {
        switch self {
        case .text(let content, let properties):
            TextWidget(data: .init(content: content, properties: properties))
        case .image(let url, let ratio, let resizeMode):
            ImageWidget(data: .init(imageURL: url, ratio: ratio, resizeMode: resizeMode))
        case .icon(let name, let resizeMode):
            SystemImageWidget(data: .init(name: name, resizeMode: resizeMode))
        case .button(let action, let style, let label):
            ButtonWidget(data: .init(action: action, style: style, label: label))
        case .color(let hex):
            ColorWidget(data: .init(color: hex))
        case .label(let title, let icon):
            LabelWidget(data: .init(title: title, icon: icon))
        case .shape(let shape, let fill):
            ShapeWidget(data: .init(shape: shape, fill: fill.map { ColorWidget(data: .init(color: $0)) }))
        case .timer(let deadline, let countdown, let properties):
            TimerWidget(data: .init(deadline: deadline, countdown: countdown, properties: properties))
        case .padding(let padding, let edges, let content):
            PaddingWidget(data: .init(length: padding, edges: edges, content: content))
        case .row(let alignment, let spacing, let items):
            LayoutWidget(data: .init(layout: .horizontal, alignment: alignment?.generalAlignment, spacing: spacing, items: items))
        case .column(let alignment, let spacing, let items):
            LayoutWidget(data: .init(layout: .vertical, alignment: alignment?.generalAlignment, spacing: spacing, items: items))
        case .stack(let alignment, let items):
            LayoutWidget(data: .init(layout: .perpendicular, alignment: alignment, items: items))
        case .frame(let width, let height, let alignment, let content):
            FrameWidget(data: .init(width: width, height: height, alignment: alignment, content: content))
        case .scaffold(let title, let inline, let toolbar, let destinations, let content):
            ScaffoldWidget(data: .init(title: title, inline: inline, toolbar: toolbar, destinations: destinations, content: content))
        case .custom(let content):
            content
        }
    }
}

prefix operator /

public prefix func /(_ widgetEnum: WidgetEnum) -> any WidgetProtocol {
    widgetEnum.widget
}

@_disfavoredOverload
public prefix func /(_ widgetEnum: WidgetEnum) -> AnyWidget {
    AnyWidget(widgetEnum.widget)
}

public prefix func /(_ widget: any WidgetProtocol) -> any WidgetProtocol {
    widget
}

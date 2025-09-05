//
//  Types.swift
//  SDUIMacros
//
//  Created by Nozhan A. on 8/31/25.
//

/// Represents an entry in a widget's ``WidgetProtocol/data-swift.property``.
public enum WidgetArgument: Sendable {
    case boolean(_ name: String, optional: Bool = false)
    case string(_ name: String, optional: Bool = false)
    case stringArray(_ name: String, optional: Bool = false)
    case integer(_ name: String, optional: Bool = false)
    case double(_ name: String, optional: Bool = false)
    case widget(_ name: String, optional: Bool = false)
    case widgets(_ name: String, optional: Bool = false)
    case custom(_ name: String, type: (Codable & Sendable).Type, optional: Bool = false)
    
    /// A shorthand for a variable of type `AnyWidget` named `content`.
    public static let content = widget("content")
    /// A shorthand for a variable of type `[AnyWidget]` named `items`.
    public static let items = widgets("items")
}

/// Represents empty data for a widget.
///
/// This will be the default value for a `WidgetBuilder` with no arguments.
public struct EmptyWidgetData: Codable, Sendable {
    public init() {}
    public static let empty = EmptyWidgetData()
}

//
//  Types.swift
//  SDUIMacros
//
//  Created by Nozhan A. on 8/31/25.
//

public enum WidgetArgument: Sendable {
    case boolean(_ name: String, optional: Bool = false)
    case string(_ name: String, optional: Bool = false)
    case stringArray(_ name: String, optional: Bool = false)
    case integer(_ name: String, optional: Bool = false)
    case double(_ name: String, optional: Bool = false)
    case widget(_ name: String, optional: Bool = false)
    case widgets(_ name: String, optional: Bool = false)
    case custom(_ name: String, type: (Codable & Sendable).Type, optional: Bool = false)
    
    public static let content = widget("content")
    public static let items = widgets("items")
}

public struct EmptyWidgetData: Codable, Sendable {
    public init() {}
    public static let empty = EmptyWidgetData()
}

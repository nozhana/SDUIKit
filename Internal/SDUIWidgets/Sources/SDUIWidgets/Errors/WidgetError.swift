//
//  WidgetError.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import Foundation

public enum WidgetError: LocalizedError, CustomStringConvertible {
    case invalidUtf8String
    case unknownDataType(String)
    case unsupportedWidgetType
    
    public var description: String {
        switch self {
        case .invalidUtf8String: "Invalid UTF-8 string."
        case .unknownDataType(let message): "Unknown data type: \(message)"
        case .unsupportedWidgetType: "Unsupported widget type."
        }
    }
    
    public var errorDescription: String? { description }
}

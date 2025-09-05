//
//  WidgetError.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import Foundation

/// An error representing a fault in widget parsing.
public enum WidgetError: LocalizedError, CustomStringConvertible {
    case invalidUtf8String
    /// Thrown when the provided string key is unrecognized.
    case unknownDataType(String)
    /// Thrown when the object provided cannot be decoded into any known or registered widgets.
    case unsupportedWidgetType
    
    /// The error description.
    public var description: String {
        switch self {
        case .invalidUtf8String: "Invalid UTF-8 string."
        case .unknownDataType(let message): "Unknown data type: \(message)"
        case .unsupportedWidgetType: "Unsupported widget type."
        }
    }
    
    /// Same as ``description``.
    ///
    /// Declared for conformance to `LocalizedError`.
    public var errorDescription: String? { description }
}

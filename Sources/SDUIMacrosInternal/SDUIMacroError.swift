//
//  SDUIMacroError.swift
//  SDUIMacros
//
//  Created by Nozhan A. on 8/31/25.
//

import Foundation

enum SDUIMacroError: LocalizedError, CustomStringConvertible {
    case widgetBuilderOnlyInstalledOnWidgets
    case unnamedDeclaration
    case invalidArgument(_ type: Any.Type? = nil)
    
    static let invalidArgument = invalidArgument()
    
    var description: String {
        switch self {
        case .widgetBuilderOnlyInstalledOnWidgets: "WidgetBuilder macro can only be installed on a widget."
        case .unnamedDeclaration: "This macro does not work on unnamed declarations."
        case .invalidArgument(let type?): "Invalid type: \(String(describing: type))"
        case .invalidArgument(nil): "Invalid type."
        }
    }
    
    var errorDescription: String? { description }
}

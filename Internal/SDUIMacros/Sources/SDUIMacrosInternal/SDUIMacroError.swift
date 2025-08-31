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
    
    var description: String {
        switch self {
        case .widgetBuilderOnlyInstalledOnWidgets: "WidgetBuilder macro can only be installed on a widget"
        case .unnamedDeclaration: "This macro does not work on unnamed declarations."
        }
    }
    
    var errorDescription: String? { description }
}

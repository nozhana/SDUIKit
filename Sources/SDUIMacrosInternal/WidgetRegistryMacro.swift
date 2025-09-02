//
//  WidgetRegistryMacro.swift
//  SDUIMacros
//
//  Created by Nozhan A. on 9/3/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum WidgetRegistryMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        "WidgetRegistrar.register(\(node.arguments))"
    }
}

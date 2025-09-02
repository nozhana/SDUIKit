//
//  EntryPoint.swift
//  SDUIMacros
//
//  Created by Nozhan A. on 8/31/25.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SDUIMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        WidgetBuilderMacro.self,
        WidgetRegistryMacro.self,
    ]
}

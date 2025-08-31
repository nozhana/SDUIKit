//
//  WidgetBuilderMacro+MemberMacro.swift
//  SDUIMacros
//
//  Created by Nozhan A. on 8/31/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct WidgetBuilderMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // guard let structDecl = declaration.as(StructDeclSyntax.self),
        //       let inheritanceClause = structDecl.inheritanceClause,
        //       inheritanceClause.inheritedTypes.contains(where: {
        //           if let identifierType = $0.type.as(IdentifierTypeSyntax.self),
        //              ["WidgetView", "WidgetProtocol"].contains(identifierType.name.text) {
        //               return true
        //           }
        //           return false
        //       }) else { throw SDUIMacroError.widgetBuilderOnlyInstalledOnWidgets }
        
        var dataType = "Data"
        
        if case .argumentList(let arguments) = node.arguments,
           arguments.first?.label?.text == "of",
           let memberAccessExpr = arguments.first?.expression.as(MemberAccessExprSyntax.self),
           let baseName = memberAccessExpr.base?.as(DeclReferenceExprSyntax.self)?.baseName.text {
            dataType = baseName
        }
        
        if node.arguments == nil {
            dataType = "EmptyWidgetData"
        }
        
        if case .argumentList(let arguments) = node.arguments,
           arguments.isEmpty {
            dataType = "EmptyWidgetData"
        }
        
        var acl: DeclModifierSyntax = .init(name: .keyword(.internal))
        
        let aclModifiers: Set<String> = .init([TokenSyntax.keyword(.open), .keyword(.public), .keyword(.internal), .keyword(.fileprivate), .keyword(.private)].map(\.text))
        
        if let aclModifier = declaration.modifiers.first(where: { aclModifiers.contains($0.name.text) }) {
            acl = aclModifier.trimmed
        }
        
        let dataVarDecl: DeclSyntax = "\(acl) var data: \(raw: dataType)"
        
        let initDecl: DeclSyntax = """
nonisolated \(acl) init(data: \(raw: dataType)) {
    self.data = data
}
"""
        return [dataVarDecl, initDecl]
    }
}

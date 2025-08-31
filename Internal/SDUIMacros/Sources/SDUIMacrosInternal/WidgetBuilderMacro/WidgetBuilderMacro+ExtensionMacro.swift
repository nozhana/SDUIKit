//
//  WidgetBuilderMacro+ExtensionMacro.swift
//  SDUIMacros
//
//  Created by Nozhan A. on 8/31/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension WidgetBuilderMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let namedDecl = declaration.asProtocol(NamedDeclSyntax.self) else {
            throw SDUIMacroError.unnamedDeclaration
        }
        let name = namedDecl.name
        
        let aclModifiers: Set<String> = Set([TokenSyntax.keyword(.open), .keyword(.public), .keyword(.internal), .keyword(.fileprivate), .keyword(.private)].map(\.text))
        var acl: DeclModifierSyntax = .init(name: .keyword(.internal))
        if let modifier = declaration.modifiers.first(where: { aclModifiers.contains($0.name.text) }) {
            acl = modifier.trimmed
        }
        
        var extensionExpr = try ExtensionDeclSyntax("extension \(name): WidgetProtocol {}")
        
        guard case .argumentList(let arguments) = node.arguments,
              !arguments.contains(where: { $0.label?.text == "of" }) else {
            return [extensionExpr]
        }
        
        let functionCalls = arguments.compactMap({ $0.expression.as(FunctionCallExprSyntax.self) })
        if functionCalls.isEmpty {
            return [extensionExpr]
        }
        
        var (variables, initParams, initializerBlocks): ([VariableDeclSyntax], [FunctionParameterSyntax], [CodeBlockItemSyntax]) = try functionCalls.reduce(into: ([], [], [])) { partialResult, functionCall in
            guard var typeName = functionCall.calledExpression.as(MemberAccessExprSyntax.self)?.declName.baseName.text,
                  let variableName = functionCall.arguments.first?.expression
                .as(StringLiteralExprSyntax.self)?
                .segments.first?
                .as(StringSegmentSyntax.self)?
                .content.text else { return }
            
            if let typeArg = functionCall.arguments.first(labeled: "type"),
               let type = typeArg.expression.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)?.content.text {
                typeName = type
            }
            
            var optional = typeName.hasSuffix("?")
            if let optionalArg = functionCall.arguments.first(labeled: "optional"),
               let boolean = optionalArg.expression.as(BooleanLiteralExprSyntax.self),
               boolean.literal.text == "true" {
                optional = true
            }
            
            var typeAnnotation: String = switch typeName {
            case "string": "String"
            case "stringArray": "[String]"
            case "integer": "Int"
            case "double": "Double"
            case "widget": "AnyWidget"
            case "widgets": "[AnyWidget]"
            default: typeName
            }
            
            if optional, !typeName.hasSuffix("?") {
                typeAnnotation += "?"
            }
            
            let variableDecl = try VariableDeclSyntax("\(acl) var \(raw: variableName): \(raw: typeAnnotation)")
            var parameterDecl: FunctionParameterSyntax = "\(raw: variableName): \(raw: typeAnnotation),"
            if optional {
                parameterDecl.defaultValue = InitializerClauseSyntax(value: NilLiteralExprSyntax())
            }
            let initializerBlock = CodeBlockItemSyntax("self.\(raw: variableName) = \(raw: variableName)")
            partialResult.0.append(variableDecl)
            partialResult.1.append(parameterDecl)
            partialResult.2.append(initializerBlock)
        }
        if var last = initParams.popLast() {
            last.trailingComma = nil
            initParams.append(last)
        }
        
        guard !variables.isEmpty else {
            throw MacroExpansionErrorMessage("Unresolved state: No variables mapped from function calls")
        }
        
        var dataDecl = try StructDeclSyntax("\(acl) struct Data: Decodable, Sendable {}")
        
        dataDecl.memberBlock = MemberBlockSyntax(members: MemberBlockItemListSyntax(variables.map { MemberBlockItemSyntax(decl: $0) }))
        
        let signature: FunctionSignatureSyntax = .init(parameterClause: .init(parameters: .init(initParams)))
        
        let dataInitDecl = try InitializerDeclSyntax("\(acl) init\(signature)") {
            initializerBlocks
        }
        
        dataDecl.memberBlock.members.append(MemberBlockItemSyntax(decl: dataInitDecl))
        
        extensionExpr.memberBlock.members.append(MemberBlockItemSyntax(decl: dataDecl))
        
        return [extensionExpr]
    }
}

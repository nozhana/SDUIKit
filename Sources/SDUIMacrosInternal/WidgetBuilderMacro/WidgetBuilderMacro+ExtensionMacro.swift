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
        
        var (variables, initParams, initializerBlocks): ([VariableDeclSyntax], [FunctionParameterSyntax], [CodeBlockItemSyntax]) = try functionCalls.reduce(into: ([], [], [])) { partialResult, functionCall in
            guard let typeName = functionCall.calledExpression.as(MemberAccessExprSyntax.self)?.declName.baseName.text,
                  let variableName = functionCall.arguments.first?.expression
                .as(StringLiteralExprSyntax.self)?
                .segments.first?
                .as(StringSegmentSyntax.self)?
                .content.text else { return }
            
            var typeAnnotation: ExprSyntax = "\(raw: typeName)"
            
            if let typeArg = functionCall.arguments.first(labeled: "type") {
                if let type = typeArg.expression.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)?.content.text {
                    typeAnnotation = "\(raw: type)"
                } else if let memberAccessExpr = typeArg.expression.as(MemberAccessExprSyntax.self) {
                    let baseExpr: ExprSyntax
                    if memberAccessExpr.declName.baseName.text == "self" {
                        baseExpr = memberAccessExpr.base!
                    } else {
                        baseExpr = ExprSyntax(memberAccessExpr)
                    }
                    typeAnnotation = baseExpr
                }
            }
            
            var optional = typeName.hasSuffix("?")
            if let optionalArg = functionCall.arguments.first(labeled: "optional"),
               let boolean = optionalArg.expression.as(BooleanLiteralExprSyntax.self),
               boolean.literal.text == "true" {
                optional = true
            }
            
            typeAnnotation = switch typeName {
            case "boolean": "Bool"
            case "string": "String"
            case "stringArray": "[String]"
            case "integer": "Int"
            case "double": "Double"
            case "widget": "AnyWidget"
            case "widgets": "[AnyWidget]"
            default: typeAnnotation
            }
            
            if optional, !typeName.hasSuffix("?") {
                typeAnnotation = "\(typeAnnotation)?"
            }
            
            let variableDecl = try VariableDeclSyntax("\(acl) var \(raw: variableName): \(raw: typeAnnotation)")
            var parameterDecl: FunctionParameterSyntax = "\(raw: variableName): \(raw: typeAnnotation),"
            if optional {
                parameterDecl.defaultValue = InitializerClauseSyntax(value: NilLiteralExprSyntax())
            }
            let initializerBlock: CodeBlockItemSyntax
            if ["widget", "widgets"].contains(typeName) {
                parameterDecl.attributes = "@WidgetContentBuilder "
                if typeName == "widgets" {
                    parameterDecl.type = "@escaping () -> [AnyWidget]"
                } else {
                    parameterDecl.type = "@escaping () -> AnyWidget"
                }
                initializerBlock = CodeBlockItemSyntax("self.\(raw: variableName) = \(raw: variableName)()")
            } else {
                initializerBlock = CodeBlockItemSyntax("self.\(raw: variableName) = \(raw: variableName)")
            }
            partialResult.0.append(variableDecl)
            partialResult.1.append(parameterDecl)
            partialResult.2.append(initializerBlock)
        }
        
        let memberAccessExprs = arguments.compactMap( { $0.expression.as(MemberAccessExprSyntax.self) })
        
        try memberAccessExprs
            .map(\.declName.baseName.text)
            .filter(["content", "items"].contains)
            .map { key -> (key: String, type: String) in
                if key == "items" {
                    (key, "[AnyWidget]")
                } else {
                    (key, "AnyWidget")
                }
            }
            .forEach { (key, type) in
                let variableDecl = try VariableDeclSyntax("\(acl) var \(raw: key): \(raw: type)")
                let parameterDecl = FunctionParameterSyntax("@WidgetContentBuilder \(raw: key): @escaping () -> \(raw: type),")
                let initializerBlock = CodeBlockItemSyntax("self.\(raw: key) = \(raw: key)()")
                variables.append(variableDecl)
                initParams.append(parameterDecl)
                initializerBlocks.append(initializerBlock)
            }
        
        if var last = initParams.popLast() {
            last.trailingComma = nil
            initParams.append(last)
        }
        
        guard !variables.isEmpty else {
            return [extensionExpr]
        }
        
        var dataDecl = try StructDeclSyntax("\(acl) struct Data: Codable, Sendable {}")
        
        dataDecl.memberBlock = MemberBlockSyntax(members: MemberBlockItemListSyntax(variables.map { MemberBlockItemSyntax(decl: $0) }))
        
        let signature: FunctionSignatureSyntax = .init(parameterClause: .init(parameters: .init(initParams)))
        
        let dataInitDecl = try InitializerDeclSyntax("\(acl) init\(signature)") {
            initializerBlocks
        }
        
        var shouldAddSimpleInit = false
        var simpleBlocks = initializerBlocks
        var simpleParams = initParams
        
        for index in 0..<initParams.count {
            guard let functionType = initParams[index].type.as(AttributedTypeSyntax.self)?.baseType.as(FunctionTypeSyntax.self) else { continue }
            shouldAddSimpleInit = true
            let variableName = initParams[index].firstName.text
            simpleParams[index] = "\(raw: variableName): \(functionType.returnClause.type),"
            
            simpleBlocks[index] = "self.\(raw: variableName) = \(raw: variableName)"
        }
        
        if var lastParam = simpleParams.popLast() {
            lastParam.trailingComma = nil
            simpleParams.append(lastParam)
        }
        
        let simpleSignature: FunctionSignatureSyntax = .init(parameterClause: .init(parameters: .init(simpleParams)))
        var simpleInitDecl = dataInitDecl
        simpleInitDecl.signature = simpleSignature
        simpleInitDecl.body = .init(statements: .init(simpleBlocks))
        
        dataDecl.memberBlock.members.append(MemberBlockItemSyntax(decl: dataInitDecl))
        if shouldAddSimpleInit {
            dataDecl.memberBlock.members.append(MemberBlockItemSyntax(decl: simpleInitDecl))
        }
        
        extensionExpr.memberBlock.members.append(MemberBlockItemSyntax(decl: dataDecl))
        
        return [extensionExpr]
    }
}

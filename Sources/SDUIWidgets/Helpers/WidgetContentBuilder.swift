//
//  WidgetContentBuilder.swift
//  SDUIKit
//
//  Created by Nozhan A. on 9/3/25.
//

import Foundation
import SDUICore

@resultBuilder
public struct WidgetContentBuilder {
    public static func buildExpression(_ expression: any WidgetProtocol) -> AnyWidget {
        expression.eraseToAnyWidget()
    }
    
    public static func buildBlock(_ components: AnyWidget...) -> [AnyWidget] {
        components
    }
    
    public static func buildBlock(_ component: AnyWidget) -> AnyWidget {
        component
    }
    
    public static func buildFinalResult(_ component: [AnyWidget]) -> [AnyWidget] {
        component
    }
    
    public static func buildFinalResult(_ component: AnyWidget) -> AnyWidget {
        component
    }
    
    public static func buildOptional(_ component: [AnyWidget]?) -> [AnyWidget] {
        component ?? []
    }
    
    public static func buildEither(first component: [AnyWidget]) -> [AnyWidget] {
        component
    }
    
    public static func buildEither(second component: [AnyWidget]) -> [AnyWidget] {
        component
    }
    
    public static func buildArray(_ components: [[AnyWidget]]) -> [AnyWidget] {
        components.flatMap(\.self)
    }
}

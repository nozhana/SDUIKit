//
//  WidgetContentBuilder.swift
//  SDUIKit
//
//  Created by Nozhan A. on 9/3/25.
//

import Foundation
import SDUICore

/// A helper function wrapper to create a widget tree.
///
/// This `resultBuilder` can create a single ``AnyWidget`` or an array of ``AnyWidget`` instances
/// from a buildable expression of any ``SDUICore/WidgetProtocol`` instance.
///
/// - Tip: Initializers for ``/SDUICore/WidgetProtocol/Data`` using `WidgetContentBuilder` arguments will be generated
/// for you automatically when using the `WidgetBuilder` macro.
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

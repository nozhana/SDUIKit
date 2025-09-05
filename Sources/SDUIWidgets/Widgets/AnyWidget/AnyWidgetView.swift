//
//  File.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SwiftUI

/// A container for an ``AnyWidget``.
///
/// ```swift
/// #Preview {
///     let anyWidget = AnyWidget(TextWidget(data: .init(content: "Hello, World!")))
///
///     AnyWidgetView(anyWidget)
/// }
/// ```
public struct AnyWidgetView: View {
    /// The inner type-erased widget.
    public var anyWidget: AnyWidget
    
    /// Initialize ``AnyWidgetView`` with a type-erased widget.
    /// - Parameter anyWidget: A type-erased widget.
    public init(_ anyWidget: AnyWidget) {
        self.anyWidget = anyWidget
    }
    
    public var body: some View {
        if let anyView = anyWidget.widget as? any View {
            AnyView(anyView)
        }
    }
}

//
//  File.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SwiftUI

public struct AnyWidgetView: View {
    public var anyWidget: AnyWidget
    
    public init(_ anyWidget: AnyWidget) {
        self.anyWidget = anyWidget
    }
    
    public var body: some View {
        if let anyView = anyWidget.widget as? any View {
            AnyView(anyView)
        }
    }
}

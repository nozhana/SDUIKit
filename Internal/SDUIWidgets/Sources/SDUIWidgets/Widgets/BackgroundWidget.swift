//
//  BackgroundWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .widget("background"), .custom("alignment", type: "Alignment", optional: true), .content)
public struct BackgroundWidget: View {
    public var body: some View {
        AnyWidgetView(data.content)
            .background(alignment: data.alignment?.systemAlignment ?? .center) {
                AnyWidgetView(data.background)
            }
    }
}

#Preview {
    let json = """
{
    "background": "icon-globe",
    "content": {
        "padding": 16,
        "content": "Hello, World!"
    }
}
"""
    
    WidgetContainer(json: json)
}

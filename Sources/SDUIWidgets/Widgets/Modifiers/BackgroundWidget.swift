//
//  BackgroundWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .widget("background"), .custom("alignment", type: Alignment.self, optional: true), .content)
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
    "background": "#d2ee22",
    "content": {
        "padding": 16,
        "content": {
            "foregroundColor": "#0000aa",
            "content": {
                "text": "Hello, World!",
                "properties": {
                    "fontSize": 26,
                    "fontWeight": 700
                }
            }
        }
    }
}
"""
    
    WidgetContainer(json: json)
}

//
//  LabelWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .widget("title"), .widget("icon"))
public struct LabelWidget: View {
    public var body: some View {
        Label {
            AnyWidgetView(data.title)
        } icon: {
            AnyWidgetView(data.icon)
        }
    }
}

#Preview {
    let json = """
{
    "title": {
        "text": "Hello, World!"
    },
    "icon": {
        "systemImage": "globe"
    }
}
"""
    
    try! LabelWidget(json: json)
}

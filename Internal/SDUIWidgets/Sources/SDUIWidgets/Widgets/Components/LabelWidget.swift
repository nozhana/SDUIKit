//
//  LabelWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SwiftUI

public struct LabelWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public var body: some View {
        Label {
            AnyWidgetView(data.title)
        } icon: {
            AnyWidgetView(data.icon)
        }
    }
}

extension LabelWidget {
    public struct Data: Codable, Sendable {
        public var title: AnyWidget
        public var icon: AnyWidget
        
        public init(title: AnyWidget, icon: AnyWidget) {
            self.title = title
            self.icon = icon
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

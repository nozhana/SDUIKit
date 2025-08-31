//
//  BackgroundWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUIUtilities
import SwiftUI

public struct BackgroundWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public var body: some View {
        AnyWidgetView(data.content)
            .background(Color(hex: data.color))
    }
}

extension BackgroundWidget {
    public struct Data: Decodable, Sendable {
        public var color: String
        public var content: AnyWidget
        
        public init(color: String, content: AnyWidget) {
            self.color = color
            self.content = content
        }
    }
}

#Preview {
    let json = """
{
    "color": "00aa44",
    "content": {
        "padding": 16,
        "content": "Hello, World!"
    }
}
"""
    
    WidgetContainer(json: json)
}

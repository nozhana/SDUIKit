//
//  BorderWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/31/25.
//

import SwiftUI

public struct BorderWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public var body: some View {
        AnyWidgetView(data.content)
            .overlay {
                (data.shape ?? .rect).systemShape
                    .stroke(data.color.map { Color(hex: $0) } ?? .primary, lineWidth: data.length)
            }
    }
}

extension BorderWidget {
    public struct Data: Decodable, Sendable {
        public var length: Double
        public var color: String?
        public var shape: Shape?
        public var content: AnyWidget
        
        public enum CodingKeys: String, CodingKey {
            case length = "border"
            case color
            case shape
            case content
        }
        
        public init(length: Double, color: String? = nil, shape: Shape? = nil, content: AnyWidget) {
            self.length = length
            self.color = color
            self.shape = shape
            self.content = content
        }
    }
}

#Preview {
    let json = """
{
    "border": 2,
    "content": "Hello, World!"
}
"""
    
    WidgetContainer(json: json)
}

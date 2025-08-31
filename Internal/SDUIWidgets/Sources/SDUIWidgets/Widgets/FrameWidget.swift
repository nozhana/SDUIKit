//
//  FrameWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/31/25.
//

import SwiftUI

public struct FrameWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public var body: some View {
        AnyWidgetView(data.content)
            .frame(width: data.width.map { CGFloat($0) },
                   height: data.height.map { CGFloat($0) },
                   alignment: data.alignment?.systemAlignment ?? .center)
    }
}

extension FrameWidget {
    public struct Data: Decodable, Sendable {
        public var width: Double?
        public var height: Double?
        public var alignment: Alignment?
        public var content: AnyWidget
        
        public init(width: Double? = nil, height: Double? = nil, alignment: Alignment? = nil, content: AnyWidget) {
            self.width = width
            self.height = height
            self.alignment = alignment
            self.content = content
        }
    }
}

#Preview {
    let json = """
{
    "color": "eeee00",
    "content": {
        "height": 100,
        "content": {
            "systemImage": "globe",
            "resizeMode": "fit"
        }
    }
}
"""
    
    WidgetContainer(json: json)
}

//
//  File.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SwiftUI

public struct LayoutWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    private var dynamicContent: any WidgetView {
        switch data.layout {
        case .horizontal:
            RowWidget(data: .init(alignment: data.alignment?.verticalAlignment, spacing: data.spacing, items: data.items))
        case .vertical:
            ColumnWidget(data: .init(alignment: data.alignment?.horizontalAlignment, spacing: data.spacing, items: data.items))
        case .perpendicular:
            StackWidget(data: .init(alignment: data.alignment, items: data.items))
        case .list:
            ListWidget(data: .init(items: data.items))
        }
    }
    
    public var body: some View {
        if let axes = data.scroll, data.layout != .list {
            ScrollableWidget(data: .init(axes: axes, content: .init(dynamicContent)))
        } else {
            AnyView(dynamicContent)
        }
    }
}

extension LayoutWidget {
    public struct Data: Decodable, Sendable {
        public var layout: Layout
        public var scroll: Axis.Set?
        public var alignment: Alignment?
        public var spacing: Double?
        public var items: [AnyWidget]
        
        public init(layout: Layout, scroll: Axis.Set? = nil, alignment: Alignment? = nil, spacing: Double? = nil, items: [AnyWidget] = []) {
            self.layout = layout
            self.scroll = scroll
            self.alignment = alignment
            self.spacing = spacing
            self.items = items
        }
        
        public enum Layout: String, CaseIterable, Decodable, Sendable {
            case horizontal, vertical, perpendicular, list
        }
    }
}

#Preview {
    let json = """
{
    "layout": "vertical",
    "scroll": "vertical",
    "spacing": 24,
    "items": [
        { "text": "A" },
        {
            "layout": "horizontal",
            "spacing": 32,
            "items": [
                { "text": "B" },
                { "text": "C" }
            ]
        }
    ]
}
"""
    
    try! LayoutWidget(json: json)
}

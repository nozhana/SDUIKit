//
//  File.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SwiftUI

public struct ColumnWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public var body: some View {
        VStack(alignment: data.alignment?.systemAlignment ?? .center, spacing: data.spacing ?? 10) {
            ForEach(Array(0..<data.items.count), id: \.self) { index in
                AnyWidgetView(data.items[index])
            }
        }
    }
}

extension ColumnWidget {
    public struct Data: Decodable, Sendable {
        public var alignment: HorizontalAlignment?
        public var spacing: Double?
        public var items: [AnyWidget]
        
        public init(alignment: HorizontalAlignment? = nil, spacing: Double? = nil, items: [AnyWidget] = []) {
            self.alignment = alignment
            self.spacing = spacing
            self.items = items
        }
    }
}

public enum HorizontalAlignment: String, CaseIterable, Decodable, Sendable {
    case leading, center, trailing
    
    var systemAlignment: SwiftUI.HorizontalAlignment {
        switch self {
        case .leading: .leading
        case .center: .center
        case .trailing: .trailing
        }
    }
    
    var generalAlignment: Alignment {
        switch self {
        case .leading: .leading
        case .center: .center
        case .trailing: .trailing
        }
    }
}

#Preview {
    let json = """
{
    "alignment": "leading",
    "items": [
        {
            "text": "Big Title",
            "properties": {
                "fontSize": 46,
                "fontWeight": 600
            }
        },
        { "text": "Oops" },
        { "text": "Ouch" }
    ]
}
"""
    
    try! ColumnWidget(json: json)
}

//
//  File.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SwiftUI

public struct RowWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public var body: some View {
        HStack(alignment: data.alignment?.systemAlignment ?? .center, spacing: data.spacing ?? 10) {
            ForEach(Array(0..<data.items.count), id: \.self) { index in
                AnyWidgetView(data.items[index])
            }
        }
    }
}

extension RowWidget {
    public struct Data: Decodable, Sendable {
        public var alignment: VerticalAlignment?
        public var spacing: Double?
        public var items: [AnyWidget]
        
        public init(alignment: VerticalAlignment? = nil, spacing: Double? = nil, items: [AnyWidget] = []) {
            self.alignment = alignment
            self.spacing = spacing
            self.items = items
        }
    }
}

public enum VerticalAlignment: String, CaseIterable, Decodable, Sendable {
    case top, center, bottom, firstTextBaseline, lastTextBaseline
    
    var systemAlignment: SwiftUI.VerticalAlignment {
        switch self {
        case .top: .top
        case .center: .center
        case .bottom: .bottom
        case .firstTextBaseline: .firstTextBaseline
        case .lastTextBaseline: .lastTextBaseline
        }
    }
    
    var generalAlignment: Alignment {
        switch self {
        case .top: .top
        case .center: .center
        case .bottom: .bottom
        // TODO: Support these later
        case .firstTextBaseline: .center
        case .lastTextBaseline: .center
        }
    }
}

#Preview {
    let json = """
{
    "items": [
        { "text": "Oops" },
        { "text": "Ouch" }
    ]
}
"""
    try! RowWidget(json: json)
}

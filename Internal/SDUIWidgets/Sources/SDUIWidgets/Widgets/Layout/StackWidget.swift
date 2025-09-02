//
//  File.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SwiftUI

public struct StackWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public var body: some View {
        ZStack(alignment: data.alignment?.systemAlignment ?? .center) {
            ForEach(Array(0..<data.items.count), id: \.self) { index in
                AnyWidgetView(data.items[index])
            }
        }
    }
}

extension StackWidget {
    public struct Data: Codable, Sendable {
        public var alignment: Alignment?
        public var items: [AnyWidget]
        
        public init(alignment: Alignment? = nil, items: [AnyWidget] = []) {
            self.alignment = alignment
            self.items = items
        }
    }
}

public enum Alignment: String, Codable, Sendable {
    case top, bottom, leading, trailing, center
    
    public var horizontalAlignment: HorizontalAlignment? {
        .init(rawValue: rawValue)
    }
    
    public var verticalAlignment: VerticalAlignment? {
        .init(rawValue: rawValue)
    }
    
    public var systemAlignment: SwiftUI.Alignment {
        switch self {
        case .top: .top
        case .bottom: .bottom
        case .leading: .leading
        case .trailing: .trailing
        case .center: .center
        }
    }
}

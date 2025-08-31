//
//  ListWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SwiftUI

public struct ListWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public var body: some View {
        List {
            ForEach(Array(0..<data.items.count), id: \.self) { index in
                AnyWidgetView(data.items[index])
            }
        }
    }
}

extension ListWidget {
    public struct Data: Decodable, Sendable {
        public var items: [AnyWidget]
        
        public init(items: [AnyWidget] = []) {
            self.items = items
        }
    }
}

public struct ListSectionWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    private var dynamicContent: some View {
        ForEach(Array(0..<data.items.count), id: \.self) { index in
            AnyWidgetView(data.items[index])
        }
    }
    
    public var body: some View {
        if let title = data.title {
            Section(title) {
                dynamicContent
            }
        } else {
            Section {
                dynamicContent
            }
        }
    }
}

extension ListSectionWidget {
    public struct Data: Decodable, Sendable {
        public var title: String?
        public var items: [AnyWidget]
        
        public enum CodingKeys: String, CodingKey {
            case title = "section"
            case items
        }
        
        public init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ListSectionWidget.Data.CodingKeys> = try decoder.container(keyedBy: ListSectionWidget.Data.CodingKeys.self)
            self.title = try container.decode(String?.self, forKey: ListSectionWidget.Data.CodingKeys.title)
            self.items = try container.decode([AnyWidget].self, forKey: ListSectionWidget.Data.CodingKeys.items)
        }
        
        public init(title: String? = nil, items: [AnyWidget] = []) {
            self.title = title
            self.items = items
        }
    }
}

#Preview {
    let json = """
{
    "layout": "list",
    "items": [
        { "text": "Hello, World!" },
        {
            "title": { "text": "Globe" },
            "icon": { "systemImage": "globe" }
        },
        {
            "section": "Settings",
            "items": [
                { "text": "Item 1" },
                { "text": "Item 2" }
            ]
        }
    ]
}
"""
    
    AnyWidgetView(try! .init(json: json))
}

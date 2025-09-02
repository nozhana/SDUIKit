//
//  ScaffoldDestinationWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/31/25.
//

import SwiftUI

public struct ScaffoldDestinationWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public var body: some View {
        AnyWidgetView(data.content)
            .ifLet(data.toolbar) { content, toolbar in
                content.toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        ForEach(Array(0..<toolbar.count), id: \.self) { index in
                            AnyWidgetView(toolbar[index])
                        }
                    }
                }
            }
#if os(iOS)
            .ifLet(data.inline) { content, inline in
                content.navigationBarTitleDisplayMode(inline ? .inline : .large)
            }
#endif
            .ifLet(data.title) { content, title in
                content.navigationTitle(title)
            }
    }
}

extension ScaffoldDestinationWidget {
    public struct Data: Codable, Sendable {
        public var title: String?
        public var inline: Bool?
        public var toolbar: [AnyWidget]?
        public var content: AnyWidget
        
        public init(title: String? = nil, inline: Bool? = nil, toolbar: [AnyWidget]? = nil, content: AnyWidget) {
            self.title = title
            self.inline = inline
            self.toolbar = toolbar
            self.content = content
        }
    }
}

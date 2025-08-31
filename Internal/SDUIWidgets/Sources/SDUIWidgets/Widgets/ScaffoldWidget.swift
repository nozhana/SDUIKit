//
//  File.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUIUtilities
import SwiftUI

public struct ScaffoldWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    @State private var path = [String]()
    
    public var body: some View {
        NavigationStack(path: $path) {
            AnyWidgetView(data.content)
                .ifLet(data.destinations) { content, destinations in
                    content
                        .navigationDestination(for: String.self) { key in
                            if let widget = destinations[key] {
                                widget
                            } else {
                                ContentUnavailableView(
                                    "Invalid Path",
                                    systemImage: "point.bottomleft.filled.forward.to.point.topright.scurvepath",
                                    description: Text("No destination found.\nPath: " + (path.isEmpty ? key : path.joined(separator: "/")))
                                )
                                .navigationTitle("Invalid Path")
                            }
                        }
                }
                .if(data.title == nil && data.toolbar == nil) { content in
                    content
                        .toolbar(.hidden)
                } else: { content in
                    content
                        .ifLet(data.toolbar) { content, toolbar in
                            content
                                .toolbar {
                                    ToolbarItemGroup(placement: .primaryAction) {
                                        ForEach(Array(0..<toolbar.count), id: \.self) { index in
                                            AnyWidgetView(toolbar[index])
                                        }
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
        .environment(\.setPath, .init(action: { path = .init($0) }))
        .environment(\.pushPath, .init(action: { path.append($0) }))
        .environment(\.popPath, .init(action: { _ = path.popLast()}))
    }
}

extension ScaffoldWidget {
    public struct Data: Decodable, Sendable {
        public var title: String?
        public var inline: Bool?
        public var toolbar: [AnyWidget]?
        public var destinations: [String: ScaffoldDestinationWidget]?
        public var content: AnyWidget
        
        public enum CodingKeys: String, CodingKey {
            case title = "scaffold"
            case inline
            case toolbar
            case destinations
            case content
        }
        
        public init(title: String? = nil, inline: Bool? = nil, toolbar: [AnyWidget]? = nil, destinations: [String: ScaffoldDestinationWidget]? = nil, content: AnyWidget) {
            self.title = title
            self.inline = inline
            self.toolbar = toolbar
            self.destinations = destinations
            self.content = content
        }
    }
}

struct SetNavigationPathAction: Sendable {
    var action: (@MainActor ([String]) -> Void)?
    
    @MainActor
    func callAsFunction<S>(_ elements: S) where S: Sequence, S.Element == String {
        action?(elements.map(\.self))
    }
    
    @MainActor
    func callAsFunction(_ elements: [String] = []) {
        action?(elements)
    }
}

struct PushNavigationPathAction: Sendable {
    var action: (@MainActor (String) -> Void)?
    
    @MainActor
    func callAsFunction(_ item: String) {
        action?(item)
    }
}

struct SimpleEnvironmentAction: Sendable {
    var action: (@MainActor () -> Void)?
    
    @MainActor
    func callAsFunction() {
        action?()
    }
}

extension EnvironmentValues {
    @Entry var setPath = SetNavigationPathAction()
    @Entry var pushPath = PushNavigationPathAction()
    @Entry var popPath = SimpleEnvironmentAction()
}

#Preview {
    let json = """
{
    "scaffold": "Home",
    "inline": true,
    "toolbar": [
        { "action": "push-call", "label": "icon-phone.fill" }
    ],
    "destinations": {
        "call": {
            "title": "Call Jasmine",
            "content": {
                "layout": "list",
                "items": [
                    {
                        "title": "Call Jasmine",
                        "icon": "icon-phone.fill"
                    }
                ]
            }
        }
    },
    "content": {
        "layout": "list",
        "items": [
            {
                "title": { "text": "Hello, World!" },
                "icon": { "systemImage": "globe" }
            },
            { "text": "Made with love,\\nNozhan 💜" },
            { "imageURL": "https://media.istockphoto.com/id/1587604256/photo/portrait-lawyer-and-black-woman-with-tablet-smile-and-happy-in-office-workplace-african.jpg?s=612x612&w=0&k=20&c=n9yulMNKdIYIQC-Qns8agFj6GBDbiKyPRruaUTh4MKs=" }
        ]
    }
}
"""
    
    try! ScaffoldWidget(json: json)
}

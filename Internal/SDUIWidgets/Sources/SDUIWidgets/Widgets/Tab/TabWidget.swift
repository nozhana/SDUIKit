//
//  File.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 9/1/25.
//

import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .custom("style", type: TabStyle.self, optional: true), .integer("initial", optional: true), .custom("tabs", type: [TabItemWidget].self))
public struct TabWidget: View {
    @State private var selection = 0
    @State private var isInitialized = false
    
    public var body: some View {
        TabView {
            ForEach(Array(0..<data.tabs.count), id: \.self) { index in
                data.tabs[index]
                    .tag(index)
            }
        }
        .ifLet(data.style) { content, style in
            switch style {
            case .automatic:
                content.tabViewStyle(.automatic)
            case .grouped:
                content.backport.tabViewStyle_grouped
            case .sidebarAdaptable:
                content.backport.tabViewStyle_sidebarAdaptable
            case .tabBarOnly:
                content.backport.tabViewStyle_tabBarOnly
            case .page(let indexDisplayMode):
                content.tabViewStyle(.backport.page(indexDisplayMode: indexDisplayMode))
            }
        }
        .onAppear {
            if !isInitialized, let initial = data.initial {
                selection = initial
                isInitialized = true
            }
        }
    }
}

@WidgetBuilder(args: .custom("label", type: LabelWidget.self), .content)
public struct TabItemWidget: View {
    public var body: some View {
        AnyWidgetView(data.content)
            .tabItem {
                data.label
            }
    }
}


public enum TabStyle: Decodable, Sendable, RawRepresentable {
    case automatic, sidebarAdaptable, tabBarOnly
    case grouped
    case page(indexDisplayMode: PageIndexDisplayMode = .automatic)
    
    public enum PageIndexDisplayMode: String, CaseIterable, Decodable, Sendable {
        case never, always, automatic
        
#if os(iOS)
        public var systemIndexDisplayMode: PageTabViewStyle.IndexDisplayMode {
            switch self {
            case .never: .never
            case .always: .always
            case .automatic: .automatic
            }
        }
#endif
    }
    
    public init(rawValue: String) {
        switch rawValue {
        case "grouped": self = .grouped
        case "sidebarAdaptable": self = .sidebarAdaptable
        case "tabBarOnly": self = .tabBarOnly
        default:
            if let pageMatch = rawValue.wholeMatch(of: /page(?:-index:(.+))?/)?.output {
                let indexDisplayMode: PageIndexDisplayMode = pageMatch.1.map {
                    PageIndexDisplayMode(rawValue: String($0)) ?? .automatic
                } ?? .automatic
                self = .page(indexDisplayMode: indexDisplayMode)
                return
            }
            self = .automatic
        }
    }
    
    public var rawValue: String {
        switch self {
        case .automatic: "automatic"
        case .grouped: "grouped"
        case .sidebarAdaptable: "sidebarAdaptable"
        case .tabBarOnly: "tabBarOnly"
        case .page(let mode): "page-index:\(mode.rawValue)"
        }
    }
}

#Preview("Default") {
    let json = """
{
    "style": "automatic",
    "tabs": [
        {
            "label": { "title": "Home", "icon": "icon-house" },
            "content": {
                "layout": "perpendicular",
                "items": [
                    "#ff0000",
                    "Home-44-bold"
                ]
            }
        },
        {
            "label": { "title": "Settings", "icon": "icon-gearshape" },
            "content": {
                "layout": "perpendicular",
                "items": [
                    "#0000ff",
                    "Settings-44-bold"
                ]
            }
        },
    ]
}
"""
    
    WidgetContainer(json: json)
}

#Preview("Page") {
    let json = """
{
    "style": "page",
    "tabs": [
        {
            "label": { "title": "Home", "icon": "icon-house" },
            "content": {
                "layout": "perpendicular",
                "items": [
                    "#ff0000",
                    "Home-44-bold"
                ]
            }
        },
        {
            "label": { "title": "Settings", "icon": "icon-gearshape" },
            "content": {
                "layout": "perpendicular",
                "items": [
                    "#0000ff",
                    "Settings-44-bold"
                ]
            }
        },
    ]
}
"""
    
    WidgetContainer(json: json)
}

#Preview("Page - No Index") {
    let json = """
{
    "style": "page-index:never",
    "tabs": [
        {
            "label": { "title": "Home", "icon": "icon-house" },
            "content": {
                "layout": "perpendicular",
                "items": [
                    "#ff0000",
                    "Home-44-bold"
                ]
            }
        },
        {
            "label": { "title": "Settings", "icon": "icon-gearshape" },
            "content": {
                "layout": "perpendicular",
                "items": [
                    "#0000ff",
                    "Settings-44-bold"
                ]
            }
        },
    ]
}
"""
    
    WidgetContainer(json: json)
}

#Preview("Grouped") {
    let json = """
{
    "style": "grouped",
    "tabs": [
        {
            "label": { "title": "Home", "icon": "icon-house" },
            "content": {
                "layout": "perpendicular",
                "items": [
                    "#ff0000",
                    "Home-44-bold"
                ]
            }
        },
        {
            "label": { "title": "Settings", "icon": "icon-gearshape" },
            "content": {
                "layout": "perpendicular",
                "items": [
                    "#0000ff",
                    "Settings-44-bold"
                ]
            }
        },
    ]
}
"""
    
    WidgetContainer(json: json)
}

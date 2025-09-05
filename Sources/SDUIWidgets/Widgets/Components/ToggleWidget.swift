//
//  ToggleWidget.swift
//  SDUIKit
//
//  Created by Nozhan A. on 9/5/25.
//

import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .string("stateKey"), .custom("style", type: ToggleStyle.self, optional: true), .widget("label"))
public struct ToggleWidget: View {
    @WidgetState private var state
    
    public var body: some View {
        let binding = Binding<Bool> {
            state[data.stateKey] as? Bool ?? false
        } set: {
            if state.keys.contains(data.stateKey),
               state[data.stateKey] as? Bool == nil { return }
            state[data.stateKey] = $0
        }
        
        Toggle(isOn: binding) {
            AnyWidgetView(data.label)
        }
        ._toggleStyle(data.style ?? .automatic)
    }
}

public enum ToggleStyle: String, Codable, Sendable {
    case automatic, button, `switch`, checkbox
    
    @MainActor
    @ViewBuilder
    fileprivate func makeBody(_ content: some View) -> some View {
        switch self {
        case .automatic:
            content.toggleStyle(.automatic)
        case .button:
            content.toggleStyle(.button)
        case .switch:
            content.toggleStyle(.switch)
        case .checkbox:
            content.toggleStyle(.backport.checkbox)
        }
    }
}

private extension View {
    func _toggleStyle(_ style: ToggleStyle) -> some View {
        style.makeBody(self)
    }
}

extension ToggleWidget.Data {
    public enum CodingKeys: String, CodingKey {
        case stateKey = "toggle", style, label
    }
}

#Preview {
    let yaml = """
---
state:
  show_hello: true
content:
  width: 300
  height: 200
  content:
    layout: vertical
    items:
    - height: 100
      content:
        if: show_hello
        transition: scale|blur|move-bottom
        animation: smooth-1.5x-extraBounce:0.35
        content: Hello, World!-34-heavy-condensed
    - toggle: show_hello
      style: button
      label:
        title: Show Hello
        icon: icon-eye.fill
"""
    
    WidgetContainer(yaml)
}

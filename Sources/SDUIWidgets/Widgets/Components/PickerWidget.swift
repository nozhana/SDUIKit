//
//  PickerWidget.swift
//  SDUIKit
//
//  Created by Nozhan A. on 9/5/25.
//

import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .string("key"), .custom("style", type: PickerStyle.self, optional: true), .custom("items", type: [PickerItemWidget].self))
public struct PickerWidget: View {
    @WidgetState private var state
    
    public var body: some View {
        let binding = Binding { state[data.key] as? String } set: { state[data.key] = $0 }
        
        Picker(selection: binding) {
            ForEach(Array(0..<data.items.count), id: \.self) { index in
                data.items[index].withKey(data.key)
            }
        } label: {
            EmptyView()
        }
        ._pickerStyle(data.style ?? .automatic)
    }
}

extension PickerWidget.Data {
    public enum CodingKeys: String, CodingKey {
        case key = "pick", style, items
    }
}

#Preview {
    let yaml = """
state:
  color_key: red
content:
  layout: vertical
  items:
  - pick: color_key
    style: radioGroup
    items:
    - id: red
      label: Red
    - id: green
      label: Green
    - id: blue
      label: Blue
"""
    
    WidgetContainer(yaml)
}


@WidgetBuilder(args: .string("id"), .string("key", optional: true), .widget("label"), .widget("activeLabel", optional: true))
public struct PickerItemWidget: View {
    @WidgetState private var state
    
    public var body: some View {
        Group {
            let isSelected = state[data.key ?? ""] as? String == data.id
            if let activeLabel = data.activeLabel,
               isSelected {
                AnyWidgetView(activeLabel)
            } else {
                AnyWidgetView(data.label)
            }
        }
        .tag(data.id)
    }
}

private extension PickerItemWidget {
    func withKey(_ key: String) -> PickerItemWidget {
        .init(data: .init(id: data.id, key: data.key ?? key, label: data.label, activeLabel: data.activeLabel))
    }
}

public enum PickerStyle: String, Codable, Sendable {
    case automatic, wheel, radioGroup, inline, menu, palette, segmented
}

private extension PickerStyle {
    @MainActor
    @ViewBuilder
    func makeBody(_ content: some View) -> some View {
        switch self {
        case .automatic:
            content.pickerStyle(.automatic)
        case .wheel:
            content.pickerStyle(.backport.wheel)
        case .radioGroup:
            content.pickerStyle(.backport.radioGroup)
        case .inline:
            content.pickerStyle(.inline)
        case .menu:
            content.pickerStyle(.menu)
        case .palette:
            content.pickerStyle(.palette)
        case .segmented:
            content.pickerStyle(.segmented)
        }
    }
}

private extension View {
    func _pickerStyle(_ style: PickerStyle) -> some View {
        style.makeBody(self)
    }
}

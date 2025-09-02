//
//  Registrar.swift
//  SDUICore
//
//  Created by Nozhan A. on 9/3/25.
//

import Foundation

package final class WidgetRegistrar: @unchecked Sendable {
    package static let shared = WidgetRegistrar()
    private init() {}
    
    package private(set) var widgetTypes: [any WidgetProtocol.Type] = []
    
    package static func register(_ widgets: [any WidgetProtocol.Type]) {
        for widget in widgets {
            if shared.widgetTypes.contains(where: { $0 == widget }) {
                continue
            }
            shared.widgetTypes.append(widget)
        }
    }
    
    package static func register(_ widgets: any WidgetProtocol.Type...) {
        register(widgets)
    }
    
    package static func unregister(_ widget: any WidgetProtocol.Type) {
        shared.widgetTypes.removeAll { $0 == widget }
    }
}

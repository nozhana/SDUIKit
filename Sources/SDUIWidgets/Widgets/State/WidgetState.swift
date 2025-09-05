//
//  WidgetState.swift
//  SDUIKit
//
//  Created by Nozhan A. on 9/5/25.
//

import SwiftUI

enum WidgetStateKeys {}

@dynamicMemberLookup
@propertyWrapper
struct WidgetState: DynamicProperty {
    typealias StateKeyPath = KeyPath<WidgetStateKeys.Type, String>
    typealias Binding = SwiftUI.Binding<[String: Any]>
    
    @Environment(\.widgetState) private var envState
    @State private var stateMap: [String: Any] = [:]
    
    init(wrappedValue map: [String: Any] = [:]) {
        self.stateMap = map
    }
    
    init(wrappedValue map: [StateKeyPath: Any]) {
        self.stateMap = map.mapKeys { WidgetStateKeys.self[keyPath: $0] }
    }
    
    var wrappedValue: [String: Any] {
        get { envState?.wrappedValue ?? stateMap }
        nonmutating set {
            if let envState {
                envState.wrappedValue = newValue
            } else {
                stateMap = newValue
            }
        }
    }
    
    @MainActor
    var projectedValue: Binding {
        envState ?? Binding {
            stateMap
        } set: { newValue in
            stateMap = newValue
        }
    }
    
    subscript(dynamicMember key: String) -> Any? {
        get { envState?.wrappedValue[key] ?? stateMap[key] }
        nonmutating set {
            if let newValue {
                if let envState {
                    envState.wrappedValue[key] = newValue
                } else {
                    stateMap[key] = newValue
                }
            } else {
                if let envState {
                    envState.wrappedValue.removeValue(forKey: key)
                } else {
                    stateMap.removeValue(forKey: key)
                }
            }
        }
    }
    
    subscript(dynamicMember keyPath: StateKeyPath) -> Any? {
        get { self[dynamicMember: WidgetStateKeys.self[keyPath: keyPath]] }
        nonmutating set { self[dynamicMember: WidgetStateKeys.self[keyPath: keyPath]] = newValue }
    }
}

private extension Dictionary {
    func mapKeys<T: Hashable>(_ transform: @escaping (Key) -> T) -> Dictionary<T, Value> {
        map { (key, value) in
            (transform(key), value)
        }
        .toDictionary()
    }
}

extension EnvironmentValues {
    @Entry var widgetState: WidgetState.Binding?
}

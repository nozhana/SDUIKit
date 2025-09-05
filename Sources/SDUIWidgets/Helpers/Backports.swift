//
//  Backports.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 9/1/25.
//

import SDUIUtilities
import SwiftUI

// MARK: - TabViewStyle Backports
extension TabViewStyle where Self == DefaultTabViewStyle {
    static var backport: Backport<Self> { .init(wrappedValue: .automatic) }
}

extension Backport<DefaultTabViewStyle> {
    @MainActor
    func page(indexDisplayMode: TabStyle.PageIndexDisplayMode = .automatic) -> some TabViewStyle {
#if os(macOS)
        .automatic
#else
        .page(indexDisplayMode: indexDisplayMode.systemIndexDisplayMode)
#endif
    }
}

// MARK: - Toggle Style Backports
extension SwiftUI.ToggleStyle where Self == DefaultToggleStyle {
    static var backport: Backport<Self> { .init(wrappedValue: .automatic) }
}

extension Backport where T: SwiftUI.ToggleStyle {
    @MainActor
    var checkbox: some SwiftUI.ToggleStyle {
#if os(macOS)
        .checkbox
#else
        .automatic
#endif
    }
}

// MARK: - Picker Style Backports
extension SwiftUI.PickerStyle where Self == DefaultPickerStyle {
    static var backport: Backport<Self> { .init(wrappedValue: .automatic) }
}

extension Backport where T: SwiftUI.PickerStyle {
    @MainActor
    var wheel: some SwiftUI.PickerStyle {
#if os(iOS)
        .wheel
#else
        .automatic
#endif
    }
    
    @MainActor
    var radioGroup: some SwiftUI.PickerStyle {
#if os(macOS)
        .radioGroup
#else
        .automatic
#endif
    }
}

// MARK: - View Backports
extension View {
    var backport: Backport<Self> { .init(wrappedValue: self) }
}

extension Backport where T: View {
    @MainActor
    @ViewBuilder
    var tabViewStyle_sidebarAdaptable: some View {
#if os(macOS)
        if #available(macOS 15.0, *) {
            wrappedValue.tabViewStyle(.sidebarAdaptable)
        } else {
            wrappedValue.tabViewStyle(.automatic)
        }
#else
        if #available(iOS 18.0, *) {
            wrappedValue.tabViewStyle(.sidebarAdaptable)
        } else {
            wrappedValue.tabViewStyle(.automatic)
        }
#endif
    }
    
    @MainActor
    @ViewBuilder
    var tabViewStyle_grouped: some View {
#if os(macOS)
        if #available(macOS 15.0, *) {
            wrappedValue.tabViewStyle(.grouped)
        } else {
            wrappedValue.tabViewStyle(.automatic)
        }
#else
        wrappedValue.tabViewStyle(.automatic)
#endif
    }
    
    @MainActor
    @ViewBuilder
    var tabViewStyle_tabBarOnly: some View {
#if os(macOS)
        if #available(macOS 15.0, *) {
            wrappedValue.tabViewStyle(.tabBarOnly)
        } else {
            wrappedValue.tabViewStyle(.automatic)
        }
#else
        if #available(iOS 18.0, *) {
            wrappedValue.tabViewStyle(.tabBarOnly)
        } else {
            wrappedValue.tabViewStyle(.automatic)
        }
#endif
    }
}

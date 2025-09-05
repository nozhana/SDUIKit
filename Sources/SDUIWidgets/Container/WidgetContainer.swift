//
//  SwiftUIView.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUICore
import SwiftUI
import Yams

/// The main SwiftUI adapter for ``SDUICore/WidgetProtocol``.
public struct WidgetContainer: View {
    private let widget: AnyWidget?
    private let error: Error?
    
    /// Initialize a container with any ``SDUICore/WidgetProtocol``.
    /// - Parameter widget: any  widget
    public init(widget: any WidgetProtocol) {
        self.widget = .init(widget)
        self.error = nil
    }
    
    /// Initialize a container with a ``WidgetContentBuilder`` block returning a single widget.
    /// - Parameter content: A ``WidgetContentBuilder`` function.
    public init(@WidgetContentBuilder content: @escaping () -> AnyWidget) {
        self.widget = content()
        self.error = nil
    }
    
    /// Initialize a container with JSON data.
    /// - Parameter json: JSON data.
    public init(json: Data) {
        do {
            self.widget = try AnyWidget(json: json)
            self.error = nil
        } catch {
            self.widget = nil
            self.error = error
        }
    }
    
    /// Initialize a container with a JSON string.
    /// - Parameter json: a JSON string.
    public init(json: String) {
        do {
            self.widget = try AnyWidget(json: json)
            self.error = nil
        } catch {
            self.widget = nil
            self.error = error
        }
    }
    
    /// Initialize a container with YAML data.
    /// - Parameter yaml: YAML data.
    public init(yaml: Data) {
        do {
            self.widget = try AnyWidget(yaml: yaml)
            self.error = nil
        } catch {
            self.widget = nil
            self.error = error
        }
    }
    
    /// Initialize a container with a YAML string.
    /// - Parameter yaml: a YAML string.
    public init(yaml: String) {
        do {
            self.widget = try AnyWidget(yaml: yaml)
            self.error = nil
        } catch {
            self.widget = nil
            self.error = error
        }
    }
    
    /// Initialize a container with either JSON-encoded or YAML-encoded data.
    /// - Parameter data: Encoded data.
    ///
    /// The container delegates the inferrence of the used markup language to ``AnyWidget`` using ``AnyWidget/init(_:)-(Data)``.
    public init(_ data: Data) {
        do {
            self.widget = try AnyWidget(data)
            self.error = nil
        } catch {
            self.widget = nil
            self.error = error
        }
    }
    
    /// Initialize a container with either a JSON-encoded or YAML-encoded string.
    /// - Parameter string: Encoded string.
    ///
    /// The container delegates the inferrence of the used markup language to ``AnyWidget`` using ``AnyWidget/init(_:)-(Data)``.
    public init(_ string: String) {
        do {
            self.widget = try AnyWidget(string)
            self.error = nil
        } catch {
            self.widget = nil
            self.error = error
        }
    }
    
    public var body: some View {
        if let widget {
            AnyWidgetView(widget)
        } else {
            ContentUnavailableView("Failed to parse widget data.", systemImage: "exclamationmark.triangle.fill", description: error.map { Text($0.localizedDescription).foregroundStyle(.secondary) })
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.red)
        }
    }
}

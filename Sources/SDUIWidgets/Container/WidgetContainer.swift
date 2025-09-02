//
//  SwiftUIView.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUICore
import SwiftUI
import Yams

public struct WidgetContainer: View {
    private let widget: AnyWidget?
    private let error: Error?
    
    public init(widget: any WidgetProtocol) {
        self.widget = .init(widget)
        self.error = nil
    }
    
    public init(json: Data) {
        do {
            self.widget = try AnyWidget(json: json)
            self.error = nil
        } catch {
            self.widget = nil
            self.error = error
        }
    }
    
    public init(json: String) {
        do {
            self.widget = try AnyWidget(json: json)
            self.error = nil
        } catch {
            self.widget = nil
            self.error = error
        }
    }
    
    public init(yaml: Data) {
        do {
            self.widget = try AnyWidget(yaml: yaml)
            self.error = nil
        } catch {
            self.widget = nil
            self.error = error
        }
    }
    
    public init(yaml: String) {
        do {
            self.widget = try AnyWidget(yaml: yaml)
            self.error = nil
        } catch {
            self.widget = nil
            self.error = error
        }
    }
    
    public init(_ data: Data) {
        do {
            self.widget = try AnyWidget(data)
            self.error = nil
        } catch {
            self.widget = nil
            self.error = error
        }
    }
    
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

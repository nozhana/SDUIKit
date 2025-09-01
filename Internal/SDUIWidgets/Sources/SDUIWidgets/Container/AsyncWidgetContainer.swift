//
//  AsyncWidgetContainer.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 9/1/25.
//

import SDUIUtilities
import SwiftUI

public struct AsyncWidgetContainer: View {
    public var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    @State private var widgetLoadable = Loadable<Data>.notLoaded
    @State private var loadWidgetTrigger = 0
    
    public var body: some View {
        Group {
            switch widgetLoadable {
            case .notLoaded:
                ContentUnavailableView("Not Loaded", systemImage: "arrow.down.app.dashed")
                    .foregroundStyle(.secondary)
            case .loading(let progress?):
                ProgressView(value: progress, total: 1)
                    .progressViewStyle(.linear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .loading(nil):
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .failed(let error):
                ContentUnavailableView {
                    Label("Failed to load widget", systemImage: "exclamationmark.circle.fill")
                } description: {
                    error.map { Text($0.localizedDescription) }
                } actions: {
                    Button("Reload", systemImage: "arrow.clockwise") {
                        loadWidgetTrigger += 1
                    }
                    .foregroundStyle(Color.accentColor)
                }
                .foregroundStyle(.red)
            case .loaded(let value?):
                WidgetContainer(value)
            case .loaded(nil):
                ContentUnavailableView("Empty Content",
                                       systemImage: "questionmark.square.dashed",
                                       description: Text("There's no content available from the provider."))
            }
        }
        .task(id: loadWidgetTrigger) {
            await loadWidget()
        }
    }
    
    private func loadWidget() async {
        guard !widgetLoadable.isLoading else { return }
        await MainActor.run {
            widgetLoadable = .loading()
        }
        do {
            let request = URLRequest(url: url, timeoutInterval: 20)
            let (data, _) = try await URLSession.shared.data(for: request)
            await MainActor.run {
                widgetLoadable = .loaded(value: data)
            }
        } catch {
            await MainActor.run {
                widgetLoadable = .failed(error)
            }
        }
    }
}

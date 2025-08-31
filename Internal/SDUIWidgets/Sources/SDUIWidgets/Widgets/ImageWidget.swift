//
//  ImageWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SwiftUI

public struct ImageWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public func platformImage(for url: URL) -> Image? {
#if canImport(UIKit)
        if let image = UIImage(contentsOfFile: url.path()) {
            return Image(uiImage: image)
        }
        return nil
#else
        if let image = NSImage(contentsOf: url) {
            return Image(nsImage: image)
        }
        return nil
#endif
    }
    
    public var body: some View {
        if data.imageURL.isFileURL {
            if let image = platformImage(for: data.imageURL) {
                Rectangle()
                    .fill(.background.tertiary)
                    .overlay {
                        image
                            .resizable()
                            .aspectRatio(nil, contentMode: data.resizeMode?.systemContentMode ?? .fit)
                    }
                    .aspectRatio(data.ratio.map { CGFloat($0) }, contentMode: .fit)
                    .clipped()
            } else {
                ContentUnavailableView("Failed to load image.", systemImage: "photo.badge.exclamationmark.fill")
            }
        } else {
            AsyncImage(url: data.imageURL) { image in
                Rectangle()
                    .fill(.background.tertiary)
                    .overlay {
                        image
                            .resizable()
                            .aspectRatio(nil, contentMode: data.resizeMode?.systemContentMode ?? .fit)
                    }
                    .aspectRatio(data.ratio.map { CGFloat($0) }, contentMode: .fit)
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(.background.secondary)
                    .overlay {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    .aspectRatio(data.ratio.map { CGFloat($0) }, contentMode: .fit)
            }
        }
    }
}

extension ImageWidget {
    public struct Data: Decodable, Sendable {
        public var imageURL: URL
        public var ratio: Double?
        public var resizeMode: ResizeMode?
        
        public init(imageURL: URL, ratio: Double? = nil, resizeMode: ResizeMode? = nil) {
            self.imageURL = imageURL
            self.ratio = ratio
            self.resizeMode = resizeMode
        }
    }
}

public enum ResizeMode: String, CaseIterable, Decodable, Sendable {
    case fit
    case fill
    
    var systemContentMode: ContentMode {
        switch self {
        case .fit: .fit
        case .fill: .fill
        }
    }
}

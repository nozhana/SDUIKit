//
//  ImageWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUIUtilities
import SDUIMacros
import SwiftUI

/// Represents a remotely-hosted widget.
///
/// Initialized with an `imageURL`, an optional `ratio`, and an optional `resizeMode`.
@WidgetBuilder(args: .custom("imageURL", type: URL.self), .double("ratio", optional: true), .custom("resizeMode", type: ResizeMode.self, optional: true))
public struct ImageWidget: View {
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

/// Represents a resizing mode for scaling a widget, most likely an ``ImageWidget``.
///
/// Either ``fit`` or ``fill``.
///
/// - Note: Widgets usually accept an **optional** `ResizeMode` which usually yields three different behaviors.
/// For instance, an ``SystemImageWidget`` is not scaled if not provided with a `ResizeMode`, neither is an ``ImageWidget``.
public enum ResizeMode: String, CaseIterable, Codable, Sendable {
    case fit
    case fill
    
    var systemContentMode: ContentMode {
        switch self {
        case .fit: .fit
        case .fill: .fill
        }
    }
}

extension ImageWidget.Data {
    public enum CodingKeys: String, CodingKey {
        case imageURL, ratio, resizeMode
    }
    
    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let stringKey = try? container.decode(String.self),
           let match = stringKey.wholeMatch(of: /(?:img|image)-(.+)/)?.output.1 {
            let components = match.split(separator: "-", omittingEmptySubsequences: false).map(String.init)
            guard let first = components.first,
                  let url = URL(string: first) else {
                throw WidgetError.unknownDataType(stringKey)
            }
            self.imageURL = url
            self.ratio = components[safe: 1].map { Double($0) } ?? nil
            self.resizeMode = components[safe: 2].map { ResizeMode(rawValue: $0) } ?? nil
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let url = try container.decode(URL.self, forKey: .imageURL)
            let ratio = try container.decodeIfPresent(Double.self, forKey: .ratio)
            let resizeMode = try container.decodeIfPresent(ResizeMode.self, forKey: .resizeMode)
            self.imageURL = url
            self.ratio = ratio
            self.resizeMode = resizeMode
        }
    }
}

#Preview {
    let yaml = """
imageURL: https://upload.wikimedia.org/wikipedia/commons/4/43/Minimalist_info_Icon.png
ratio: 1.5
"""
    
    WidgetContainer(yaml: yaml)
}

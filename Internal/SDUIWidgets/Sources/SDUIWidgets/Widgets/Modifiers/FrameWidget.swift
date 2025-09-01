//
//  FrameWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/31/25.
//

import SDUIMacros
import SwiftUI
import Yams

@WidgetBuilder(args: .double("width", optional: true), .double("height", optional: true), .custom("alignment", type: "Alignment", optional: true), .content)
public struct FrameWidget: View {
    public var body: some View {
        AnyWidgetView(data.content)
            .frame(width: data.width.map { CGFloat($0) },
                   height: data.height.map { CGFloat($0) },
                   alignment: data.alignment?.systemAlignment ?? .center)
    }
}

extension FrameWidget.Data {
    public enum CodingKeys: String, CodingKey {
        case width, height, size, alignment, content
    }
    
    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let stringKey = try? container.decode(String.self),
           let match = stringKey.wholeMatch(of: /(?'size'\d+)pt?-(?'content'.+)/)?.output,
           let data = try? YAMLEncoder().encode(String(match.content)),
           let content = try? YAMLDecoder().decode(AnyWidget.self, from: data) {
            let size = Double(String(match.size))
            self.width = size
            self.height = size
            self.alignment = nil
            self.content = content
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let content = try container.decode(AnyWidget.self, forKey: .content)
            let size = try? container.decodeIfPresent(Double.self, forKey: .size)
            let width = try container.decodeIfPresent(Double.self, forKey: .width)
            let height = try container.decodeIfPresent(Double.self, forKey: .height)
            let alignment = try container.decodeIfPresent(Alignment.self, forKey: .alignment)
            self.width = width ?? size
            self.height = height ?? size
            self.alignment = alignment
            self.content = content
        }
    }
}

#Preview {
    let json = """
{
    "background": "#eeee00",
    "content": {
        "height": 100,
        "content": {
            "systemImage": "globe",
            "resizeMode": "fit"
        }
    }
}
"""
    
    WidgetContainer(json: json)
}

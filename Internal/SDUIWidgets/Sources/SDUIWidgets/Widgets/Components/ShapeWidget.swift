//
//  ShapeWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 9/1/25.
//

import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .custom("shape", type: Shape.self), .custom("fill", type: ColorWidget.self, optional: true))
public struct ShapeWidget: View {
    public var body: some View {
        data.shape.systemShape
            .ifLet(data.fill) { content, color in
                content.fill(color.systemColor)
            }
    }
}

extension ShapeWidget.Data {
    public enum CodingKeys: String, CodingKey {
        case shape, fill
    }
    
    public init(from decoder: any Decoder) throws {
        let shapeKeyRegex = /shape-([^\/\n]+)(?:\/(#[a-zA-Z0-9]{6}))?/
        if let container = try? decoder.singleValueContainer(),
           let stringKey = try? container.decode(String.self),
           let shapeMatch = stringKey.wholeMatch(of: shapeKeyRegex)?.output {
            let (shapeKey, colorKey) = (String(shapeMatch.1), shapeMatch.2.map { String($0) })
            guard let shape = Shape(rawValue: shapeKey) else {
                throw WidgetError.unknownDataType(shapeKey)
            }
            self.shape = shape
            if let colorKey {
                self.fill = .init(data: .init(color: colorKey))
            } else {
                self.fill = nil
            }
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let shape = try container.decode(Shape.self, forKey: .shape)
            let color = try container.decodeIfPresent(ColorWidget.self, forKey: .fill)
            self.shape = shape
            self.fill = color
        }
    }
}

#Preview("Shorthand") {
    let json = """
"shape-circle/#ff0000"
"""
    
    WidgetContainer(json: json)
}

#Preview("Expanded") {
    let json = """
{
    "shape": "circle",
    "fill": "#ff0000"
}
"""
    
    WidgetContainer(json: json)
}

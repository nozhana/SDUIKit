//
//  File.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/31/25.
//

import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .string("color"))
public struct ColorWidget: View {
    public var body: some View {
        systemColor
    }
    
    public var systemColor: Color {
        Color(hex: data.color)
    }
}

extension ColorWidget.Data {
    public enum CodingKeys: String, CodingKey {
        case color
    }
    
    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let string = try? container.decode(String.self),
           string.starts(with: /#/),
           string.count == 7 {
            self.color = string
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let color = try container.decode(String.self, forKey: .color)
            self.color = color
        }
    }
}

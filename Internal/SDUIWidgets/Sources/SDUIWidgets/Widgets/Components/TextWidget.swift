//
//  TextWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUIUtilities
import SwiftUI

public struct TextWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public var body: some View {
        Text(data.content)
            .font(.system(size: data.absoluteFontSize,
                          weight: data.absoluteFontWeight.systemFontWeight,
                          design: data.absoluteFontDesign.systemFontDesign))
    }
}

extension TextWidget {
    public struct Data: Decodable, Sendable {
        public var content: String
        public var properties: Properties?
        
        public enum CodingKeys: String, CodingKey {
            case content = "text"
            case properties
        }
        
        fileprivate var absoluteFontSize: Double {
            properties?.fontSize ?? 17
        }
        
        fileprivate var absoluteFontWeight: Properties.FontWeight {
            properties?.fontWeight ?? .regular
        }
        
        fileprivate var absoluteFontDesign: Properties.FontDesign {
            properties?.fontDesign ?? .sans
        }
        
        public init(content: String, properties: Properties? = nil) {
            self.content = content
            self.properties = properties
        }
        
        public init(from decoder: any Decoder) throws {
            do {
                let container = try decoder.container(keyedBy: TextWidget.Data.CodingKeys.self)
                self.content = try container.decode(String.self, forKey: TextWidget.Data.CodingKeys.content)
                self.properties = try container.decodeIfPresent(TextWidget.Data.Properties.self, forKey: TextWidget.Data.CodingKeys.properties)
            } catch {
                let container = try decoder.singleValueContainer()
                let stringKey = try container.decode(String.self)
                let matches = stringKey.split(separator: "-", omittingEmptySubsequences: false).map(String.init)
                self.content = matches.first ?? ""
                self.properties = Properties(matches: Array(matches.dropFirst()))
            }
        }
        
        public struct Properties: Decodable, Sendable {
            public var fontSize: Double?
            public var fontWeight: FontWeight?
            public var fontDesign: FontDesign?
            
            public enum CodingKeys: String, CodingKey {
                case fontSize, fontWeight, fontDesign
            }
            
            public init(fontSize: Double? = nil, fontWeight: FontWeight? = nil, fontDesign: FontDesign? = nil) {
                self.fontSize = fontSize
                self.fontWeight = fontWeight
                self.fontDesign = fontDesign
            }
            
            public init(from decoder: any Decoder) throws {
                if let container = try? decoder.singleValueContainer(),
                   let stringKey = try? container.decode(String.self) {
                    // let matches = stringKey.matches(of: /[^-]+|\B(?=-)/)
                    //     .map(\.output)
                    //     .map(String.init)
                    let matches = stringKey.split(separator: "-", omittingEmptySubsequences: false)
                        .map(String.init)
                    self.init(matches: matches)
                } else {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let fontSize = try container.decodeIfPresent(Double.self, forKey: .fontSize)
                    let fontWeight = try container.decodeIfPresent(FontWeight.self, forKey: .fontWeight)
                    let fontDesign = try container.decodeIfPresent(FontDesign.self, forKey: .fontDesign)
                    self.init(fontSize: fontSize, fontWeight: fontWeight, fontDesign: fontDesign)
                }
            }
            
            fileprivate init(matches: [String]) {
                fontSize = matches.first.map { Double($0) } ?? nil
                if let match2 = matches[safe: 1] {
                    if let weight = FontWeight(name: match2) {
                        fontWeight = weight
                    } else if let integer = Int(match2),
                              let weight = FontWeight(rawValue: integer) {
                        fontWeight = weight
                    } else {
                        fontWeight = nil
                    }
                } else {
                    fontWeight = nil
                }
                fontDesign = matches[safe: 2].map { FontDesign(rawValue: $0) } ?? nil
            }
            
            public enum FontWeight: Int, CaseIterable, Decodable, Sendable {
                case ultralight = 200
                case light = 300
                case regular = 400
                case medium = 500
                case semibold = 600
                case bold = 700
                case heavy = 800
                case black = 900
                
                public init(from decoder: any Decoder) throws {
                    let container = try decoder.singleValueContainer()
                    if let name = try? container.decode(String.self),
                       let weight = FontWeight(name: name) {
                        self = weight
                    } else {
                        let integer = try container.decode(Int.self)
                        guard let weight = FontWeight(rawValue: integer) else {
                            throw WidgetError.unknownDataType("Weight \(integer)")
                        }
                        self = weight
                    }
                }
                
                public init?(name: String) {
                    for weight in FontWeight.allCases {
                        if name == weight.name {
                            self = weight
                            return
                        }
                    }
                    return nil
                }
                
                public var systemFontWeight: Font.Weight {
                    switch self {
                    case .ultralight: .ultraLight
                    case .light: .light
                    case .regular: .regular
                    case .medium: .medium
                    case .semibold: .semibold
                    case .bold: .bold
                    case .heavy: .heavy
                    case .black: .black
                    }
                }
                
                public var name: String {
                    switch self {
                    case .ultralight: "ultralight"
                    case .light: "light"
                    case .regular: "regular"
                    case .medium: "medium"
                    case .semibold: "semibold"
                    case .bold: "bold"
                    case .heavy: "heavy"
                    case .black: "black"
                    }
                }
            }
            
            public enum FontDesign: String, CaseIterable, Decodable, Sendable {
                case sans, serif, rounded, monospaced
                
                public var systemFontDesign: Font.Design {
                    switch self {
                    case .sans: .default
                    case .serif: .serif
                    case .rounded: .rounded
                    case .monospaced: .monospaced
                    }
                }
            }
        }
    }
}

extension TextWidget: ExpressibleByStringLiteral {
    nonisolated public init(stringLiteral value: String) {
        self.init(data: .init(content: value))
    }
}

extension TextWidget: ExpressibleByStringInterpolation {
    nonisolated public init(stringInterpolation: DefaultStringInterpolation) {
        self.init(stringLiteral: stringInterpolation.description)
    }
}

#Preview("Simple") {
    let json = """
{
    "title": "Hello, World!--medium",
    "icon": "icon-globe"
}
"""
    
    WidgetContainer(json: json)
}

#Preview("Shorthand") {
    let json = """
{
    "title": "Hello, World!-26-bold-serif",
    "icon": "icon-globe"
}
"""
    
    WidgetContainer(json: json)
}

#Preview("Regular") {
    let json = """
{
    "title": {
        "text": "Hello, World!",
        "properties": "24-bold-rounded"
    },
    "icon": "icon-globe"
}
"""
    
    WidgetContainer(json: json)
}

#Preview("Expanded") {
    let json = """
{
    "title": {
        "text": "Hello, World!",
        "properties": {
            "fontSize": 36,
            "fontWeight": 900,
            "fontDesign": "monospaced"
        }
    },
    "icon": "icon-globe"
}
"""
    
    WidgetContainer(json: json)
}

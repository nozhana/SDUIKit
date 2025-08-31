//
//  TextWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

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
                let string = try container.decode(String.self)
                self.content = string
                self.properties = nil
            }
        }
        
        public struct Properties: Decodable, Sendable {
            public var fontSize: Double?
            public var fontWeight: FontWeight?
            public var fontDesign: FontDesign?
            
            public init(fontSize: Double? = nil, fontWeight: FontWeight? = nil, fontDesign: FontDesign? = nil) {
                self.fontSize = fontSize
                self.fontWeight = fontWeight
                self.fontDesign = fontDesign
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

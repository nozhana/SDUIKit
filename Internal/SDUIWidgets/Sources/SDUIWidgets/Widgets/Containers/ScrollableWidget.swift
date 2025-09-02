//
//  ScrollableWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SwiftUI

public struct ScrollableWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public var body: some View {
        ScrollView(data.axes?.systemAxes ?? .vertical) {
            AnyWidgetView(data.content)
        }
    }
}

extension ScrollableWidget {
    public struct Data: Codable, Sendable {
        public var axes: Axis.Set?
        public var content: AnyWidget
    }
}

public enum Axis: String, CaseIterable, Codable, Sendable {
    case horizontal, vertical
}

extension Axis {
    public struct Set: OptionSet, Codable, Sendable {
        public var rawValue: Int8
        
        public init(rawValue: Int8 = 0) {
            self.rawValue = rawValue
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let integer = try? container.decode(Int8.self) {
                self.rawValue = integer
                return
            }
            if let string = try? container.decode(String.self) {
                switch string {
                case "horizontal": self = .horizontal
                case "vertical": self = .vertical
                case "all": self = .all
                default:
                    throw WidgetError.unknownDataType(string)
                }
                return
            }
            throw WidgetError.unsupportedWidgetType
        }
        
        public static let horizontal = Set(rawValue: 1)
        public static let vertical = Set(rawValue: 1 << 1)
        public static let all: Set = [horizontal, vertical]
        
        fileprivate var systemAxes: SwiftUI.Axis.Set {
            .init(rawValue: rawValue)
        }
    }
}

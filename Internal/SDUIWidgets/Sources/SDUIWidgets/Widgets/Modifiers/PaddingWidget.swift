//
//  PaddingWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SwiftUI

public struct PaddingWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public var body: some View {
        AnyWidgetView(data.content)
            .padding(data.edges?.systemEdges ?? .all, data.length)
    }
}

extension PaddingWidget {
    public struct Data: Decodable, Sendable {
        public var length: Double
        public var edges: Edges?
        public var content: AnyWidget
        
        public enum CodingKeys: String, CodingKey {
            case length = "padding"
            case edges
            case content
        }
        
        public init(length: Double, edges: Edges? = nil, content: AnyWidget) {
            self.length = length
            self.edges = edges
            self.content = content
        }
    }
}

public enum Edge: String, CaseIterable, Decodable, Sendable {
    case top, leading, bottom, trailing
    
    fileprivate var index: Int {
        switch self {
        case .top: 0
        case .leading: 1
        case .bottom: 2
        case .trailing: 3
        }
    }
    
    var systemEdge: SwiftUI.Edge {
        switch self {
        case .top: .top
        case .leading: .leading
        case .bottom: .bottom
        case .trailing: .trailing
        }
    }
}

public struct Edges: Decodable, Sendable, RawRepresentable, OptionSet {
    public let rawValue: Int8
    
    public init(rawValue: Int8) {
        self.rawValue = rawValue
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let integer = try? container.decode(Int8.self) {
            self.rawValue = integer
            return
        } else if let string = try? container.decode(String.self) {
            switch string {
            case "top": self = .top
            case "leading": self = .leading
            case "bottom": self = .bottom
            case "trailing": self = .trailing
            case "vertical": self = .vertical
            case "horizontal": self = .horizontal
            case "all": self = .all
            default: throw WidgetError.unknownDataType(string)
            }
        } else {
            throw DecodingError.valueNotFound(Edges.self, .init(codingPath: [], debugDescription: "Edges not found."))
        }
    }
    
    static let top = Edges(rawValue: 1 << Edge.top.index)
    static let leading = Edges(rawValue: 1 << Edge.leading.index)
    static let bottom = Edges(rawValue: 1 << Edge.bottom.index)
    static let trailing = Edges(rawValue: 1 << Edge.trailing.index)
    
    static let vertical: Edges = [top, bottom]
    static let horizontal: Edges = [leading, trailing]
    static let all: Edges = [vertical, horizontal]
    
    var systemEdges: SwiftUI.Edge.Set {
        .init(rawValue: rawValue)
    }
}

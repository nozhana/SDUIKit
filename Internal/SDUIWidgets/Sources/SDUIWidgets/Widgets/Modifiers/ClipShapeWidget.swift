//
//  ClipShapeWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SwiftUI

public struct ClipShapeWidget: WidgetView {
    public var data: Data
    
    nonisolated public init(data: Data) {
        self.data = data
    }
    
    public var body: some View {
        AnyWidgetView(data.content)
            .clipShape(data.shape.systemShape, style: .init(eoFill: data.eoFill ?? false, antialiased: data.antialiased ?? true))
    }
}

extension ClipShapeWidget {
    public struct Data: Codable, Sendable {
        public var shape: Shape
        public var eoFill: Bool?
        public var antialiased: Bool?
        public var content: AnyWidget
        
        public init(shape: Shape, eoFill: Bool? = nil, antialiased: Bool? = nil, content: AnyWidget) {
            self.shape = shape
            self.eoFill = eoFill
            self.antialiased = antialiased
            self.content = content
        }
    }
}

public enum Shape: Codable, Sendable, RawRepresentable {
    case circle, capsule, rect
    case roundedRect(cornerRadius: Double)
    
    public init?(rawValue: String) {
        switch rawValue {
        case "circle": self = .circle
        case "capsule": self = .capsule
        case "rect": self = .rect
        default:
            guard let match = rawValue.firstMatch(of: /rect-(\d+)/)?.output.1,
                  let cornerRadius = Double(match) else {
                return nil
            }
            self = .roundedRect(cornerRadius: cornerRadius)
        }
    }
    
    public var rawValue: String {
        switch self {
        case .circle: "circle"
        case .capsule: "capsule"
        case .rect: "rect"
        case .roundedRect(let cornerRadius):
            "rect-\(cornerRadius.formatted(.number.precision(.fractionLength(0...2))))"
        }
    }
    
    var systemShape: AnyShape {
        let anyShape: any SwiftUI.Shape = switch self {
        case .circle: .circle
        case .capsule: .capsule
        case .rect: .rect
        case .roundedRect(let cornerRadius):
                .rect(cornerRadius: cornerRadius)
        }
        return AnyShape(anyShape)
    }
}


#Preview {
    let json = """
{
    "shape": "circle",
    "content": "icon-photo.fill"
}
"""
    
    try! ClipShapeWidget(json: json)
}

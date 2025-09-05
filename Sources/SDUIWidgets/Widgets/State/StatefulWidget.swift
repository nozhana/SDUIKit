//
//  StatefulWidget.swift
//  SDUIKit
//
//  Created by Nozhan A. on 9/5/25.
//

import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .custom("initialState", type: [String: StateValue].self), .content)
public struct StatefulWidget: View {
    @WidgetState private var state
    
    public var body: some View {
        AnyWidgetView(data.content)
            .environment(\.widgetState, $state)
            .onAppear {
                state = data.initialState.mapValues(\.value)
            }
    }
}

extension StatefulWidget.Data {
    public enum CodingKeys: String, CodingKey {
        case initialState = "state", content
    }
}

public enum StateValue: Codable, Sendable {
    case boolean(Bool)
    case string(String)
    case integer(Int)
    case double(Double)
    case date(Date)
    case data(Data)
    indirect case array([StateValue])
    indirect case dictionary([String: StateValue])
    
    var value: Any {
        switch self {
        case .boolean(let boolean):
            boolean
        case .string(let string):
            string
        case .integer(let integer):
            integer
        case .double(let double):
            double
        case .date(let date):
            date
        case .data(let data):
            data
        case .array(let array):
            array.map(\.value)
        case .dictionary(let dictionary):
            dictionary.mapValues(\.value)
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .boolean(let boolean):
            try container.encode(boolean)
        case .string(let string):
            try container.encode(string)
        case .integer(let integer):
            try container.encode(integer)
        case .double(let double):
            try container.encode(double)
        case .date(let date):
            try container.encode(date.ISO8601Format())
        case .data(let data):
            try container.encode(data)
        case .array(let array):
            try container.encode(array)
        case .dictionary(let dictionary):
            try container.encode(dictionary)
        }
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let boolean = try? container.decode(Bool.self) {
            self = .boolean(boolean)
        } else if let string = try? container.decode(String.self) {
            if let date = ISO8601DateFormatter().date(from: string) {
                self = .date(date)
            } else {
                self = .string(string)
            }
        } else if let integer = try? container.decode(Int.self) {
            self = .integer(integer)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else if let date = try? container.decode(Date.self) {
            self = .date(date)
        } else if let data = try? container.decode(Data.self) {
            self = .data(data)
        } else if let array = try? container.decode([StateValue].self) {
            self = .array(array)
        } else if let dictionary = try? container.decode([String: StateValue].self) {
            self = .dictionary(dictionary)
        } else {
            throw WidgetError.unsupportedWidgetType
        }
    }
}

extension StateValue {
    init(stringValue: String) throws {
        if let boolean = Bool(stringValue) {
            self = .boolean(boolean)
        } else if let integer = Int(stringValue) {
            self = .integer(integer)
        } else if let double = Double(stringValue) {
            self = .double(double)
        } else if let date = try? Date(stringValue, strategy: .iso8601) {
            self = .date(date)
        } else {
            throw WidgetError.unknownDataType(stringValue)
        }
    }
}

#Preview {
    let yaml = """
---
state: {}
content:
  width: 300
  height: 200
  content:
    layout: vertical
    items:
    - if: show_hello
      transition: scale|blur
      animation: smooth-1s-d0.5s
      content: Hello, World!-34-bold
    - action: state-show_hello:true
      label: Tap me!
"""
    
    WidgetContainer(yaml)
}

//
//  WidgetProtocol.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUICore
import SwiftUI
import Yams

public typealias WidgetView = WidgetProtocol & View

public extension WidgetProtocol {
    init(json: Foundation.Data) throws {
        self = try JSONDecoder().decode(Self.self, from: json)
    }
    
    init(json: String) throws {
        guard let data = json.data(using: .utf8) else {
            throw WidgetError.invalidUtf8String
        }
        try self.init(json: data)
    }
    
    init(yaml: Foundation.Data) throws {
        self = try YAMLDecoder().decode(Self.self, from: yaml)
    }
    
    init(yaml: String) throws {
        guard let data = yaml.data(using: .utf8) else {
            throw WidgetError.invalidUtf8String
        }
        try self.init(yaml: data)
    }
    
    init(_ data: Foundation.Data) throws {
        if let widget = try? YAMLDecoder().decode(Self.self, from: data) {
            self = widget
        } else {
            self = try JSONDecoder().decode(Self.self, from: data)
        }
    }
    
    init(_ string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw WidgetError.invalidUtf8String
        }
        try self.init(data)
    }
    
    var json: String {
        get throws {
            let data = try JSONEncoder().encode(self)
            let object = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            let prettyData = try JSONSerialization.data(withJSONObject: object, options: [.fragmentsAllowed, .prettyPrinted])
            guard let prettyString = String(data: prettyData, encoding: .utf8) else {
                throw WidgetError.invalidUtf8String
            }
            return prettyString
        }
    }
    
    var yaml: String {
        get throws {
            try YAMLEncoder().encode(self)
        }
    }
}

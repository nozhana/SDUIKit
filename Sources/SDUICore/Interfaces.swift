//
//  Interfaces.swift
//  SDUIMacros
//
//  Created by Nozhan A. on 8/31/25.
//

import Foundation

public protocol WidgetProtocol: Codable, Sendable {
    associatedtype Data: Codable, Sendable
    var data: Data { get }
    init(data: Data)
}

extension WidgetProtocol {
    public init(from decoder: any Decoder) throws {
        self.init(data: try Data(from: decoder))
    }
    
    public func encode(to encoder: any Encoder) throws {
        try data.encode(to: encoder)
    }
}

//
//  Interfaces.swift
//  SDUIMacros
//
//  Created by Nozhan A. on 8/31/25.
//

import Foundation

public protocol WidgetProtocol: Decodable, Sendable {
    associatedtype Data: Decodable, Sendable
    var data: Data { get }
    init(data: Data)
}

public extension WidgetProtocol {
    init(from decoder: any Decoder) throws {
        self.init(data: try Data(from: decoder))
    }
}

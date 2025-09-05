//
//  Interfaces.swift
//  SDUIMacros
//
//  Created by Nozhan A. on 8/31/25.
//

import Foundation

/// The Protocol all "Widgets" conform to.
public protocol WidgetProtocol: Codable, Sendable {
    /// The ``data-swift.property``—_e.g._ recipe to construct a widget.
    ///
    /// - Tip: This type is generated for you automatically when you use the `WidgetBuilder` macro.
    associatedtype Data: Codable, Sendable
    /// The ``WidgetProtocol/Data-swift.associatedtype``—_e.g._ recipe to construct the widget.
    ///
    /// - Tip: This property is generated for you automatically when you use the `WidgetBuilder` macro.
    var data: Data { get }
    /// Initialize the widget.
    /// - Parameter data: An instance of the widget's ``Data``.
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

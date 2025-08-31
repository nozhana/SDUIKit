//
//  WidgetProtocol.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUICore
import SwiftUI

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
}

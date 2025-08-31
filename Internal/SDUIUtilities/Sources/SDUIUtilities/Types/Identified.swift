//
//  Identified.swift
//  SDUIUtilities
//
//  Created by Nozhan A. on 8/31/25.
//

import Foundation

public struct Identified<T, ID>: Identifiable where ID: Hashable {
    public var id: ID
    public var value: T
    
    public init(id: ID, value: T) {
        self.id = id
        self.value = value
    }
}

extension Identified where ID == UUID {
    public init(_ value: T) {
        self.id = UUID()
        self.value = value
    }
}

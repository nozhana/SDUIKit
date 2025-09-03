//
//  Identified.swift
//  SDUIUtilities
//
//  Created by Nozhan A. on 8/31/25.
//

import Foundation

package struct Identified<T, ID>: Identifiable where ID: Hashable {
    package var id: ID
    package var value: T
    
    package init(id: ID, value: T) {
        self.id = id
        self.value = value
    }
}

extension Identified where ID == UUID {
    package init(_ value: T) {
        self.id = UUID()
        self.value = value
    }
}

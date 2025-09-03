//
//  Backport.swift
//  SDUIUtilities
//
//  Created by Nozhan A. on 9/1/25.
//

import Foundation

@propertyWrapper
@dynamicMemberLookup
package struct Backport<T> {
    package var wrappedValue: T
    
    package init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    
    package var projectedValue: Self { self }
    
    package subscript<V>(dynamicMember keyPath: KeyPath<T, V>) -> Backport<V> {
        let v = wrappedValue[keyPath: keyPath]
        return Backport<V>(wrappedValue: v)
    }
}

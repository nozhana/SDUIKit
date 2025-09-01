//
//  Backport.swift
//  SDUIUtilities
//
//  Created by Nozhan A. on 9/1/25.
//

import Foundation

@propertyWrapper
@dynamicMemberLookup
public struct Backport<T> {
    public var wrappedValue: T
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    
    public var projectedValue: Self { self }
    
    public subscript<V>(dynamicMember keyPath: KeyPath<T, V>) -> Backport<V> {
        let v = wrappedValue[keyPath: keyPath]
        return Backport<V>(wrappedValue: v)
    }
}

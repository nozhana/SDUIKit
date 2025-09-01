//
//  Collection+.swift
//  SDUIUtilities
//
//  Created by Nozhan A. on 9/1/25.
//

import Foundation

public extension Collection {
    subscript(safe index: Index) -> Element? {
        if indices.contains(index) {
            return self[index]
        }
        return nil
    }
}

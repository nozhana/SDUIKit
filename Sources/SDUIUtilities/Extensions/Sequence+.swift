//
//  Sequence+.swift
//  SDUIKit
//
//  Created by Nozhan A. on 9/3/25.
//

import Foundation

package extension Sequence {
    func toDictionary<K, V>() -> Dictionary<K, V> where Element == (K, V), K: Hashable {
        Dictionary(uniqueKeysWithValues: self)
    }
}

//
//  Loadable.swift
//  SDUIUtilities
//
//  Created by Nozhan A. on 9/1/25.
//

import Foundation

public enum Loadable<T> {
    case notLoaded
    case loading(progress: Double? = nil)
    case failed(Error? = nil)
    case loaded(value: T?)
}

public extension Loadable {
    var isLoaded: Bool {
        if case .loaded = self {
            return true
        }
        return false
    }
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var isFailed: Bool {
        if case .failed = self {
            return true
        }
        return false
    }
    
    var loadedValue: T? {
        if case .loaded(let value) = self {
            return value
        }
        return nil
    }
    
    var progress: Double? {
        if case .loading(let progress) = self {
            return progress
        }
        return nil
    }
    
    var error: Error? {
        if case .failed(let error) = self {
            return error
        }
        return nil
    }
}

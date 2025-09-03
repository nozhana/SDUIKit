//
//  View+.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SwiftUI

package extension View {
    @ViewBuilder
    func `if`(_ condition: Bool, @ViewBuilder content: @escaping (_ content: Self) -> some View) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func `if`(_ condition: Bool, @ViewBuilder content: @escaping (_ content: Self) -> some View, @ViewBuilder else otherContent: @escaping (_ content: Self) -> some View) -> some View {
        if condition {
            content(self)
        } else {
            otherContent(self)
        }
    }
    
    @ViewBuilder
    func ifLet<T>(_ optional: T?, @ViewBuilder content: @escaping (_ content: Self, _ unwrapped: T) -> some View) -> some View {
        if let unwrapped = optional {
            content(self, unwrapped)
        } else {
            self
        }
    }
}

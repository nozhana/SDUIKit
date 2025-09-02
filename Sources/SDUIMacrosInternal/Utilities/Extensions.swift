//
//  File.swift
//  SDUIMacros
//
//  Created by Nozhan A. on 8/31/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension LabeledExprListSyntax {
    func first(labeled label: String) -> LabeledExprSyntax? {
        first { $0.label?.text == label }
    }
}

//
//  File.swift
//  SDUIUtilities
//
//  Created by Nozhan A. on 8/30/25.
//

import Foundation

#if canImport(UIKit)
import UIKit
public typealias CoreColor = UIColor
#endif

#if os(macOS)
import AppKit
public typealias CoreColor = NSColor
#endif

import SwiftUI

public extension CoreColor {
    private convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1) {
        assert((0...255) ~= r, "Invalid red component")
        assert((0...255) ~= g, "Invalid green component")
        assert((0...255) ~= b, "Invalid blue component")
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: alpha)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1) {
        self.init(r: (hex >> 16) & 0xFF,
                  g: (hex >> 8) & 0xFF,
                  b: hex & 0xFF,
                  alpha: alpha)
    }
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var hexValue: UInt64 = 0
        scanner.scanHexInt64(&hexValue)
        self.init(hex: Int(hexValue))
    }
    
    var hex: String {
        let components = self.cgColor.components!
        
        let (red, green, blue) = (components[0], components[1], components[2])
        
        return String(format: "%02lX%02lX%02lX", lroundf(Float(red) * 255), lroundf(Float(green) * 255), lroundf(Float(blue) * 255))
    }
}

public extension CoreColor {
    static var primaryColor: CoreColor {
#if canImport(UIKit)
        return label
#else
        return labelColor
#endif
    }
}

public extension Color {
    init(hex: Int, alpha: CGFloat = 1) {
#if canImport(UIKit)
        self.init(uiColor: .init(hex: hex, alpha: alpha))
#else
        self.init(nsColor: .init(hex: hex, alpha: alpha))
#endif
    }
    
    init(hex: String) {
#if canImport(UIKit)
        self.init(uiColor: .init(hex: hex))
#else
        self.init(nsColor: .init(hex: hex))
#endif
    }
}

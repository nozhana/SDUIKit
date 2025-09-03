//
//  TestingWidgetContainer.swift
//
//
//  Created by You on x/x/xx.
//

import SDUIKit
import SwiftUI

#Preview {
    let json = """
{
  "layout": "vertical",
  "items": [
    "36pt-icon-globe-fit",
    "Hello, World!",
  ]
}
"""
    
    let data = json.data(using: .utf8)!
    
    WidgetContainer(json: data)
}

//
//  TestingWidgetContainer.swift
//
//
//  Created by You on x/x/xx.
//

import SDUIKit
import SwiftUI

#Preview {
    let yaml = """
---
layout: vertical
items:
- 36pt-icon-globe-fit
- Hello, World!
"""
    
    let data = yaml.data(using: .utf8)!
    
    WidgetContainer(yaml: data)
}

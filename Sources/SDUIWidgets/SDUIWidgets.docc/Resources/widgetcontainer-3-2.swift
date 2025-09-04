//
//  TestingWidgetContainer.swift
//
//
//  Created by You on x/x/xx.
//

import SDUIKit
import SwiftUI

#Preview {
    WidgetContainer {
        /.column(alignment: .leading, spacing: 16) {
            /.frame(width: 100, height: 100) {
                /.icon("globe", resizeMode: .fit)
            }
            /.text("Hello, World!",
                   properties: .init(fontSize: 36, fontWeight: .bold))
        }
    }
}

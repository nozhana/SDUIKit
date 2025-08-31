//
//  OverlayWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/31/25.
//

import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .widget("overlay"), .custom("alignment", type: "Alignment", optional: true), .widget("content"))
public struct OverlayWidget: View {
    public var body: some View {
        AnyWidgetView(data.content)
            .overlay(alignment: data.alignment?.systemAlignment ?? .center) {
                AnyWidgetView(data.overlay)
            }
    }
}

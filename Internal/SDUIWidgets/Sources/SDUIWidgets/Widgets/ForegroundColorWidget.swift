//
//  ForegroundColorWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/31/25.
//

import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .custom("foregroundColor", type: "ColorWidget"), .content)
public struct ForegroundColorWidget: View {
    public var body: some View {
        AnyWidgetView(data.content)
            .foregroundStyle(data.foregroundColor.systemColor)
    }
}

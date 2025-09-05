//
//  LabelWidget.swift
//  SDUIWidgets
//
//  Created by Nozhan A. on 8/30/25.
//

import SDUIMacros
import SwiftUI

/// Represents a label with a title and an icon.
///
/// ### WidgetContentBuilder Syntax
/// ```swift
/// WidgetContainer {
///     /.label {
///         /.text("Hello, World!")
///     } icon: {
///         /.icon("sun.max.fill")
///     }
/// }
/// ```
///
/// ### JSON Syntax
/// ```json
/// {
///     "title": "Hello, World!",
///     "icon": "icon-sun.max.fill"
/// }
/// ```
@WidgetBuilder(args: .widget("title"), .widget("icon"))
public struct LabelWidget: View {
    public var body: some View {
        Label {
            AnyWidgetView(data.title)
        } icon: {
            AnyWidgetView(data.icon)
        }
    }
}

#Preview {
    let json = """
{
    "title": {
        "text": "Hello, World!"
    },
    "icon": {
        "systemImage": "globe"
    }
}
"""
    
    try! LabelWidget(json: json)
}

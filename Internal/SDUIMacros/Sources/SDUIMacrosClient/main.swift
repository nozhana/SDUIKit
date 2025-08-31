import Foundation
import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .string("bar"), .integer("baz", optional: true))
public struct Foo: View {
    public var body: some View {
        Text(data.bar)
    }
}

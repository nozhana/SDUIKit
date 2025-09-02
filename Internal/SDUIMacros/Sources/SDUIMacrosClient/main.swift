import Foundation
import SDUIMacros
import SwiftUI

@WidgetBuilder(args: .string("bar"), .integer("baz", optional: true))
struct Foo: View {
    var body: some View {
        Text(data.bar)
    }
}


@WidgetBuilder
struct Bar {}

enum Baz: Codable, Sendable {
    case boo
    
    enum Boo: Codable, Sendable {
        case meow
    }
}

@WidgetBuilder(args: .custom("boo", type: Baz.Boo.self))
struct Bim {}

let foo = Foo(data: .init(bar: "bar", baz: 2))
let bar = Bar()

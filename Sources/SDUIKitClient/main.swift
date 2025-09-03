import Foundation
import SDUIKit

// - MARK: - Test widget registry
@WidgetBuilder(args: .double("entry1"), .items, .widget("label"))
public struct Registerable1 {}

@WidgetBuilder(args: .string("entry2"))
struct Registerable2 {}

let widgetsToRegister: [any WidgetProtocol.Type] = [
    Registerable1.self,
    Registerable2.self,
]

#registerWidgets(widgetsToRegister)

print("Registered widgets: \(String(describing: widgetsToRegister))")
print()

let yaml = """
entry1: 4
label: "Hello, World!"
items:
- entry2: bar
"""

let reg1 = try AnyWidget(yaml: yaml)

print("reg1 ---")
print(try reg1.json)
print()

// MARK: - Custom widgets
extension WidgetEnum {
    static func border(_ length: Double, @WidgetContentBuilder content: @escaping () -> AnyWidget) -> WidgetEnum {
        .custom {
            BorderWidget(data: .init(length: length, content: content()))
        }
    }
}

let testWidget = AnyWidget {
    /.row {
        /.text("Hello, World!",
               properties: .init(fontSize: 24, fontWeight: .heavy))
        /.frame(width: 36) {
            /.border(2) {
                /.icon("globe", resizeMode: .fit)
            }
        }
        LayoutWidget(data: .init(layout: .vertical, scroll: .vertical, items: [
            /.text("Hey there")
        ]))
    }
}

print("testWidget ---")
print(try testWidget.yaml)

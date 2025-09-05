# ``SDUIWidgets/WidgetContentBuilder``

### Implementation

```swift
import SDUICore
import SDUIWidgets
import SwiftUI

struct MyWidget: View, WidgetProtocol {
    struct Data: Codable, Sendable {
        var foo: String
        var content: AnyWidget
        var items: [AnyWidget]
        
        init(foo: String,
             @WidgetContentBuilder content: @escaping () -> AnyWidget,
             @WidgetContentBuilder items: @escaping () -> [AnyWidget]) {
            self.foo = foo
            self.content = content()
            self.items = items()
        }
    }
    
    // ...
}
```

### Usage

```swift
#Preview {
    let widgetData = MyWidget.Data(foo: "Bar") {
        /.text("Header", properties: .init(fontSize: 34, fontWeight: .bold))
    } items: {
        /.text("Item 1")
        
        /.label {
            /.text("Item 2")
        } icon: {
            /.icon("sun.max.fill")
        }
        
        /.text("Item 3")
    }
    
    MyWidget(data: widgetData)
}
```

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->

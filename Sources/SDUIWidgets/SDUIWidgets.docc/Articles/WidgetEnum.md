# ``SDUIWidgets/WidgetEnum``

### Creating a custom WidgetEnum

First, extend the `WidgetEnum` type to include your custom widget.

```swift
extension WidgetEnum {
    static func myWidget(_ foo: String) -> WidgetEnum {
        .custom {
            MyWidget(data: .init(foo: foo))
        }
    }
}
```

Now, you can use your widgetEnum in a ``WidgetContentBuilder`` widget tree:

```swift
#Preview {
    WidgetContainer {
        /.row {
            /.text("Hello, World!")
            /.myWidget("Foo bar!")
        }
    }
}
```

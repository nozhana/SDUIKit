# ``SDUIWidgets/AnyWidget``

### Erase a widget's type

Use ``init(_:)-(WidgetProtocol)`` to initialize an `AnyWidget` instance using a widget,
or call ``eraseToAnyWidget()`` on any ``/SDUICore/WidgetProtocol`` instance.

```swift
#Preview {
    let anyWidget1: AnyWidget = MyWidget(data: .init(foo: "bar"))
        .eraseToAnyWidget()
    
    let myWidget = MyWidget(data: .init(foo: "baz"))
    let anyWidget2 = AnyWidget(myWidget)

    AnyWidgetView(anyWidget1)
    AnyWidgetView(anyWidget2)
}
```

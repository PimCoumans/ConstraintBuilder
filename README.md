# ConstraintBuilder

Convenience Auto Layout methods and ability to apply your constraints through a function builder

```swift
someView.extendToSuperview()
someOtherView.extendToSuperviewLayoutMargins()
centeredView.center(in: mySpecialLayoutGuide)
```

```swift
someView.applyConstraints {
	$0.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
	$0.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor)
}
```

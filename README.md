# ConstraintBuilder

Convenience Auto Layout methods, applying constraints through a function builder

```swift
someView.applyConstraints {
	$0.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
	$0.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor)
}
```

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public extension NSLayoutConstraint {
	/// Activates all constraints created in the `builder` closure;
	/// - Parameter builder: Closure in which all constraints should be created or referenced
	///
	/// Typical usage:
	/// ```swift
	/// NSLayoutConstraint.build {
	///     someView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
	///     someView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
	///     anotherView.leadingAnchor.constraint(equalTo: someView.trailingAnchor)
	///     anotherView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
	/// }
	/// ```
	class func build(@ConstraintBuilder _ builder: () -> [NSLayoutConstraint]) {
		activate(builder())
	}
}

public extension NSLayoutConstraint {
	/// Updates constraint priority and returns itself, allowing for chaining this method after creation
	func withPriority(_ priority: LayoutPriority) -> NSLayoutConstraint {
		self.priority = priority
		return self
	}

	/// Creates a copy of the constraint setting the multiplier to the provided value.
	/// - Parameters:
	///   - multiplier: New multiplier to be used for the constraint
	///   - activated: Wether the current (old) constraint should be deactivated and the new constraint activated
	/// - Returns: New copy of the receiving layout constraint with updated multiplier
	func updatingMultiplier(_ multiplier: CGFloat, activated: Bool = true) -> NSLayoutConstraint {
		guard multiplier != self.multiplier else {
			return self
		}
		guard let item = firstItem else {
			print("Unable to recreate constraint without firstItem")
			return self
		}
		let constraint = NSLayoutConstraint(
			item: item,
			attribute: firstAttribute,
			relatedBy: relation,
			toItem: secondItem,
			attribute: secondAttribute,
			multiplier: multiplier,
			constant: constant)
		constraint.priority = priority
		constraint.shouldBeArchived = shouldBeArchived
		constraint.identifier = identifier
		if activated {
			isActive = false
			constraint.isActive = true
		}
		return constraint
	}
}

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

@resultBuilder
public struct ConstraintBuilder {
	public static func buildBlock(_ components: NSLayoutConstraint...) -> [NSLayoutConstraint] {
		Array(components)
	}
	public static func buildBlock(_ components: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
		Array(components)
	}
}

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

public protocol ConstraintBuildable {
	associatedtype Constrained
	/// Create and activate constraints with this view as the main subject
	/// ```swift
	/// view.applyConstraints {
	///     $0.leadingAnchor.constraint(equalTo: otherView.leadingAnchor)
	///     $0.centerYAnchor.constraint(equalTo: otherView.centerYAnchor)
	/// }
	/// ```
	/// - Parameter builder: Constraint builder to add the constraints from
	func applyConstraints(@ConstraintBuilder _ builder: (Constrained) -> [NSLayoutConstraint])
	/// Extends all edges to the edges of the provided view
	/// - Parameter view: View of which edges should be extended to
	func extend(to other: Constrained)
	
	/// Aligns center with center of provided view
	/// - Parameter view: View of which center should be aligned to
	func center(in other: Constrained)
}

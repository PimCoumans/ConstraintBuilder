#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

@resultBuilder
public struct ConstraintBuilder {
	static func buildBlock(_ components: NSLayoutConstraint...) -> [NSLayoutConstraint] {
		Array(components)
	}
	static func buildBlock(_ components: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
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

public protocol ContraintBuildable {
	/// Extends all edges to the edges of the provided view
	/// - Parameter view: View of which edges should be extended to
	func extend(to view: Self)
	
	/// Aligns center with center of provided view
	/// - Parameter view: View of which center should be aligned to
	func center(in view: Self)
	
	/// Extends all edges to the edges of the superview
	/// Should result in `assertionFailure` when no superview is available
	func extendToSuperview()
	
	/// Aligns center with center of superview
	/// Should result in `assertionFailure` when no superview is available
	func centerInSuperview()
}

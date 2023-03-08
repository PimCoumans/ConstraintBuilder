#if canImport(UIKit)
import UIKit
public typealias LayoutPriority = UILayoutPriority
public typealias LayoutGuide = UILayoutGuide
extension UILayoutGuide: LayoutContainer { }
extension UIView: LayoutContainerView { }
#elseif canImport(AppKit)
import AppKit
public typealias LayoutPriority = NSLayoutConstraint.Priority
public typealias LayoutGuide = NSLayoutGuide
extension NSLayoutGuide: LayoutContainer { }
extension NSView: LayoutContainerView { }
#endif

// Anchors shared by views and layout guides
public protocol LayoutContainer {
	var leadingAnchor: NSLayoutXAxisAnchor { get }
	var trailingAnchor: NSLayoutXAxisAnchor { get }
	var leftAnchor: NSLayoutXAxisAnchor { get }
	var rightAnchor: NSLayoutXAxisAnchor { get }
	var topAnchor: NSLayoutYAxisAnchor { get }
	var bottomAnchor: NSLayoutYAxisAnchor { get }
	var widthAnchor: NSLayoutDimension { get }
	var heightAnchor: NSLayoutDimension { get }
	var centerXAnchor: NSLayoutXAxisAnchor { get }
	var centerYAnchor: NSLayoutYAxisAnchor { get }
}

// Layout guides available in NSView (from macOS 11.0) and UIView (from iOS 11.0)
public protocol LayoutContainerView: LayoutContainer {
	@available(macOS 11.0, iOS 11.0, tvOS 11.0, *)
	var safeAreaLayoutGuide: LayoutGuide { get }
	@available(macOS 11.0, iOS 9.0,  tvOS 9.0, *)
	var layoutMarginsGuide: LayoutGuide { get }
}

@resultBuilder
public struct ConstraintBuilder {
	public static func buildBlock(_ components: NSLayoutConstraint...) -> [NSLayoutConstraint] {
		Array(components)
	}
	public static func buildBlock(_ components: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
		Array(components)
	}
}

/// Convenience methods to apply layout constraints
public protocol ConstraintBuildable {
	associatedtype Constrained: LayoutContainer
	/// Create and activate constraints with this view as the main subject
	/// ```swift
	/// view.applyConstraints {
	///     $0.leadingAnchor.constraint(equalTo: otherView.leadingAnchor)
	///     $0.centerYAnchor.constraint(equalTo: otherView.centerYAnchor)
	/// }
	/// ```
	/// - Parameter builder: Constraint builder to add the constraints from
	func applyConstraints(@ConstraintBuilder _ builder: (Constrained) -> [NSLayoutConstraint])

	/// Extends all edges to the edges of the provided view or guide
	/// - Parameter view: View of which edges should be extended to
	func extend(to other: any LayoutContainer)
	
	/// Aligns center with center of provided view or guide
	/// - Parameter view: View of which center should be aligned to
	func center(in other: any LayoutContainer)

	/// Applies constraints so the receiver fits within the provided container. Returns an 'aspect ratio' height constraint that should be updated for the correct ratio.
	/// - Parameter layoutGuide: Guide to fit the receiving view in
	/// - Returns: New layout constraint for the view's height multiplied by its width.
	/// - Note: Store the returned layout constraint and use `updatingMultiplier(_:)` to change the actual aspect ratio.
	/// The ratio is in height divided by width.
	func aspectFit(in other: any LayoutContainer) -> NSLayoutConstraint
}

// Conformance to `ConstraintBuildable` for `NSLayoutGuide` and `UILayoutGuide`
extension LayoutGuide: ConstraintBuildable {
	public func applyConstraints(@ConstraintBuilder _ builder: (LayoutGuide) -> [NSLayoutConstraint]) {
		NSLayoutConstraint.activate(builder(self))
	}
}

/// Convenience methods to apply layout constraints to views
public protocol ViewConstraintBuildable: ConstraintBuildable where Constrained: LayoutContainerView {
	/// Use superview if available,  `assertionFailure()` if not
	func withSuperview(_ method: (LayoutContainerView) -> Void)

	/// Extends all edges to the edges of the superview
	/// Should result in `assertionFailure` when no superview is available
	func extendToSuperview()

	/// Aligns center with center of superview
	/// Should result in `assertionFailure` when no superview is available
	func centerInSuperview()

	/// Extends all edges to the edges of the superview‘s safe area
	/// Should result in `assertionFailure` when no superview is available
	@available(macOS 11.0, iOS 11.0, *)
	func extendToSuperviewSafeArea()

	/// Extends all edges to the edges of the superview‘s layout margins
	/// Should result in `assertionFailure` when no superview is available
	@available(macOS 11.0, iOS 11.0, *)
	func extendToSuperviewLayoutMargins()
}

// Default implementations of convenience methods
extension ConstraintBuildable where Self: LayoutContainer {
	public func extend(to other: any LayoutContainer) {
		applyConstraints { _ in
			leadingAnchor.constraint(equalTo: other.leadingAnchor)
			trailingAnchor.constraint(equalTo: other.trailingAnchor)
			bottomAnchor.constraint(equalTo: other.bottomAnchor)
			topAnchor.constraint(equalTo: other.topAnchor)
		}
	}

	public func center(in other: any LayoutContainer) {
		applyConstraints { _ in
			centerXAnchor.constraint(equalTo: other.centerXAnchor)
			centerYAnchor.constraint(equalTo: other.centerYAnchor)
		}
	}

	public func aspectFit(in other: any LayoutContainer) -> NSLayoutConstraint {
		let aspectRatioConstraint = heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1)
		applyConstraints {
			$0.centerXAnchor.constraint(equalTo: other.centerXAnchor)
			$0.centerYAnchor.constraint(equalTo: other.centerYAnchor)

			$0.topAnchor.constraint(greaterThanOrEqualTo: other.topAnchor)
			$0.topAnchor.constraint(equalTo: other.topAnchor).withPriority(.defaultLow)
			$0.bottomAnchor.constraint(lessThanOrEqualTo: other.bottomAnchor)
			$0.bottomAnchor.constraint(equalTo: other.bottomAnchor).withPriority(.defaultLow)

			$0.leadingAnchor.constraint(greaterThanOrEqualTo: other.leadingAnchor)
			$0.leadingAnchor.constraint(equalTo: other.leadingAnchor).withPriority(.defaultLow)

			$0.trailingAnchor.constraint(lessThanOrEqualTo: other.trailingAnchor)
			$0.trailingAnchor.constraint(equalTo: other.trailingAnchor).withPriority(.defaultLow)
			aspectRatioConstraint
		}
		return aspectRatioConstraint
	}
}
// Default implementations of view convenience methods
extension ViewConstraintBuildable where Self: LayoutContainerView {
	public func extendToSuperview() {
		withSuperview(extend(to:))
	}

	public func centerInSuperview() {
		withSuperview(center(in:))
	}

	@available(macOS 11.0, iOS 11.0, *)
	public func extendToSuperviewSafeArea() {
		withSuperview { extend(to: $0.safeAreaLayoutGuide) }
	}

	@available(macOS 11.0, iOS 11.0, *)
	public func extendToSuperviewLayoutMargins() {
		withSuperview { extend(to: $0.layoutMarginsGuide) }
	}
}

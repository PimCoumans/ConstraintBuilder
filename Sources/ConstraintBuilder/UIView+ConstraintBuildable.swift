#if canImport(UIKit)
import UIKit

public protocol UIViewConstraintBuildable: ContraintBuildable {
	/// Create and activate constriants with this view as the main subject
	/// ```swift
	/// view.applyConstraints {
	///     $0.leadingAnchor.constraint(equalTo: otherView.leadingAnchor)
	///     $0.centerYAnchor.constraint(equalTo: otherView.centerYAnchor)
	/// }
	/// ```
	/// - Parameter builder: Constraint builder to add the constriants from
	func applyConstraints(@ConstraintBuilder _ builder: (UIView) -> [NSLayoutConstraint])
	
	/// Extends all edges to provided layout guide
	/// - Parameter view: UILayoutGuide of which edges should be extended to
	func extend(to layoutGuide: UILayoutGuide)
	
	/// Aligns center with center of layout guide
	/// - Parameter view: UILayoutGuide of which center should be aligned to
	func center(in layoutGuide: UILayoutGuide)
	
	/// Extends all edges to the edges of the superview‘s safe area
	/// Should result in `assertionFailure` when no superview is available
	func extendToSuperviewSafeArea()
	
	/// Extends all edges to the edges of the superview‘s layout margins
	/// Should result in `assertionFailure` when no superview is available
	func extendToSuperviewLayoutMargins()
}

extension UIView: UIViewConstraintBuildable {
	public func applyConstraints(@ConstraintBuilder _ builder: (UIView) -> [NSLayoutConstraint]) {
		translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(builder(self))
	}
	
	public func extend(to view: UIView) {
		applyConstraints { _ in
			leadingAnchor.constraint(equalTo: view.leadingAnchor)
			trailingAnchor.constraint(equalTo: view.trailingAnchor)
			topAnchor.constraint(equalTo: view.topAnchor)
			bottomAnchor.constraint(equalTo: view.bottomAnchor)
		}
	}
	
	public func center(in view: UIView) {
		applyConstraints { _ in
			centerXAnchor.constraint(equalTo: view.centerXAnchor)
			centerYAnchor.constraint(equalTo: view.centerYAnchor)
		}
	}
	
	public func extend(to layoutGuide: UILayoutGuide) {
		applyConstraints { _ in
			leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor)
			trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)
			topAnchor.constraint(equalTo: layoutGuide.topAnchor)
			bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
		}
	}
	
	public func center(in layoutGuide: UILayoutGuide) {
		applyConstraints { _ in
			centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor)
			centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor)
		}
	}
	
	/// Use superview if available,  `assertionFailure()` if not
	private func withSuperview(_ method: (UIView) -> Void) {
		guard let superview = superview else {
			return assertionFailure()
		}
		method(superview)
	}
	
	public func extendToSuperview() {
		withSuperview(extend(to:))
	}
	
	public func centerInSuperview() {
		withSuperview(center(in:))
	}
	
	public func extendToSuperviewSafeArea() {
		withSuperview { extend(to: $0.safeAreaLayoutGuide) }
	}
	
	public func extendToSuperviewLayoutMargins() {
		withSuperview { extend(to: $0.layoutMarginsGuide) }
	}
}

#endif

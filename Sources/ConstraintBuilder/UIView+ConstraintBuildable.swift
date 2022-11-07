#if canImport(UIKit)
import UIKit

extension Collection where Element: ConstraintBuildable {
	public func applyConstraints(@ConstraintBuilder _ builder: (Element) -> [NSLayoutConstraint]) {
		NSLayoutConstraint.activate(flatMap { builder($0) })
	}
}

public protocol UIViewConstraintBuildable: ConstraintBuildable {
	/// Extends all edges to the edges of the superview
	/// Should result in `assertionFailure` when no superview is available
	func extendToSuperview()
	
	/// Aligns center with center of superview
	/// Should result in `assertionFailure` when no superview is available
	func centerInSuperview()
	
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
	
	public func extend(to other: UIView) {
		applyConstraints { _ in
			leadingAnchor.constraint(equalTo: other.leadingAnchor)
			trailingAnchor.constraint(equalTo: other.trailingAnchor)
			topAnchor.constraint(equalTo: other.topAnchor)
			bottomAnchor.constraint(equalTo: other.bottomAnchor)
		}
	}
	
	public func center(in other: UIView) {
		applyConstraints { _ in
			centerXAnchor.constraint(equalTo: other.centerXAnchor)
			centerYAnchor.constraint(equalTo: other.centerYAnchor)
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

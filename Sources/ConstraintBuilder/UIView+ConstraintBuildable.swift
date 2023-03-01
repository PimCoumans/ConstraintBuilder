#if canImport(UIKit)
import UIKit

extension UIView: ViewConstraintBuildable {
	public func withSuperview(_ method: (UIView) -> Void) {
		guard let superview else {
			return assertionFailure()
		}
		method(superview)
	}

	public func applyConstraints(@ConstraintBuilder _ builder: (UIView) -> [NSLayoutConstraint]) {
		translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(builder(self))
	}
}
#endif

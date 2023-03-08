#if canImport(UIKit)
import UIKit

extension ViewConstraintBuildable where Self: UIView {
	public func withSuperview(_ method: (LayoutContainerView) -> Void) {
		guard let superview else {
			return assertionFailure()
		}
		method(superview)
	}

	public func applyConstraints(@ConstraintBuilder _ builder: (Self) -> [NSLayoutConstraint]) {
		translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(builder(self))
	}
}
extension UIView: ViewConstraintBuildable { }
#endif

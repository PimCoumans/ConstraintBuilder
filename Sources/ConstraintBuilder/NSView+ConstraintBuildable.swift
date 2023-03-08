#if canImport(AppKit)
import AppKit

extension ViewConstraintBuildable where Self: NSView {
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
extension NSView: ViewConstraintBuildable { }
#endif

#if canImport(AppKit)
import AppKit

extension NSView: ViewConstraintBuildable {
	public func withSuperview(_ method: (NSView) -> Void) {
		guard let superview else {
			return assertionFailure()
		}
		method(superview)
	}

	public func applyConstraints(@ConstraintBuilder _ builder: (NSView) -> [NSLayoutConstraint]) {
		translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(builder(self))
	}
}
#endif

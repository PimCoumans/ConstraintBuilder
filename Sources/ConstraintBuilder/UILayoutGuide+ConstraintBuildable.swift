#if canImport(UIKit)
import UIKit

extension UILayoutGuide: ConstraintBuildable {
	public func applyConstraints(@ConstraintBuilder _ builder: (UILayoutGuide) -> [NSLayoutConstraint]) {
		NSLayoutConstraint.activate(builder(self))
	}
	
	public func extend(to other: UILayoutGuide) {
		applyConstraints { _ in
			leadingAnchor.constraint(equalTo: other.leadingAnchor)
			trailingAnchor.constraint(equalTo: other.trailingAnchor)
			topAnchor.constraint(equalTo: other.topAnchor)
			bottomAnchor.constraint(equalTo: other.bottomAnchor)
		}
	}
	
	public func center(in other: UILayoutGuide) {
		applyConstraints { _ in
			centerXAnchor.constraint(equalTo: other.centerXAnchor)
			centerYAnchor.constraint(equalTo: other.centerYAnchor)
		}
	}
}

#endif

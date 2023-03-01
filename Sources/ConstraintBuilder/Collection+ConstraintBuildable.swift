import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension Collection where Element: ConstraintBuildable {
	public func applyConstraints(@ConstraintBuilder _ builder: (Element.Constrained) -> [NSLayoutConstraint]) {
		for container in self {
			container.applyConstraints(builder)
		}
	}
}

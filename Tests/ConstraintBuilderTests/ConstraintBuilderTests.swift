import XCTest
import ConstraintBuilder

final class ConstraintBuilderTests: XCTestCase {
	#if canImport(UIKit) || canImport(tvOS)
	var superview: UIView!
	var view: UIView!
	var guide: UILayoutGuide!
	#elseif canImport(AppKit)
	var superview: NSView!
	var view: NSView!
	var guide: NSLayoutGuide!
	#endif
	override func setUp() {
		#if canImport(UIKit) || canImport(tvOS)
		superview = UIView()
		view = UIView()
		guide = UILayoutGuide()
		#elseif canImport(AppKit)
		superview = NSView()
		view = NSView()
		guide = NSLayoutGuide()
		#endif
		superview.addLayoutGuide(guide)
		superview.addSubview(view)
	}
	
	func testExtendToSuperview() {
		view.extendToSuperview()
	}
	
	func testCenterInSuperview() {
		view.centerInSuperview()
	}

	func textConstraintBuilding() {
		view.applyConstraints {
			$0.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
		}
	}

	func testAspectInSuperview() {
		var ratioConstraint = view.aspectFit(in: superview)
		ratioConstraint = ratioConstraint.updatingMultiplier(9/16)
	}

	func textGuideConstraintBuilding() {
		guide.applyConstraints {
			$0.leadingAnchor.constraint(equalTo: superview.leadingAnchor)
		}
	}

	func testGuideExtendToView() {
		guide.extend(to: superview)
	}

	func testViewExtendToGuide() {
		view.extend(to: guide)
	}
}

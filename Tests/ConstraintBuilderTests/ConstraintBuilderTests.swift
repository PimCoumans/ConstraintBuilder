import XCTest
import ConstraintBuilder

final class ConstraintBuilderTests: XCTestCase {
	#if canImport(UIKit) || canImport(tvOS)
	var superview: UIView!
	var view: UIView!
	#elseif canImport(AppKit)
	var superview: NSView!
	var view: NSView!
	#endif
	override func setUp() {
		#if canImport(UIKit) || canImport(tvOS)
		superview = UIView()
		view = UIView()
		#elseif canImport(AppKit)
		superview = NSView()
		view = NSView()
		#endif
		superview.addSubview(view)
	}
	
	func testExtendToSuperview() {
		view.extendToSuperview()
	}
	
	func testCenterInSuperview() {
		view.centerInSuperview()
	}

	func testAspectInSuperview() {
		var ratioConstraint = view.aspectFit(in: superview)
		ratioConstraint = ratioConstraint.updatingMultiplier(9/16)
	}
}

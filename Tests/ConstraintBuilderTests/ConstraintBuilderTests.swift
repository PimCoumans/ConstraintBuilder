import XCTest
import ConstraintBuilder

final class ConstraintBuilderTests: XCTestCase {
	#if canImport(UIKit)
	
	var superview: UIView!
	var view: UIView!
	override func setUp() {
		superview = UIView()
		view = UIView()
		superview.addSubview(view)
	}
	
	func testExtendToSuperview() {
		view.extendToSuperview()
	}
	
	func testCenterInSuperview() {
		view.centerInSuperview()
	}
	#endif
}

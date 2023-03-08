import XCTest
import ConstraintBuilder

final class ConstraintBuilderTests: XCTestCase {
	class CustomView: UIView {
		let customGuide = UILayoutGuide()
		override init(frame: CGRect) {
			super.init(frame: frame)
			addLayoutGuide(customGuide)
			customGuide.extend(to: self)
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
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

	func testCustomViewConstraints() {
		let customView = CustomView()
		superview.addSubview(customView)
		customView.extendToSuperviewLayoutMargins()
		customView.applyConstraints {
			$0.customGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor)
			$0.customGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			$0.customGuide.topAnchor.constraint(equalTo: view.topAnchor)
			$0.customGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		}
	}
}

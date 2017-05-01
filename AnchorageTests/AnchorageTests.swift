//
//  AnchorageTests.swift
//  AnchorageTests
//
//  Created by Zev Eisenberg on 4/29/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

@testable import Anchorage
import XCTest

#if os(macOS)
    typealias TestView = NSView
    typealias TestWindow = NSWindow
    let TestPriorityRequired = NSLayoutPriorityRequired
    let TestPriorityHigh = NSLayoutPriorityDefaultHigh
    let TestPriorityLow = NSLayoutPriorityDefaultLow
#else
    typealias TestView = UIView
    typealias TestWindow = UIWindow
    let TestPriorityRequired = UILayoutPriorityRequired
    let TestPriorityHigh = UILayoutPriorityDefaultHigh
    let TestPriorityLow = UILayoutPriorityDefaultLow
#endif

class AnchorageTests: XCTestCase {

    let cgEpsilon: CGFloat = 0.00001
    let fEpsilon: Float = 0.00001

    let view1 = TestView()
    let view2 = TestView()

    let window = TestWindow()

    override func setUp() {
#if os(macOS)
        window.contentView!.addSubview(view1)
        window.contentView!.addSubview(view2)
#else
        window.addSubview(view1)
        window.addSubview(view2)
#endif
    }

    func testFloatingPointConversion() {
        XCTAssertEqualWithAccuracy(CGFloat.pi, CGFloat.pi.toCGFloat(), accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(CGFloat(Float.pi), Float.pi.toCGFloat(), accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(CGFloat(Double.pi), Double.pi.toCGFloat(), accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(CGFloat(Float80.pi), Float80.pi.toCGFloat(), accuracy: cgEpsilon)
    }

    func testBasicEquality() {
        let constraint = view1.widthAnchor == view2.widthAnchor
        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqualWithAccuracy(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.priority, TestPriorityRequired, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testBasicLessThan() {
        let constraint = view1.widthAnchor <= view2.widthAnchor
        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqualWithAccuracy(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.priority, TestPriorityRequired, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testBasicGreaterThan() {
        let constraint = view1.widthAnchor >= view2.widthAnchor
        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqualWithAccuracy(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.priority, TestPriorityRequired, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithOffset() {
        let constraint = view1.widthAnchor == view2.widthAnchor + 10
        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqualWithAccuracy(constraint.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.priority, TestPriorityRequired, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithMultiplier() {
        let constraint = view1.widthAnchor == view2.widthAnchor / 2
        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqualWithAccuracy(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.multiplier, 0.5, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.priority, TestPriorityRequired, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithOffsetAndMultiplier() {
        let constraint = view1.widthAnchor == (view2.widthAnchor + 10) / 2
        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqualWithAccuracy(constraint.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.multiplier, 0.5, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.priority, TestPriorityRequired, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithPriorityConstant() {
        let constraint = view1.widthAnchor == view2.widthAnchor ~ .high
        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqualWithAccuracy(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.priority, TestPriorityHigh, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithPriorityLiteral() {
        let constraint = view1.widthAnchor == view2.widthAnchor ~ 750
        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqualWithAccuracy(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.priority, TestPriorityHigh, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithPriorityConstantMath() {
        let constraint = view1.widthAnchor == view2.widthAnchor ~ .high - 1
        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqualWithAccuracy(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.priority, TestPriorityHigh - 1, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithPriorityLiteralMath() {
        let constraint = view1.widthAnchor == view2.widthAnchor ~ Priority(750 - 1)
        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqualWithAccuracy(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.priority, TestPriorityHigh - 1, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithOffsetAndPriorityMath() {
        let constraint = view1.widthAnchor == view2.widthAnchor + 10 ~ .high - 1
        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqualWithAccuracy(constraint.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.priority, TestPriorityHigh - 1, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithOffsetAndMultiplierAndPriorityMath() {
        let constraint = view1.widthAnchor == (view2.widthAnchor + 10) / 2 ~ .high - 1
        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqualWithAccuracy(constraint.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.multiplier, 0.5, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(constraint.priority, TestPriorityHigh - 1, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testCenterAnchors() {
        let constraints = view1.centerAnchors == view2.centerAnchors + 10 ~ .high - 1

        let horizontal = constraints.first
        assertIdentical(horizontal.firstItem, view1)
        assertIdentical(horizontal.secondItem, view2)
        XCTAssertEqualWithAccuracy(horizontal.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(horizontal.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(horizontal.priority, TestPriorityHigh - 1, accuracy: fEpsilon)
        XCTAssertTrue(horizontal.isActive)
        XCTAssertEqual(horizontal.relation, .equal)
        XCTAssertEqual(horizontal.firstAttribute, .centerX)
        XCTAssertEqual(horizontal.secondAttribute, .centerX)

        let vertical = constraints.second
        assertIdentical(vertical.firstItem, view1)
        assertIdentical(vertical.secondItem, view2)
        XCTAssertEqualWithAccuracy(vertical.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(vertical.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(vertical.priority, TestPriorityHigh - 1, accuracy: fEpsilon)
        XCTAssertTrue(vertical.isActive)
        XCTAssertEqual(vertical.relation, .equal)
        XCTAssertEqual(vertical.firstAttribute, .centerY)
        XCTAssertEqual(vertical.secondAttribute, .centerY)
    }

    func testHorizontalAnchors() {
        let constraints = view1.horizontalAnchors == view2.horizontalAnchors + 10 ~ .high - 1

        let leading = constraints.first
        assertIdentical(leading.firstItem, view1)
        assertIdentical(leading.secondItem, view2)
        XCTAssertEqualWithAccuracy(leading.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(leading.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(leading.priority, TestPriorityHigh - 1, accuracy: fEpsilon)
        XCTAssertTrue(leading.isActive)
        XCTAssertEqual(leading.relation, .equal)
        XCTAssertEqual(leading.firstAttribute, .leading)
        XCTAssertEqual(leading.secondAttribute, .leading)

        let trailing = constraints.second
        assertIdentical(trailing.firstItem, view1)
        assertIdentical(trailing.secondItem, view2)
        XCTAssertEqualWithAccuracy(trailing.constant, -10, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(trailing.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(trailing.priority, TestPriorityHigh - 1, accuracy: fEpsilon)
        XCTAssertTrue(trailing.isActive)
        XCTAssertEqual(trailing.relation, .equal)
        XCTAssertEqual(trailing.firstAttribute, .trailing)
        XCTAssertEqual(trailing.secondAttribute, .trailing)
    }

    func testVerticalAnchors() {
        let constraints = view1.verticalAnchors == view2.verticalAnchors + 10 ~ .high - 1

        let top = constraints.first
        assertIdentical(top.firstItem, view1)
        assertIdentical(top.secondItem, view2)
        XCTAssertEqualWithAccuracy(top.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(top.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(top.priority, TestPriorityHigh - 1, accuracy: fEpsilon)
        XCTAssertTrue(top.isActive)
        XCTAssertEqual(top.relation, .equal)
        XCTAssertEqual(top.firstAttribute, .top)
        XCTAssertEqual(top.secondAttribute, .top)

        let bottom = constraints.second
        assertIdentical(bottom.firstItem, view1)
        assertIdentical(bottom.secondItem, view2)
        XCTAssertEqualWithAccuracy(bottom.constant, -10, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(bottom.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(bottom.priority, TestPriorityHigh - 1, accuracy: fEpsilon)
        XCTAssertTrue(bottom.isActive)
        XCTAssertEqual(bottom.relation, .equal)
        XCTAssertEqual(bottom.firstAttribute, .bottom)
        XCTAssertEqual(bottom.secondAttribute, .bottom)
    }

    func testEdgeAnchors() {
        let constraints = view1.edgeAnchors == view2.edgeAnchors + 10 ~ .high - 1

        let all = constraints.all
        XCTAssertEqual(all.count, 4)
        XCTAssertEqual(all[0].firstAttribute, .top)
        XCTAssertEqual(all[1].firstAttribute, .leading)
        XCTAssertEqual(all[2].firstAttribute, .bottom)
        XCTAssertEqual(all[3].firstAttribute, .trailing)

        let vertical = constraints.vertical
        XCTAssertEqual(vertical.count, 2)
        XCTAssertEqual(vertical[0].firstAttribute, .top)
        XCTAssertEqual(vertical[1].firstAttribute, .bottom)

        let horizontal = constraints.horizontal
        XCTAssertEqual(horizontal.count, 2)
        XCTAssertEqual(horizontal[0].firstAttribute, .leading)
        XCTAssertEqual(horizontal[1].firstAttribute, .trailing)

        let leading = constraints.leading
        assertIdentical(leading.firstItem, view1)
        assertIdentical(leading.secondItem, view2)
        XCTAssertEqualWithAccuracy(leading.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(leading.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(leading.priority, TestPriorityHigh - 1, accuracy: fEpsilon)
        XCTAssertTrue(leading.isActive)
        XCTAssertEqual(leading.relation, .equal)
        XCTAssertEqual(leading.firstAttribute, .leading)
        XCTAssertEqual(leading.secondAttribute, .leading)

        let trailing = constraints.trailing
        assertIdentical(trailing.firstItem, view1)
        assertIdentical(trailing.secondItem, view2)
        XCTAssertEqualWithAccuracy(trailing.constant, -10, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(trailing.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(trailing.priority, TestPriorityHigh - 1, accuracy: fEpsilon)
        XCTAssertTrue(trailing.isActive)
        XCTAssertEqual(trailing.relation, .equal)
        XCTAssertEqual(trailing.firstAttribute, .trailing)
        XCTAssertEqual(trailing.secondAttribute, .trailing)

        let top = constraints.top
        assertIdentical(top.firstItem, view1)
        assertIdentical(top.secondItem, view2)
        XCTAssertEqualWithAccuracy(top.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(top.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(top.priority, TestPriorityHigh - 1, accuracy: fEpsilon)
        XCTAssertTrue(top.isActive)
        XCTAssertEqual(top.relation, .equal)
        XCTAssertEqual(top.firstAttribute, .top)
        XCTAssertEqual(top.secondAttribute, .top)

        let bottom = constraints.bottom
        assertIdentical(bottom.firstItem, view1)
        assertIdentical(bottom.secondItem, view2)
        XCTAssertEqualWithAccuracy(bottom.constant, -10, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(bottom.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(bottom.priority, TestPriorityHigh - 1, accuracy: fEpsilon)
        XCTAssertTrue(bottom.isActive)
        XCTAssertEqual(bottom.relation, .equal)
        XCTAssertEqual(bottom.firstAttribute, .bottom)
        XCTAssertEqual(bottom.secondAttribute, .bottom)
    }

    func testInactiveBatchConstraints() {
        let constraints = Anchorage.batch(active: false) {
            view1.widthAnchor == view2.widthAnchor
            view1.heightAnchor == view2.heightAnchor / 2 ~ .low
        }

        let width = constraints[0]
        let height = constraints[1]

        assertIdentical(width.firstItem, view1)
        assertIdentical(width.secondItem, view2)
        XCTAssertEqualWithAccuracy(width.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(width.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(width.priority, TestPriorityRequired, accuracy: fEpsilon)
        XCTAssertFalse(width.isActive)
        XCTAssertEqual(width.relation, .equal)
        XCTAssertEqual(width.firstAttribute, .width)
        XCTAssertEqual(width.secondAttribute, .width)

        assertIdentical(height.firstItem, view1)
        assertIdentical(height.secondItem, view2)
        XCTAssertEqualWithAccuracy(height.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(height.multiplier, 0.5, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(height.priority, TestPriorityLow, accuracy: fEpsilon)
        XCTAssertFalse(height.isActive)
        XCTAssertEqual(height.relation, .equal)
        XCTAssertEqual(height.firstAttribute, .height)
        XCTAssertEqual(height.secondAttribute, .height)
    }

    func testActiveBatchConstraints() {
        let constraints = Anchorage.batch(active: true) {
            view1.widthAnchor == view2.widthAnchor
            view1.heightAnchor == view2.heightAnchor / 2 ~ .low
        }

        let width = constraints[0]
        let height = constraints[1]

        assertIdentical(width.firstItem, view1)
        assertIdentical(width.secondItem, view2)
        XCTAssertEqualWithAccuracy(width.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(width.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(width.priority, TestPriorityRequired, accuracy: fEpsilon)
        XCTAssertTrue(width.isActive)
        XCTAssertEqual(width.relation, .equal)
        XCTAssertEqual(width.firstAttribute, .width)
        XCTAssertEqual(width.secondAttribute, .width)

        assertIdentical(height.firstItem, view1)
        assertIdentical(height.secondItem, view2)
        XCTAssertEqualWithAccuracy(height.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(height.multiplier, 0.5, accuracy: cgEpsilon)
        XCTAssertEqualWithAccuracy(height.priority, TestPriorityLow, accuracy: fEpsilon)
        XCTAssertTrue(height.isActive)
        XCTAssertEqual(height.relation, .equal)
        XCTAssertEqual(height.firstAttribute, .height)
        XCTAssertEqual(height.secondAttribute, .height)
    }

}

extension AnchorageTests {

    func assertIdentical(_ expression1: @autoclosure (Void) -> AnyObject?, _ expression2: @autoclosure (Void) -> AnyObject?, _ message: @autoclosure (Void) -> String = "Objects were not identical", file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(expression1() === expression2(), message, file: file, line: line)
    }

}

public extension BinaryFloatingPoint {

    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }

}

extension NSLayoutAttribute: CustomDebugStringConvertible {

    public var debugDescription: String {
#if os(macOS)
        switch self {
        case .left: return "left"
        case .right: return "right"
        case .top: return "top"
        case .bottom: return "bottom"
        case .leading: return "leading"
        case .trailing: return "trailing"
        case .width: return "width"
        case .height: return "height"
        case .centerX: return "centerX"
        case .centerY: return "centerY"
        case .lastBaseline: return "lastBaseline"
        case .firstBaseline: return "firstBaseline"
        case .notAnAttribute: return "notAnAttribute"
        }
#else
        switch self {
        case .left: return "left"
        case .right: return "right"
        case .top: return "top"
        case .bottom: return "bottom"
        case .leading: return "leading"
        case .trailing: return "trailing"
        case .width: return "width"
        case .height: return "height"
        case .centerX: return "centerX"
        case .centerY: return "centerY"
        case .lastBaseline: return "lastBaseline"
        case .firstBaseline: return "firstBaseline"
        case .leftMargin: return "leftMargin"
        case .rightMargin: return "rightMargin"
        case .topMargin: return "topMargin"
        case .bottomMargin: return "bottomMargin"
        case .leadingMargin: return "leadingMargin"
        case .trailingMargin: return "trailingMargin"
        case .centerXWithinMargins: return "centerXWithinMargins"
        case .centerYWithinMargins: return "centerYWithinMargins"
        case .notAnAttribute: return "notAnAttribute"
        }
#endif
    }

}

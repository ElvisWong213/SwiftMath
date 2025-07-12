//
//  SwiftMathTests.swift
//  SwiftMathTests
//
//  Created by Elvis on 09/07/2025.
//

import XCTest
@testable import SwiftMath

final class SwiftMathTests: XCTestCase {
    func testInvalidMatrix() {
        let m = Matrix([
            [1, 2, 3],
            [1, 2, 3, 4]
        ])
        XCTAssertNil(m)
    }

    func testValidMatrix() {
        let m = Matrix([
            [1, 2, 3, 4],
            [1, 2, 3, 4]
        ])
        XCTAssertNotNil(m)
    }

    func testSubscript() {
        let m = Matrix([
            [-1, 3, 2],
            [0, -4, 1],
            [1, 0, -2]
        ])
        XCTAssertEqual(m?[0, 0], -1.0)
        XCTAssertEqual(m?[0, 1], 3.0)
        XCTAssertEqual(m?[1, 1], -4.0)
        XCTAssertEqual(m?[2, 2], -2.0)
    }
    
    func testSubscript2() {
        let m = Matrix([
            [1, 2, 3, 4],
            [5, 6, 7, 8],
            [9, 10, 11, 12],
            [13, 14, 15, 16],
        ])
        XCTAssertEqual(m?[0, 0], 1.0)
        XCTAssertEqual(m?[0, 3], 4.0)
        XCTAssertEqual(m?[2, 2], 11.0)
        XCTAssertEqual(m?[3, 3], 16.0)
    }

    func testMultiply() {
        let m1 = Matrix([
            [1, 2, 3],
            [5, 6, 7],
            [9, 10, 11],
            [13, 14, 15],
        ])

        let m2 = Matrix([
            [1, 2, 3, 4],
            [5, 6, 7, 8],
            [9, 10, 11, 12],
        ])

        let ans = Matrix([
            [38, 44, 50, 56],
            [98, 116, 134, 152],
            [158, 188, 218, 248],
            [218, 260, 302, 344]
        ])

        XCTAssertNotNil(m1)
        XCTAssertNotNil(m2)
        XCTAssertEqual(m1! * m2!, ans)
    }

    func testMultiplyFail() {
        let m1 = Matrix([
            [1, 2, 3],
            [5, 6, 7],
            [9, 10, 11],
        ])

        let m2 = Matrix([
            [1, 2, 3, 4],
            [5, 6, 7, 8],
        ])

        XCTAssertNotNil(m1)
        XCTAssertNotNil(m2)
        XCTAssertNil(m1! * m2!)
    }

    func testAdd() {
        let m1 = Matrix([
            [1, 2, 3, 4],
            [5, 6, 7, 8],
            [9, 10, 11, 12],
            [13, 14, 15, 16],
        ])

        let m2 = Matrix([
            [16, 15, 14, 13],
            [12, 11, 10, 9],
            [8, 7, 6, 5],
            [4, 3, 2, 1],
        ])

        let ans = Matrix([
            [17, 17, 17, 17],
            [17, 17, 17, 17],
            [17, 17, 17, 17],
            [17, 17, 17, 17],
        ])

        XCTAssertNotNil(m1)
        XCTAssertNotNil(m2)
        XCTAssertEqual(m1! + m2!, ans)
    }

    func testAddFail() {
        let m1 = Matrix([
            [1, 2, 3, 4],
            [5, 6, 7, 8],
            [9, 10, 11, 12],
        ])

        let m2 = Matrix([
            [16, 15, 14, 13],
            [12, 11, 10, 9],
            [8, 7, 6, 5],
            [4, 3, 2, 1],
        ])

        XCTAssertNotNil(m1)
        XCTAssertNotNil(m2)
        XCTAssertNil(m1! + m2!)
    }

    func testSubtract() {
        let m1 = Matrix([
            [1, 2, 3, 4],
            [5, 6, 7, 8],
            [9, 10, 11, 12],
            [13, 14, 15, 16],
        ])

        let m2 = Matrix([
            [16, 15, 14, 13],
            [12, 11, 10, 9],
            [8, 7, 6, 5],
            [4, 3, 2, 1],
        ])

        let ans = Matrix([
            [-15, -13, -11, -9],
            [-7, -5, -3, -1],
            [1, 3, 5, 7],
            [9, 11, 13, 15],
        ])

        XCTAssertNotNil(m1)
        XCTAssertNotNil(m2)
        XCTAssertEqual(m1! - m2!, ans)
    }

    func testSubtractFail() {
        let m1 = Matrix([
            [1, 2, 3, 4],
            [5, 6, 7, 8],
            [9, 10, 11, 12],
        ])

        let m2 = Matrix([
            [16, 15, 14, 13],
            [12, 11, 10, 9],
            [8, 7, 6, 5],
            [4, 3, 2, 1],
        ])

        XCTAssertNotNil(m1)
        XCTAssertNotNil(m2)
        XCTAssertNil(m1! - m2!)
    }

    func testAdj() {
        let m = Matrix([
            [-1, 3, 2],
            [0, -2, 1],
            [1, 0, -2]
        ])
        let ans = Matrix([
            [4, 6, 7],
            [1, 0, 1],
            [2, 3, 2]
        ])
        XCTAssertEqual(m?.getAdj(), ans)
    }
    
    func testDet() {
        let m = Matrix([
            [-3, 5, 2],
            [2, -4, -1],
            [-3, 0, 6]
        ])
        XCTAssertEqual(m?.getDet(), 3)
    }
    
    func testInverse() {
        let m = Matrix([
            [-1, 3, 2],
            [0, -2, 1],
            [1, 0, -2]
        ])
        let ans = Matrix([
            [4.0/3.0, 2, 7.0/3.0],
            [1.0/3.0, 0, 1.0/3.0],
            [2.0/3.0, 1, 2.0/3.0]
        ])
        XCTAssertEqual(m?.inverse(), ans)
    }
    
    func testInverse2() {
        let m = Matrix([
            [1, 1, 1, 1],
            [1, -1, 1, 0],
            [1, 1, 0, 0],
            [1, 0, 0, 0]
        ]) 
        let ans = Matrix([
            [0, 0, 0, 1],
            [0, 0, 1, -1],
            [0, 1, 1, -2],
            [1, -1, -2, 2]
        ])
        XCTAssertEqual(m?.inverse(), ans)
    }
}

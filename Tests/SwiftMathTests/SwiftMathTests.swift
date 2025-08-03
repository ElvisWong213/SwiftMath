//
//  SwiftMathTests.swift
//  SwiftMathTests
//
//  Created by Elvis on 09/07/2025.
//

import XCTest
@testable import SwiftMath

final class MatrixTests: XCTestCase {
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

    func testGaussianElimination() {
        let a = Matrix([
            [1, -2, 1],
            [2, 1, -3],
            [4, -7, 1]
        ])
        let b: [Double] = [0, 5, -1]

        let result = Matrix.gaussianElimination(a: a!, b: b)
        let ans: [Double] = [3, 2, 1]
        XCTAssertEqual(result?.count, ans.count)
        for i in ans.indices {
            XCTAssertEqual(result![i], ans[i], accuracy: 1e-10)
        }
    }

    func testGaussianElimination2() {
        let a = Matrix([
            [1, -3, 4],
            [2, -5, 6],
            [-3, 3, 4]
        ])
        let b: [Double] = [3, 6, 6]

        let result = Matrix.gaussianElimination(a: a!, b: b)
        let ans: [Double] = [10.5, 7.5, 3.75]
        XCTAssertEqual(result?.count, ans.count)
        for i in ans.indices {
            XCTAssertEqual(result![i], ans[i], accuracy: 1e-10)
        }
    }

    func testGaussianElimination3() {
        let a = Matrix([
            [3, -1, -1],
            [1, 1, 0],
            [2, 0, -3]
        ])
        let b: [Double] = [5, 0, 2]

        let result = Matrix.gaussianElimination(a: a!, b: b)
        let ans: [Double] = [1.3, -1.3, 0.2]
        XCTAssertEqual(result?.count, ans.count)
        for i in ans.indices {
            XCTAssertEqual(result![i], ans[i], accuracy: 1e-10)
        }
    }
 
    func testGaussianElimination4() {
        let a = Matrix([
            [ 2,  1, -1,  2,  0,  3, -2,  4,  1,  0],
            [ 4,  5, -3,  6, -1,  2,  0,  3,  2, -1],
            [ 0, -2,  7,  3,  1,  0,  5, -1,  2,  4],
            [ 3,  0,  1, -2,  4,  2,  3,  1, -3,  2],
            [ 1, -1,  0,  2,  5,  3,  2,  0,  4,  1],
            [ 2,  3, -2,  1,  0,  6,  1, -1,  2,  3],
            [ 0,  2,  3, -1,  2,  0,  7,  2, -2,  1],
            [ 1,  4,  0,  2,  3, -2,  2,  8,  0,  2],
            [ 2,  0,  4, -3,  1,  2,  1,  3,  9, -1],
            [ 0, -1,  2,  1,  4,  0, -1,  2,  1, 10]
        ])
        let b: [Double] = [8, 19, 13, 7, 15, 21, 14, 30, 25, 18]

        let result = Matrix.gaussianElimination(a: a!, b: b)
        let ans: [Double] = [-9.502862098236018026, 29.571101125024768459, 24.313859649551971794, 2.7175243584129787858, 18.389280830546660945, 
                            6.2596571353087519744, -19.208693439924068992, -9.2043244591979765748, -4.0656264448092057481, -7.406568393139770783]
        XCTAssertEqual(result?.count, ans.count)
        for i in ans.indices {
            XCTAssertEqual(result![i], ans[i], accuracy: 1e-10)
        }
    }

    func testGaussianEliminationFail() {
        let a = Matrix([
            [1, -2, 1],
            [2, 1, -3],
        ])
        let b: [Double] = [0, 5, -1]

        let result = Matrix.gaussianElimination(a: a!, b: b)
        XCTAssertNil(result)
    }
}

//
//  SwiftMathTests.swift
//  SwiftMathTests
//
//  Created by Elvis on 09/07/2025.
//

import XCTest
@testable import SwiftMath

final class SwiftMathTests: XCTestCase {
    func testAdj() throws {
        guard let m = Matrix(matrix: [
            [-1, 3, 2],
            [0, -2, 1],
            [1, 0, -2]
        ]) else {
            return
        }
        guard let ans = Matrix(matrix: [
            [4, 6, 7],
            [1, 0, 1],
            [2, 3, 2]
        ]) else {
            return
        }
        XCTAssertEqual(m.getAdj(), ans)
    }
    
    func testDet() {
        guard let m = Matrix(matrix: [
            [-3, 5, 2],
            [2, -4, -1],
            [-3, 0, 6]
        ]) else {
            return
        }
        XCTAssertEqual(m.getDet(), 3)
    }
    
    func testInverse() {
        guard let m = Matrix(matrix: [
            [-1, 3, 2],
            [0, -2, 1],
            [1, 0, -2]
        ]) else {
            return
        }
        guard let ans = Matrix(matrix: [
            [4.0/3.0, 2, 7.0/3.0],
            [1.0/3.0, 0, 1.0/3.0],
            [2.0/3.0, 1, 2.0/3.0]
        ]) else {
            return
        }
        XCTAssertEqual(m.inverse(), ans)
    }
    
    func testInverse2() {
        guard let m = Matrix(matrix: [
            [1, 1, 1, 1],
            [1, -1, 1, 0],
            [1, 1, 0, 0],
            [1, 0, 0, 0]
        ]) else {
            return
        }
        guard let ans = Matrix(matrix: [
            [0, 0, 0, 1],
            [0, 0, 1, -1],
            [0, 1, 1, -2],
            [1, -1, -2, 2]
        ]) else {
            return
        }
        XCTAssertEqual(m.inverse(), ans)
    }
}

//
//  Matrix.swift
//  ColorFilters
//
//  Created by Elvis on 08/07/2025.
//

import Foundation

public struct Matrix {
    public let row: Int
    public let col: Int
    var values: [Double]
    
    public init(row: Int, col: Int) {
        self.row = row
        self.col = col
        self.values = Array(repeating: 0.0, count: row * col)
    }
    
    public init?(_ matrix: [[Double]]) {
        if matrix.isEmpty {
            return nil
        }
        let colsCount = matrix[0].count
        if colsCount == 0 {
            return nil
        }
        for row in matrix {
            if row.count != colsCount {
                return nil
            }
        }
        self = Self(row: matrix.count, col: matrix[0].count)
        self.values = matrix.flatMap { $0 }
    }

    public func isSquare() -> Bool {
        return self.row == self.col
    }
    
    func isValidIndex(row: Int, col: Int) -> Bool {
        return row >= 0 && row < self.row && col >= 0 && col < self.col
    }
    
    public subscript(row: Int, col: Int) -> Double {
        get {
            assert(isValidIndex(row: row, col: col), "Index out of range")
            return values[(row * self.col) + col]
        }
        set {
            assert(isValidIndex(row: row, col: col), "Index out of range")
            values[(row * self.col) + col] = newValue
        }
    }
    
    public func transpose() -> Self {
        var newMatrix = Matrix(row: col, col: row)
        for r in 0..<self.row {
            for c in 0..<self.col {
                newMatrix[c, r] = self[r, c]
            }
        }
        return newMatrix
    }
    
    public func inverse() -> Self? {
        guard let det = getDet(), let adj = getAdj() else {
            return nil
        }
        return (1.0 / det) * adj
    }
    
    public func getDet() -> Double? {
        if !isSquare() {
            return nil
        }
        return det(self)
    }
    
    func det(_ matrix: Self) -> Double? {
        if !matrix.isSquare() {
            return nil
        }
        let n = matrix.row
        if n == 1 {
            return matrix[0, 0]
        }
        if n == 2 {
            return matrix[0, 0] * matrix[1, 1] - matrix[1, 0] * matrix[0, 1]
        }
        var result: Double = 0.0
        var sign: Double = 1.0
        for c in 0..<n {
            guard let cofactor = getCofactor(matrix, 0, c), let det = det(cofactor) else {
                return nil
            }
            result += sign * matrix[0, c] * det
            sign *= -1.0
        }
        return result
    }
    
    public func getAdj() -> Self? {
        if !isSquare() {
            return nil
        }
        let n = self.row
        var newMatrix = Matrix(row: n, col: n)
        for r in 0..<n {
            for c in 0..<n {
                guard let ans = adj(self, r: r, c: c) else {
                    return nil
                }
                newMatrix[r, c] = ans
            }
        }
        return newMatrix.transpose()
    }
    
    func adj(_ matrix: Self, r: Int, c: Int) -> Double? {
        let n = matrix.row
        if n == 2 {
            guard let cofactor = getCofactor(matrix, r, c) else {
                return nil
            }
            return cofactor[0, 0]
        }
        var result: Double = 0.0
        let sign: Double = (c + r) % 2 == 0 ? 1.0 : -1.0
        guard let cofactor = getCofactor(matrix, r, c), let det = det(cofactor) else {
            return nil
        }
        result += sign * det
        return result
    }
    
    func getCofactor(_ matrix: Self, _ row: Int, _ col: Int) -> Self? {
        if !matrix.isSquare() {
            return nil
        }
        var newMatrix = Matrix(row: matrix.row - 1, col: matrix.col - 1)
        var i = 0
        var j = 0
        for r in 0..<matrix.row {
            for c in 0..<matrix.col {
                if r == row || c == col {
                    continue
                }
                newMatrix[i, j] = matrix[r, c]
                j += 1
                if j == newMatrix.col {
                    i += 1
                    j = 0
                }
            }
        }
        return newMatrix
    }
    
    public func toArray() -> [Double] {
        return values
    }
}

extension Matrix {
    public static func +(lhs: Self, rhs: Self) -> Self? {
        if lhs.row != rhs.row || lhs.col != rhs.col {
            return nil
        }
        var newMatrix = Matrix(row: lhs.row, col: lhs.col)
        for index in lhs.values.indices {
            newMatrix.values[index] = lhs.values[index] + rhs.values[index]
        }
        return newMatrix
    }

    public static func -(lhs: Self, rhs: Self) -> Self? {
        if lhs.row != rhs.row || lhs.col != rhs.col {
            return nil
        }
        var newMatrix = Matrix(row: lhs.row, col: lhs.col)
        for index in lhs.values.indices {
            newMatrix.values[index] = lhs.values[index] - rhs.values[index]
        }
        return newMatrix
    }

    public static func *(lhs: Double, rhs: Self) -> Self {
        var newMatrix = rhs
        for i in 0..<rhs.row {
            for j in 0..<rhs.col {
                newMatrix[i, j] *= lhs
            }
        }
        return newMatrix
    }
    
    public static func *(lhs: Self, rhs: Double) -> Self {
        return rhs * lhs
    }
    
    public static func *(lhs: Self, rhs: Self) -> Self? {
        if lhs.col != rhs.row {
            return nil
        }
        var newMatrix = Matrix(row: lhs.row, col: rhs.col)
        for i in 0..<newMatrix.row {
            for j in 0..<newMatrix.col {
                newMatrix[i, j] = multiply(lhs, rhs, row: i, col: j)
            }
        }
        return newMatrix
    }
    
    static func multiply(_ lhs: Self, _ rhs: Self, row: Int, col: Int) -> Double {
        var result: Double = 0
        for i in 0..<lhs.col {
            result += lhs[row, i] * rhs[i, col]
        }
        return result
    }
}

extension Matrix: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.row != rhs.row || lhs.col != rhs.col {
            return false
        }
        for index in lhs.values.indices {
            if !isEqual(lhs.values[index], rhs.values[index]) {
                return false
            }
        }
        return true
    }
    
    static func isEqual(_ a: Double, _ b: Double, epsilon: Double = 1e-9) -> Bool {
        return abs(a - b) < epsilon
    }
}

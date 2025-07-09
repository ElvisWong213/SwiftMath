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
    public var values: [[Double]]
    
    public init(row: Int, col: Int) {
        self.row = row
        self.col = col
        self.values = Array(repeating: Array(repeating: 0.0, count: col), count: row)
    }
    
    public init?(matrix: [[Double]]) {
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
        self.row = matrix.count
        self.col = matrix[0].count
        self.values = matrix
    }
    
    public func transpose() -> Self {
        var newMatrix = Matrix(row: col, col: row)
        for r in 0..<self.row {
            for c in 0..<self.col {
                newMatrix.values[c][r] = self.values[r][c]
            }
        }
        return newMatrix
    }
    
    public func inverse() -> Self? {
        guard let det = getDet() else {
            return nil
        }
        let adj = getAdj()
        return (1.0 / det) * adj
    }
    
    public func getDet() -> Double? {
        if self.row != self.col {
            return nil
        }
        return det(self)
    }
    
    func det(_ matrix: Self) -> Double {
        let n = matrix.row
        if n == 2 {
            return matrix.values[0][0] * matrix.values[1][1] - matrix.values[1][0] * matrix.values[0][1]
        }
        var result: Double = 0.0
        var sign: Double = 1.0
        for c in 0..<n {
            result += sign * matrix.values[0][c] * det(getCofactor(matrix, 0, c))
            sign *= -1.0
        }
        return result
    }
    
    public func getAdj() -> Self {
        let n = self.row
        var newMatrix = Matrix(row: n, col: n)
        for r in 0..<n {
            for c in 0..<n {
                let ans = adj(self, r: r, c: c)
                newMatrix.values[r][c] = ans
            }
        }
        return newMatrix.transpose()
    }
    
    func adj(_ matrix: Self, r: Int, c: Int) -> Double {
        let n = matrix.row
        if n == 2 {
            let minor = getCofactor(matrix, r, c)
            return minor.values[0][0]
        }
        var result: Double = 0.0
        let sign: Double = (c + r) % 2 == 0 ? 1.0 : -1.0
        result += sign * det(getCofactor(matrix, r, c))
        return result
    }
    
    func getCofactor(_ matrix: Self, _ row: Int, _ col: Int) -> Self {
        var newMatrix = Matrix(row: matrix.row - 1, col: matrix.col - 1)
        var i = 0
        var j = 0
        for r in 0..<matrix.row {
            for c in 0..<matrix.col {
                if r == row || c == col {
                    continue
                }
                newMatrix.values[i][j] = matrix.values[r][c]
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
        return values.flatMap { $0 }
    }
}

extension Matrix {
    public static func *(lhs: Double, rhs: Self) -> Self {
        var m = rhs
        for i in 0..<rhs.row {
            for j in 0..<rhs.col {
                m.values[i][j] *= lhs
            }
        }
        return m
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
                newMatrix.values[i][j] = multiply(lhs, rhs, row: i, col: j)
            }
        }
        return newMatrix
    }
    
    static func multiply(_ lhs: Self, _ rhs: Self, row: Int, col: Int) -> Double {
        var result: Double = 0
        for i in 0..<lhs.row {
            result += lhs.values[row][i] * rhs.values[i][col]
        }
        return result
    }
}

extension Matrix: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.row != rhs.row || lhs.col != rhs.col {
            return false
        }
        for r in 0..<lhs.row {
            for c in 0..<lhs.col {
                if !isEqual(lhs.values[r][c], rhs.values[r][c]) {
                    return false
                }
            }
        }
        return true
    }
    
    static func isEqual(_ a: Double, _ b: Double, epsilon: Double = 1e-9) -> Bool {
        return abs(a - b) < epsilon
    }
}

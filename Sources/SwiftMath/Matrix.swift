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
    public var count: Int {
        return self.row
    }
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
        self.init(row: matrix.count, col: matrix[0].count)
        self.values = matrix.flatMap { $0 }
    }

    public func isSquare() -> Bool {
        return self.row == self.col
    }
    
    func isValidIndex(row: Int, col: Int) -> Bool {
        return row >= 0 && row < self.row && col >= 0 && col < self.col
    }

    func isValidIndex(row: Int) -> Bool {
        return row >= 0 && row < self.row
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

    public subscript(row: Int) -> [Double] {
        get {
            assert(isValidIndex(row: row), "Index out of range")
            var array: [Double] = []
            array.reserveCapacity(self.col)
            
            for c in 0..<self.col {
                array.append(self[row, c])
            }
            return array
        }
        set {
            assert(isValidIndex(row: row), "Index out of range")
            assert(self.col == newValue.count, "Array size does not match")
            for i in 0..<newValue.count {
                self[row, i] = newValue[i]
            }
        }
    }
    
    public func transpose() -> Matrix {
        var newMatrix = Matrix(row: col, col: row)
        for r in 0..<self.row {
            for c in 0..<self.col {
                newMatrix[c, r] = self[r, c]
            }
        }
        return newMatrix
    }
    
    public func inverse() -> Matrix? {
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
    
    func det(_ matrix: Matrix) -> Double? {
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
    
    public func getAdj() -> Matrix? {
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
    
    func adj(_ matrix: Matrix, r: Int, c: Int) -> Double? {
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
    
    func getCofactor(_ matrix: Matrix, _ row: Int, _ col: Int) -> Matrix? {
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

    public func to2dArray() -> [[Double]] {
        var matrix: [[Double]] = []
        for r in 0..<self.row {
            matrix.append(self[r])
        }
        return matrix
    }
}

extension Matrix {
    public static func gaussianElimination(a: Matrix, b: [Double]) -> [Double]? {
        if b.count != a.count {
            print("Matrix size does not match array size")
            return nil
        }
        if !a.isSquare() {
            print("Number of equations does not match number of unknowns")
            return nil
        }

        let n = a.count

        guard var newMatrix = columnStack(a: a, b: b) else {
            return nil
        }

        for i in 0..<n {
            var pivotRow = i
            var maxValue = abs(newMatrix[i, i])

            for r in i+1..<n {
                if abs(newMatrix[r, i]) > maxValue {
                    maxValue = abs(newMatrix[r, i])
                    pivotRow = r
                }
            }

            if maxValue < 1e-10 {
                print("No unique solution")
                return nil
            }

            if pivotRow != i {
                let dummy = newMatrix[i]
                newMatrix[i] = newMatrix[pivotRow]
                newMatrix[pivotRow] = dummy
            }

            let pivot = newMatrix[i][i]
            newMatrix[i] = newMatrix[i].map { $0 / pivot }
            let rowMatrix = newMatrix[i]

            for r in i+1..<n {
                let factor = newMatrix[r][i]
                
                for index in rowMatrix.indices {
                    newMatrix[r, index] = newMatrix[r, index] - rowMatrix[index] * factor
                }
            }
        }

        var output: [Double] = Array(repeating: 0, count: n)
        for i in stride(from: n-1, to: -1, by: -1) {
            output[i] = newMatrix[i, n]
            for j in i+1..<n {
                output[i] -= newMatrix[i][j] * output[j]
            }
        }

        return output
    }

    public static func columnStack(a: Matrix, b: [Double]) -> Matrix? {
        var newMatrix = a.to2dArray()

        if b.count != a.count {
            return nil
        }

        for (index, value) in b.enumerated() {
            newMatrix[index].append(value)
        }

        return Matrix(newMatrix)
    }
}

extension Matrix {
    public static func +(lhs: Matrix, rhs: Matrix) -> Matrix? {
        if lhs.row != rhs.row || lhs.col != rhs.col {
            return nil
        }
        var newMatrix = Matrix(row: lhs.row, col: lhs.col)
        for index in lhs.values.indices {
            newMatrix.values[index] = lhs.values[index] + rhs.values[index]
        }
        return newMatrix
    }

    public static func -(lhs: Matrix, rhs: Matrix) -> Matrix? {
        if lhs.row != rhs.row || lhs.col != rhs.col {
            return nil
        }
        var newMatrix = Matrix(row: lhs.row, col: lhs.col)
        for index in lhs.values.indices {
            newMatrix.values[index] = lhs.values[index] - rhs.values[index]
        }
        return newMatrix
    }

    public static func *(lhs: Double, rhs: Matrix) -> Matrix {
        var newMatrix = rhs
        for i in 0..<rhs.row {
            for j in 0..<rhs.col {
                newMatrix[i, j] *= lhs
            }
        }
        return newMatrix
    }
    
    public static func *(lhs: Matrix, rhs: Double) -> Matrix {
        return rhs * lhs
    }
    
    public static func *(lhs: Matrix, rhs: Matrix) -> Matrix? {
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
    
    static func multiply(_ lhs: Matrix, _ rhs: Matrix, row: Int, col: Int) -> Double {
        var result: Double = 0
        for i in 0..<lhs.col {
            result += lhs[row, i] * rhs[i, col]
        }
        return result
    }
}

extension Matrix: Equatable {
    public static func == (lhs: Matrix, rhs: Matrix) -> Bool {
        return lhs.isEqual(to: rhs)
    }

    public func isEqual(to other: Matrix, accuracy: Double = 1e-10) -> Bool {
        if self.row != other.row || self.col != other.col {
            return false
        }
        for index in self.values.indices {
            if !Matrix.isEqual(self.values[index], other.values[index], accuracy) {
                return false
            }
        }
        return true
    }
    
    static func isEqual(_ a: Double, _ b: Double, _ accuracy: Double) -> Bool {
        return abs(a - b) < accuracy
    }
}

extension Matrix: CustomStringConvertible {
    public var description: String {
        var description = "***Matrix***\n"
        description += "Row: \(self.row)\n"
        description += "Col: \(self.col)\n"
        description += "Matrix values:\n"
        for r in 0..<self.row {
            switch r {
            case 0:
                description += "\t┌"
            case self.row - 1:
                description += "\t└"
            default:
                description += "\t│"
            }

            for c in 0..<self.col {
                if c == 0 {
                    description += "["
                }
                description += "\(self[r, c])"
                if c == self.col - 1 {
                    description += "]"
                } else {
                    description += ",\t"
                }
            }

            switch r {
            case 0:
                description += "┐\n"
            case self.row - 1:
                description += "┘"
            default:
                description += "│\n"
            }
        }
        return description
    }
}

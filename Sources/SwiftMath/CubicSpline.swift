import Foundation

public struct CubicSpline {
    public var points: [CGPoint]
    var result: [Double]?
    
    public init() {
        self.points = []
        self.result = nil
    }

    public init(points: [CGPoint]) {
        self.points = points
        self.result = nil
        self.performCalculation()
    }

    public mutating func performCalculation() {
        if self.points.count < 2 {
            return
        }
        
        var a: [[Double]] = []
        var b: [Double] = []
        let numberOfPoints = points.count - 1

        // Evaluate known points
        for (index, point) in points.enumerated() {
            var startIndex = index == 0 ? 0 : 4 * (index - 1)
            var array: [Double] = Array(repeating: 0, count: numberOfPoints * 4)
            let values: [Double] = [point.x * point.x * point.x, point.x * point.x, point.x, 1]

            for value in values {
                array[startIndex] = value
                startIndex += 1
            }
            a.append(array)
            b.append(point.y)
            
            if index <= 0 || index >= points.count-1 {
                continue
            }

            startIndex = 4 * index
            array = Array(repeating: 0, count: numberOfPoints * 4)
            for value in values {
                array[startIndex] = value
                startIndex += 1
            }
            a.append(array)
            b.append(point.y)
        }

        // Continuity of first derivative
        for index in 1..<points.count-1 {
            let point = points[index]

            var startIndex = 4 * (index - 1)
            var array: [Double] = Array(repeating: 0, count: numberOfPoints * 4)
            let values: [Double] = [3 * point.x * point.x, 2 * point.x, 1, 0, -3 * point.x * point.x, -2 * point.x, -1, 0]

            for value in values {
                array[startIndex] = value
                startIndex += 1
            }
            a.append(array)
            b.append(0)
        }

        // Continuity of second derivative
        for index in 1..<points.count-1 {
            let point = points[index]

            var startIndex = 4 * (index - 1)
            var array: [Double] = Array(repeating: 0, count: numberOfPoints * 4)
            let values: [Double] = [6 * point.x, 2, 0, 0, -6 * point.x, -2, 0, 0]

            for value in values {
                array[startIndex] = value
                startIndex += 1
            }
            a.append(array)
            b.append(0)
        }

        // Natural cubic spline
        if let firstPoint = points.first {
            var startIndex = 0
            var array: [Double] = Array(repeating: 0, count: numberOfPoints * 4)
            let values: [Double] = [6 * firstPoint.x, 2, 0, 0]

            for value in values {
                array[startIndex] = value
                startIndex += 1
            }
            a.append(array)
            b.append(0)
        }

        if let lastPoint = points.last {
            var startIndex = 4 * (numberOfPoints - 1)
            var array: [Double] = Array(repeating: 0, count: numberOfPoints * 4)
            let values: [Double] = [6 * lastPoint.x, 2, 0, 0]

            for value in values {
                array[startIndex] = value
                startIndex += 1
            }
            a.append(array)
            b.append(0)
        }

        guard let aMatrix = Matrix(a) else {
            return
        }

        self.result = Matrix.gaussianElimination(a: aMatrix, b: b)
    }

    public func getResultArray() -> [Double]? {
        return self.result
    }

    public func getY(given x: Double) -> Double? {
        guard let result else {
            return nil
        }
        var equationIndex = -1

        for index in 0..<self.points.count-1 {
            let pointA = self.points[index]
            let pointB = self.points[index + 1]
            if x >= pointA.x && x <= pointB.x {
                equationIndex = index
                break
            }
        }

        if equationIndex < 0 {
            return nil
        }

        let startIndex = 4 * equationIndex
        return result[startIndex] * x * x * x + result[startIndex + 1] * x * x + result[startIndex + 2] * x + result[startIndex + 3]
    }
}

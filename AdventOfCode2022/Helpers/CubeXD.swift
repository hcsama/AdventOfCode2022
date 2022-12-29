//
//  CubeXD.swift
//  AdventOfCode2015
//
//  Created by Hans-Christian Fuchs on 28.12.21.
//

import Foundation


class CubeXD : Hashable, Equatable, Sequence {
    var topLeft: VectorXD
    var botRight: VectorXD

    init(_ c: CubeXD) {
        topLeft = c.topLeft
        botRight = c.botRight
    }

    init(_ tL: VectorXD, _ bR: VectorXD) {
        topLeft = tL
        botRight = bR
        CalculateEnclosing([tL, bR])
    }

    init<T: Collection<VectorXD>>(_ points: T) {
        if let point = points.first {
            topLeft = VectorXD(point)
            botRight = VectorXD(point)
            CalculateEnclosing(points)
        } else {
            topLeft = VectorXD(1)
            botRight = VectorXD(1)
            assert(false, "Empty CubeXD in init()")
        }
    }

    func InsetCube(_ by: Int) -> CubeXD {
        let newCube = CubeXD(self)
        for d in 0..<topLeft.dim {
            newCube.topLeft.v[d] += by
            newCube.topLeft.v[d] -= by
        }
        return newCube
    }

    private func CalculateEnclosing<T: Collection<VectorXD>>(_ points: T) {
        let dim = points.first!.dim
        for point in points {
            assert(dim == point.dim, "Dimensional mismatch in points list for CubeXD")
            for d in 0..<dim {
                topLeft.v[d] = Swift.min(topLeft.v[d], point.v[d])
                botRight.v[d] = Swift.max(botRight.v[d], point.v[d])
            }
        }
    }

    func contains(_ point: VectorXD) -> Bool {
        return !notContains(point)
    }

    func notContains(_ point: VectorXD) -> Bool {
        for d in 0..<point.dim {
            if point.v[d] < topLeft.v[d] || point.v[d] > botRight.v[d] {
                return true
            }
        }
        return false
    }

    static func == (lhs: CubeXD, rhs: CubeXD) -> Bool {
        return lhs.topLeft == rhs.topLeft && lhs.botRight == rhs.botRight
    }

    /**
     Calculates cartesian volume

     - returns: An Int volume

     */
    func Volume() -> Int {
        var vol = 1
        for d in 0..<topLeft.v.count {
            vol *= abs(botRight.v[d] - topLeft.v[d]) + 1
        }
        return vol
    }

    /**
     Tests if two CubeXD overlap. Returns a CubeXD? of the overlap or nil

     - parameter other: The CubeXD to test against

     - returns: A CubeXD if two CubeXD ocverlap, nil

     */
    func Intersect(_ other: CubeXD) -> CubeXD? {
        let (tL, bR) = Intersect(topLeft, botRight, other.topLeft, other.botRight)
        if tL != nil && bR != nil {
            return CubeXD(tL!, bR!)
        }
        return nil
    }

    /**
     Tests if two CubeXD occupy the same space. Returns boolean

     - parameter other: The CubeXD to test against

     - returns: true if the two CubeXD occupy the same space, false otherwise

     */
    func SameSpace(_ other: CubeXD) -> Bool {
        if topLeft.v.count != other.topLeft.v.count {
            return false
        }
        let myVol = Volume()
        if other.Volume() == myVol {
            if let inter = Intersect(other) {
                if inter.Volume() == myVol {
                    return true
                }
            }
        }
        return false
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(topLeft)
        hasher.combine(botRight)
    }

    private func Intersect(_ a0: Int, _ b0: Int, _ a1: Int, _ b1: Int) -> (Int?, Int?)
    {
        var x0 = a0
        var y0 = b0
        var x1 = a1
        var y1 = b1
        if x0 > x1 {
            var hlp = x0
            x0 = x1
            x1 = hlp
            hlp = y0
            y0 = y1
            y1 = hlp
        }
        var matchx: Int? = nil
        var matchy: Int? = nil
        if x1 >= x0 && x1 <= y0 {
            matchx = Swift.max(x0, x1)
        }
        if y0 >= x1 {
            matchy = Swift.min(y0, y1)
        }
        return (matchx, matchy)
    }

    private func Intersect(_ topLeft0: VectorXD, _ botRight0: VectorXD, _ topLeft1: VectorXD, _ botRight1: VectorXD) -> (VectorXD?, VectorXD?)
    {
        var tL: [Int] = []
        var bR: [Int] = []
        assert(topLeft0.v.count == topLeft1.v.count, "CubeXD dimensional mismatch")

        for d in 0..<topLeft0.v.count {
            let (x0, x1) = Intersect(topLeft0.v[d], botRight0.v[d], topLeft1.v[d], botRight1.v[d])
            if x0 == nil || x1 == nil {
                return (nil, nil)
            }
            tL.append(x0!)
            bR.append(x1!)
        }
        return (VectorXD(tL), VectorXD(bR))
    }

    var description: String {
        get {
            var res = "["
            res.append(topLeft.description)
            res.append(", ")
            res.append(botRight.description)
            return res + "]"
        }
    }

    func makeIterator() -> CubeXDIterator {
        return CubeXDIterator(self)
    }
}

struct CubeXDIterator : IteratorProtocol {
    let cube: CubeXD
    var curPoint: VectorXD? = nil
    var done = false

    init(_ cube: CubeXD) {
        self.cube = cube
    }

    func incrDim(_ point: inout VectorXD, _ curDim: Int) -> Bool{
        if curDim == point.dim {
            return true
        }
        point.v[curDim] += 1
        if point.v[curDim] > cube.botRight.v[curDim] {
            point.v[curDim] = cube.topLeft.v[curDim]
            if incrDim(&point, curDim + 1) {
                return true
            }
        }
        return false
    }

    mutating func next() -> VectorXD? {
        if done {
            return nil
        }
        if let lastPoint = curPoint {
            curPoint = VectorXD(lastPoint)
            if incrDim(&curPoint!, 0) {
                curPoint = nil
                done = true
            }
        } else {
            curPoint = VectorXD(cube.topLeft)
        }
        return curPoint
    }
}

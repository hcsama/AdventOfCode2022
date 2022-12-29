//
//  VectorXD.swift
//  AdventOfCode2021
//
//  Created by Hans-Christian Fuchs on 02.12.21.
//

import Foundation


/**
 A vector with Int coordinates and of arbitrary dimensions.
 Conforms to protocols Hashable and Comparable.
 */
class VectorXD: Equatable, Hashable, CustomStringConvertible
{
    var v: [Int]
    let dim: Int

    /**
     Creates a vector with <dim> dimensions. Coordinates are initialized to 0

     - parameter dim: The number of dimensions
     */
    init(_ d: Int)
    {
        v = Array(repeating: 0, count: d)
        dim = d
    }

    /**
     Creates a vector from an integer array. Dimensions are based on the length of the array

     - parameter coords: The integer input array
     */
    init(_ coords: [Int])
    {
        v = coords
        dim = coords.count
    }

    /**
     Creates a vector from another vector

     - parameter vec: The other vector
     */
    init(_ vec: VectorXD)
    {
        v = vec.v
        dim = vec.dim
    }

    static func == (lhs: VectorXD, rhs: VectorXD) -> Bool
    {
        return lhs == rhs.v
    }

    static func == (lhs: VectorXD, rhs: [Int]) -> Bool
    {
        let same = lhs.dim == rhs.count
        if same
        {
            for i in 0..<lhs.dim
            {
                if lhs.v[i] != rhs[i]
                {
                    return false
                }
            }
        }
        return same
    }

    static func + (lhs: VectorXD, rhs: VectorXD) -> VectorXD
    {
        let v = VectorXD(lhs)
        v.Add(rhs.v)
        return v
    }

    static func - (lhs: VectorXD, rhs: VectorXD) -> VectorXD
    {
        let v = VectorXD(lhs)
        v.Sub(rhs.v)
        return v
    }

    static func - (lhs: VectorXD, rhs: [Int]) -> VectorXD
    {
        let v = VectorXD(lhs)
        v.Sub(rhs)
        return v
    }

    static func + (lhs: VectorXD, rhs: [Int]) -> VectorXD
    {
        let v = VectorXD(lhs)
        v.Add(rhs)
        return v
    }

    static func * (lhs: VectorXD, rhs: Int) -> VectorXD
    {
        let v = VectorXD(lhs)
        var i = 0
        while i < v.dim {
            v.v[i] *= rhs
            i += 1
        }
        return v
    }

    func hash(into hasher: inout Hasher)
    {
        hasher.combine(v)
    }

    private func Add(_ b: [Int])
    {
        assert(dim == b.count, "Dimensional mismatch")
        var i = 0
        while i < dim {
            v[i] += b[i]
            i += 1
        }
    }

    private func Sub(_ b: [Int])
    {
        assert(dim == b.count, "Dimensional mismatch")
        var i = 0
        while i < dim {
            v[i] -= b[i]
            i += 1
        }
    }

    private func Neighbor(_ n: inout [VectorXD], _ curVec: VectorXD, _ curDim: Int)
    {
        if curDim < dim
        {
            var i = -1
            while i <= 1 {
                let vec = VectorXD(dim)
                vec.v = curVec.v
                vec.v[curDim] = v[curDim] + i
                Neighbor(&n, vec, curDim + 1)
                i += 1
            }
        }
        else
        {
            if curVec != self
            {
                n.append(curVec)
            }
        }
    }

    /**
     Returns a list of all neighboring points across all dimensions

     - parameter onlyDirect: Will skip diagonal neighbors if true

     - returns: List of neighbouring vectors excluding the center vector itself
     */
    func Neighbors(onlyDirect: Bool = false) -> [VectorXD]
    {
        var n: [VectorXD] = []
        if(onlyDirect) {
            var d = 0
            while d < dim {
                var off = -1
                while off <= 1 {
                    let hlp = VectorXD(self)
                    hlp.v[d] = v[d] + off
                    n.append(hlp)
                    off += 2
                }
                d += 1
            }
        } else {
            Neighbor(&n, VectorXD(dim), 0)
        }
        return n
    }

    func Manhatten() -> Int
    {
        return v.reduce(0, {$0 + abs($1)})
    }

    func Polar() -> [Double]
    {
        assert(dim == 2 || dim == 3, "Polar() only implemented for 2 and 3 dimensions")
        let r: Double = sqrt(v.reduce(Double(0), {$0 + Double($1)*Double($1)}))
        let hlp = v.sorted(by: {abs($0) < abs($1)})
        if r == 0 {
            return v.map({_ in 0})
        }
        let phi = atan2(Double(hlp[1]), Double(hlp[0]))
        if dim == 2 {
            return [r, phi]
        } else {
            return [r, phi, acos(Double(hlp[2])/r)]
        }
    }

    var description: String {
        get {
            var res = "["
            for x in 0..<dim {
                if x != 0 {
                    res.append(", ")
                }
                res.append(String(v[x]))
            }
            return res + "]"
        }
    }
}

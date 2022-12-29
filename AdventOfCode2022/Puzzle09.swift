//
//  Puzzle09.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 09.12.22.
//

import Foundation

private let puzzle = "09"

fileprivate func ReadMoves(_ lines: [String]) -> [(VectorXD, Int)]
{
    let dirs:[String: VectorXD] = ["U": VectorXD([0, -1]), "D": VectorXD([0, 1]), "L": VectorXD([-1, 0]), "R": VectorXD([1, 0])]
    var res: [(VectorXD, Int)] = []
    for line in lines {
        let words = line.components(separatedBy: " ")
        res.append((VectorXD(dirs[words[0]]!), Int(words[1])!))
    }
    return res
}

fileprivate func Touching(_ v1: VectorXD, _ v2: VectorXD) -> Bool
{
    return v1.Neighbors(onlyDirect: false).contains(v2) || v1 == v2
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    let moves = ReadMoves(lines)
    var hPos = VectorXD([0,0])
    var tPos = VectorXD([0,0])
    var visited: Set<VectorXD> = [VectorXD(tPos)]
    for move in moves {
        for _ in 0..<move.1 {
            hPos = hPos + move.0
            if Touching(hPos, tPos) {
                continue
            }
            let dist = hPos - tPos
            dist.v[0] = dist.v[0].signum()
            dist.v[1] = dist.v[1].signum()
            tPos = tPos + dist
            visited.insert(VectorXD(tPos))
        }
    }
    return (visited.count)
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    let moves = ReadMoves(lines)
    var knots = Array(repeating: VectorXD([0,0]), count: 10)
    var visited: Set<VectorXD> = [VectorXD(knots.last!)]
    for move in moves {
        for _ in 0..<move.1 {
            knots[0] = knots[0] + move.0
            for knot in 1..<knots.count {
                if Touching(knots[knot-1], knots[knot]) {
                    continue
                }
                let dist = knots[knot-1] - knots[knot]
                dist.v[0] = dist.v[0].signum()
                dist.v[1] = dist.v[1].signum()
                knots[knot] = knots[knot] + dist
            }
            visited.insert(VectorXD(knots.last!))
        }
    }
    return (visited.count)
}

func Puzzle09(_ homePath: String)
{
    let file = try! String(contentsOfFile: homePath + "day" + puzzle + ".txt")
    let testfile = try! String(contentsOfFile: homePath + "day" + puzzle + "-test.txt")

    let lines = Array(file.components(separatedBy: "\n").dropLast())
    let testlines = Array(testfile.components(separatedBy: "\n").dropLast())
    
    print("TEST " + puzzle + "-1 :", Part1(testlines))
    print(puzzle + "-1 :", Part1(lines))

    print("TEST " + puzzle + "-2 :", Part2(testlines))
    print(puzzle + "-2 :", Part2(lines))
}


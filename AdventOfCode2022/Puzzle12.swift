//
//  Puzzle12.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 12.12.22.
//

import Foundation

private let puzzle = "12"

class Elevations : MazeHelper {
    var elevations: [VectorXD: Int] = [:]
    var start: VectorXD
    var end: VectorXD
    var reversed: Bool

    init(_ lines: [String], reverse: Bool = false) {
        reversed = reverse  // look backwards from end?
        let grid = lines.map({$0.map({$0})})
        let dict = GridToDict(grid: grid)
        elevations = dict.mapValues({
                                    switch $0 {
                                    case "S":
                                        return 0
                                    case "E":
                                        return 26
                                    default:
                                        return Int($0.asciiValue! - Character("a").asciiValue!)
                                    }
                                })
        start = dict.first(where: {k,v in v == "S"})!.key
        end = dict.first(where: {k,v in v == "E"})!.key
    }

    override func Neighbors(_ v: VectorXD) -> [VectorXD : Int] {
        let n = v.Neighbors(onlyDirect: true)
        var res: [VectorXD: Int] = [:]
        let startingHeight = elevations[v]!
        for item in n {
            if let newHeight = elevations[item] { // in reverse mode can go one down or any up
                if  (reversed && newHeight >= startingHeight - 1) || (!reversed && newHeight <= startingHeight + 1) {
                    res[item] = 1
                }
            }
        }
        return res
    }

    override func isTarget(_ v: VectorXD) -> Bool {
        if reversed { // in reverse mode, any 'a' is a target
            if let e = elevations[v] {
                return e == 0
            }
        } else { // in regular mode, the end position is the position of 'E'
            return v == end
        }
        return false
    }
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    let elevations = Elevations(lines)
    let (cost, _) = elevations.CheapestPath(start: elevations.start)
    return cost
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    // Search backwards from endpoint to first level 0
    let elevations = Elevations(lines, reverse: true)
    let (cost, _) = elevations.CheapestPath(start: elevations.end)
    return cost
}

func Puzzle12(_ homePath: String)
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


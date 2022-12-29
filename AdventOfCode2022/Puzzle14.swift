//
//  Puzzle14.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 14.12.22.
//

import Foundation

private let puzzle = "14"

fileprivate class Maze {
    var rocks: [VectorXD: Int] = [:]
    var bottom = 0
    var floor = 0

    init(_ lines: [String]) {
        for line in lines {
            let hlp = MakeRocks(line)
            for r in hlp {
                rocks[r.key] = r.value
            }
        }
        bottom = rocks.max(by: {$0.key.v[1] < $1.key.v[1]})!.key.v[1]
        floor = bottom + 2
    }

    private func MakeRocks(_ line: String) -> [VectorXD: Int] {
        var res: [VectorXD: Int] = [:]
        let coords = line.components(separatedBy: " -> ").map({$0.components(separatedBy: ",").map({Int($0)!})})
        for c in 0..<coords.count-1 {
            let c1 = VectorXD(coords[c])
            let c2 = VectorXD(coords[c+1])
            let delta = VectorXD((c2-c1).v.map({$0.signum()}))
            var pos = c1
            while pos != c2 {
                res[pos] = 1
                pos = pos+delta
            }
            res[c2] = 1
        }
        return res
    }

    func Print() {
        let left = rocks.min(by: {$0.key.v[0] < $1.key.v[0]})!.key.v[0]
        let right = rocks.max(by: {$0.key.v[0] < $1.key.v[0]})!.key.v[0]
        let top = 0
        for y in 0..<floor-top {
            for x in 0...right-left {
                var c = "."
                let hlp = rocks[VectorXD([x+left, y+top])]
                if hlp == 0 {
                    c = "o"
                } else if hlp == 1 {
                    c = "#"
                }
                print(c, terminator: "")
            }
            print()
        }
    }
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    let maze = Maze(lines)
    let startPos = VectorXD([500,0])
    let moves = [VectorXD([0, 1]), VectorXD([-1, 1]), VectorXD([1, 1])]
    var hitBottom = false
    while !hitBottom {
        var pos = startPos
        var canMove = true
        while canMove {
            var moved = false
            for m in moves {
                if maze.rocks[pos+m] == nil {
                    pos = pos + m
                    moved = true
                    break
                }
            }
            canMove = moved
            if pos.v[1] >= maze.bottom {
                hitBottom = true
                canMove = false
            } else if !canMove {
                maze.rocks[pos] = 0
            }
        }
    }
    return maze.rocks.filter({$1 == 0}).count
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    let maze = Maze(lines)
    let startPos = VectorXD([500,0])
    let moves = [VectorXD([0, 1]), VectorXD([-1, 1]), VectorXD([1, 1])]
    while maze.rocks[startPos] == nil {
        var pos = startPos
        var canMove = true
        while canMove {
            var moved = false
            for m in moves {
                let newPos = pos+m
                if maze.rocks[newPos] == nil && (newPos).v[1] < maze.floor {
                    pos = newPos
                    moved = true
                    break
                }
            }
            canMove = moved
            if !canMove {
                maze.rocks[pos] = 0
            }
        }
    }
    if maze.floor == 11 {
        maze.Print()
    }
    return maze.rocks.filter({$1 == 0}).count
}

func Puzzle14(_ homePath: String)
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


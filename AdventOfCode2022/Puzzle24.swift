//
//  Puzzle24.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 24.12.22.
//

import Foundation

private let puzzle = "24"


fileprivate func ReadBlizzards(_ lines: [String]) -> (CubeXD, [(VectorXD, Character)])
{
    let grid = lines.map({$0.map({$0})})
    let blizzards = GridToDict(grid: grid, filter: {!["#", "."].contains($1)})
    let bounds = CubeXD(VectorXD([0,0]), VectorXD([grid[0].count-1, grid.count-1]))
    return (bounds, blizzards.map({($0.key, $0.value)}))
}

fileprivate func outsideField(_ pos: VectorXD, _ bounds: CubeXD) -> Bool
{
    if pos.v[0] <= bounds.topLeft.v[0] || pos.v[0] >= bounds.botRight.v[0] {
        return true
    }
    if pos.v[1] <= bounds.topLeft.v[1] || pos.v[1] >= bounds.botRight.v[1] {
        return true
    }
    return false
}

fileprivate func PrintField(_ bounds: CubeXD, _ blizzards: [(VectorXD, Character)], _ spots: Set<VectorXD>)
{
    for y in 0...bounds.botRight.v[1] {
        for x in 0...bounds.botRight.v[0] {
            var c = "."
            if spots.contains(VectorXD([x,y])) {
                c = "E"
            }
            if x == 0 || x == bounds.botRight.v[0] {
                c = "#"
            } else if (y == 0 && x != 1) || (y == bounds.botRight.v[1] && x != bounds.botRight.v[0]-1) {
                c = "#"
            }
            let b = blizzards.filter({$0.0.v[0] == x && $0.0.v[1] == y})
            if b.count == 1 {
                c = String(b[0].1)
            } else if b.count > 0 {
                c = String(String(b.count).first!)
            }
            print(c, terminator: "")
        }
        print()
    }
    print()
}

fileprivate let directions = [Character("^"): VectorXD([0, -1]), Character("v"): VectorXD([0, 1]), Character("<"): VectorXD([-1, 0]), Character(">"): VectorXD([1, 0])]
fileprivate func MoveBlizzards(_ bounds: CubeXD, _ blizzards: inout [(VectorXD, Character)])
{
    let blizzardCount = blizzards.count
    var i = 0
    while i < blizzardCount {
        let newPos = blizzards[i].0 + directions[blizzards[i].1]!
        var d = 0
        while d < 2 {
            if newPos.v[d] <= bounds.topLeft.v[d] {
                newPos.v[d] = bounds.botRight.v[d]-1
                break
            } else if newPos.v[d] >= bounds.botRight.v[d] {
                newPos.v[d] = bounds.topLeft.v[d]+1
            }
            d += 2
        }
        blizzards[i] = (newPos, blizzards[i].1)
        i += 1
    }
}

fileprivate func FromTo(_ bounds: CubeXD, _ blizzards: inout [(VectorXD, Character)], _ startPos: VectorXD, _ endPos: VectorXD) -> Int
{
    var states: Set<VectorXD> = [startPos]
    var t = 0
    while states.count > 0 {
        MoveBlizzards(bounds, &blizzards)
        let blizzardSpots = Set(blizzards.map({$0.0}))
        var newStates: Set<VectorXD> = []
        for state in states {
            for newPos in state.Neighbors(onlyDirect: true) {
                if outsideField(newPos, bounds) && newPos != endPos {
                    continue
                }
                if blizzardSpots.contains(newPos) {
                    continue
                }
                if newPos == endPos {
                    return t+1
                } else {
                    newStates.insert(newPos)
                }
            }
            if !blizzardSpots.contains(state) { // only wait if not blizzard coming in
                newStates.insert(state)
            }
        }
        states = newStates
        t = t + 1
    }
    return 0

}

fileprivate func Part1(_ lines: [String]) -> Any
{
    var (bounds, blizzards) = ReadBlizzards(lines)
    let startPos = VectorXD([1, 0])
    let endPos = VectorXD([bounds.botRight.v[0]-1, bounds.botRight.v[1]])
    return FromTo(bounds, &blizzards, startPos, endPos)
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    var (bounds, blizzards) = ReadBlizzards(lines)
    var t = 0
    let startPos = VectorXD([1, 0])
    let endPos = VectorXD([bounds.botRight.v[0]-1, bounds.botRight.v[1]])
    t += FromTo(bounds, &blizzards, startPos, endPos)
    t += FromTo(bounds, &blizzards, endPos, startPos)
    t += FromTo(bounds, &blizzards, startPos, endPos)
    return t
}

func Puzzle24(_ homePath: String)
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


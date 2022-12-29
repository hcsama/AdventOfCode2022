//
//  Puzzle17.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 17.12.22.
//

import Foundation

private let puzzle = "17"

fileprivate class Rock {
    let size: VectorXD
    var bbox: CubeXD
    var points: Set<VectorXD>
    var pos: VectorXD

    init(_ lines: [String]) {
        let grid = lines.map({$0.map({$0})})
        points = Set(GridToDict(grid: grid, filter: {$1 == "#"}).keys)
        let s = VectorXD(2)
        var dim = 0
        s.v[dim] = points.max(by: {$0.v[dim] < $1.v[dim]})!.v[dim] - points.min(by: {$0.v[dim] < $1.v[dim]})!.v[dim] + 1
        dim = 1
        s.v[dim] = points.max(by: {$0.v[dim] < $1.v[dim]})!.v[dim] - points.min(by: {$0.v[dim] < $1.v[dim]})!.v[dim] + 1
        size = s
        let p = VectorXD(2)
        p.v[0] = 0
        p.v[1] = s.v[1]-1
        pos = p
        bbox = CubeXD(VectorXD([0, 0]), VectorXD([size.v[0]-1, size.v[1]-1]))
    }

    init(_ r: Rock) {
        size = VectorXD(r.size)
        points = r.points
        pos = VectorXD(r.pos)
        bbox = CubeXD(r.bbox)
    }

    func MoveTo(_ newPos: VectorXD) {
        if newPos.v[0] < 0 { // left wall
            return
        }
        if newPos.v[0] + size.v[0] > 7 { // right wall
            return
        }
        let delta = newPos - pos
        points = Set(points.map({$0 + delta}))
        bbox.topLeft = bbox.topLeft + delta
        bbox.botRight = bbox.botRight + delta
        pos = pos + delta
    }
}

private func CreateRocks(_ lines: [String]) -> [Rock]
{
    var res: [Rock] = []
    var i = 0
    while i < lines.count {
        if lines[i][0] != ">" {
            var j = i+1
            while lines[j] != "" {
                j += 1
            }
            res.append(Rock(Array(lines[i..<j])))
            i = j+1
        } else {
            i += 1
        }
    }
    return res
}

fileprivate func Collisions(_ field: Set<VectorXD>, _ rock: Rock) -> Bool {
    for p in rock.points {
        if field.contains(p) {
            return true
        }
    }
    return false
}

fileprivate func PrintField(_ field: Set<VectorXD>, _ lines: Int) {
    let top = field.min(by: {$0.v[1] < $1.v[1]})!.v[1]
    for y in top...top+lines-1 {
        for x in -1...7 {
            var c = "."
            if x == -1 || x == 7 {
                c = "|"
            }
            if y == 0 {
                c = "-"
            }
            if field.contains(VectorXD([x, y])) {
                c = "#"
            }
            print(c, terminator: "")
        }
        print()
    }
    print()
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    let rocks = CreateRocks(lines)
    let nRocks = rocks.count
    var topLine = 0
    var field: Set<VectorXD> = []
    let instr = lines.last!.map({$0 == "<" ? -1 : 1})
    let nInstr = instr.count
    var rockCounter = 0
    var i = 0
    while true {
        if rockCounter == 2022 {
            break
        }
        var newRock = Rock(rocks[rockCounter % nRocks])
        rockCounter = rockCounter + 1
        newRock.MoveTo(VectorXD([2, topLine - 4]))
        var hit = false
        while !hit {
            // Air impact
            var push = instr[i % nInstr]
            i = i + 1
            var prevRock = Rock(newRock)
            newRock.MoveTo(VectorXD([newRock.pos.v[0] + push, newRock.pos.v[1]]))
            if Collisions(field, newRock) {
                newRock = prevRock
            }
            // Gravity
            push = 1
            prevRock = Rock(newRock)
            newRock.MoveTo(VectorXD([newRock.pos.v[0], newRock.pos.v[1] + push]))
            if newRock.pos.v[1] == 0 || Collisions(field, newRock) {
                newRock = prevRock
                for p in newRock.points {
                    field.insert(p)
                }
                topLine = min(topLine, newRock.bbox.topLeft.v[1])
                hit = true
            }
        }
    }
    return abs(topLine)
}

fileprivate class PatternLoc : Hashable {
    let pattern: Set<VectorXD>
    let wind: Int

    init(_ p: Set<VectorXD>, _ w: Int) {
        pattern = p
        wind = w
    }

    static func == (lhs: PatternLoc, rhs: PatternLoc) -> Bool {
        return lhs.pattern == rhs.pattern && lhs.wind == rhs.wind
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(pattern)
        hasher.combine(wind)
    }

}

fileprivate func Part2(_ lines: [String]) -> Any
{
    let rocks = CreateRocks(lines)
    var topLine = 0
    var field: Set<VectorXD> = []
    let instr = lines.last!.map({$0 == "<" ? -1 : 1})
    let nInstr = instr.count
    var rockCounter = 0
    var i = 0
    let target = 1000000000000
    var repeatedHeight = 0
    var baseHeight = 0
    var runTo = target
    var patterns: [PatternLoc: (Int, Int)] = [:]
    let patternHeight = 30
    while rockCounter < runTo {
        let theRock = rockCounter % rocks.count
        let newRock = Rock(rocks[theRock])
        newRock.MoveTo(VectorXD([2, topLine - 4]))
        var hit = false
        while !hit {
            // Air impact
            let theWind = i % nInstr
            var push = instr[theWind]
            newRock.MoveTo(VectorXD([newRock.pos.v[0] + push, newRock.pos.v[1]]))
            if Collisions(field, newRock) {
                newRock.MoveTo(VectorXD([newRock.pos.v[0] - push, newRock.pos.v[1]]))
            }
            // Gravity
            push = 1
            newRock.MoveTo(VectorXD([newRock.pos.v[0], newRock.pos.v[1] + push]))
            if newRock.pos.v[1] == 0 || Collisions(field, newRock) {
                newRock.MoveTo(VectorXD([newRock.pos.v[0], newRock.pos.v[1] - push]))
                for p in newRock.points {
                    field.insert(p)
                }
                topLine = min(topLine, newRock.bbox.topLeft.v[1])
                hit = true
                if runTo == target {
                    if -topLine > patternHeight * 10 && theRock == 0 {
                        let currentPattern: Set<VectorXD> = Set(field.filter({$0.v[1] < topLine + patternHeight }).map({$0 + VectorXD([0, -topLine])}))
                        let curLoc = PatternLoc(currentPattern, theWind)
                        if let (height, nRocks) = patterns[curLoc] {
                            // repeat found
                            let cycleHeight = abs(topLine) - height
                            let cycleRocks = rockCounter - nRocks
                            let remain = (target-rockCounter)
                            let repeats = remain / cycleRocks
                            let rest = remain % cycleRocks
                            runTo = rockCounter+rest
                            baseHeight = abs(topLine) // todo
                            repeatedHeight = baseHeight + cycleHeight * repeats
                        } else {
                            patterns[curLoc] = (abs(topLine), rockCounter)
                        }
                    }
                }
            }
            i = i + 1
        }
        rockCounter = rockCounter + 1
    }
    return repeatedHeight + abs(topLine) - baseHeight
}

func Puzzle17(_ homePath: String)
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


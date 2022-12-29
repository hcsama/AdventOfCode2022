//
//  Puzzle22.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 22.12.22.
//

import Foundation

private let puzzle = "22"

fileprivate class Maze
{
    var maze: [VectorXD: Character] = [:]
    var borders: [[(Int, Int)]] = Array(repeating: [], count: 2)

    init(_ lines: [String]) {
        for y in 1...lines.count {
            if lines[y-1] == "" {
                break
            }
            let theLine = lines[y-1].map({$0})
            for x in 1...theLine.count {
                let c = theLine[x-1]
                if c == " " {
                    continue
                }
                let pos = VectorXD([x,y])
                maze[pos] = theLine[x-1]
            }
        }
        let rows = maze.keys.max(by: {$0.v[1] < $1.v[1]})!.v[1]
        let cols = maze.keys.max(by: {$0.v[0] < $1.v[0]})!.v[0]
        borders[0] = Array(repeating: (0,0), count: rows)
        borders[1] = Array(repeating: (0,0), count: cols)
        for y in 1...rows {
            let xMin = maze.keys.filter({$0.v[1] == y}).min(by: {$0.v[0] < $1.v[0]})!.v[0]
            let xMax = maze.keys.filter({$0.v[1] == y}).max(by: {$0.v[0] < $1.v[0]})!.v[0]
            borders[0][y-1] = (xMin, xMax)
        }
        for x in 1...cols {
            let yMin = maze.keys.filter({$0.v[0] == x}).min(by: {$0.v[1] < $1.v[1]})!.v[1]
            let yMax = maze.keys.filter({$0.v[0] == x}).max(by: {$0.v[1] < $1.v[1]})!.v[1]
            borders[1][x-1] = (yMin, yMax)
        }
    }
}

fileprivate func ReadMaze(_ lines: [String]) -> Maze
{
    return Maze(lines)
}

fileprivate func ReadInstructions(_ lines: [String]) -> [Int]
{
    var next = false
    var theLine: [Character] = []
    let moves = ["R": -1, "L": -3]
    for line in lines {
        if next {
            theLine = line.map({$0})
            break
        }
        if line == "" {
            next = true
        }
    }
    var i = 0
    var res: [Int] = []
    while i < theLine.count {
        let c = theLine[i]
        if c.isWholeNumber {
            var j = i + 1
            while j < theLine.count && theLine[j].isWholeNumber {
                j += 1
            }
            res.append(Int(String(theLine[i..<j]))!)
            i = j
        } else {
            res.append(moves[String(c)]!)
            i = i + 1
        }
    }
    return res
}

fileprivate let directions = [0: VectorXD([1, 0]), 1: VectorXD([0, 1]), 2: VectorXD([-1, 0]), 3: VectorXD([0, -1])]

fileprivate func Part1(_ maze: Maze, _ instructions: [Int]) -> Any
{
    let firstX = maze.maze.filter({$0.key.v[1] == 1 && $0.value != "#"}).min(by: {$0.key.v[0] < $1.key.v[0]})!.key.v[0]
    var pos = VectorXD([firstX, 1])
    var facing = 0
    for instr in instructions {
        if instr > 0 {
            var steps = instr
            while steps > 0 {
                let newPos = pos + directions[facing]!
                let d = directions[facing]!.v[0] != 0 ? 0 : 1
                if newPos.v[d] < maze.borders[d][newPos.v[1-d]-1].0 {
                    newPos.v[d] = maze.borders[d][newPos.v[1-d]-1].1
                } else if newPos.v[d] > maze.borders[d][newPos.v[1-d]-1].1 {
                    newPos.v[d] = maze.borders[d][newPos.v[1-d]-1].0
                }
                if maze.maze[newPos]! == "#" {
                    break
                }
                steps -= 1
                pos = newPos
            }
        } else {
            facing = (facing + instr + 2) % 4
            if facing < 0 {
                facing = 3
            }
        }
    }
    let res = facing + 1000 * pos.v[1] + 4 * pos.v[0]
    return res
}

fileprivate func RotateRight(_ pos: VectorXD) -> VectorXD
{
    let res = VectorXD(2)
    if pos.v[0] > 0 {
        if pos.v[1] > 0 {
            res.v[1] = pos.v[0]
            res.v[0] = -pos.v[1]
        } else {
            res.v[1] = pos.v[0]
            res.v[0] = -pos.v[1]
        }
    } else {
        if pos.v[1] > 0 {
            res.v[0] = -pos.v[1]
            res.v[1] = pos.v[0]
        } else {
            res.v[0] = -pos.v[1]
            res.v[1] = pos.v[0]
        }
    }
    return res
}

fileprivate func RotatedSide(_ side: Set<VectorXD>) -> Set<VectorXD>
{
    var res: Set<VectorXD> = []
    for v in side {
        res.insert(RotateRight(v))
    }
    return res
}

fileprivate struct Connection
{
    var connections: [Int]
    var newDirs: [Int]
}

fileprivate func SidesConnected(_ s1: Int, _ s2: Int, _ connections: [Connection]) -> Bool
{
    return connections[s1].connections.contains(s2)
}

fileprivate func TurnRight(_ dir: Int) -> Int
{
    return (dir + 1) % 4
}

fileprivate func ReverseDir(_ dir: Int) -> Int
{
    return (dir + 2) % 4
}

fileprivate func TurnLeft(_ dir: Int) -> Int
{
    var res = dir - 1
    if res < 0 {
        res = 3
    }
    return res
}

fileprivate func DetermineConnections(_ cubeSize: Int, _ sides: [VectorXD: Int]) -> [Connection]
{
    var connections: [Connection] = Array(repeating: Connection(connections: [-1,-1,-1,-1], newDirs: [-1,-1,-1,-1]), count: sides.count)
    for side in sides {
        for dir in 0..<4 {
            if let other = sides[side.key + directions[dir]!] {  // Connect all directly adjacent sides
                connections[side.value].connections[dir] = other
                connections[side.value].newDirs[dir] = dir
            }
        }
    }
    var madeConnection = true
    while madeConnection {
        madeConnection = false
        for side in sides.values {
            for dir in 0..<3 {
                let s1 = connections[side].connections[dir]
                let s2 = connections[side].connections[dir+1]
                if s1 >= 0 && s2 >= 0 && !SidesConnected(s1, s2, connections) {  // connect two sides connected to a common side next to each other
                    let s1dir = TurnRight(connections[side].newDirs[dir])
                    let s2dir = TurnLeft(connections[side].newDirs[dir+1])
                    connections[s1].connections[s1dir] = s2
                    connections[s1].newDirs[s1dir] = ReverseDir(s2dir)
                    connections[s2].connections[s2dir] = s1
                    connections[s2].newDirs[s2dir] = ReverseDir(s1dir)
                    madeConnection = true
                }
            }
        }
    }
    return connections
    /* Expected results
    if cubeSize == 4 { // test data
        // 0
        connections2.append(Connection(connections: [5, 3, 2, 1], newDirs: [2, 1, 1, 1]))
        // 1
        connections2.append(Connection(connections: [2, 4, 5, 0], newDirs: [0, 3, 3, 1]))
        // 2
        connections2.append(Connection(connections: [3, 4, 1, 0], newDirs: [0, 0, 2, 0]))
        // 3
        connections2.append(Connection(connections: [5, 4, 2, 0], newDirs: [1, 1, 2, 3]))
        // 4
        connections2.append(Connection(connections: [5, 1, 2, 3], newDirs: [0, 3, 3, 3]))
        // 5
        connections2.append(Connection(connections: [0, 1, 4, 3], newDirs: [2, 0, 2, 2]))
    } else {
        // 0
        connections2.append(Connection(connections: [1, 2, 3, 5], newDirs: [0, 1, 0, 0]))
        // 1
        connections2.append(Connection(connections: [4, 2, 0, 5], newDirs: [2, 2, 2, 3]))
        // 2
        connections2.append(Connection(connections: [1, 4, 3, 0], newDirs: [3, 1, 1, 3]))
        // 3
        connections2.append(Connection(connections: [4, 5, 0, 2], newDirs: [0, 1, 0, 0]))
        // 4
        connections2.append(Connection(connections: [1, 5, 3, 2], newDirs: [2, 2, 2, 3]))
        // 5
        connections2.append(Connection(connections: [4, 1, 0, 3], newDirs: [3, 1, 1, 3]))
    }
    */
}

fileprivate func Part2(_ maze: Maze, _ instructions: [Int]) -> Any
{
    let minBorder = maze.borders[0].min(by: {($0.1-$0.0) < ($1.1-$1.0)})!
    let cubeSize = (minBorder.1 - minBorder.0) + 1
    var cubeSides: [[Set<VectorXD>]] = Array(repeating: [], count: 6)
    var sides: [VectorXD: Int] = [:]
    var sideNo = 0
    for cy in 0..<(maze.borders[0].count)/cubeSize {
        let xFrom = maze.borders[0][cy*cubeSize].0-1
        let xTo = maze.borders[0][cy*cubeSize].1-1
        for cx in 0..<(xTo+1)/cubeSize {
            if cx*cubeSize < xFrom {
                continue
            }
            var theSide: Set<VectorXD> = []
            for x in cx*cubeSize..<(cx+1)*cubeSize {
                for y in cy*cubeSize..<(cy+1)*cubeSize {
                    theSide.insert(VectorXD([x+1, y+1]))
                }
            }
            cubeSides[sideNo].append(theSide)
            sides[VectorXD([cx, cy])] = sideNo
            for _ in 0..<3 {
                theSide = RotatedSide(theSide)
                cubeSides[sideNo].append(theSide)
            }
            sideNo += 1
        }
    }
    let connections = DetermineConnections(cubeSize, sides)
    let firstX = maze.maze.filter({$0.key.v[1] == 1 && $0.value != "#"}).min(by: {$0.key.v[0] < $1.key.v[0]})!.key.v[0]
    var pos = VectorXD([firstX, 1])
    var curCube = -1
    for cube in 0..<cubeSides.count {
        if cubeSides[cube][0].contains(pos) {
            curCube = cube
            break
        }
    }
    var sideBorders: [[CubeXD]] = Array(repeating: [], count: sideNo)
    for cube in 0..<sideNo {
        for d in 0..<4 {
            sideBorders[cube].append(CubeXD(cubeSides[cube][d]))
        }
    }
    var facing = 0
    for instr in instructions {
        if instr > 0 {
            var steps = instr
            while steps > 0 {
                var newPos = pos + directions[facing]!
                if !cubeSides[curCube][0].contains(newPos) {  // Leaving side
                    let newCurCube = connections[curCube].connections[facing]
                    let newFacing = connections[curCube].newDirs[facing]
                    var rot = 0
                    while (facing + rot)%4 != newFacing {
                        rot = rot + 1
                        newPos = RotateRight(newPos)
                    }
                    switch newFacing {
                    case 0: // to right
                        newPos.v[0] = sideBorders[newCurCube][0].topLeft.v[0]
                        newPos.v[1] = sideBorders[newCurCube][0].topLeft.v[1] + newPos.v[1] - sideBorders[curCube][rot].topLeft.v[1]
                    case 2: // to left
                        newPos.v[0] = sideBorders[newCurCube][0].botRight.v[0]
                        newPos.v[1] = sideBorders[newCurCube][0].topLeft.v[1] + newPos.v[1] - sideBorders[curCube][rot].topLeft.v[1]
                    case 1: //from top
                        newPos.v[1] = sideBorders[newCurCube][0].topLeft.v[1]
                        newPos.v[0] = sideBorders[newCurCube][0].topLeft.v[0] + newPos.v[0] - sideBorders[curCube][rot].topLeft.v[0]
                    case 3: //from bottom
                        newPos.v[1] = sideBorders[newCurCube][0].botRight.v[1]
                        newPos.v[0] = sideBorders[newCurCube][0].topLeft.v[0] + newPos.v[0] - sideBorders[curCube][rot].topLeft.v[0]
                    default:
                        print("impossible direction")
                    }
                    if maze.maze[newPos]! == "#" {
                        break
                    }
                    curCube = newCurCube
                    facing = newFacing
                }
                if maze.maze[newPos]! == "#" {
                    break
                }
                steps -= 1
                pos = newPos
            }
        } else {
            facing = (facing + instr + 2) % 4
            if facing < 0 {
                facing = 3
            }
        }
    }
    let res = facing + 1000 * pos.v[1] + 4 * pos.v[0]
    return res
}

func Puzzle22(_ homePath: String)
{
    let file = try! String(contentsOfFile: homePath + "day" + puzzle + ".txt")
    let testfile = try! String(contentsOfFile: homePath + "day" + puzzle + "-test.txt")

    let lines = Array(file.components(separatedBy: "\n").dropLast())
    let testlines = Array(testfile.components(separatedBy: "\n").dropLast())

    let testMaze = ReadMaze(testlines)
    let testInstructions = ReadInstructions(testlines)
    print("TEST " + puzzle + "-1 :", Part1(testMaze, testInstructions))
    let maze = ReadMaze(lines)
    let instructions = ReadInstructions(lines)
    print(puzzle + "-1 :", Part1(maze, instructions))

    print("TEST " + puzzle + "-2 :", Part2(testMaze, testInstructions))
    print(puzzle + "-2 :", Part2(maze, instructions))
}


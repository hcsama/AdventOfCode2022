//
//  Puzzle08.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 08.12.22.
//

import Foundation

private let puzzle = "08"

fileprivate func Part1(_ lines: [String]) -> Any
{
    let grid = lines.map({$0.map({Int(String([$0]))!})})
    let xDim = grid[0].count
    let yDim = grid.count
    var visible: [VectorXD: Bool] = [:]
    var highest: Int = 0
    for y in 0..<yDim {
        for x in 0..<xDim {
            if x == 0 || grid[y][x] > highest {
                visible[VectorXD([x,y])] = true
                highest = grid[y][x]
            }
        }
        for x in stride(from: xDim-1, to: 0, by: -1) {
            if x == xDim-1 || grid[y][x] > highest {
                visible[VectorXD([x,y])] = true
                highest = grid[y][x]
            }
        }
    }
    for x in 0..<xDim {
        for y in 0..<yDim {
            if y == 0 || highest < grid[y][x] {
                visible[VectorXD([x,y])] = true
                highest = grid[y][x]
            }
        }
        for y in stride(from: yDim-1, to: 0, by: -1) {
            if y == yDim-1 || grid[y][x] > highest {
                visible[VectorXD([x,y])] = true
                highest = grid[y][x]
            }
        }
    }
    return visible.count
}

fileprivate func CountViz(_ x0: Int, _ y0: Int, _ grid: [[Int]]) -> Int
{
    var total = 1
    let xDim = grid[0].count
    let yDim = grid.count
    let theHeight = grid[y0][x0]
    var sum = 0
    for x in x0+1..<xDim {
            sum += 1
        if grid[y0][x] >= theHeight {
            break
        }
    }
    total *= sum
    sum = 0
    for x in stride(from: x0-1, to: -1, by: -1) {
            sum += 1
        if grid[y0][x] >= theHeight {
            break
        }
    }
    total *= sum
    sum = 0
    for y in y0+1..<yDim {
            sum += 1
        if grid[y][x0] >= theHeight {
            break
        }
    }
    total *= sum
    sum = 0
    for y in stride(from: y0-1, to: -1, by: -1) {
            sum += 1
        if grid[y][x0] >= theHeight {
            break
        }
    }
    total *= sum

    return total
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    let grid = lines.map({$0.map({Int(String([$0]))!})})
    let xDim = grid[0].count
    let yDim = grid.count
    var visible: [VectorXD: Int] = [:]
    for y in 0..<yDim {
        for x in 0..<xDim {
            visible[VectorXD([x,y])] = CountViz(x, y, grid)
        }
    }
    return visible.max(by: {$0.value < $1.value})!.value
}

func Puzzle08(_ homePath: String)
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


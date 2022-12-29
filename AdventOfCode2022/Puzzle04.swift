//
//  Puzzle04.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 04.12.22.
//

import Foundation

private let puzzle = "04"

fileprivate func ReadElves(_ line: String) -> [CubeXD]
{
    let elves = line.components(separatedBy: [",", "-"])
    var res: [CubeXD] = []
    res.append(CubeXD(VectorXD([Int(elves[0])!]), VectorXD([Int(elves[1])!])))
    res.append(CubeXD(VectorXD([Int(elves[2])!]), VectorXD([Int(elves[3])!])))
    return res
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    var elves: [[CubeXD]] = []
    for line in lines {
        elves.append(ReadElves(line))
    }
    var total = 0
    for elf in elves {
        if elf[0].Intersect(elf[1]) == elf[1] || elf[1].Intersect(elf[0]) == elf[0] {
            total += 1
        }
    }
    return total
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    var elves: [[CubeXD]] = []
    for line in lines {
        elves.append(ReadElves(line))
    }
    var total = 0
    for elf in elves {
        if elf[0].Intersect(elf[1]) != nil {
            total += 1
        }
    }
    return total
}

func Puzzle04(_ homePath: String)
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


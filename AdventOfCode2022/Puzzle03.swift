//
//  Puzzle03.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 03.12.22.
//

import Foundation

private let puzzle = "03"

fileprivate func CharToVal(_ c: Character) -> Int
{
    if c >= "a" && c <= "z" {
        return Int(c.asciiValue! - Character("a").asciiValue! + 1)
    } else {
        return Int(c.asciiValue! - Character("A").asciiValue! + 27)
    }
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    var total = 0
    for line in lines {
        let r = line.map({CharToVal($0)})
        let diff = Set(r[0..<line.count/2]).intersection(r[line.count/2..<line.count])
        assert(diff.count == 1, "Count is \(diff.count)")
        total += diff.first!
    }
    return total
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    var total = 0
    for i in 0..<lines.count/3 {
        var diff: Set<Int> = []
        for j in 0..<3 {
            let r = lines[i*3+j].map({CharToVal($0)})
            if j == 0 {
                diff = Set(r)
            } else {
                diff = diff.intersection(r)
            }
        }
        assert(diff.count == 1, "Count is \(diff.count)")
        total += diff.first!
    }
    return total
}

func Puzzle03(_ homePath: String)
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


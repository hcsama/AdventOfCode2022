//
//  Puzzle05.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 05.12.22.
//

import Foundation

private let puzzle = "05"

fileprivate func ReadCrates(_ lines: [String]) -> [[String]]
{
    var nCrates = 0

    for line in lines {
        let words = line.components(separatedBy: " ")
        if words[1] == "1" {
            nCrates = Int(words[words.count-1])!
            break
        }
    }

    var crates: [[String]] = Array(repeating: [], count: nCrates)

    for line in lines {
        if line == "" {
            break
        }
        for crate in 0..<nCrates {
            if line[crate*4] == "[" {
                crates[crate].insert(line[crate*4+1], at: 0)
            }
        }
    }

    return crates
}

fileprivate func ReadInstructions(_ lines: [String]) -> [[Int]]
{
    var instr = false
    var res: [[Int]] = []
    for line in lines {
        if instr {
            let words = line.components(separatedBy: " ")
            res.append([Int(words[1])!, Int(words[3])!, Int(words[5])!])
        } else if line == "" {
            instr = true
        }
    }
    return res
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    var crates = ReadCrates(lines)
    let instructions = ReadInstructions(lines)
    for instr in instructions {
        for _ in 0..<instr[0] {
            crates[instr[2]-1].append(crates[instr[1]-1].popLast()!)
        }
    }
    var res = ""
    for i in 0..<crates.count {
        if let c = crates[i].last {
            res += c
        }
    }
    return res
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    var crates = ReadCrates(lines)
    let instructions = ReadInstructions(lines)
    for instr in instructions {
        let n = crates[instr[1]-1].count
        crates[instr[2]-1].append(contentsOf: crates[instr[1]-1][n-instr[0]..<n])
        crates[instr[1]-1] = crates[instr[1]-1].dropLast(instr[0])
    }
    var res = ""
    for i in 0..<crates.count {
        if let c = crates[i].last {
            res += c
        }
    }
    return res
}

func Puzzle05(_ homePath: String)
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


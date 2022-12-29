//
//  Puzzle06.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 06.12.22.
//

import Foundation

private let puzzle = "06"

fileprivate func FindMarker(_ line: String) -> Int
{
    for i in 0..<line.count-4 {
        let s = Set(line[i..<i+4])
        if s.count == 4 {
            return i+4
        }
    }
    return -1
}

fileprivate func FindMessage(_ line: String) -> Int
{
    for i in 0..<line.count-14 {
        let s = Set(line[i..<i+14])
        if s.count == 14 {
            return i+14
        }
    }
    return -1
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    return FindMarker(lines[0])
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    return FindMessage(lines[0])
}

func Puzzle06(_ homePath: String)
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


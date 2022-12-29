//
//  Puzzle01.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 01.12.22.
//

import Foundation

private let puzzle = "01"

func Puzzle01(_ homePath: String)
{
    let file = try! String(contentsOfFile: homePath + "day" + puzzle + ".txt")

    let lines = Array(file.components(separatedBy: "\n"))

    var elfs: [Int] = []
    var theElf = 0
    var theSum = 0

    for line in lines {
        if line == "" {
            elfs.append(theSum)
            theElf += 1
            theSum = 0
        } else {
            theSum += Int(line)!
        }
    }

    print(puzzle + "-1 :", elfs.max()!)

    elfs.sort()
    let n = elfs.count

    print(puzzle + "-2 :", elfs[n-1]+elfs[n-2]+elfs[n-3])
}


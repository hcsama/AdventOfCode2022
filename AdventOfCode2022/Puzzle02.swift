//
//  Puzzle02.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 02.12.22.
//

import Foundation

private let puzzle = "02"


let scores = ["X": 1, "Y": 2, "Z": 3]
let playMap = ["A": "X", "B": "Y", "C": "Z"]
let winner = [["X", "Z"], ["Z", "Y"], ["Y", "X"]]

fileprivate func Part1(_ lines: [String]) -> Int
{
    var totalScore = 0

    for line in lines {
        var draws = line.components(separatedBy: " ")
        draws[0] = playMap[draws[0]]!
        var factor = 0
        if draws[0] == draws[1] {
            factor = 3
        } else if winner.contains([draws[1], draws[0]]) {
            factor = 6
        }
        totalScore += factor+scores[draws[1]]!
    }
    return totalScore
}


fileprivate func Part2(_ lines: [String]) -> Int
{
    var totalScore = 0

    for line in lines {
        var draws = line.components(separatedBy: " ")
        draws[0] = playMap[draws[0]]!
        switch draws[1] {
        case "X": // Lose
            for w in winner {
                if w[0] == draws[0] {
                    draws[1] = w[1]
                    break
                }
            }
            break
        case "Y": // Draw
            draws[1] = draws[0]
            break
        case "Z": // Win
            for w in winner {
                if w[1] == draws[0] {
                    draws[1] = w[0]
                    break
                }
            }
            break
        default:
            print("wrong input")
        }
        var factor = 0
        if draws[0] == draws[1] {
            factor = 3
        } else if winner.contains([draws[1], draws[0]]) {
            factor = 6
        }
        totalScore += factor+scores[draws[1]]!
    }
    return totalScore
}


func Puzzle02(_ homePath: String)
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


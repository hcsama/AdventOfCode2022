//
//  Puzzle25.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 25.12.22.
//

import Foundation

private let puzzle = "25"

fileprivate let digitvals:[Character: Int] = ["=": -2, "-": -1, "0": 0, "1": 1, "2": 2]

fileprivate func ReadSNAFUS(_ lines: [String]) -> [[Int]]
{
    return lines.map({$0.map({digitvals[$0]!})})
}

fileprivate func SNAFUToNumber(_ snafu: [Int]) -> Int
{
    var total = 0
    var posVal = 1
    for c in snafu.reversed() {
        total += c * posVal
        posVal *= 5
    }
    return total
}

fileprivate func SetDigitVal(_ snafu: inout [Int], _ digit: Int, _ newVal: Int)
{
    var theDigit = digit
    if theDigit < 0 {
        snafu.insert(0, at: 0)
        theDigit = 0
    }
    if newVal <= 2 {
        snafu[theDigit] = newVal
    } else {
        snafu[theDigit] = -(5 - newVal)
        let newVal = theDigit > 0 ? snafu[theDigit-1]+1 : 1
        SetDigitVal(&snafu, theDigit-1, newVal)
    }
}

fileprivate func NumberToSNAFU(_ val: Int) -> String
{
    var posVal = 5
    var digits = 1
    while posVal < val {
        posVal *= 5
        digits += 1
    }
    var res: [Int] = Array(repeating: 0, count: digits)
    var remainder = val
    var digit = 0
    posVal /= 5
    for _ in 0..<digits {
        let lenBefore = res.count
        SetDigitVal(&res, digit, remainder/posVal)
        let lenAfter = res.count
        digit += lenAfter-lenBefore
        remainder = remainder % posVal
        posVal /= 5
        digit += 1
    }
    return String(res.map({c in digitvals.first(where: {$0.value == c})!.key}))
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    let snafus = ReadSNAFUS(lines)
    var total = 0
    for snafu in snafus {
        let sval = SNAFUToNumber(snafu)
        total += sval
    }
    return (total, NumberToSNAFU(total))
}

func Puzzle25(_ homePath: String)
{
    let file = try! String(contentsOfFile: homePath + "day" + puzzle + ".txt")
    let testfile = try! String(contentsOfFile: homePath + "day" + puzzle + "-test.txt")

    let lines = Array(file.components(separatedBy: "\n").dropLast())
    let testlines = Array(testfile.components(separatedBy: "\n").dropLast())
    
    print("TEST " + puzzle + "-1 :", Part1(testlines))
    print(puzzle + "-1 :", Part1(lines))
}


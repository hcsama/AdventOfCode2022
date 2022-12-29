//
//  Puzzle20.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 20.12.22.
//

import Foundation

private let puzzle = "20"


fileprivate class Coord : CircularLinkedList {
    var value: Int
    var origPos: Int

    init(_ v: Int, _ p: Int) {
        value = v
        origPos = p
        super.init()
    }

    func Next() -> Coord? {
        return next! as? Coord
    }
}

fileprivate func ReadNumbers(_ lines: [String]) -> [Coord]
{
    CircularLinkedList.Reset()
    var nums: [Coord] = []
    var p: Int = 0
    for line in lines {
        nums.append(Coord(Int(line)!, p))
        p += 1
    }
    return nums
}

fileprivate func PrintNumbers(_ nums: [Coord]) {
    var num = nums.first
    print("[", terminator: "")
    for _ in 0..<nums.count {
        print(num!.value, terminator: " ")
        num = num!.Next()
    }
    print("]")
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    let nums = ReadNumbers(lines)
    var i = 0
    while i < CircularLinkedList.listCount {
        let num = nums[i]
        num.Move(num.value, num.value < 0)
        i += 1
    }
    var theNull = nums.first(where: {$0.value == 0})!
    var total = 0
    for _ in 0..<3 {
        for _ in 0..<1000 {
            theNull = theNull.Next()!
        }
        total += theNull.value
    }
    return total
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    let nums = ReadNumbers(lines)
    for i in 0..<CircularLinkedList.listCount {
        nums[i].value *= 811589153
    }
    for _ in 0..<10 {
        for i in 0..<CircularLinkedList.listCount {
            let num = nums[i]
            num.Move(num.value, num.value < 0)
        }
    }
    var theNull = nums.first(where: {$0.value == 0})!
    var total = 0
    for _ in 0..<3 {
        for _ in 0..<1000 {
            theNull = theNull.Next()!
        }
        total += theNull.value
    }
    return total
}

func Puzzle20(_ homePath: String)
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


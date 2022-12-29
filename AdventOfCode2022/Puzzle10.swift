//
//  Puzzle10.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 10.12.22.
//

import Foundation

private let puzzle = "10"

// Prog represented as item-wise array
// instructions do nothing
// numbers change register
// automatically uses 1 cycle for noop and 2 cycles for addx
fileprivate class FlowProcessor {
    var register: Int = 1
    var curInstr = 0
    var cycle: Int {
        get {
            curInstr + 1
        }
    }
    let theProg: [String]

    init(_ lines: [String]) {
        theProg = lines.map({$0.components(separatedBy: " ")}).flatMap({$0})
    }

    func Step() {
        if let n = Int(theProg[curInstr]) {
            register += n
        }
        curInstr += 1
    }
}

// Alternate way of doing it with a real cpu emulator
fileprivate class ProcState {
    var register: Int = 1
    var cycle = 1
    let theProg: [(String, Int)]
    let durations = ["noop": 1, "addx": 2]
    var curInstr = 0
    var subCycle = 0

    init(_ lines: [String]) {
        var prog: [(String, Int)] = []
        for line in lines {
            let words = line.components(separatedBy: " ")
            prog.append((words[0], words[0] == "noop" ? 0 : Int(words[1])!))
        }
        theProg = prog
    }

    func Step() {
        cycle += 1
        subCycle += 1
        if subCycle >= durations[theProg[curInstr].0]! {
            switch theProg[curInstr].0 {
            case "addx":
                register += theProg[curInstr].1
                break
            default:
                break
            }
            subCycle = 0
            curInstr += 1
        }
    }

}

fileprivate func Part1(_ lines: [String]) -> Any
{
    var total = 0
    let cpu = FlowProcessor(lines)
    let relevantCycles = [20, 60, 100, 140, 180, 220]
    let end = relevantCycles.max()!
    for _ in 0...end {
        cpu.Step()
        if relevantCycles.contains(cpu.cycle) {
            total += cpu.cycle * cpu.register
        }
    }
    return total
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    let cpu = FlowProcessor(lines)
    let rowSize = 40
    let rows = 6
    var screen = Array(repeating: " ", count: rowSize*rows)
    for i in 0..<rowSize*rows {
        let pos = i
        if cpu.register-1 <= pos%rowSize && cpu.register+1 >= pos%rowSize {
            screen[pos] = "|"
        }
        cpu.Step()
    }
    print()
    for y in 0..<rows {
        for x in 0..<rowSize {
            print(screen[y*rowSize+x], terminator: "")
        }
        print()
    }
    print()
    return 0
}

func Puzzle10(_ homePath: String)
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


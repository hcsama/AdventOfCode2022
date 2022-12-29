//
//  Puzzle11.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 11.12.22.
//

import Foundation

private let puzzle = "11"

fileprivate class Monkey : CustomStringConvertible {
    var id: Int
    var items: [Int] = []
    var op: String
    var opVal: String
    var testVal: Int
    var dest: [Bool: Int] = [:]
    var inspections = 0
    var divisor = 3
    var modVal = 1

    init(_ lines: [String]) {
        var words = lines[0].components(separatedBy: " ")
        id = Int(words[1][0])!
        words = lines[1].replacingOccurrences(of: ",", with: "").components(separatedBy: " ")
        for i in 4..<words.count {
            items.append(Int(words[i])!)
        }
        words = lines[2].components(separatedBy: " ")
        op = words[6]
        opVal = words[7]
        words = lines[3].components(separatedBy: " ")
        testVal = Int(words[5])!
        words = lines[4].components(separatedBy: " ")
        dest[true] = Int(words[9])!
        words = lines[5].components(separatedBy: " ")
        dest[false] = Int(words[9])!
    }

    func RunMonkey(_ monkeys: inout [Monkey]) {
        for item in items {
            inspections += 1
            var newVal = item
            switch op {
            case "+":
                if let n = Int(opVal) {
                    newVal += n
                } else {
                    newVal += newVal
                }
            case "*":
                if let n = Int(opVal) {
                    newVal *= n
                } else {
                    newVal *= newVal
                }
            default:
                print("illegal operation")
            }
            newVal /= divisor
            let newMonkey = dest[newVal % testVal == 0]!
            if modVal != 1 {
                newVal %= monkeys[newMonkey].modVal
            }
            monkeys[newMonkey].items.append(newVal)
        }
        items = []
    }

    var description: String {
        get {
            return "Monkey " + String(id) + ": " + items.map({String($0)}).joined(separator: ", ")
        }
    }
}

fileprivate func ReadMonkeys(_ lines: [String]) -> [Monkey]
{
    var monkeys: [Monkey] = []
    for i in stride(from: 0, to: lines.count, by: 7) {
        monkeys.append(Monkey(Array(lines[i...i+5])))
    }
    return monkeys
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    var monkeys = ReadMonkeys(lines)
    for _ in 0..<20 {
        for monkey in monkeys {
            monkey.RunMonkey(&monkeys)
        }
    }
    monkeys.sort(by: {$0.inspections < $1.inspections})
    return monkeys[monkeys.count-1].inspections * monkeys[monkeys.count-2].inspections
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    var monkeys = ReadMonkeys(lines)
    var newModVal = 1
    for monkey in monkeys {
        newModVal *= monkey.testVal
    }
    for i in 0..<monkeys.count {
        monkeys[i].divisor = 1
        monkeys[i].modVal = newModVal
    }
    for _ in 0..<10000 {
        for monkey in monkeys {
            monkey.RunMonkey(&monkeys)
        }
    }
    monkeys.sort(by: {$0.inspections < $1.inspections})
    return monkeys[monkeys.count-1].inspections * monkeys[monkeys.count-2].inspections
}

func Puzzle11(_ homePath: String)
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


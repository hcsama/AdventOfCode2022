//
//  Puzzle21.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 21.12.22.
//

import Foundation

private let puzzle = "21"

fileprivate class Monkey
{
    var operation: String?
    var value: Int?
    let name: String
    var requires: [String] = []
    static var allMonkeys: [String: Monkey] = [:]

    init(_ line: String) {
        let words = line.components(separatedBy: [" ", ":"])
        name = words[0]
        if words.count == 3 {
            value = Int(words.last!)!
            operation = nil
        } else {
            requires.append(words[2])
            requires.append(words[4])
            operation = words[3]
            value = nil
        }
        Monkey.allMonkeys[name] = self
    }

    static func Reset() {
        Monkey.allMonkeys = [:]
    }

    static func Solve(_ solveFor: String) -> Int {
        var toBeSolved: Set<String> = Set(Monkey.allMonkeys.filter({$0.value.value == nil || ($0.value.operation != nil && (Monkey.allMonkeys[$0.value.requires[0]]!.value == nil || Monkey.allMonkeys[$0.value.requires[1]]!.value == nil))}).keys)
        while true {
            for term in toBeSolved {
                let monkey = Monkey.allMonkeys[term]!
                let haveNumber = monkey.value != nil
                let left = monkey.operation != nil ? Monkey.allMonkeys[monkey.requires[0]] : nil
                let right = monkey.operation != nil ? Monkey.allMonkeys[monkey.requires[1]] : nil
                let haveLeftValue = left?.value != nil
                let haveRightValue = right?.value != nil
                if !haveNumber && haveLeftValue && haveRightValue {
                    switch monkey.operation {
                    case "+":
                        monkey.value = left!.value! + right!.value!
                    case "-":
                        monkey.value = left!.value! - right!.value!
                    case "/":
                        monkey.value = left!.value! / right!.value!
                    case "*":
                        monkey.value = left!.value! * right!.value!
                    default:
                        print("Illegal operation monkey", monkey.name)
                    }
                } else if haveNumber && haveLeftValue && !haveRightValue {
                    switch monkey.operation {
                    case "+":
                        right!.value = monkey.value! - left!.value!
                    case "-":
                        right!.value = left!.value! - monkey.value!
                    case "/":
                        right!.value = left!.value! / monkey.value!
                    case "*":
                        right!.value =  monkey.value! / left!.value!
                    default:
                        print("Illegal operation monkey", monkey.name)
                    }
                } else if haveNumber && !haveLeftValue && haveRightValue {
                    switch monkey.operation {
                    case "+":
                        left!.value = monkey.value! - right!.value!
                    case "-":
                        left!.value = right!.value! + monkey.value!
                    case "/":
                        left!.value = right!.value! * monkey.value!
                    case "*":
                        left!.value =  monkey.value! / right!.value!
                    default:
                        print("Illegal operation monkey", monkey.name)
                    }
                } else if !(haveNumber && monkey.operation == nil) {
                    continue
                }
                if term == solveFor {
                    return monkey.value!
                }
                toBeSolved.remove(term)
            }
        }
    }
}

fileprivate func ReadMonkeys(_ lines: [String])
{
    Monkey.Reset()
    for line in lines {
        let _ = Monkey(line)
    }
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    ReadMonkeys(lines)
    return Monkey.Solve("root")
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    ReadMonkeys(lines)
    let root = Monkey.allMonkeys["root"]!
    root.value = 0
    root.operation = "-"
    let humn = Monkey.allMonkeys["humn"]!
    humn.value = nil
    return Monkey.Solve("humn")
}

func Puzzle21(_ homePath: String)
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


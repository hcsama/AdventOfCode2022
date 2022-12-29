//
//  Puzzle19.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 19.12.22.
//

import Foundation

private let puzzle = "19"

fileprivate let resources = ["ore": 0, "clay": 1, "obsidian": 2, "geode": 3]
fileprivate var totalMinutes = 24
fileprivate let resourceCount = resources.count

fileprivate class Robot
{
    let robotType: Int
    var requires: [Int] = []

    init(_ rType: String) {
        robotType = resources[rType]!
        requires = Array(repeating: 0, count: resourceCount)
    }
}

fileprivate class Blueprint
{
    let id: Int
    var robots: [Robot] = []
    var maxDemand: [Int] = Array(repeating: 0, count: resourceCount)

    init(_ line: String) {
        let words = line.components(separatedBy: " ")
        id = Int(words[1].components(separatedBy: ":")[0])!
        var offset = 0
        for i in 0..<resourceCount {
            let robot = Robot(words[offset+3])
            robot.requires[resources[words[offset+7].components(separatedBy: ".")[0]]!] = Int(words[offset+6])!
            if i >= 2 {
                robot.requires[resources[words[offset+10].components(separatedBy: ".")[0]]!] = Int(words[offset+9])!
                offset += 9
            } else {
                offset += 6
            }
            robots.append(robot)
        }
        for rob in 0..<resourceCount {
            for res in 0..<resourceCount {
                maxDemand[res] = max(robots[rob].requires[res], maxDemand[res])
            }
        }
    }
}

fileprivate func ReadBlueprints(_ lines: [String]) -> [Blueprint]
{
    var res: [Blueprint] = []
    for line in lines {
        res.append(Blueprint(line))
    }
    return res
}

fileprivate struct State : Hashable, CustomStringConvertible, Comparable {
    var robots: [Int] = Array(repeating: 0, count: resourceCount)
    var available: [Int] = Array(repeating: 0, count: resourceCount)

    init() {
        available[0] = 0
        robots[0] = 1
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(robots)
        hasher.combine(available)
    }

    static func == (lhs: State, rhs: State) -> Bool {
        return lhs.robots == rhs.robots && lhs.available == rhs.available
    }

    static func < (lhs: State, rhs: State) -> Bool {
        for r in 0..<resourceCount {
            if lhs.robots[r] > rhs.robots[r] {
                return false
            } else if lhs.robots[r] < rhs.robots[r] {
                return true
            }
        }
        for r in 0..<resourceCount {
            if lhs.available[r] > rhs.available[r] {
                return false
            } else if lhs.available[r] < rhs.available[r] {
                return true
            }
        }
        return false
    }

    mutating func RunRobots(_ blueprint: Blueprint) {
        for i in 0..<resourceCount {
            available[i] += robots[i]
        }
    }

    mutating func BuildRobot(_ r: Int, _ blueprint: Blueprint) {
        robots[r] += 1
        for i in 0..<resourceCount {
            available[i] -= blueprint.robots[r].requires[i]
        }
    }

    func CanBuild(_ r: Int, _ blueprint: Blueprint) -> Bool {
        var canBuild = true
        for i in 0..<resourceCount {
            if available[i] < blueprint.robots[r].requires[i] {
                canBuild = false
                break
            }
        }
        return canBuild
    }

    var description: String {
        get {
            var res = "== State ==" + "\r"
            for r in 0..<resourceCount {
                if robots[r] > 0 {
                    res += String(robots[r]) + " "
                    res += resources.first(where: {$0.value == r})!.key + "-robots. You now have "
                    res += String(available[r]) + " " + resources.first(where: {$0.value == r})!.key + ".\r"
                }
            }
            return res + "\r"
        }
    }
}

fileprivate func CapRanges(_ state: inout State, _ blueprint: Blueprint, _ curTime: Int) {
    // Dont need more resources of a given type than could be consumed
    // for most expensive bot in the remaining time
    for r in 0..<resourceCount-1 {
        let delta = blueprint.maxDemand[r] - state.robots[r]
        let remainingMinutes = totalMinutes - curTime
        let max_usable = blueprint.maxDemand[r] + delta * remainingMinutes
        if state.available[r] > max_usable {
            state.available[r] = min(max_usable, state.available[r])
        }
    }
}

fileprivate func BIsBetter(_ a: State, _ b: State) -> Bool
{
    // A better node (b) is one where for every robot there are at least
    // as many as in the node to check (a) and for every mineral there are
    // also at least as many
    var res = true
    var r = 0
    while r < resourceCount {  // for loop is *much* slower because of iterator
        if a.robots[r] > b.robots[r] {
            res = false
            break
        }
        if a.available[r] > b.available[r] {
            res = false
            break
        }
        r += 1
    }
    return res
}

fileprivate func AllStates(_ startState: State, _ blueprint: Blueprint) -> Set<State>
{
    var nodes: Set<State> = [startState]

    for t in 1...totalMinutes {
        var newNodes: Set<State> = []
        for state in nodes {
            var newState = state
            newState.RunRobots(blueprint)
            var r = 0
            while r < resourceCount {
                if r >= resourceCount-1 || newState.robots[r] < blueprint.maxDemand[r] {
                    if state.CanBuild(r, blueprint) { // create Robot
                        var buildState = newState
                        buildState.BuildRobot(r, blueprint)
                        CapRanges(&buildState, blueprint, t)
                        newNodes.insert(buildState)
                    }
                }
                r += 1
            }
            CapRanges(&newState, blueprint, t)
            newNodes.insert(newState)
        }
        let sortedNodes = newNodes.sorted()
        nodes = []
        var i = 0
        let sortedCount = sortedNodes.count
        while i < sortedCount {
            var isRedundant = false
            var j = i+1
            while j < sortedCount {
                if BIsBetter(sortedNodes[i], sortedNodes[j]) {
                    isRedundant = true
                    break
                }
                j += 1
            }
            if !isRedundant {
                nodes.insert(sortedNodes[i])
            }
            i += 1
        }
    }
    return nodes
}

fileprivate func Process(_ blueprint: Blueprint) -> Int
{
    let initialState = State()
    print("BP #\(blueprint.id)", terminator: "-")
    let allGeodes = AllStates(initialState, blueprint)
    if let total = allGeodes.max(by: {$0.available.last! < $1.available.last!})?.available.last {
        print(total, terminator: "  ")
        return total
    } else {
        print(0, terminator: "  ")
        return 0
    }
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    let blueprints = ReadBlueprints(lines)
    var maxGeodes = 0
    for blueprint in blueprints {
        maxGeodes += Process(blueprint) * blueprint.id
    }
    print()
    return maxGeodes
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    totalMinutes = 32
    var blueprints = ReadBlueprints(lines)
    if blueprints.count > 2 {
        blueprints = blueprints.dropLast(blueprints.count-3)
    }
    var maxGeodes = 1
    for blueprint in blueprints {
        maxGeodes *= Process(blueprint)
    }
    print()
    return maxGeodes
}

func Puzzle19(_ homePath: String)
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

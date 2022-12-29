//
//  Puzzle16.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 16.12.22.
//

import Foundation

private let puzzle = "16"

fileprivate let totalTime = 30

fileprivate class NetworkNode : Equatable {
    let name: String
    let flowRate: Int
    var cumulatedFlow: [Int] = Array(repeating: 0, count: totalTime)
    var connections: [NetworkNode] = []
    var directConnections: [String: Int] = [:]
    static var rootNode: NetworkNode? = nil
    static var nodes: [String: NetworkNode] = [:]
    static var switchableNodes = 0

    init(_ n: String, _ r: Int) {
        name = n
        flowRate = r
        if flowRate > 0 {
            NetworkNode.switchableNodes += 1
        }
        if n == "AA" {
            NetworkNode.rootNode = self
        }
        NetworkNode.nodes[n] = self
        for i in 1..<totalTime {
            cumulatedFlow[i] = flowRate * (totalTime - i)
        }
    }

    static func Reset() {
        NetworkNode.rootNode = nil
        NetworkNode.nodes = [:]
        NetworkNode.switchableNodes = 0
    }

    static func == (lhs: NetworkNode, rhs: NetworkNode) -> Bool {
        return lhs.name == rhs.name
    }
}

fileprivate func ReadNodes(_ lines: [String])
{
    NetworkNode.Reset()
    for line in lines {
        let words = line.components(separatedBy: " ")
        let n = words[1]
        let r = Int(words[4].components(separatedBy: ["=", ";"])[1])!
        let _ = NetworkNode(n, r)
    }
    for line in lines {
        let words = line.components(separatedBy: " ")
        for w in words[9..<words.count] {
            NetworkNode.nodes[words[1]]!.connections.append(NetworkNode.nodes[w.components(separatedBy: ",")[0]]!)
        }
    }
}

fileprivate func FindDist(_ node: NetworkNode, _ target: NetworkNode, _ path: [String]) -> Int
{
    if node.name == target.name {
        return path.count
    }
    var minDist = NetworkNode.nodes.count
    var newPath = path
    newPath.append(node.name)
    for nextNode in node.connections {
        if path.contains(nextNode.name) {
            continue
        }
        let dist = FindDist(nextNode, target, newPath)
        minDist = min(dist, minDist)
    }
    return minDist
}

fileprivate func CalcDistances() -> [NetworkNode]
{
    let relevantNodes = Array(NetworkNode.nodes.filter({$1.flowRate > 0 || $1.name == "AA"}).values)
    var done: Set<String> = []
    for node in relevantNodes {
        for target in relevantNodes {
            if node.name == target.name {
                continue
            }
            if !done.contains(node.name+target.name) {
                let dist = FindDist(node, target, [])
                done.insert(node.name+target.name)
                done.insert(target.name+node.name)
                node.directConnections[target.name] = dist
                target.directConnections[node.name] = dist
            }
        }
    }
    return relevantNodes
}

fileprivate struct State: Hashable, Equatable
{
    var visited: Set<String> = []
    var path: [NetworkNode] = []
    var timestamps: [Int] = []
    var timeExpired: Int = 0
    var totalFlow: Int = 0
    var done: Bool = false

    func hash(into hasher: inout Hasher) {
        hasher.combine(visited)
        hasher.combine(path.last!.name)
    }

    static func == (lhs: State, rhs: State) -> Bool {
        return lhs.visited == rhs.visited && lhs.path == rhs.path
    }
}

fileprivate func Visit(_ maxTime: Int, _ maxValves: Int? = nil) -> [State] {
    let root = NetworkNode.rootNode!
    let rootState = State(visited: [root.name], path: [root], timeExpired: 1, totalFlow: 0)
    // states are distinguished by the nodes visited and the last node visited
    var states: [State: State] = [rootState: rootState]
    var couldMove = true
    var newStates = states
    var bestFlow = 0
    var bestTime = 0
    while couldMove {
        states = newStates
        print(states.count, terminator: " ")
        couldMove = false
        for state in states.values {
            var canMove = false
            if state.done {
                continue
            }
            if maxValves == nil || state.visited.count < maxValves! {
                for nextNode in state.path.last!.directConnections {
                    if state.visited.contains(nextNode.key) { // Already been there
                        continue
                    }
                    if state.timeExpired + nextNode.value >= maxTime { // Would take too long
                        continue
                    }
                    let next = NetworkNode.nodes[nextNode.key]!
                    var newState = state
                    newState.visited.insert(nextNode.key)
                    newState.path.append(next)
                    newState.timeExpired += nextNode.value+1
                    newState.timestamps.append(newState.timeExpired-1)
                    newState.totalFlow += next.cumulatedFlow[newState.timeExpired-1 + (totalTime - maxTime)]
                    if maxValves == nil {  // If we are limiting the number of valves we are looking for combos, no cutting off lower ones
                        if newState.timeExpired >= bestTime && newState.totalFlow < bestFlow {
                            continue
                        }
                        if newState.totalFlow > bestFlow {
                            bestFlow = newState.totalFlow
                            bestTime = newState.timeExpired
                        }
                    }
                    if let knownState = newStates[newState] {
                        if knownState.totalFlow < newState.totalFlow {  // newState is better, same combo, ending same valve, but better flow
                            newStates[newState] = newState
                        }
                    } else { // don't know this combo yet
                        newStates[newState] = newState
                    }
                    canMove = true
                }
            }
            if canMove {
                var newState = state
                newState.done = true
                newStates[newState] = newState
                couldMove = true
            }
        }
    }
    print()
    return Array(newStates.values)
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    ReadNodes(lines)
    let _ = CalcDistances()
    let bestFlow = Visit(totalTime).max(by: {$0.totalFlow < $1.totalFlow})!
    return bestFlow.totalFlow
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    ReadNodes(lines)
    let relevantNodes = CalcDistances()
    let allCombos = Visit(26, relevantNodes.count-1) // All nodes but one (why else use the elephant?)
    let sortedCombos = allCombos.sorted(by: {$0.totalFlow > $1.totalFlow}) // Sort descending
    var bestFlow = 0
    var limit = sortedCombos.count
    for human in 0..<sortedCombos.count {
        if human >= limit { // Stop if we arrive at symmetry
            break
        }
        for elephant in 0..<sortedCombos.count {
            if human == elephant {
                continue
            }
            if sortedCombos[human].visited.intersection(sortedCombos[elephant].visited).count > 1 {
                continue
            }
            let hCombo = sortedCombos[human]
            let eCombo = sortedCombos[elephant]
            if hCombo.totalFlow + eCombo.totalFlow >= bestFlow {
                print(hCombo.totalFlow, hCombo.path.map({$0.name}), eCombo.totalFlow, eCombo.path.map({$0.name}))
                bestFlow = hCombo.totalFlow + eCombo.totalFlow
                if elephant < limit {
                    limit = elephant
                }
            }
        }
    }
    return bestFlow
}

func Puzzle16(_ homePath: String)
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

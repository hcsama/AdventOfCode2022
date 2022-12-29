//
//  MazeHelper.swift
//  AdventOfCode2021
//
//  Created by Hans-Christian Fuchs on 09.12.21.
//

import Foundation

/**
 Turns two dimensional Grid of T into dictionary of VectorXD: T. Allows for filtering

 - parameter grid: Two dimensional array of T
 - parameter filter: Optional function taking a VectorXD and grid element T and returning boolean if the element should be included

 - returns: A dictionary of VectorXD: grid element
 */
func GridToDict<T>(grid: [[T]], filter: ((_ pos: VectorXD, _ gridItem: T) -> Bool)? = nil) -> [VectorXD: T] {
    var result: [VectorXD: T] = [:]
    for y in 0..<grid.count {
        for x in 0..<grid[y].count {
            if filter == nil || filter!(VectorXD([x, y]), grid[y][x]) {
                result[VectorXD([x, y])] = grid[y][x]
            }
        }
    }
    return result
}

/**
 Base Class for maze handling
 */
class MazeHelper {

    /**
     Provides a dictionary of all neighboring points and their transition costs
      This function should be overridden

     - parameter v: Which point to start from

     - returns: A dictionary of VectorXD: Transition cost
     */
    func Neighbors(_ v: VectorXD) -> [VectorXD: Int] {
        return [:]
    }

    /**
     Finds the cheapest paths (dijkstra) from a given starting point to the set of possible endpoints provided.
     Relies on Neighbors method.

     - parameter start: Where to start from
     - parameter targets: Set of VectorXD containing endpoints to reach

     - returns: A dictionary of VectorXD: Total cost and a dictionary of VectorXD: [VectorXD] for each path. Paths include start and endpoints. Not all targets may have been reached
     */
    func CheapestPaths(start: VectorXD, targets: Set<VectorXD>) -> ([VectorXD: Int], [VectorXD: [VectorXD]])
    {
        var stack: [VectorXD: Int] = [start: 0]
        var prev: [VectorXD: VectorXD] = [:]
        var done: Set<VectorXD> = []
        var targetsToReach = targets
        var targetsDone: [VectorXD: Int] = [:]
        var targetPaths: [VectorXD: [VectorXD]] = [:]

        assert(targets.count > 0, "Target list is empty")
        while stack.count > 0 && targetsToReach.count > 0 {
            let minItem = stack.min(by: {$0.value < $1.value})!
            stack[minItem.key] = nil
            done.insert(minItem.key)
            if targetsToReach.contains(minItem.key) {
                targetsToReach.remove(minItem.key)
                targetsDone[minItem.key] = minItem.value
            }
            for i in Neighbors(minItem.key) {
                if !done.contains(i.key) {
                    let newCost = minItem.value + i.value
                    if stack[i.key] == nil || newCost < stack[i.key]! {
                        stack[i.key] = newCost
                        prev[i.key] = minItem.key
                    }
                }
            }
        }
        for i in targetsDone { // Record all paths
            var path: [VectorXD] = [i.key]
            while prev.keys.contains(path.last!) {
                path.append(prev[path.last!]!)
            }
            path.reverse()
            targetPaths[i.key] = path
        }
        return (targetsDone, targetPaths)
    }

    /**
     Checks if point is target point returns true or false
      This function should be overridden

     - parameter v: Which point to check

     - returns: Whether the point is a target point or not
     */
    func isTarget(_ v: VectorXD) -> Bool {
        return false
    }

    /**
     Finds the cheapest path (dijkstra) from a given starting point to an Endpoint defined by isTarget().
     Relies on Neighbors() and isTarget() methods.

     - parameter start: Where to start from

     - returns: An Int total cost and an array [VectorXD] for the path. Path includes start and endpoints. May return 0 and empty path
     */
    func CheapestPath(start: VectorXD) -> (Int, [VectorXD])
    {
        var stack: [VectorXD: Int] = [start: 0]
        var prev: [VectorXD: VectorXD] = [:]
        var done: Set<VectorXD> = []
        var targetPath: [VectorXD] = []
        var targetCost: Int = 0
        var targetPos: VectorXD?

        while stack.count > 0 {
            let minItem = stack.min(by: {$0.value < $1.value})!
            stack[minItem.key] = nil
            done.insert(minItem.key)
            if isTarget(minItem.key) { // found it
                targetCost = minItem.value
                targetPos = minItem.key
                break
            }
            for i in Neighbors(minItem.key) {
                if !done.contains(i.key) {
                    let newCost = minItem.value + i.value
                    if stack[i.key] == nil || newCost < stack[i.key]! {
                        stack[i.key] = newCost
                        prev[i.key] = minItem.key
                    }
                }
            }
        }
        // reconstruct path
        if targetCost > 0 {  // zero cost means no path
            targetPath = [targetPos!]
            while prev.keys.contains(targetPath.last!) {
                targetPath.append(prev[targetPath.last!]!)
            }
            targetPath.reverse()
        }
        return (targetCost, targetPath)
    }

    /**
     Provides a dictionary of all permitted neighboring points. Used for Flood
      This function should be overridden

     - parameter v: Which point to start from

     - returns: A Set of VectorXD
     */
    func AllowedNeighbors(_ v: VectorXD) -> Set<VectorXD> {
        return []
    }

    private func DoFlood(result: inout Set<VectorXD>, start: VectorXD)
    {
        result.insert(start)
        for p in AllowedNeighbors(start) {
            if !result.contains(p) {
                DoFlood(result: &result, start: p)
            }
        }
    }

    /**
     Returns a set of coordinates collected by starting from <start> and by evaluating AllowedNeighbors for each step.

     - parameter grid: Dictionary of the grid item type identified by a VectorXD location
     - parameter start: The point to start from

     - returns: The Set of positions that where flooded
     */
    func Flood(start: VectorXD) -> Set<VectorXD>
    {
        var result: Set<VectorXD> = []
        DoFlood(result: &result, start: start)
        return result
    }

}



//
//  Puzzle18.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 18.12.22.
//

import Foundation

private let puzzle = "18"

fileprivate class PointCloud {
    var points: Set<VectorXD>
    var noGo: Set<VectorXD>
    var bbox: CubeXD

    init<T: Collection<VectorXD>>(_ p: T) {
        points = Set(p)
        bbox = CubeXD(points)
        noGo = []
    }

    func Flood(_ point: VectorXD, _ flooded: inout Set<VectorXD>) -> Bool {
        let neighbors = point.Neighbors(onlyDirect: true).filter({!bbox.notContains($0)})
        var touchesSide =  neighbors.count < point.dim * 2
        flooded.insert(point)
        for next in neighbors {
            if flooded.contains(next) || points.contains(next) {
                continue
            } else if noGo.contains(next) {
                touchesSide = true
                continue
            } else {
                touchesSide = Flood(next, &flooded) || touchesSide
            }
        }
        return touchesSide
    }
}

fileprivate func ReadCubes(_ lines: [String]) -> [VectorXD]
{
    var res: [VectorXD] = []
    for line in lines {
        let words = line.components(separatedBy: ",")
        res.append(VectorXD([Int(words[0])!, Int(words[1])!, Int(words[2])!]))
    }
    return res
}

fileprivate func CountNeighbors(_ cube: VectorXD, _ cubeSet: Set<VectorXD>) -> Int {
    var total = 0
    let sides = cube.Neighbors(onlyDirect: true)
    for side in sides {
        if !cubeSet.contains(side) {
            total += 1
        }
    }
    return total
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    let cubes = PointCloud(ReadCubes(lines))
    var total = 0
    for cube in cubes.points {
        total += CountNeighbors(cube, cubes.points)
        }
    return total
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    let cubes = PointCloud(ReadCubes(lines))
    let bbox = cubes.bbox.InsetCube(-1)
    var floods = 0
    for point in bbox {
        if cubes.points.contains(point) || cubes.noGo.contains(point) {
            continue
        }
        floods += 1
        var flooded: Set<VectorXD> = []
        if !cubes.Flood(point, &flooded) {
            cubes.points.formUnion(flooded)
        } else {
            cubes.noGo.formUnion(flooded)
        }
    }
    print(floods)
    var total = 0
    for cube in cubes.points {
        total += CountNeighbors(cube, cubes.points)
        }
    return total
}

func Puzzle18(_ homePath: String)
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


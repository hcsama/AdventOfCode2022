//
//  Puzzle15.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 15.12.22.
//

import Foundation

private let puzzle = "15"

class Sensor {
    let pos: VectorXD
    let beaconPos: VectorXD
    let range: Int

    init(_ line: String) {
        let words = line.components(separatedBy: " ")
        pos = VectorXD([Int(words[2].components(separatedBy: ["=", ","])[1])!, Int(words[3].components(separatedBy: ["=", ":"])[1])!])
        beaconPos = VectorXD([Int(words[8].components(separatedBy: ["=", ","])[1])!, Int(words[9].components(separatedBy: ["="])[1])!])
        range = abs((beaconPos - pos).Manhatten())
    }
}

fileprivate func RowCover(_ sensors: [Sensor], _ row: Int, _ maxVal: Int) -> Int? {
    var cover: [[Int]] = []
    for sensor in sensors {
        if sensor.pos.v[1] - sensor.range <= row && sensor.pos.v[1] + sensor.range >= row {
            let remain = sensor.range - abs(sensor.pos.v[1] - row)
            cover.append([max(sensor.pos.v[0] - remain,  0), min(sensor.pos.v[0] + remain, maxVal)])
        }
    }
    cover.sort(by: {$0[0] < $1[0]})
    var biggestRight = cover[0][1]
    var hit: Int? = nil
    for c in 1..<cover.count {
        if cover[c][0] > biggestRight+1 {
            hit = cover[c][0] - 1
            break
        }
        biggestRight = max(biggestRight, cover[c][1])
    }
    return hit
}

fileprivate func ImpossibleSpots(_ sensors: [Sensor], _ beaconRow: Int) -> (Int, Set<Int>) {
    var left: Int? = nil
    var right: Int? = nil
    var beacons: Set<Int> = []
    for sensor in sensors {
        if sensor.pos.v[1] - sensor.range <= beaconRow && sensor.pos.v[1] + sensor.range >= beaconRow {
            let remain = sensor.range - abs(sensor.pos.v[1] - beaconRow)
            let newLeft = sensor.pos.v[0] - remain
            let newRight = sensor.pos.v[0] + remain
            if left == nil || newLeft < left! {
                left = newLeft
            }
            if right == nil || newRight > right! {
                right = newRight
            }
            if sensor.beaconPos.v[1] == beaconRow {
                beacons.insert(sensor.beaconPos.v[0])
            }
        }
    }
    return (right!-left!+1, beacons)
}
fileprivate func Part1(_ lines: [String]) -> Any
{
    var sensors: [Sensor] = []
    for line in lines {
        sensors.append(Sensor(line))
    }
    let beaconRow = sensors.count == 14 ? 10 : 2000000
    let (n, spots) = ImpossibleSpots(sensors, beaconRow)
    return n-spots.count
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    var sensors: [Sensor] = []
    for line in lines {
        sensors.append(Sensor(line))
    }
    var res = 0
    let maxRow = sensors.count == 14 ? 20 : 4000000
    for beaconRow in 0...maxRow {
        if let cover = RowCover(sensors, beaconRow, maxRow) {
            res = cover * 4000000 + beaconRow
            break
        }
    }
    return res
}

func Puzzle15(_ homePath: String)
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


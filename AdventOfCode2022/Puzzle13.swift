//
//  Puzzle13.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 13.12.22.
//

import Foundation

private let puzzle = "13"

fileprivate class Item {
    var value: Int? = nil
    var items: [Item] = []
    var divider: Bool = false

    init() {
    }

    init(_ v: Int) {
        value = v
    }
}

fileprivate func ReadOne(_ line: String, _ pos: inout Int) -> Item
{
    let item = Item()

    while line[pos] != "]" {
        switch line[pos] {
        case "[":
            pos = pos+1
            item.items.append(ReadOne(line, &pos))
        case ",":
            pos += 1
        default:
            let words = line[pos..<line.count].components(separatedBy: [",", "]"])
            let subItem = Item(Int(words[0])!)
            item.items.append(subItem)
            pos += words[0].count
        }
    }
    pos += 1
    return item
}

fileprivate func ReadLines(_ lines: [String]) -> [[Item]]
{
    var items: [[Item]] = []
    for i in 0..<lines.count/3+1 {
        var pos1 = 1
        var pos2 = 1
        items.append([ReadOne(lines[i*3], &pos1), ReadOne(lines[i*3+1], &pos2)])
    }
    return items
}

fileprivate func Compare(_ i1: Item, _ i2: Item) -> Int
{
    var item1 = i1
    var item2 = i2

    if let v1 = item1.value {
        if let v2 = item2.value {
            if v1 < v2 { return -1 }
            if v1 > v2 { return 1 }
            if v1 == v2 { return 0 }
        }
    }

    if item1.value != nil {
        item1 = Item()
        item1.items.append(Item(i1.value!))
    }

    if item2.value != nil {
        item2 = Item()
        item2.items.append(Item(i2.value!))
    }

    for i in 0..<min(item1.items.count, item2.items.count) {
        let comp = Compare(item1.items[i], item2.items[i])
        switch comp {
        case -1:
            return -1
        case 1:
            return 1
        default:
            if comp != 0 {
                print("illegal comparison")
            }
        }
    }
    if item1.items.count < item2.items.count {
        return -1
    }
    if item1.items.count > item2.items.count {
        return 1
    }

    return 0
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    let items = ReadLines(lines)
    var total = 0
    for i in 0..<items.count {
        let res = Compare(items[i][0], items[i][1])
        if res == -1 {
            total += i+1
        }
        if res == 0 {
            print("illegal order")
        }
    }
    return total
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    let items = ReadLines(lines + ["", "[[2]]", "[[6]]"])
    var flatItems = items.flatMap({$0})
    flatItems[flatItems.count-1].divider = true
    flatItems[flatItems.count-2].divider = true
    flatItems.sort(by: {Compare($0, $1) < 0})
    var res = 1
    for i in 0..<flatItems.count {
        if flatItems[i].divider {
            res *= i+1
        }
    }
    return res
}

func Puzzle13(_ homePath: String)
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


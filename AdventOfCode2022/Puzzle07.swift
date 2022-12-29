//
//  Puzzle07.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 07.12.22.
//

import Foundation

private let puzzle = "07"

fileprivate class Node : CustomStringConvertible {
    let name: String
    let isDir: Bool
    var size: Int
    var children: [Node] = []
    var parent: Node? = nil

    init (_ n: String, _ d: Bool, _ s: Int) {
        name = n
        isDir = d
        size = s
    }

    func AddChild(_ n: Node) {
        children.append(n)
        n.parent = self
    }

    func CalcSize() {
        for c in children {
            c.CalcSize()
            size += c.size
        }
    }

    func FindSmallCildren(_ limit: Int) -> [Node]
    {
        var res: [Node] = []
        for c in children {
            if c.isDir {
                if c.size <= limit {
                    res.append(c)
                }
                res.append(contentsOf: c.FindSmallCildren(limit))
            }
        }
        return res
    }

    func FindBigCildren(_ limit: Int) -> [Node]
    {
        var res: [Node] = []
        for c in children {
            if c.isDir {
                if c.size >= limit {
                    res.append(c)
                }
                res.append(contentsOf: c.FindBigCildren(limit))
            }
        }
        return res
    }

    func Print(_ curName: String) {
        let s = curName + description
        if isDir && size <= 100000 {
            print("***" + s)
        } else {
            print(s)
        }
        if isDir {
            for c in children {
                c.Print(s)
            }
        }
    }

    var description: String {
        get {
            var s = name
            if isDir && name != "/" {
                s += "/"
            }
            s += " (\(size))"
            return s
        }
    }
}

fileprivate func ReadTree(_ lines: [String]) -> Node
{
    let root = Node("/", true, 0)
    var curDir = root
    for line in lines {
        let words = line.components(separatedBy: " ")
        if words[0] == "$" {
            switch words[1] {
            case "cd":
                if words [2] == "/" {
                    curDir = root
                } else if words[2] == ".." {
                    curDir = curDir.parent!
                } else {
                    for c in curDir.children {
                        if c.name == words[2] {
                            curDir = c
                            break
                        }
                    }
                }
                break
            case "ls":
                // no action
                break
            default:
                print("unknown command \(line)")
            }
        } else {
            if words[0] == "dir" {
                curDir.AddChild(Node(words[1], true, 0))
            } else {
                curDir.AddChild(Node(words[1], false, Int(words[0])!))
            }
        }
    }
    return root
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    let tree = ReadTree(lines)
    tree.CalcSize()
    let small = tree.FindSmallCildren(100000)
    var total = 0
    for s in small {
        total += s.size
    }
    return total
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    let totalSize = 70000000
    let required = 30000000
    let tree = ReadTree(lines)
    tree.CalcSize()
    let free = totalSize - tree.size
    let small = tree.FindBigCildren(required - free)
    return small.min(by: {n1, n2 in n1.size < n2.size})!.size
}

func Puzzle07(_ homePath: String)
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


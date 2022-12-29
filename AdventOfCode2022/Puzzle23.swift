//
//  Puzzle23.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 23.12.22.
//

import Foundation

private let puzzle = "23"

fileprivate let directions: [Int: Set<Int>] = [0: [0, 1, 7], 4: [4, 3, 5], 6: [6, 7, 5], 2: [2, 1, 3]]
fileprivate let order = [0, 4, 6, 2]
fileprivate let dirVectors = [VectorXD([0, -1]), VectorXD([1, -1]), VectorXD([1, 0]), VectorXD([1, 1]), VectorXD([0, 1]), VectorXD([-1, 1]), VectorXD([-1, 0]), VectorXD([-1, -1])]

fileprivate class Elf : Hashable
{
    let id: Int
    var pos: VectorXD
    static var nextPrio: Int = 0
    var proposedMove: Int?
    static var elfs: [VectorXD: Elf] = [:]
    static var proposedMoves: [VectorXD: Int] = [:]

    init(_ v: VectorXD) {
        pos = VectorXD(v)
        Elf.nextPrio = 0
        proposedMove = nil
        id = Elf.elfs.count
        Elf.elfs[self.pos] = self
    }

    static func Reset() {
        Elf.elfs = [:]
        Elf.nextPrio = 0
        Elf.proposedMoves = [:]
    }

    static func newRound() {
        Elf.proposedMoves = [:]
    }

    static func finishRound() {
        Elf.nextPrio += 1
    }

    func Propose() {
        proposedMove = nil
        var otherElfs = Array(repeating: false, count: 8)
        var anyElf = false
        var dir = 0
        while dir < 8 {
            let checkPos = pos + dirVectors[dir]
            if Elf.elfs[checkPos] != nil {
                otherElfs[dir] = true
                anyElf = true
            } else {
                otherElfs[dir] = false
            }
            dir += 1
        }
        if !anyElf {
            return
        }
        var d = Elf.nextPrio
        while d < Elf.nextPrio+4 {
            let dir = order[d%4]
            var anyElf = false
            for look in directions[dir]! {
                anyElf = otherElfs[look] || anyElf
            }
            if !anyElf {
                proposedMove = dir
                let newPos = pos + dirVectors[dir]
                if let m = Elf.proposedMoves[newPos] {
                    Elf.proposedMoves[newPos] = m+1
                } else {
                    Elf.proposedMoves[newPos] = 1
                }
                break
            }
            d += 1
        }
    }

    func Move() {
        if let move = proposedMove {
            let newPos = pos + dirVectors[move]
            if Elf.proposedMoves[newPos] == 1 {
                Elf.elfs[pos] = nil
                pos = newPos
                Elf.elfs[pos] = self
            }
        }
    }

    static func == (lhs: Elf, rhs: Elf) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(pos)
    }
}

fileprivate func ReadElfs(_ lines: [String])
{
    Elf.Reset()
    let grid = lines.map({$0.map({$0})})
    let elfpos = GridToDict(grid: grid, filter: {$1 == "#"})
    for p in elfpos.keys {
        let _ = Elf(p)
    }
}

fileprivate func Part1(_ lines: [String]) -> Any
{
    ReadElfs(lines)
    for i in 0..<10 {
        Elf.newRound()
        let allElfs = Array(Elf.elfs.values)
        for elf in allElfs {
            elf.Propose()
        }
        if Elf.elfs.values.filter({$0.proposedMove != nil}).count == 0 {
            print("no more moves", i)
            break
        }
        for elf in allElfs {
            elf.Move()
        }
        Elf.finishRound()
    }
    let area = CubeXD(Elf.elfs.keys)
    let size = area.botRight - area.topLeft
    return (size.v[0] + 1) * (size.v[1] + 1) - Elf.elfs.count
}

fileprivate func Part2(_ lines: [String]) -> Any
{
    ReadElfs(lines)
    var rounds = 0
    while true {
        Elf.newRound()
        rounds += 1
        let allElfs = Array(Elf.elfs.values)
        for elf in allElfs {
            elf.Propose()
        }
        if Elf.elfs.values.filter({$0.proposedMove != nil}).count == 0 {
            break
        }
        for elf in allElfs {
            elf.Move()
        }
        Elf.finishRound()
    }
    return rounds
}

func Puzzle23(_ homePath: String)
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


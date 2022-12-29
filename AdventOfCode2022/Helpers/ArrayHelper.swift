//
//  ArrayHelper.swift
//  AdventOfCode2021
//
//  Created by Hans-Christian Fuchs on 04.12.21.
//

import Foundation

/**
 Flips any array vertically and returns the result

 - parameter t: The array to flip

 - returns: The flipped array
 */
func flipV<T>(_ t: [T]) -> [T]
{
    return t.reversed()
}

/**
 Flips any two dimensional array horizontally (reversing all rows) and returns the result

 - parameter t: The array to flip

 - returns: The flipped array
 */
func flipH<T>(_ t: [[T]]) -> [[T]]
{
    return t.map({$0.reversed()})
}

/**
 Transposes any two dimensional array and returns the result. The array MUST be rectangular

 - parameter t: The array to transpose

 - returns: The transposed array
 */
func transpose<T>(_ t: [[T]]) -> [[T]]
{
    var hlp: [[T]] = []
    let w = t[0].count
    let h = t.count
    for x in 0..<w {
        var line: [T] = []
        for y in 0..<h {
            assert(t[y].count == w, "Array not rectangular")
            line.append(t[y][x])
        }
        hlp.append(line)
    }
    return hlp
}

func rotateCW<T>(_ t: [[T]]) -> [[T]]
{
    var hlp: [[T]] = []
    let w = t[0].count
    let h = t.count
    for x in 0..<w {
        var line: [T] = []
        for y in 0..<h {
            assert(t[y].count == w, "Array not rectangular")
            line.append(t[y][w-1-x])
        }
        hlp.append(line)
    }
    return hlp
}

func rotateCCW<T>(_ t: [[T]]) -> [[T]]
{
    var hlp: [[T]] = []
    let w = t[0].count
    let h = t.count
    for x in 0..<w {
        var line: [T] = []
        for y in 0..<h {
            assert(t[y].count == w, "Array not rectangular")
            line.append(t[h-1-y][w-1-x])
        }
        hlp.append(line)
    }
    return hlp
}


extension Array where Element == Array<Int> {
    /**
     Flips any array vertically and returns the result

     - parameter t: The array to flip

     - returns: The flipped array
     */
        func flippedV() -> [Array<Int>] {
            return flipV(self)
        }

    /**
     Flips any two dimensional array horizontally (reversing all rows) and returns the result

     - parameter t: The array to flip

     - returns: The flipped array
     */
        func flippedH() -> [Array<Int>] {
            return flipH(self)
        }

    /**
     Transposes any two dimensional array and returns the result.
     The array MUST be rectangular

     - parameter t: The array to transpose

     - returns: The transposed array
     */
        func transposed() -> [Array<Int>] {
            return transpose(self)
        }

    /**
     Rotates any two dimensional array clockwise 90deg and returns the result.
     The array MUST be rectangular

     - parameter t: The array to rotate

     - returns: The rotated array
     */
        func rotatedCW() -> [Array<Int>] {
            return rotateCW(self)
        }

    /**
     Rotates any two dimensional array counter-clockwise 90deg and returns the result.
     The array MUST be rectangular

     - parameter t: The array to rotate

     - returns: The rotated array
     */
        func rotatedCCW() -> [Array<Int>] {
            return rotateCCW(self)
        }
}


extension Array where Element == Array<Character> {
    /**
     Flips any array vertically and returns the result

     - parameter t: The array to flip

     - returns: The flipped array
     */
            func flippedV() -> [Array<Character>] {
                return flipV(self)
            }

    /**
     Flips any two dimensional array horizontally (reversing all rows) and returns the result

     - parameter t: The array to flip

     - returns: The flipped array
     */
            func flippedH() -> [Array<Character>] {
                return flipH(self)
            }

    /**
     Transposes any two dimensional array and returns the result.
     The array MUST be rectangular

     - parameter t: The array to transpose

     - returns: The transposed array
     */
        func transposed() -> [Array<Character>] {
            return transpose(self)
        }

    /**
     Rotates any two dimensional array clockwise 90deg and returns the result.
     The array MUST be rectangular

     - parameter t: The array to rotate

     - returns: The rotated array
     */
        func rotatedCW() -> [Array<Character>] {
            return rotateCW(self)
        }

    /**
     Rotates any two dimensional array counter-clockwise 90deg and returns the result.
     The array MUST be rectangular

     - parameter t: The array to rotate

     - returns: The rotated array
     */
        func rotatedCCW() -> [Array<Character>] {
            return rotateCCW(self)
        }
}


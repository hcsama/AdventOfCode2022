//
//  main.swift
//  AdventOfCode2021
//
//  Created by Hans-Christian Fuchs on 22.11.21.
//
// Set Swift compiler to optimize for speed!
//
import Foundation

private let homePath = "/Users/hch/Documents/XCode/AdventOfCode2022/AdventOfCode2022/"

let s = StopWatch()
s.start()

Puzzle25(homePath)

s.stop()
print("Total puzzle time is \(s.seconds())s")

//Puzzle99(homePath)

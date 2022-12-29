//
//  StopWatch.swift
//  AdventOfCode2021
//
//  Created by Hans-Christian Fuchs on 26.12.21.
//

import Foundation


class StopWatch
{
    private var startTime: DispatchTime? = nil
    private var result: UInt64? = nil

    init() {
    }

    func start() {
        assert(startTime == nil, "StopWatch started while already running")
        startTime = DispatchTime.now()
        result = nil
    }

    func stop() {
        assert(startTime != nil, "StopWatch stopped but not running")
        let stopTime = DispatchTime.now()
        result = stopTime.uptimeNanoseconds - startTime!.uptimeNanoseconds
        startTime = nil
    }

    func micros() -> UInt64 {
        return result! / 1000
    }

    func millis() -> UInt64 {
        return result! / 1000000
    }

    func seconds() -> Float {
        return Float(Double(result!) / 1000000000.0)
    }
}


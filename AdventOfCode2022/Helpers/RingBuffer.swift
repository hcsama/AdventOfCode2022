//
//  RingBuffer.swift
//  AdventOfCode2016
//
//  Created by Hans-Christian Fuchs on 11.01.22.
//

import Foundation


/**
 A circular Buffer where zero index can shift. Elements can be added and removed at front and back
 Access is via regular Array subscription. However, index is corrected for zero shift
 */
class RingBuffer<Element> : CustomStringConvertible {
    var buffer: [Element]
    var startPos: Int
    var nElements: Int

    /**
     Creates buffer of certain size, initialized to a common value

     - parameter capacity: Size of buffer
     - parameter initVal: Value to use to initialize buffer positions
     */
    init(capacity: Int, initVal: Element) {
        buffer = Array(repeating: initVal, count: capacity)
        startPos = 0
        nElements = capacity
    }

    /**
     Creates buffer of certain size, initialized to a computed value

     - parameter capacity: Size of buffer
     - parameter initFunc: Function to call to value to initialize buffer positions
     */
    init(capacity: Int, initFunc: (_ index: Int) -> Element) {
        buffer = []
        startPos = 0
        nElements = capacity
        for i in 0..<capacity {
            buffer[i] = initFunc(i)
        }
    }

    private func CalcIndex(_ i: Int) -> Int {
        assert(i < nElements, "index out of bounds in RingBuffer (\(i) vs \(nElements))")
        let newInd = (startPos + i) % buffer.count
        return newInd
    }

    subscript(index: Int) -> Element {
        get {
            buffer[CalcIndex(index)]
        }
        set {
            buffer[CalcIndex(index)] = newValue
        }
    }

    func count() -> Int {
        return nElements
    }
    
    @discardableResult func popFirst() -> Element? {
        if nElements > 0 {
            let hlp = startPos
            startPos = (startPos+1) % buffer.count
            nElements -= 1
            return buffer[hlp]
        }
        return nil
    }

    @discardableResult func popLast() -> Element? {
        if nElements > 0 {
            let hlp = CalcIndex(nElements - 1)
            nElements -= 1
            return buffer[hlp]
        }
        return nil
    }

    func pushFirst(_ item: Element) {
        if nElements == buffer.count {
            buffer.insert(item, at: startPos)
        } else {
            startPos -= 1
            if startPos < 0 {
                startPos = buffer.count-1
            }
            buffer[startPos] = item
        }
        nElements += 1
    }

    func pushLast(_ item: Element) {
        nElements += 1
        if nElements > buffer.count {
            buffer.insert(item, at: CalcIndex(nElements-1))
        } else {
            buffer[CalcIndex(nElements-1)] = item
        }
    }

    var description: String {
        get {
            var res = "["
            for i in 0..<nElements {
                if i != 0 {
                    res.append(", ")
                }
                res.append(String(describing: buffer[CalcIndex(i)]))
            }
            return res + "]"
        }
    }
}

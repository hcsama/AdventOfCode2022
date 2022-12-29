//
//  RingArray.swift
//  Experimente
//
//  Created by Hans-Christian Fuchs on 06.12.21.
//

import Foundation

/**
 A circular Array of fixed size where zero index can shift
 Access is via regular Array subscription. However, index is corrected for zero shift
 */
class RingArray<Element> {
    private var values: [Element]
    private var startIndex = 0

    /**
     Creates array of fixed size and initializes with provided value

     - parameter length: Size of Array
     - parameter initVal: Value to initialize each Array position with

     */

    init(length: Int, initVal: Element) {
        values = Array(repeating: initVal, count: length)
    }
    
    private func CalcIndex(_ i: Int) -> Int {
        var newInd = (i + startIndex) % values.count
        if newInd < 0 {
            newInd = values.count + newInd
        }
        return newInd
    }
    
    subscript(index: Int) -> Element {
        get {
            values[CalcIndex(index)]
        }
        set {
            values[CalcIndex(index)] = newValue
        }
    }
    
    /**
     Moves the zero index position of the array by a negative or positive Value

     - parameter delta: By how much to shift zero index

     */
    func MoveStartindex(_ delta: Int)
    {
        startIndex = CalcIndex(delta)
    }
    
    /**
     Returns the size of the Array

     - returns: Size of array as provided on creation
     */
    func count() -> Int {
        return values.count
    }
    
    /**
     Returns an array, starting at the current zero index if desired

     - parameter rotated: Boolean to rotate result so that current zero index is at pos zero

     - returns: The array
     */
    func Items(rotated: Bool = false) -> [Element] {
        if rotated {
            var retVal = Array(values[startIndex..<values.count])
            retVal.append(contentsOf: values[0..<startIndex])
            return retVal
        } else {
            return values
        }
    }
}

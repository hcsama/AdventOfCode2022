//
//  CircularLinkedList.swift
//  AdventOfCode2022
//
//  Created by Hans-Christian Fuchs on 29.12.22.
//

import Foundation


class CircularLinkedList {
    var prev: CircularLinkedList? = nil
    var next: CircularLinkedList? = nil
    static var listHead: CircularLinkedList? = nil
    static var listCount: Int = 0

    /// Initializes the list item and appends it at the end of the list (or starts new list if first item)
    /// - Parameter v: Value for payload
    init() {
        CircularLinkedList.listCount += 1
        if CircularLinkedList.listCount == 1 {  // new list
            CircularLinkedList.listHead = self
            self.prev = self
            self.next = self
        } else {
            let last = CircularLinkedList.listHead!.prev!
            last.next = self
            self.prev = last
            self.next = CircularLinkedList.listHead
            CircularLinkedList.listHead!.prev = self
        }
    }

    /// Reset the list completely, remove any existing items
    static func Reset() {
        CircularLinkedList.listCount = 0
        if CircularLinkedList.listHead != nil {
            var l = CircularLinkedList.listHead!
            while l.next != nil { // remove all references to release objects
                let n = l.next!
                l.next = nil
                l.prev = nil
                l = n
            }
        }
        CircularLinkedList.listHead = nil
    }

    /// Move the item to m places further on in the list.
    /// - Parameter m: How many positions to move by. Can be positive or negative. Will wrap around automatically
    /// - Parameter insertBefore: Optional default false. If true, item will be inserted before the position moved to
    func Move(_ m: Int, _ insertBefore: Bool = false) {
        let move = m % (CircularLinkedList.listCount-1)
        if move == 0 {
            return
        }
        var target: CircularLinkedList? = self
        var i = 0
        let absMove = abs(move)
        while i < absMove {
            if move > 0 {
                target = target!.next
            } else if move < 0 {
                target = target!.prev
            }
            i += 1
        }
        // remove self from list
        self.prev!.next = self.next
        self.next!.prev = self.prev
        // re-insert self
        if !insertBefore { // insert after
            let newNext = target!.next
            target!.next = self
            self.prev = target
            newNext!.prev = self
            next = newNext
        } else { // insert before
            let newPrev = target!.prev
            target!.prev = self
            self.next = target
            newPrev!.next = self
            prev = newPrev
        }
    }
}

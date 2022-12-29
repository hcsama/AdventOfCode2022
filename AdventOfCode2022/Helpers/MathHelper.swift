//
//  MathHelper.swift
//  AdventOfCode2021
//
//  Created by Hans-Christian Fuchs on 16.12.21.
//

import Foundation

func GreatestCommonDivisor(_ aa: Int64, _ bb: Int64) -> Int64
{
    var a = aa
    var b = bb
    while b != 0 {
        let t = b
        b = a % b
        a = t
    }
    return a
}

func LowestCommonMultiple(_ a: Int64, _ b: Int64) -> Int64
{
    return a * b / GreatestCommonDivisor(a, b)
}

/**
 Provides a list of all natural number divisors of n, including 1 and n itself

 - parameter n: Natural number for which to find divisors

 - returns: A list of integers which are the divisors of n
 */
func Divisors(_ n: Int) -> [Int]
{
    var res: [Int] = [1]
    for i in 2...n {
        if n%i == 0 {
            res.append(i)
        }
    }
    return res
}

/**
 Calculates inverse multiplicative modulo x for a*x ≡ 1   (mod m)

 - parameter a: Natural number for which to find inverse modulo
 - parameter m: Modulo value
 - returns: Inverse modulo or -1 if doesn't exist
 */
func ModInv(_ a: Int64, _ m: Int64) -> Int64
{
    var (t, newT) = (Int64(0), Int64(1))
    var (r, newR) = (m, a)
    while newR != 0
    {
        let q = r / newR
        (t, newT) = (newT, t - q * newT)
        (r, newR) = (newR, r - q * newR)
    }
    if r > 1 {
        return -1
    } else {
        while t < 0 {
            t += m
        }
        return t % m
    }
}

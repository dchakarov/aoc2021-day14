//
//  main.swift
//  No rights reserved.
//

import Foundation
import RegexHelper

func main() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }
    
    var lines = inputString.components(separatedBy: "\n")
        .filter { !$0.isEmpty }

    var template = lines.removeFirst()

    var rules = [String: String]()

    var chars = Set<Character>()

    lines.forEach { line in
        let ar = line.components(separatedBy: " -> ")
        rules[ar[0]] = ar[1]
        chars.insert(Character(ar[1]))
    }

    for _ in 0 ..< 10 {
        template = process(template: template, rules: rules)
    }

    var charCounts = [Character: Int]()
    for char in chars {
        charCounts[char] = template.filter { $0 == char }.count
    }

    let result = charCounts.values.max()! - charCounts.values.min()!
    print(result)
}

func process(template: String, rules: [String: String]) -> String {
    let templateArray = Array(template).map(String.init)

    var newTemplate = [String]()

    for i in 0 ..< templateArray.count - 1 {
        let pair = "\(templateArray[i])\(templateArray[i+1])"
        if let letter = rules[pair] {
            newTemplate.append("\(templateArray[i])\(letter)")
        } else {
            newTemplate.append("\(templateArray[i])")
        }
    }
    newTemplate.append(templateArray.last!)

    return newTemplate.joined(separator: "")
}

func main2() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }

    var lines = inputString.components(separatedBy: "\n")
        .filter { !$0.isEmpty }

    let template = lines.removeFirst()

    var rules = [[String]: String]()

    lines.forEach { line in
        let ar = line.components(separatedBy: " -> ")
        let pair = Array(ar[0]).map(String.init)
        rules[pair] = ar[1]
    }

    var pairs = [[String]: Int]()
    let templateArray = Array(template).map(String.init)
    for i in 0 ..< templateArray.count - 1 {
        let el = [templateArray[i], templateArray[i+1]]
        if pairs.keys.contains(el) {
            pairs[el]! += 1
        } else {
            pairs[el] = 1
        }
    }

    for _ in 0 ..< 40 {
        pairs = process2(pairs: pairs, rules: rules)
    }

    var charCounts = [String: Int]()
    for (pair, count) in pairs {
        if charCounts.keys.contains(pair[0]) {
            charCounts[pair[0]]! += count
        } else {
            charCounts[pair[0]] = count
        }
        if charCounts.keys.contains(pair[1]) {
            charCounts[pair[1]]! += count
        } else {
            charCounts[pair[1]] = count
        }
    }

    var realCharCounts = charCounts.mapValues { $0 / 2 }
    realCharCounts[templateArray.first!]! += 1
    realCharCounts[templateArray.last!]! += 1

    let result = realCharCounts.values.max()! - realCharCounts.values.min()!

    print(result)
}

func process2(pairs: [[String]: Int], rules: [[String]: String]) -> [[String]: Int] {
    var newPairs = pairs
    for pair in pairs.keys {
        let pairCount = pairs[pair]!
        if pairCount > 0, let letter = rules[pair] {
            newPairs[pair]! -= pairCount
            let newPair1 = [pair[0], letter]
            let newPair2 = [letter, pair[1]]

            if newPairs.keys.contains(newPair1) {
                newPairs[newPair1]! += pairCount
            } else {
                newPairs[newPair1] = pairCount
            }
            if newPairs.keys.contains(newPair2) {
                newPairs[newPair2]! += pairCount
            } else {
                newPairs[newPair2] = pairCount
            }
        }
    }
    return newPairs
}

main2()

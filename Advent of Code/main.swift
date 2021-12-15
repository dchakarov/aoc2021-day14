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

main()

import Foundation

func part01() -> Int {
    print("day01")

    let input = try! String(contentsOf: URL(fileURLWithPath: "input/day01"))

    return
        input
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        .components(separatedBy: CharacterSet.newlines)
        .map { Int($0)! }
        .reduce(0, +)
}

enum ProcessError: Error {
    case SearchExhausted
}

func part02() throws -> Int {
    let input = try! String(contentsOf: URL(fileURLWithPath: "input/day01"))
    let frequencyAdjustments =
        input
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        .components(separatedBy: CharacterSet.newlines)
        .map { Int($0)! }

    var frequency = 0
    var valuesSeen = Set<Int>()
    for i in 0...Int.max {
        let adjustment = frequencyAdjustments[i % frequencyAdjustments.count]
        let newFreq = frequency + adjustment
        if valuesSeen.contains(newFreq) {
            return newFreq
        } else {
            valuesSeen.update(with: newFreq)
            frequency = newFreq
        }
    }
    throw ProcessError.SearchExhausted
}

// print(part01())
try! print(part02())

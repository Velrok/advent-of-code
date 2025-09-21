import Foundation

func part01() -> Int {
    print("day02")

    let lines =
        try! String(contentsOf: URL(fileURLWithPath: "input/day02"))
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: .newlines)

    return lines.filter(hasExactly(2)).count * lines.filter(hasExactly(3)).count
}

func hasExactly(_ count: Int) -> ((String) -> Bool) {
    return { word in
        Dictionary(grouping: Array(word)) { $0 }
            .values
            .contains { $0.count == count }
    }
}

func part02() -> Int {
    print("day02")

    let lines =
        try! String(contentsOf: URL(fileURLWithPath: "input/day02"))
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: .newlines)

    print("lines (\(lines.count))")
    var candidates = Set<String>()
    for (idx, l1) in lines.enumerated() {
        for l2 in lines {
            guard l1 != l2 else { continue }
            if missmatchCount(line1: l1, line2: l2) <= 1 {
                candidates.insert(l1)
            }
        }
        print("\(idx + 1) / \(lines.count)")
    }
    print("candidates (\(candidates.count))")
    let candidatesArray = Array(candidates)
    print(candidatesArray[0])
    print(candidatesArray[1])

    // let wordLength = lines.first!.count
    // let wordLength = 4
    // let candidates = lines
    //
    // for prefixLength in 3...wordLength {
    //     print("prefixLength (\(prefixLength))")
    //
    //     let groups = prefixGroup(length: prefixLength, lines: candidates)
    //     let prefixes = groups.keys
    //     print("prefixes (\(prefixes.count)) \(prefixes.sorted())")
    //
    //     var validPrefixes = Set<Substring>()
    //     for p1 in prefixes {
    //         for p2 in prefixes {
    //             guard p1 != p2 else { continue }
    //             if missmatchCount(line1: p1, line2: p2) < 2 {
    //                 validPrefixes.insert(p1)
    //             }
    //         }
    //     }
    //     print("validPrefixes (\(validPrefixes.count)) \(validPrefixes.sorted())")
    // }
    return 0
}

func prefixGroup(length: Int, lines: [String]) -> [Substring: [String]] {
    Dictionary(grouping: lines) { $0.prefix(length) }
}

func missmatchCount(line1: String, line2: String) -> Int {
    zip(Array(line1), Array(line2))
        .filter { $0 != $1 }
        .count
}

print(part02())

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

print(part01())

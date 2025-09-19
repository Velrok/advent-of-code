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
func part02() {}

print(part01())

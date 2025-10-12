import Foundation

func part01() {
    var content = try! String(contentsOfFile: "input/day05")
        .trimmingCharacters(in: .newlines)
    let reactiveUnits = charRange(from: Character("a"), to: Character("z"))
        .flatMap({ char in
            let lower = char.lowercased()
            let upper = char.uppercased()
            return [lower + upper, upper + lower]
        })
    let re = try! Regex(
        "(" + reactiveUnits.joined(separator: "|") + ")"
    )

    var shortened = false
    repeat {
        let before = content.count
        content.replace(re, with: "")
        let after = content.count
        shortened = after < before
        print("shortened: \(shortened) by: \(before - after) [before: \(before), after: \(after)]")
    } while shortened

    dump(content.count)
}

func charRange(from: Character, to: Character) -> [Character] {
    (from.asciiValue!...to.asciiValue!)
        .map({ Character(UnicodeScalar($0)) })
}

part01()

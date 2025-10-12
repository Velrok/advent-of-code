import Foundation

func part01() {
    var input = try! String(contentsOfFile: "input/day05")
        .trimmingCharacters(in: .newlines)

    let reactivePairs = charRange(from: Character("a"), to: Character("z"))
        .flatMap({ char in
            let lower = Character(char.lowercased())
            let upper = Character(char.uppercased())
            return [(lower, upper), (upper, lower)]
        })

    let reactiveLookup =
        Dictionary(
            uniqueKeysWithValues:
                reactivePairs
                .map({
                    ($0.0, $0.1)
                }))

    dump(
        buildPolymer(input, reactiveLookup)
            .count
    )
}

func buildPolymer(_ input: String, _ reactiveLookup: [Character: Character]) -> String {
    var polymer = [Character]()
    for c in input {
        guard let tail = polymer.last else {
            polymer.append(c)
            continue
        }
        if reactiveLookup[c] == tail {
            polymer.removeLast()
        } else {
            polymer.append(c)
        }
    }
    return String(polymer)
}

func charRange(from: Character, to: Character) -> [Character] {
    (from.asciiValue!...to.asciiValue!)
        .map({ Character(UnicodeScalar($0)) })
}

part01()

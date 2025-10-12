import Foundation

func part01() {
    let input = try! String(contentsOfFile: "input/day05")
        .trimmingCharacters(in: .newlines)

    let reactiveLookup = buildReactiveLookup(
        alphabet: charRange(from: Character("a"), to: Character("z")))

    dump(
        buildPolymer(input, reactiveLookup)
            .count
    )
}

func buildReactiveLookup(alphabet: [Character]) -> [Character: Character] {
    let reactivePairs =
        alphabet
        .flatMap({ char in
            let lower = Character(char.lowercased())
            let upper = Character(char.uppercased())
            return [(lower, upper), (upper, lower)]
        })

    return Dictionary(
        uniqueKeysWithValues:
            reactivePairs
            .map({
                ($0.0, $0.1)
            }))

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

func part02() {
    let input = try! String(contentsOfFile: "input/day05")
        .trimmingCharacters(in: .newlines)
    // let input = "dabAcCaCBAcCcaDA"

    let aToZ = charRange(from: Character("a"), to: Character("z"))
    let reactiveLookup = buildReactiveLookup(alphabet: aToZ)

    let polymers = aToZ.map({ letter in
        let excluded = Set([letter, Character(letter.uppercased())])
        let input = input.filter({ !excluded.contains($0) })
        // dump(input)

        return buildPolymer(input, reactiveLookup)
    })

    // dump(polymers)
    let polymerLengths = polymers.map({ $0.count })
    dump(polymerLengths.min())
}

part02()

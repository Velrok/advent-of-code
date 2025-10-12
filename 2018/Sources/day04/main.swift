import Foundation

struct Guard {
    let id: String
    var sleepTimes: [ClosedRange<Int>]
}

func parseMinutes(_ line: String.SubSequence) -> Int {
    let minutesRe = /00:(\d\d)]/
    let (_, minutes) =
        line
        .firstMatch(of: minutesRe)!
        .output
    return Int(minutes)!
}

func part01() {
    let content = try! String(contentsOfFile: "input/day04.sorted")
    let lines =
        content
        .split(separator: "\n")
        .sorted()[0...7]
    // print(lines[0...7])

    var guards: [String: Guard] = [:]

    var currentGuard: String? = nil
    var asleepAt: Int? = nil

    for line in lines {
        if line.contains("begins shift") {
            let (_, guardId) =
                line
                .firstMatch(of: /Guard #(\d+) begins shift/)!
                .output

            fatalError("BUG:: need to cheeck for existing guard before creating new.")
            currentGuard = String(guardId)
            let newGuard = Guard(id: currentGuard!, sleepTimes: [])

            #if DEBUG
                print(line)
                print("-> new guard")
                dump(newGuard)
            #endif

            guards[currentGuard!] = newGuard

        } else if line.contains("falls asleep") {
            guard currentGuard != nil else {
                fatalError("No guard!")
            }
            asleepAt = parseMinutes(line)
            #if DEBUG
                print(line)
                print("-> guard \(currentGuard) falls asleep at \(asleepAt)")
            #endif
        } else if line.contains("wakes up") {
            guard currentGuard != nil else { fatalError("No guard!") }

            let wakeupAt = parseMinutes(line)

            guard asleepAt != nil, asleepAt! < wakeupAt else {
                fatalError("asleepAt: \(asleepAt) was invalid compared to wakeupAt: \(wakeupAt)")
            }

            var g = guards[currentGuard!]!
            let duration = (asleepAt!...wakeupAt)

            g.sleepTimes.append(duration)

            #if DEBUG
                print(line)
                print("-> guard \(currentGuard) duration \(duration)")
            #endif

            guards[currentGuard!] = g

        } else {
            fatalError("Unknown instruction: \(line)")
        }

    }

    dump(guards)

    // [1518-04-21 00:04] Guard #3331 begins shift
    // [1518-09-03 00:12] falls asleep
    // [1518-04-21 00:57] wakes up

}

part01()

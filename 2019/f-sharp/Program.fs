open System.IO

let input = File.ReadAllText "inputs/day01.txt"

printfn "Part 1: %d" (Day01.part1 input)
printfn "Part 2: %d" (Day01.part2 input)

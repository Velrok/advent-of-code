module Day01

let mass_to_fuel (mass: int) : int = (mass / 3) - 2

let part1 (input: string) : int =
    let something =
        input.Split("\n") |> Array.map int |> Array.map mass_to_fuel |> Array.reduce sum

    failwith "TODO"


let part2 (input: string) : int = failwith "TODO"

module Day01

let massToFuel (mass: int) : int = (mass / 3) - 2

let part1 (input: string) : int =
    input.Trim().Split("\n") |> Array.map int |> Array.map massToFuel |>
        Array.sum


let part2 (input: string) : int = failwith "TODO"

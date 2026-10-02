module Day01

let massToFuel (mass: int) : int = mass / 3 - 2

let parseLines (input: string) : int array =
    input.Trim().Split("\n") |> Array.map int


let part1 (input: string) : int =
    parseLines input |> Array.map massToFuel |> Array.sum

let rec rocketEq (fuel: int) (mass: int) : int =
    let massF = massToFuel mass
    if massF <= 0 then fuel else rocketEq (fuel + massF) massF

let part2 (input: string) : int =
    parseLines input |> Array.map (rocketEq 0) |> Array.sum

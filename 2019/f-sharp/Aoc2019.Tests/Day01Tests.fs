module Day01Tests

open Xunit

[<Theory>]
[<InlineData(12, 2)>]
[<InlineData(14, 2)>]
[<InlineData(1969, 654)>]
[<InlineData(100756, 33583)>]
let ``massToFuel matches part 1 examples`` (mass: int, expected: int) =
    Assert.Equal(expected, Day01.massToFuel mass)

[<Theory>]
[<InlineData(14, 2)>]
[<InlineData(1969, 966)>]
[<InlineData(100756, 50346)>]
let ``rocketEq matches part 2 examples`` (mass: int, expected: int) =
    Assert.Equal(expected, Day01.rocketEq 0 mass)

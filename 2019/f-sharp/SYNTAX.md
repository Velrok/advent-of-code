# F# Syntax Cheat Sheet

Running reference – entries are added when I ask for syntax help.

## Project

- **Compile order matters**: files in `.fsproj` compile top to bottom
  ```xml
  <Compile Include="Day01.fs" />
  <Compile Include="Program.fs" />  <!-- always last -->
  ```

## Pattern matching

- Discriminated union + `match` ≈ Rust `enum` + `match`
  ```fsharp
  type Shape =
      | Circle of float
      | Rect of float * float

  let area s =
      match s with
      | Circle r -> 3.14 * r * r
      | Rect (w, h) -> w * h
  ```

## Reading type signatures

- `val inline failwith: message: string -> 'T` – how to read it
  - `val` = a value/function binding
  - `inline` = body is copied to each call site (no call overhead)
  - `message: string` = parameter name (just a label) and type
  - `->` = "returns"
  - `'T` = generic type variable; caller decides, so it fits anywhere
  ```fsharp
  let x: int = failwith "boom"      // 'T = int
  let s: string = failwith "boom"   // 'T = string
  ```
- Curried: `a -> b -> c` = takes `a`, returns a function `b -> c`
- Rust equivalent: `panic!` returns `!` (coerces to any type)

## Exceptions

- `failwith msg` raises a generic `Exception` with `msg` (≈ Rust `panic!`)
- `invalidArg`, `raise (MyExn ...)` for more specific errors

## Strings

- Split by newline: .NET `String.Split`, returns `string[]`
  ```fsharp
  let lines = text.Split('\n')
  let clean = text.Split([| '\r'; '\n' |], System.StringSplitOptions.RemoveEmptyEntries)
  let viaPipe = text |> fun t -> t.Split('\n')
  ```
- Whole file as lines: `System.IO.File.ReadAllLines "path"` (handles `\r\n`)
- Rust: `text.lines()`

## Collections: List vs array

- `List` = immutable singly linked list; `[1; 2; 3]`; Rust ≈ none (closest: persistent linked list)
- `array` = mutable fixed-size contiguous block (.NET `T[]`); `[| 1; 2; 3 |]`; Rust ≈ `Vec<T>`/`[T; N]`
  ```fsharp
  let xs = 0 :: [1; 2]      // list cons: O(1) prepend
  let arr = [| 1; 2; 3 |]
  arr.[0] <- 9              // in-place mutation, O(1) index
  let y = arr.[1]           // list: List.item 1 xs is O(n)
  ```
- Same module API for both: `List.map` / `Array.map`, `List.sum` / `Array.sum`, ...
- Convert: `List.toArray`, `Array.toList`, `Seq.toList`

## Pipes

- `|>` feeds the left value into the right function
  ```fsharp
  [1; 2; 3] |> List.map (fun x -> x * 2) |> List.sum
  ```

## Parsing

- String → int: `int` (throws on bad input) or `Int32.TryParse` (safe)
  ```fsharp
  let n = int "42"                          // FormatException if invalid
  let n2 = System.Int32.Parse "42"          // same, explicit .NET
  match System.Int32.TryParse "42" with     // tuple return: (ok, value)
  | true, v -> Some v
  | false, _ -> None
  ```
- Other types work the same way: `int64 "42"`, `float "1.5"`, `Int64.TryParse`
- Rust: `"42".parse::<i32>()` → `Result`

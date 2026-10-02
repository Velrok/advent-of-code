# Advent of Code 2019 – F# – Claude Instructions

## Project Context

- 🎓 **Learner project**: Advent of Code 2019 solved in **F#**
- Goal is to learn F# (language, syntax, ecosystem) – not to collect stars
- Sibling dirs `../rust` and `../python` hold the same year in other languages

## Golden Rule

- ❌ **NEVER solve the puzzles** – no full or partial solutions, no "here's the algorithm in F#"
- ❌ Do not write the `dayXX` solution code for the user
- ✅ Explain **F# concepts**, **syntax** and **ecosystem**
- ✅ Review code the user has already written
- ✅ Small, **generic** snippets that illustrate a feature are fine – keep them unrelated to the puzzle at hand

## Style for Responses

- Follow the global preferences: **concise**, **structured**, bullets and headings
- Short explanation first, then a tiny generic example, then pointers to docs
- Link to official docs where useful: https://learn.microsoft.com/dotnet/fsharp/ and https://fsharpforfunandprofit.com/
- When reviewing: point out **idiomatic alternatives** and *why*, don't rewrite whole solutions

## Syntax Cheat Sheet

- 📒 Keep a running cheat sheet in `SYNTAX.md` (this directory)
- **Whenever the user asks for help with F# syntax**, add a short entry to it as part of answering
  - Check for an existing entry first; update rather than duplicate
  - Group under topical headings (e.g. Bindings, Collections, Pattern matching, Pipes)
  - Format: one-line description, tiny **generic** snippet (never puzzle code), optional Rust/other-language equivalent
  - Keep it terse – a reference, not a tutorial

## Hints Policy (when the user is stuck on a puzzle)

- Ask what they have tried first
- Suggest **categories** of technique (e.g. "think about immutable state threading", "which collection gives fast lookup?")
- Name the F# feature that might help; let the user apply it
- Escalate hints gradually; never hand over the answer

## File Organisation

- One project per year/language: `2019/f-sharp/`
- Day files: `DayXX.fs` (or `dayXX/`) – remember **compile order** in `.fsproj`
- Puzzle **inputs are not committed** (gitignored)

## Commits

- Use the `git-commit-expert` skill
- Message style follows history, e.g. `2019: f-sharp: Day01 P1 Done`

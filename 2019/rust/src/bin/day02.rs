use anyhow::Context;
use anyhow::Result;
use aoc19::intcode::*;
use itertools::Itertools;

fn main() -> Result<()> {
    let prog = Program::from_file(std::path::Path::new("inputs/day02.txt"))?;
    let result = prog.clone().exec_without_io(Some(12), Some(2))?;
    println!("P1: {result}");

    let mut haystack = (0..100).cartesian_product(0..100);
    let needle = 19690720;
    let result = haystack
        .find_map(|(noun, verb)| {
            (prog.clone().exec_without_io(Some(noun), Some(verb)).ok() == Some(needle))
                .then_some(noun * 100 + verb)
        })
        .context("None of the noun/verb pairs found the expected result.")?;
    println!("P2: {result}");

    Ok(())
}

use anyhow::Context;
use anyhow::Result;
use aoc19::intcode::*;
use itertools::Itertools;
use rayon::*;
use std::fs;

fn main() -> Result<()> {
    let prog = read_program("inputs/day02.txt")?;
    let result = prog.clone().exec_without_io(Some(12), Some(2));
    println!("P1: {result}");

    let mut haystack = (0..100).cartesian_product(0..100);
    let needle = 19690720;
    let result = haystack
        .find_map(|(noun, verb)| {
            (prog.clone().exec_without_io(Some(noun), Some(verb)) == needle).then_some(noun * 100 + verb)
        })
        .context("None of the noun/verb pairs found the expected result.")?;
    println!("P2: {result}");

    Ok(())
}

fn read_program(filename: &str) -> Result<Program> {
    let data: Vec<i32> = fs::read_to_string(filename)?
        .trim_end()
        .split(',')
        .map(|c| c.parse::<i32>().expect("Program is made up of integers."))
        .collect();
    Ok(Program::new(&data))
}

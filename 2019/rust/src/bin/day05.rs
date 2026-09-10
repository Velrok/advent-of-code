use anyhow::Result;
use aoc19::intcode::Program;

fn main() -> Result<()> {
    let prog = read_program("inputs/day05.txt")?;
    prog.clone()
        .exec_without_verb_noun(&[1], &mut std::io::stdout());
    Ok(())
}

fn read_program(filename: &str) -> Result<Program> {
    let data: Vec<i32> = std::fs::read_to_string(filename)?
        .trim_end()
        .split(',')
        .map(|c| c.parse::<i32>().expect("Program is made up of integers."))
        .collect();
    Ok(Program::new(&data))
}

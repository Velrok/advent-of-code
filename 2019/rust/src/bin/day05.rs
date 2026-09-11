use anyhow::Result;
use aoc19::intcode::Program;

fn main() -> Result<()> {
    let prog = Program::from_file(std::path::Path::new("inputs/day05.txt"))?;
    println!("part 1:");
    let mut output = vec![];
    prog.clone().exec_without_verb_noun(&[1], &mut output);

    println!("part 2:");
    let mut output = vec![];
    prog.clone().exec_without_verb_noun(&[5], &mut output);
    Ok(())
}

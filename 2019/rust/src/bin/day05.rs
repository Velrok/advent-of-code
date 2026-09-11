use anyhow::Result;
use aoc19::intcode::Program;

fn main() -> Result<()> {
    let prog = Program::from_file(std::path::Path::new("inputs/day05.txt"))?;
    println!("part 1:");
    prog.clone()
        .exec_without_verb_noun(&[1], &mut std::io::stdout());
    println!("part 2:");
    prog.clone()
        .exec_without_verb_noun(&[5], &mut std::io::stdout());
    Ok(())
}

use anyhow::Result;
use aoc19::intcode::Program;

fn main() -> Result<()> {
    let prog = Program::from_file(std::path::Path::new("inputs/day05.txt"))?;

    println!("part 1:");
    let mut part1 = prog.clone();
    part1.feed_input(1);
    part1.exec_without_verb_noun()?;
    while let Some(val) = part1.read_output() {
        println!("{val}");
    }

    println!("part 2:");
    let mut part2 = prog.clone();
    part2.feed_input(5);
    part2.exec_without_verb_noun()?;
    while let Some(val) = part2.read_output() {
        println!("{val}");
    }
    Ok(())
}

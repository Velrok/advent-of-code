use anyhow::Result;
use aoc19::intcode::Program;
use std::{fs, io::Read};

fn main() -> Result<()> {
    let args: Vec<_> = std::env::args().collect();
    let mut program = match args.get(1) {
        None => anyhow::bail!("Expected one arg to be valid program file"),
        Some(filename) => {
            let program_path = std::path::Path::new(filename);
            Program::from_file(program_path)?
        }
    };

    let mut input_buf = Vec::new();
    std::io::stdin()
        .read_to_end(&mut input_buf)
        .expect("Expected to be able to read STDIN fully.");
    let inputs: Vec<_> = String::from_utf8(input_buf)
        .expect("Expected input to be utf8 compatible.")
        .trim()
        .split([',', ' ', '\n'])
        .filter(|s| !s.is_empty())
        .map(|s| s.parse::<i32>().expect("Inputs to be i32 numbers."))
        .collect();

    for input in inputs {
        program.feed_input(input);
    }

    let noun = args.get(2).and_then(|n| n.parse().ok());
    let verb = args.get(3).and_then(|n| n.parse().ok());

    let exec_result = program.exec(noun, verb)?;
    while let Some(out) = program.read_output() {
        eprintln!("{out}");
    }
    println!("{exec_result}");

    Ok(())
}

use anyhow::Result;
use aoc19::intcode::Program;
use std::{
    fs::File,
    io::{BufReader, BufWriter, Read, Write},
    path::Path,
};

enum Commands {
    Run,
    Decompile,
}

fn main() -> Result<()> {
    let args: Vec<String> = std::env::args().collect();
    match args.get(1) {
        None => print_help(),
        Some(cmd_str) => {
            let cmd = match cmd_str.as_str() {
                "run" => Commands::Run,
                _ => anyhow::bail!("Unknown command: {cmd_str}"),
            };
            let cmd_args = &args[2..];
            match cmd {
                Commands::Run => execute(cmd_args)?,
                Commands::Decompile => decompile(cmd_args)?,
            }
        }
    };
    Ok(())
}

fn decompile(cmd_args: &[String]) -> Result<()> {
    match cmd_args.first() {
        None => anyhow::bail!("decompile needs a file to read"),
        Some(input_path_str) => {
            let output_path_str = cmd_args.get(1);
            let mut writer: Box<dyn Write> = match output_path_str {
                Some(out_dest) => {
                    let file = File::create(std::path::Path::new(out_dest))
                        .expect("Cant open dest_file for writting!");
                    Box::new(BufWriter::new(file))
                }
                None => Box::new(std::io::stdout()),
            };

            let input_path = Path::new(input_path_str);

            let file = File::open(input_path);
            let ints = BufReader::new(file?).split(b',').map(|bytes| {
                str::from_utf8(bytes)
                    .expect("Expected UTF8 encoding")
                    .parse::<i64>()
                    .expect("Expected to only see i64 numbers.");
            });

            // we can tokenize by ,
            // then read the int as an op type
            // should be able to reuse fn read_instruction(&self) -> Instruction after some refactor to take
            // an opcode: Word and some mem slice *[Word]
            // now might be the time to give Instruction a width we know how many to read
            // we can do this in a loop until we get to the end of the tokens
            // we shoudl end up with a [Instrction]
            // we can then map a translator Instrction -> String
            // and finally print to the writer one line per Instruction
            todo!()
        }
    }
}

fn print_help() {
    println!("Todo: help page")
}

fn execute(args: &[String]) -> Result<()> {
    let mut program = match args.first() {
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
        .map(|s| s.parse::<i64>().expect("Inputs to be i64 numbers."))
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

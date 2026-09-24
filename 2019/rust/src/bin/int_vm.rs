use anyhow::Context;
use anyhow::Result;
use aoc19::intcode::Instruction;
use aoc19::intcode::Program;
use aoc19::intcode::Word;
use itertools::Itertools;
use std::{
    fs::File,
    io::{BufRead, BufReader, BufWriter, Read, Write},
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
                "decomp" => Commands::Decompile,
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
            let reader = BufReader::new(file?);
            let prog_code = reader.split(b',').map(|bytes| {
                let binding = bytes.unwrap();
                let s = str::from_utf8(&binding).expect("Expected UTF8 encoding");
                s.trim()
                    .parse::<i64>()
                    .with_context(|| format!("expected i64, got {s:?}"))
                    .unwrap()
            });

            let instructions: Vec<(usize, Instruction)> = prog_code
                .enumerate()
                .batching(|it| match it.next() {
                    Some((idx, op)) => {
                        let len = aoc19::intcode::instruction_width(op);
                        let following_mem: Vec<Word> =
                            it.take(len - 1).map(|(_, mem)| mem).collect();
                        Some((idx, Program::parse_instruction(op, &following_mem)))
                    }
                    None => None,
                })
                .collect();
            for (idx, instruction) in instructions {
                let line = match instruction {
                    Instruction::Add(param1, param2, addr) => {
                        let p1 = decomp_read_param(param1);
                        let p2 = decomp_read_param(param2);
                        let addr = decomp_write_param(addr);
                        format!("ADD {p1} {p2} -> {addr}")
                    }
                    Instruction::Mult(param1, param2, addr) => {
                        let p1 = decomp_read_param(param1);
                        let p2 = decomp_read_param(param2);
                        let addr = decomp_write_param(addr);
                        format!("MULT {p1} {p2} -> {addr}")
                    }
                    Instruction::Input(parameter) => {
                        let p = decomp_write_param(parameter);
                        format!("READ {p}")
                    }
                    Instruction::Output(parameter) => {
                        let p = decomp_read_param(parameter);
                        format!("WRITE {p}")
                    }
                    Instruction::JumpIfTrue(condition, target) => {
                        let p = decomp_read_param(condition);
                        let addr = decomp_read_param(target);
                        format!("JUMP_IF_TRUE {p} -> {addr}")
                    }
                    Instruction::JumpIfFalse(condition, target) => {
                        let p = decomp_read_param(condition);
                        let addr = decomp_read_param(target);
                        format!("JUMP_IF_FALSE {p} -> {addr}")
                    }
                    Instruction::LessThen(param1, param2, addr) => {
                        let p1 = decomp_read_param(param1);
                        let p2 = decomp_read_param(param2);
                        let addr = decomp_write_param(addr);
                        format!("LESS_THEN {p1} {p2} -> {addr}")
                    }
                    Instruction::Equals(param1, param2, addr) => {
                        let p1 = decomp_read_param(param1);
                        let p2 = decomp_read_param(param2);
                        let addr = decomp_write_param(addr);
                        format!("EQUALS {p1} {p2} -> {addr}")
                    }
                    Instruction::AdjustRelativeBase(parameter) => {
                        let p = decomp_read_param(parameter);
                        format!("REL_BASE {p}")
                    }
                    Instruction::End => "END".to_string(),
                };
                writer
                    .write_all(format!("{idx:04}: {line}\n").as_bytes())
                    .unwrap();
            }
            Ok(())
        }
    }
}

fn decomp_read_param(param: aoc19::intcode::ReadParameter) -> String {
    match param {
        aoc19::intcode::ReadParameter::Relative(p) => format!("@[{p}]"),
        aoc19::intcode::ReadParameter::Position(p) => format!("@{p}"),
        aoc19::intcode::ReadParameter::Immediate(direct_val) => format!("{direct_val}"),
    }
}

fn decomp_write_param(param: aoc19::intcode::WriteParameter) -> String {
    match param {
        aoc19::intcode::WriteParameter::Relative(p) => format!("@[{p}]"),
        aoc19::intcode::WriteParameter::Position(p) => format!("@{p}"),
    }
}

fn print_help() {
    println!(
        "intcode-vm - run or decompile Intcode programs

USAGE:
    intcode-vm <COMMAND> [ARGS]

COMMANDS:
    run <program_file> [noun] [verb]
        Execute a program, feeding it stdin as comma/space/newline separated
        inputs. Outputs are printed to stderr as they're produced, the final
        memory value at address 0 is printed to stdout.

    decomp <program_file> [output_file]
        Decompile a program into a human-readable instruction listing.
        Writes to stdout, or to output_file if given.

    (no command)
        Print this help page."
    )
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

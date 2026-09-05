use anyhow::Result;
use std::fs;

type Address = usize;

#[derive(Clone)]
struct Program {
    memory: Vec<i32>,
    instruction_pointer: Address,
}

enum Instruction {
    Add(Address, Address, Address),
    Mult(Address, Address, Address),
    End,
}

impl Program {
    fn new(data: Vec<i32>) -> Self {
        Self {
            memory: data,
            instruction_pointer: 0,
        }
    }

    fn exec(&mut self) -> i32 {
        loop {
            let op = self.read_instruction();
            match op {
                Instruction::Add(p1, p2, target) => {
                    let x = self.memory[p1];
                    let y = self.memory[p2];
                    self.memory[target] = x + y;
                    self.instruction_pointer += 4
                }
                Instruction::Mult(p1, p2, target) => {
                    let x = self.memory[p1];
                    let y = self.memory[p2];
                    self.memory[target] = x * y;
                    self.instruction_pointer += 4
                }
                Instruction::End => return self.memory[0],
            }
        }
    }

    fn read_instruction(&self) -> Instruction {
        match self.memory[self.instruction_pointer] {
            1 => Instruction::Add(
                self.memory[self.instruction_pointer + 1] as usize,
                self.memory[self.instruction_pointer + 2] as usize,
                self.memory[self.instruction_pointer + 3] as usize,
            ),
            2 => Instruction::Mult(
                self.memory[self.instruction_pointer + 1] as usize,
                self.memory[self.instruction_pointer + 2] as usize,
                self.memory[self.instruction_pointer + 3] as usize,
            ),
            99 => Instruction::End,
            _ => panic!("Invalid instruction number."),
        }
    }
}

fn main() -> Result<()> {
    let prog = read_program("inputs/day02.txt")?;
    let result = run_modified(12, 2, prog.clone());
    println!("P1: {result}");

    'outer: for noun in 1..100 {
        for verb in 1..100 {
            let result = run_modified(noun, verb, prog.clone());
            if result == 19690720 {
                let out = noun * 100 + verb;
                println!("P2: {out}");
                break 'outer;
            }
        }
    }

    Ok(())
}

fn read_program(filename: &str) -> Result<Program> {
    let data = fs::read_to_string(filename)?
        .trim_end()
        .split(',')
        .map(|c| c.parse::<i32>().expect("Program is made up of integers."))
        .collect();
    Ok(Program::new(data))
}

fn run_modified(noun: i32, verb: i32, mut program: Program) -> i32 {
    program.memory[1] = noun;
    program.memory[2] = verb;

    program.exec()
}

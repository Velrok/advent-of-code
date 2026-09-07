type Address = usize;

#[derive(Clone)]
pub struct Program {
    memory: Vec<i32>,
    instruction_pointer: Address,
}

enum Instruction {
    Add(Address, Address, Address),
    Mult(Address, Address, Address),
    End,
}

impl Program {
    pub fn new(data: Vec<i32>) -> Self {
        Self {
            memory: data,
            instruction_pointer: 0,
        }
    }

    pub fn exec(&mut self, noun: i32, verb: i32) -> i32 {
        self.memory[1] = noun;
        self.memory[2] = verb;
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
            _ => unreachable!("We are only fed valid programs."),
        }
    }
}

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
    pub fn new(data: &[i32]) -> Self {
        Self {
            memory: data.to_vec(),
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

#[cfg(test)]
mod tests {
    use super::*;

    const ADD: i32 = 1;
    const MULT: i32 = 2;
    const END: i32 = 99;

    const SIMPLE_ADD_PROG: [i32; 7] = [ADD, 5, 6, 0, END, 2, 3];
    const SIMPLE_MULT_PROG: [i32; 7] = [MULT, 5, 6, 0, END, 2, 3];

    #[test]
    fn test_add_pos_mode() {
        assert_eq!(Program::new(&SIMPLE_ADD_PROG).exec(5, 6), 5);
    }

    #[test]
    fn test_mult_pos_mode() {
        assert_eq!(Program::new(&SIMPLE_MULT_PROG).exec(5, 6), 6);
    }
}

type Address = usize;

enum Parameter {
    Position(Address),
    Immediate(i32),
}

#[derive(Clone)]
pub struct Program {
    memory: Vec<i32>,
    instruction_pointer: Address,
}

enum Instruction {
    Add(Parameter, Parameter, Address),
    Mult(Parameter, Parameter, Address),
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
                    let x = self.param_value(p1);
                    let y = self.param_value(p2);
                    self.memory[target] = x + y;
                    self.instruction_pointer += 4
                }
                Instruction::Mult(p1, p2, target) => {
                    let x = self.param_value(p1);
                    let y = self.param_value(p2);
                    self.memory[target] = x * y;
                    self.instruction_pointer += 4
                }
                Instruction::End => return self.memory[0],
            }
        }
    }

    fn param_value(&self, param: Parameter) -> i32 {
        match param {
            Parameter::Position(addr) => self.memory[addr],
            Parameter::Immediate(val) => val,
        }
    }

    fn read_instruction(&self) -> Instruction {
        let op_code = self.memory[self.instruction_pointer] % 100;
        let mods = self.memory[self.instruction_pointer] / 100;
        match op_code {
            1 => Instruction::Add(
                Parameter::Position(self.memory[self.instruction_pointer + 1] as usize),
                Parameter::Position(self.memory[self.instruction_pointer + 2] as usize),
                self.memory[self.instruction_pointer + 3] as usize,
            ),
            2 => Instruction::Mult(
                Parameter::Position(self.memory[self.instruction_pointer + 1] as usize),
                Parameter::Position(self.memory[self.instruction_pointer + 2] as usize),
                self.memory[self.instruction_pointer + 3] as usize,
            ),
            99 => Instruction::End,
            _ => unreachable!("We are only fed valid programs."),
        }
    }

    fn parse_param(&self, mods: i32, param_pos: u32) -> Parameter {
        
        match (mods / 10i32.pow(param_pos)) % 10 {
            0 => Parameter::Position()
            1 => Parameter::Immediate(self.memory[self.instruction_pointer + param_pos])
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const ADD: i32 = 1;
    const MULT: i32 = 2;
    const END: i32 = 99;

    const ADD_PROG: [i32; 7] = [ADD, 5, 6, 0, END, 2, 3];
    const MULT_PROG: [i32; 7] = [MULT, 5, 6, 0, END, 2, 3];

    #[test]
    fn test_add_pos_mode() {
        assert_eq!(Program::new(&ADD_PROG).exec(5, 6), 5);
    }

    #[test]
    fn test_mult_pos_mode() {
        assert_eq!(Program::new(&MULT_PROG).exec(5, 6), 6);
    }

    // Immediate mode
    const P1_IMMEDIATE: i32 = 100;
    const P2_IMMEDIATE: i32 = 1000;
    const P3_IMMEDIATE: i32 = 10000;
    const ADD_PROG_IMMEDIAT_MODE: [i32; 5] = [ADD + P1_IMMEDIATE + P2_IMMEDIATE, 5, 6, 0, END];

    #[test]
    fn test_add_immediate_mode() {
        assert_eq!(Program::new(&ADD_PROG_IMMEDIAT_MODE).exec(5, 6), 11,);
    }
}

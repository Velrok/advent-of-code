type Address = usize;

enum Parameter {
    Position(Address),
    Immediate(i32),
}

enum Instruction {
    Add(Parameter, Parameter, Address),
    Mult(Parameter, Parameter, Address),
    Input(Address),
    Output(Address),
    JumpIfTrue(Parameter, Parameter),
    JumpIfFalse(Parameter, Parameter),
    LessThen(Parameter, Parameter, Address),
    Equals(Parameter, Parameter, Address),
    End,
}

#[derive(Clone)]
pub struct Program {
    memory: Vec<i32>,
    instruction_pointer: Address,
}

impl Program {
    pub fn new(data: &[i32]) -> Self {
        Self {
            memory: data.to_vec(),
            instruction_pointer: 0,
        }
    }

    pub fn exec_without_io(&mut self, noun: Option<i32>, verb: Option<i32>) -> i32 {
        self.exec(noun, verb, &[], &mut vec![])
    }

    pub fn exec_without_verb_noun(
        &mut self,
        inputs: &[i32],
        output: &mut impl std::io::Write,
    ) -> i32 {
        self.exec(None, None, inputs, output)
    }

    pub fn exec(
        &mut self,
        noun: Option<i32>,
        verb: Option<i32>,
        inputs: &[i32],
        output: &mut impl std::io::Write,
    ) -> i32 {
        if let Some(val) = noun {
            self.memory[1] = val
        };
        if let Some(val) = verb {
            self.memory[2] = val
        };

        let mut inputs_iter = inputs.iter();

        loop {
            let op = self.read_instruction();
            match op {
                Instruction::Add(p1, p2, target) => {
                    let x = self.param_value(p1);
                    let y = self.param_value(p2);
                    self.memory[target] = x + y;
                    self.instruction_pointer += 4
                }
                Instruction::Mult(p1, p2, target_addr) => {
                    let x = self.param_value(p1);
                    let y = self.param_value(p2);
                    self.memory[target_addr] = x * y;
                    self.instruction_pointer += 4
                }
                Instruction::End => return self.memory[0],
                Instruction::Input(target_addr) => {
                    self.memory[target_addr] = *inputs_iter
                        .next()
                        .expect("Expected another input, gone none.");
                    self.instruction_pointer += 2;
                }
                Instruction::Output(read_addr) => {
                    let val = self.memory[read_addr];
                    self.instruction_pointer += 2;
                    writeln!(output, "{val}").expect("Expected valid output buffer.");
                }
                Instruction::JumpIfTrue(param1, param2) => {
                    if self.param_value(param1) > 0 {
                        self.instruction_pointer = self.param_value(param2) as usize;
                    } else {
                        self.instruction_pointer += 3;
                    }
                }
                Instruction::JumpIfFalse(param1, param2) => {
                    if self.param_value(param1) == 0 {
                        self.instruction_pointer = self.param_value(param2) as usize;
                    } else {
                        self.instruction_pointer += 3;
                    }
                }
                Instruction::LessThen(param1, param2, _) => todo!(),
                Instruction::Equals(param1, param2, _) => todo!(),
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
        match op_code {
            1 => Instruction::Add(
                self.read_param(1),
                self.read_param(2),
                self.memory[self.instruction_pointer + 3] as usize,
            ),
            2 => Instruction::Mult(
                self.read_param(1),
                self.read_param(2),
                self.memory[self.instruction_pointer + 3] as usize,
            ),
            3 => Instruction::Input(self.memory[self.instruction_pointer + 1] as usize),
            4 => Instruction::Output(self.memory[self.instruction_pointer + 1] as usize),
            5 => Instruction::JumpIfTrue(self.read_param(1), self.read_param(2)),
            6 => Instruction::JumpIfFalse(self.read_param(1), self.read_param(2)),
            7 => Instruction::LessThen(
                self.read_param(1),
                self.read_param(2),
                self.memory[self.instruction_pointer + 3] as usize,
            ),
            8 => Instruction::Equals(
                self.read_param(1),
                self.read_param(2),
                self.memory[self.instruction_pointer + 3] as usize,
            ),
            99 => Instruction::End,
            _ => unreachable!("We are only fed valid programs."),
        }
    }

    fn read_param(&self, number: u32) -> Parameter {
        let modifier = (self.memory[self.instruction_pointer] / 10i32.pow(1 + number)) % 10;
        match modifier {
            0 => Parameter::Position(
                self.memory[self.instruction_pointer + number as usize] as usize,
            ),
            1 => Parameter::Immediate(self.memory[self.instruction_pointer + number as usize]),
            _ => unreachable!("We are only fed valid programs."),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const ADD: i32 = 1;
    const MULT: i32 = 2;
    const INP: i32 = 3;
    const OUTP: i32 = 4;
    const JUMP_T: i32 = 5;
    const JUMP_F: i32 = 6;
    const END: i32 = 99;

    const ADD_PROG: [i32; 7] = [ADD, 5, 6, 0, END, 2, 3];
    const MULT_PROG: [i32; 7] = [MULT, 5, 6, 0, END, 2, 3];

    #[test]
    fn test_add_pos_mode() {
        assert_eq!(Program::new(&ADD_PROG).exec_without_io(Some(5), Some(6)), 5);
    }

    #[test]
    fn test_mult_pos_mode() {
        assert_eq!(
            Program::new(&MULT_PROG).exec_without_io(Some(5), Some(6)),
            6
        );
    }

    // Immediate mode
    const P1_IMMEDIATE: i32 = 100;
    const P2_IMMEDIATE: i32 = 1000;
    const ADD_PROG_IMMEDIAT_MODE: [i32; 5] = [ADD + P1_IMMEDIATE + P2_IMMEDIATE, 5, 6, 0, END];
    const MULT_PROG_IMMEDIAT_MODE: [i32; 5] = [MULT + P1_IMMEDIATE + P2_IMMEDIATE, 5, 6, 0, END];

    #[test]
    fn test_add_immediate_mode() {
        assert_eq!(
            Program::new(&ADD_PROG_IMMEDIAT_MODE).exec_without_io(Some(5), Some(6)),
            11
        );
    }

    #[test]
    fn test_mult_immediate_mode() {
        assert_eq!(
            Program::new(&MULT_PROG_IMMEDIAT_MODE).exec_without_io(Some(5), Some(6)),
            30
        );
    }

    const IO_PROG: [i32; 6] = [INP, 5, OUTP, 5, END, -2];

    #[test]
    fn test_io() {
        let mut output = Vec::new();
        Program::new(&IO_PROG).exec_without_verb_noun(&[7], &mut output);
        assert_eq!(String::from_utf8(output).unwrap(), "7\n");
    }

    #[test]
    fn test_jump_if_true() {
        let prog = [
            JUMP_T + P1_IMMEDIATE + P2_IMMEDIATE,
            1,
            7,
            ADD + P1_IMMEDIATE + P2_IMMEDIATE,
            3,
            7,
            0,
            END,
        ];
        // jump away leaves the initial instruction
        assert_eq!(
            Program::new(&prog).exec_without_io(Some(1), None),
            JUMP_T + P1_IMMEDIATE + P2_IMMEDIATE
        );
        // no jump overwrites the initial instruciton with 3 + 7 = 10
        assert_eq!(Program::new(&prog).exec_without_io(Some(0), None), 10);
    }

    #[test]
    fn test_jump_if_false() {
        let prog = [
            JUMP_F + P1_IMMEDIATE + P2_IMMEDIATE,
            1,
            7,
            ADD + P1_IMMEDIATE + P2_IMMEDIATE,
            3,
            7,
            0,
            END,
        ];
        // jump away leaves the initial instruction
        assert_eq!(
            Program::new(&prog).exec_without_io(Some(0), None),
            JUMP_F + P1_IMMEDIATE + P2_IMMEDIATE
        );
        // no jump overwrites the initial instruciton with 3 + 7 = 10
        assert_eq!(Program::new(&prog).exec_without_io(Some(1), None), 10);
    }
}

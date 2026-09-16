use anyhow::Result;
use std::collections::VecDeque;

type Address = usize;
type Word = i32;

enum Parameter {
    Position(Address),
    Immediate(Word),
}

pub enum StepResult {
    Stopped(Word),
    InstructionProcessed,
    OutputWritten(Word),
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
    memory: Vec<Word>,
    stopped: bool,
    instruction_pointer: Address,
    inputs: VecDeque<Word>,
    outputs: VecDeque<Word>,
}

impl Program {
    pub fn new(data: &[Word]) -> Self {
        Self {
            memory: data.to_vec(),
            stopped: false,
            instruction_pointer: 0,
            inputs: VecDeque::new(),
            outputs: VecDeque::new(),
        }
    }

    pub fn from_file(filename: &std::path::Path) -> anyhow::Result<Self> {
        let data: Vec<Word> = std::fs::read_to_string(filename)?
            .trim_end()
            .split(',')
            .map(|c| c.parse::<i32>().expect("Program is made up of integers."))
            .collect();
        Ok(Self::new(&data))
    }

    pub fn exec_without_io(&mut self, noun: Option<Word>, verb: Option<Word>) -> Result<Word> {
        self.exec(noun, verb)
    }

    pub fn exec_without_verb_noun(&mut self) -> Result<Word> {
        self.exec(None, None)
    }

    pub fn feed_input(&mut self, val: Word) {
        self.inputs.push_back(val)
    }

    pub fn inputs_copy(&self) -> Vec<Word> {
        self.inputs.clone().into()
    }

    pub fn read_output(&mut self) -> Option<Word> {
        self.outputs.pop_front()
    }

    pub fn read_last_output(&mut self) -> Option<Word> {
        self.outputs.pop_back()
    }

    pub fn exec(&mut self, noun: Option<Word>, verb: Option<Word>) -> anyhow::Result<Word> {
        if let Some(val) = noun {
            self.memory[1] = val
        };
        if let Some(val) = verb {
            self.memory[2] = val
        };

        loop {
            if let StepResult::Stopped(val) = self.step()? {
                return Ok(val);
            }
        }
    }

    pub fn step(&mut self) -> Result<StepResult> {
        let op = self.read_instruction();
        Ok(match op {
            Instruction::Add(p1, p2, target) => {
                let x = self.param_value(p1);
                let y = self.param_value(p2);
                self.memory[target] = x + y;
                self.instruction_pointer += 4;
                StepResult::InstructionProcessed
            }
            Instruction::Mult(p1, p2, target_addr) => {
                let x = self.param_value(p1);
                let y = self.param_value(p2);
                self.memory[target_addr] = x * y;
                self.instruction_pointer += 4;
                StepResult::InstructionProcessed
            }
            Instruction::End => {
                self.stopped = true;
                StepResult::Stopped(self.memory[0])
            }
            Instruction::Input(target_addr) => match self.inputs.pop_front() {
                Some(val) => {
                    self.memory[target_addr] = val;
                    self.instruction_pointer += 2;
                    StepResult::InstructionProcessed
                }
                None => anyhow::bail!("Expected more inputs, but got None."),
            },
            Instruction::Output(read_addr) => {
                let val = self.memory[read_addr];
                self.instruction_pointer += 2;
                self.outputs.push_back(val);
                StepResult::OutputWritten(val)
            }
            Instruction::JumpIfTrue(param1, param2) => {
                if self.param_value(param1) > 0 {
                    self.instruction_pointer = self.param_value(param2) as usize;
                } else {
                    self.instruction_pointer += 3;
                }
                StepResult::InstructionProcessed
            }
            Instruction::JumpIfFalse(param1, param2) => {
                if self.param_value(param1) == 0 {
                    self.instruction_pointer = self.param_value(param2) as usize;
                } else {
                    self.instruction_pointer += 3;
                }
                StepResult::InstructionProcessed
            }
            Instruction::LessThen(param1, param2, target_addr) => {
                let result = if self.param_value(param1) < self.param_value(param2) {
                    1
                } else {
                    0
                };
                self.memory[target_addr] = result;
                self.instruction_pointer += 4;
                StepResult::InstructionProcessed
            }
            Instruction::Equals(param1, param2, target_addr) => {
                let result = if self.param_value(param1) == self.param_value(param2) {
                    1
                } else {
                    0
                };
                self.memory[target_addr] = result;
                self.instruction_pointer += 4;
                StepResult::InstructionProcessed
            }
        })
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

    pub fn stopped(&self) -> bool {
        self.stopped
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
    const LESS_THEN: i32 = 7;
    const EQUAL: i32 = 8;
    const END: i32 = 99;

    const ADD_PROG: [i32; 7] = [ADD, 5, 6, 0, END, 2, 3];
    const MULT_PROG: [i32; 7] = [MULT, 5, 6, 0, END, 2, 3];

    #[test]
    fn test_add_pos_mode() {
        assert_eq!(
            Program::new(&ADD_PROG)
                .exec_without_io(Some(5), Some(6))
                .unwrap(),
            5
        );
    }

    #[test]
    fn test_mult_pos_mode() {
        assert_eq!(
            Program::new(&MULT_PROG)
                .exec_without_io(Some(5), Some(6))
                .unwrap(),
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
            Program::new(&ADD_PROG_IMMEDIAT_MODE)
                .exec_without_io(Some(5), Some(6))
                .unwrap(),
            11
        );
    }

    #[test]
    fn test_mult_immediate_mode() {
        assert_eq!(
            Program::new(&MULT_PROG_IMMEDIAT_MODE)
                .exec_without_io(Some(5), Some(6))
                .unwrap(),
            30
        );
    }

    const IO_PROG: [i32; 6] = [INP, 5, OUTP, 5, END, -2];

    #[test]
    fn test_io() {
        let mut program = Program::new(&IO_PROG);
        program.feed_input(7);
        program.exec_without_verb_noun().unwrap();
        assert_eq!(program.read_output(), Some(7));
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
            Program::new(&prog).exec_without_io(Some(1), None).unwrap(),
            JUMP_T + P1_IMMEDIATE + P2_IMMEDIATE
        );
        // no jump overwrites the initial instruciton with 3 + 7 = 10
        assert_eq!(
            Program::new(&prog).exec_without_io(Some(0), None).unwrap(),
            10
        );
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
            Program::new(&prog).exec_without_io(Some(0), None).unwrap(),
            JUMP_F + P1_IMMEDIATE + P2_IMMEDIATE
        );
        // no jump overwrites the initial instruciton with 3 + 7 = 10
        assert_eq!(
            Program::new(&prog).exec_without_io(Some(1), None).unwrap(),
            10
        );
    }

    #[test]
    fn test_less_then() {
        let prog = [LESS_THEN + P1_IMMEDIATE + P2_IMMEDIATE, -1, -1, 0, END];
        // 3 < 4 = true -> we store 1 in pos 0
        assert_eq!(
            Program::new(&prog)
                .exec_without_io(Some(3), Some(4))
                .unwrap(),
            1
        );
        // 5 < 4 = false -> we store 0 in pos 0
        assert_eq!(
            Program::new(&prog)
                .exec_without_io(Some(5), Some(4))
                .unwrap(),
            0
        );
    }

    #[test]
    fn test_equals() {
        let prog = [EQUAL + P1_IMMEDIATE + P2_IMMEDIATE, -1, -10, 0, END];
        // 3 == 3 = true -> we store 1 in pos 0
        assert_eq!(
            Program::new(&prog)
                .exec_without_io(Some(3), Some(3))
                .unwrap(),
            1
        );
        // 5 == 4 = false -> we store 0 in pos 0
        assert_eq!(
            Program::new(&prog)
                .exec_without_io(Some(5), Some(4))
                .unwrap(),
            0
        );
    }
}

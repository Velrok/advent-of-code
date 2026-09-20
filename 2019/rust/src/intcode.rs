use anyhow::Result;
use std::collections::VecDeque;

type Address = usize;
type Word = i64;

#[derive(PartialEq, Debug)]
enum Parameter {
    Relative(Word),
    Position(Address),
    Immediate(Word),
}

#[derive(PartialEq, Debug)]
pub enum StepResult {
    Stopped(Word),
    InstructionProcessed,
    OutputWritten(Word),
}

#[derive(Debug)]
enum Instruction {
    Add(Parameter, Parameter, Address),
    Mult(Parameter, Parameter, Address),
    Input(Parameter),
    Output(Parameter),
    JumpIfTrue(Parameter, Parameter),
    JumpIfFalse(Parameter, Parameter),
    LessThen(Parameter, Parameter, Address),
    Equals(Parameter, Parameter, Address),
    AdjustRelativeBase(Parameter),
    End,
}

#[derive(Clone)]
pub struct Program {
    id: String,
    memory: Vec<Word>,
    stopped: bool,
    instruction_pointer: Address,
    inputs: VecDeque<Word>,
    outputs: VecDeque<Word>,
    relative_base: Word,
}

impl Program {
    pub fn new(data: &[Word], id: Option<&str>) -> Self {
        Self {
            id: id.map(str::to_owned).unwrap_or_else(|| {
                let id: u8 = rand::random();
                format!("{id:02x}")
            }),
            memory: data.to_vec(),
            relative_base: 0,
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
            .map(|c| c.parse::<Word>().expect("Program is made up of integers."))
            .collect();
        Ok(Self::new(&data, None))
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
        #[cfg(debug_assertions)]
        {
            let id = &self.id;
            let instr_ptr = self.instruction_pointer;
            let base = self.relative_base;
            print!("<{id}> {instr_ptr}|{base}({op:?})");
        }
        let result = match op {
            Instruction::Add(p1, p2, target) => {
                let x = self.param_value(p1);
                let y = self.param_value(p2);
                self.set_mem(target, x + y);
                self.instruction_pointer += 4;
                StepResult::InstructionProcessed
            }
            Instruction::Mult(p1, p2, target_addr) => {
                let x = self.param_value(p1);
                let y = self.param_value(p2);
                self.set_mem(target_addr, x * y);
                self.instruction_pointer += 4;
                StepResult::InstructionProcessed
            }
            Instruction::End => {
                self.stopped = true;
                StepResult::Stopped(self.memory[0])
            }
            Instruction::Input(param1) => match self.inputs.pop_front() {
                Some(val) => {
                    let target_addr = Address::try_from(self.param_value(param1))
                        .expect("Output val is a usize.");
                    self.set_mem(target_addr, val);
                    self.instruction_pointer += 2;
                    StepResult::InstructionProcessed
                }
                None => anyhow::bail!("Expected more inputs, but got None."),
            },
            Instruction::Output(param1) => {
                let val = self.param_value(param1);
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
                self.set_mem(target_addr, result);
                self.instruction_pointer += 4;
                StepResult::InstructionProcessed
            }
            Instruction::AdjustRelativeBase(param1) => {
                let diff = self.param_value(param1);
                self.relative_base += diff;
                self.instruction_pointer += 2;
                StepResult::InstructionProcessed
            }
            Instruction::Equals(param1, param2, target_addr) => {
                let result = if self.param_value(param1) == self.param_value(param2) {
                    1
                } else {
                    0
                };
                self.set_mem(target_addr, result);
                self.instruction_pointer += 4;
                StepResult::InstructionProcessed
            }
        };
        #[cfg(debug_assertions)]
        println!(" >> {result:?}");
        Ok(result)
    }

    fn set_mem(&mut self, addr: Address, val: Word) {
        if addr >= self.memory.len() {
            self.memory.resize(addr + 1, 0);
        }
        self.memory[addr] = val;
    }

    fn param_value(&self, param: Parameter) -> Word {
        match param {
            Parameter::Position(addr) => self.memory[addr],
            Parameter::Relative(offset) => {
                let addr = usize::try_from(self.relative_base + offset)
                    .expect("Programms say within the memory space and dont go negative.");
                self.memory[addr]
            }
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
            3 => Instruction::Input(self.read_param(1)),
            4 => Instruction::Output(self.read_param(1)),
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
            9 => Instruction::AdjustRelativeBase(self.read_param(1)),
            99 => Instruction::End,
            _ => unreachable!("We are only fed valid programs."),
        }
    }

    fn read_param(&self, number: u32) -> Parameter {
        let modifier = (self.memory[self.instruction_pointer] / (10 as Word).pow(1 + number)) % 10;
        let param_val = self.memory[self.instruction_pointer + number as usize];
        match modifier {
            0 => Parameter::Position(
                Address::try_from(param_val)
                    .expect("Position parameter points to a valid Address in memory."),
            ),
            1 => Parameter::Immediate(param_val),
            2 => Parameter::Relative(param_val),
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

    const ADD: Word = 1;
    const MULT: Word = 2;
    const INP: Word = 3;
    const OUTP: Word = 4;
    const JUMP_T: Word = 5;
    const JUMP_F: Word = 6;
    const LESS_THEN: Word = 7;
    const EQUAL: Word = 8;
    const ADJ_REL_BASE: Word = 9;
    const END: Word = 99;

    const P1_IMMEDIATE: Word = 100;
    const P2_IMMEDIATE: Word = 1000;

    const P1_RELATIVE: Word = 200;
    const P2_RELATIVE: Word = 2000;

    #[test]
    fn test_read_position_param() {
        let vm = Program::new(&[ADD, 5, 6, 0, END, 1, 2], None);
        assert_eq!(vm.read_param(1), Parameter::Position(5));
        assert_eq!(vm.read_param(2), Parameter::Position(6));
    }

    #[test]
    fn test_read_immediate_param() {
        let vm = Program::new(&[ADD + P1_IMMEDIATE + P2_IMMEDIATE, 5, 6, 0, END], None);
        assert_eq!(vm.read_param(1), Parameter::Immediate(5));
        assert_eq!(vm.read_param(2), Parameter::Immediate(6));
    }

    #[test]
    fn test_read_relative_param() {
        let vm = Program::new(&[ADD + P1_RELATIVE + P2_RELATIVE, -1, 3, 0, END], None);
        assert_eq!(vm.read_param(1), Parameter::Relative(-1));
        assert_eq!(vm.read_param(2), Parameter::Relative(3));
    }

    #[test]
    fn test_exec_adjust_relative_base() {
        let mut vm = Program::new(&[ADJ_REL_BASE + P1_IMMEDIATE, 56, END], None);
        assert_eq!(vm.relative_base, 0);
        assert_eq!(vm.step().unwrap(), StepResult::InstructionProcessed);
        assert_eq!(vm.relative_base, 56);
        assert_eq!(
            vm.step().unwrap(),
            StepResult::Stopped(ADJ_REL_BASE + P1_IMMEDIATE)
        );
    }

    const ADD_PROG: [Word; 7] = [ADD, 5, 6, 0, END, 2, 3];
    const MULT_PROG: [Word; 7] = [MULT, 5, 6, 0, END, 2, 3];

    #[test]
    fn test_add_pos_mode() {
        assert_eq!(
            Program::new(&ADD_PROG, None)
                .exec_without_io(Some(5), Some(6))
                .unwrap(),
            5
        );
    }

    #[test]
    fn test_mult_pos_mode() {
        assert_eq!(
            Program::new(&MULT_PROG, None)
                .exec_without_io(Some(5), Some(6))
                .unwrap(),
            6
        );
    }

    // Immediate mode
    const ADD_PROG_IMMEDIAT_MODE: [Word; 5] = [ADD + P1_IMMEDIATE + P2_IMMEDIATE, 5, 6, 0, END];
    const MULT_PROG_IMMEDIAT_MODE: [Word; 5] = [MULT + P1_IMMEDIATE + P2_IMMEDIATE, 5, 6, 0, END];

    #[test]
    fn test_add_immediate_mode() {
        assert_eq!(
            Program::new(&ADD_PROG_IMMEDIAT_MODE, None)
                .exec_without_io(Some(5), Some(6))
                .unwrap(),
            11
        );
    }

    #[test]
    fn test_mult_immediate_mode() {
        assert_eq!(
            Program::new(&MULT_PROG_IMMEDIAT_MODE, None)
                .exec_without_io(Some(5), Some(6))
                .unwrap(),
            30
        );
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
            Program::new(&prog, None)
                .exec_without_io(Some(1), None)
                .unwrap(),
            JUMP_T + P1_IMMEDIATE + P2_IMMEDIATE
        );
        // no jump overwrites the initial instruciton with 3 + 7 = 10
        assert_eq!(
            Program::new(&prog, None)
                .exec_without_io(Some(0), None)
                .unwrap(),
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
            Program::new(&prog, None)
                .exec_without_io(Some(0), None)
                .unwrap(),
            JUMP_F + P1_IMMEDIATE + P2_IMMEDIATE
        );
        // no jump overwrites the initial instruciton with 3 + 7 = 10
        assert_eq!(
            Program::new(&prog, None)
                .exec_without_io(Some(1), None)
                .unwrap(),
            10
        );
    }

    #[test]
    fn test_less_then() {
        let prog = [LESS_THEN + P1_IMMEDIATE + P2_IMMEDIATE, -1, -1, 0, END];
        // 3 < 4 = true -> we store 1 in pos 0
        assert_eq!(
            Program::new(&prog, None)
                .exec_without_io(Some(3), Some(4))
                .unwrap(),
            1
        );
        // 5 < 4 = false -> we store 0 in pos 0
        assert_eq!(
            Program::new(&prog, None)
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
            Program::new(&prog, None)
                .exec_without_io(Some(3), Some(3))
                .unwrap(),
            1
        );
        // 5 == 4 = false -> we store 0 in pos 0
        assert_eq!(
            Program::new(&prog, None)
                .exec_without_io(Some(5), Some(4))
                .unwrap(),
            0
        );
    }
}

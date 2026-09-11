use std::collections::VecDeque;

use anyhow::Result;
use aoc19::intcode::Program;
use itertools::Itertools;
use rayon::prelude::*;

const PHASES: [i32; 5] = [0, 1, 2, 3, 4];
const LOOPING_PHASES: [i32; 5] = [5, 6, 7, 8, 9];

fn main() -> Result<()> {
    let amp_p = Program::from_file(std::path::Path::new("inputs/day07.txt"))?;
    // part01(&amp_p);
    part02(&amp_p);
    Ok(())
}

fn part01(amp_p: &Program) {
    let problem_space: Vec<Vec<i32>> = PHASES.iter().copied().permutations(5).collect();
    let max_thrust = problem_space
        .par_iter()
        .map(|phases| run_amp_chain(amp_p, phases))
        .max()
        .expect("Expected to get results.");
    println!("part 1 | max_thrust: {max_thrust}");
}

fn part02(amp_p: &Program) {
    let problem_space: Vec<Vec<i32>> = LOOPING_PHASES.iter().copied().permutations(5).collect();
    // let result = run_amp_chain(&amp_p, phases);
    // dbg!(result);
    let max_thrust = problem_space
        .par_iter()
        .map(|phases| run_amp_chain(amp_p, phases))
        .max()
        .expect("Expected to get results.");
    println!("part 2 | max_thrust: {max_thrust}");
}

fn run_amp_chain(amp: &Program, phases: &[i32]) -> i32 {
    let mut signal = 0;
    let mut io_buffer = VecDeque::new();
    for phase in phases {
        io_buffer.clear();
        io_buffer.push_back(*phase);
        io_buffer.push_back(signal);

        amp.clone().exec_without_verb_noun(&mut io_buffer);
        signal = io_buffer
            .pop_front()
            .expect("Last output should have left a value.");
    }
    signal
}

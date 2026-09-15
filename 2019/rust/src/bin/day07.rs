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
    let problem_space: Vec<Vec<i32>> = LOOPING_PHASES
        .iter()
        .copied()
        .combinations_with_replacement(5)
        .collect();
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
    let mut amps: Vec<_> = phases
        .iter()
        .map(|phase| {
            let mut copy = amp.clone();
            copy.feed_input(*phase);
            copy
        })
        .collect();
    amps[0].feed_input(0);
    let amps_count = amps.len();
    let mut curr_amp_idx = 0;
    loop {
        let next_idx = (curr_amp_idx + 1) % amps_count;
        let (amp, next_amp): (&mut Program, &mut Program) = if next_idx > curr_amp_idx {
            // [a b] [c d]
            //    ^   ^
            //    C   N
            let (left, right) = amps.split_at_mut(next_idx);
            (left.last_mut().unwrap(), right.first_mut().unwrap())
        } else {
            // [a b c] [d]
            //  ^       ^
            //  N      C
            let (left, right) = amps.split_at_mut(curr_amp_idx);
            (left.first_mut().unwrap(), right.first_mut().unwrap())
        };

        match amp.step() {
            aoc19::intcode::StepResult::Stopped(val) => return val,
            aoc19::intcode::StepResult::InstructionProcessed => {}
            aoc19::intcode::StepResult::AwaitingInput(_) => {
                while let Some(val) = amp.read_output() {
                    next_amp.feed_input(val)
                }
                curr_amp_idx = next_idx;
            }
        };
    }
}

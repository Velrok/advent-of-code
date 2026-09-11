use anyhow::Result;
use aoc19::intcode::Program;
use itertools::Itertools;
use rayon::prelude::*;

const PHASES: [i32; 5] = [0, 1, 2, 3, 4];

fn main() -> Result<()> {
    let amp_p = Program::from_file(std::path::Path::new("inputs/day07.txt"))?;
    part01(&amp_p);
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

fn run_amp_chain(amp: &Program, phases: &[i32]) -> i32 {
    let mut signal = 0;
    let mut out: Vec<i32> = Vec::with_capacity(1);
    for phase in phases {
        out.clear();
        run_amp(amp.clone(), *phase, signal, &mut out);
        signal = *out.first().expect("Amps write a new signal.");
    }
    signal
}

fn run_amp(mut amp: Program, phase: i32, signal: i32, out: &mut Vec<i32>) {
    amp.exec_without_verb_noun(&[phase, signal], out);
}

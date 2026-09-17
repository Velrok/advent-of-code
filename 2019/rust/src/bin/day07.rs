use anyhow::Result;
use aoc19::intcode::Program;
use itertools::Itertools;

const PHASES: [i64; 5] = [0, 1, 2, 3, 4];
const LOOPING_PHASES: [i64; 5] = [5, 6, 7, 8, 9];

fn main() -> Result<()> {
    let amp_p = Program::from_file(std::path::Path::new("inputs/day07.txt"))?;
    // part01(&amp_p);
    part02(&amp_p);
    Ok(())
}

fn part01(amp_p: &Program) {
    let problem_space: Vec<Vec<i64>> = PHASES.iter().copied().permutations(5).collect();
    let max_thrust = problem_space
        .iter()
        .map(|phases| run_amp_chain(amp_p, phases).expect("Expected chain to run to completion."))
        .max()
        .expect("Expected to get results.");
    println!("part 1 | max_thrust: {max_thrust}");
}

fn part02(amp_p: &Program) {
    let problem_space: Vec<Vec<i64>> = LOOPING_PHASES.iter().copied().permutations(5).collect();

    let thrusts: Vec<_> = problem_space
        .iter()
        .map(|phases| run_amp_chain(amp_p, phases).expect("Expected chain to run to completion."))
        .collect();

    let max_thrust = thrusts.iter().max().expect("Expected to get results.");
    println!("part 2 | thrusts: {thrusts:?} MAX: {max_thrust}");
}

fn run_amp_chain(amp: &Program, phases: &[i64]) -> Result<i64> {
    #[cfg(debug_assertions)]
    println!("=== Amp chain: {phases:?} ===");
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

    let inputs: Vec<_> = amps.iter().map(|amp| amp.inputs_copy()).collect();

    #[cfg(debug_assertions)]
    println!("  Inputs: {inputs:?}");

    loop {
        let next_idx = (curr_amp_idx + 1) % amps_count;
        if curr_amp_idx == next_idx {
            anyhow::bail!("Index math is wrong! We expect at least two amps.");
        }
        let amp = amps.get_mut(curr_amp_idx).expect("Current Amp.");

        match amp.step()? {
            aoc19::intcode::StepResult::Stopped(_) => {
                if amps.iter().all(|amp| amp.stopped()) {
                    let amp_e = amps.last_mut().expect("Last amp exists.");

                    #[cfg(debug_assertions)]
                    println!("<< All stopped >>");

                    return Ok(amp_e
                        .read_last_output()
                        .expect("Amp E still has the last output"));
                }
                curr_amp_idx = next_idx;
            }
            aoc19::intcode::StepResult::InstructionProcessed => {
                #[cfg(debug_assertions)]
                print!(".");
            }
            aoc19::intcode::StepResult::OutputWritten(out) => {
                #[cfg(debug_assertions)]
                println!("  Amp[{curr_amp_idx}] -|{out}|-> Amp[{next_idx}]");

                amps.get_mut(next_idx).expect("Next Amp.").feed_input(out);
                curr_amp_idx = next_idx;
            }
        };
    }
}

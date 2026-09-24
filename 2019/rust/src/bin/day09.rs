use anyhow::Result;
use aoc19::intcode::Program;

fn main() -> Result<()> {
    let mut process = Program::from_file(std::path::Path::new("inputs/day09.txt"))?;
    process.feed_input(1);
    let exit_code = process.exec_without_verb_noun();
    let outputs: Vec<_> = std::iter::from_fn(|| process.read_output()).collect();
    println!("{exit_code:?} > {outputs:?}");
    Ok(())
}

#[cfg(test)]
mod tests {
    use aoc19::intcode::Program;

    #[test]
    fn test_make_copy() {
        let program = vec![
            109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99,
        ];
        let mut vm = Program::new(&program, None);
        vm.exec(None, None).unwrap();
        let outputs: Vec<i64> = std::iter::from_fn(|| vm.read_output()).collect();
        assert_eq!(outputs, program);
    }

    #[test]
    fn test_16_digit_number() {
        let program = vec![1102, 34915192, 34915192, 7, 4, 7, 99, 0];
        let mut vm = Program::new(&program, None);
        vm.exec(None, None).unwrap();
        assert_eq!(1219070632396864, vm.read_output().unwrap());
    }

    #[test]
    fn test_middle_number() {
        let program = vec![104, 1125899906842624, 99];
        let mut vm = Program::new(&program, None);
        vm.exec(None, None).unwrap();
        assert_eq!(1125899906842624, vm.read_output().unwrap());
    }
}

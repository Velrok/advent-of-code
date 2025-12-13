use std::fs;

pub fn main() {
    // Cephalopod math doesn't look that different from normal math.
    // The math worksheet (your puzzle input) consists of a list of problems; each problem has a group of numbers that need
    // to be either added (+) or multiplied (*) together.
    let input = fs::read_to_string("inputs/day06").unwrap();

    dbg!(part01(&input));
}

fn part01(input: &str) {
    let matrix: Vec<Vec<&str>> = input
        .lines()
        .map(|line| line.split_whitespace().collect())
        .collect();

    let matrix = transpose(matrix);

    let result: isize = matrix
        .iter()
        .map(|formular| match formular.as_slice() {
            [n1, n2, n3, n4, op] => apply(
                op,
                n1.parse::<isize>().unwrap(),
                n2.parse::<isize>().unwrap(),
                n3.parse::<isize>().unwrap(),
                n4.parse::<isize>().unwrap(),
            ),
            _ => panic!("Expected 3 numbers and an operation."),
        })
        .sum();

    dbg!(result);
}

fn apply(op: &str, n1: isize, n2: isize, n3: isize, n4: isize) -> isize {
    match op {
        "+" => n1 + n2 + n3 + n4,
        "*" => n1 * n2 * n3 * n4,
        _ => panic!("unsupported op"),
    }
}

fn transpose(matrix: Vec<Vec<&str>>) -> Vec<Vec<&str>> {
    let rows = matrix.len();
    let cols = matrix[0].len();

    let mut transposed = vec![vec![""; rows]; cols];
    for col in 0..cols {
        for row in 0..rows {
            transposed[col][row] = matrix[row][col];
        }
    }

    transposed
}

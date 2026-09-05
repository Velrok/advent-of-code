use std::fs;

fn main() {
    let input = fs::read_to_string("inputs/day01.txt").unwrap();
    let masses: Vec<i32> = input
        .lines()
        .map(|line| line.parse::<i32>().unwrap())
        .collect();

    let result = part01(&masses);
    println!("P1: {result}");

    let result = part02(&masses);
    println!("P2: {result}");
}

fn part01(input: &[i32]) -> i32 {
    input.iter().map(fuel).sum()
}

fn part02(input: &[i32]) -> i32 {
    input.iter().map(rocket_fuel).sum()
}

fn fuel(mass: &i32) -> i32 {
    (mass / 3) - 2
}

fn rocket_fuel(mass: &i32) -> i32 {
    let mass_fuel = fuel(mass);
    std::iter::successors(Some(mass_fuel), |&prev| {
        let next = fuel(&prev);
        (next > 0).then_some(next)
    })
    .sum()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn rocket_fuel_example_1() {
        assert_eq!(rocket_fuel(&1969), 966);
    }
}

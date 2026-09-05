use std::fs;

fn main() {
    let input = fs::read_to_string("inputs/day01.txt").unwrap();
    let masses: Vec<i32> = input
        .lines()
        // .map(|line| dbg!(line))
        .map(|line| line.parse::<i32>().unwrap())
        .collect();

    let result = part01(&masses);
    println!("P1: {result}");

    let result = part02(&masses);
    println!("P2: {result}");
}

fn part01(input: &[i32]) -> i32 {
    input.iter().map(mass_fuel).sum()
}

fn part02(input: &[i32]) -> i32 {
    input.iter().map(rocket_fuel).sum()
}

fn mass_fuel(mass: &i32) -> i32 {
    (mass / 3) - 2
}

fn rocket_fuel(mass: &i32) -> i32 {
    let fuel = mass_fuel(mass);
    std::iter::successors(Some(fuel), |&prev| {
        let next = mass_fuel(&prev);
        (next > 0).then_some(next)
    })
    .sum()
}

#[cfg(test)]
mod tesitests {
    use super::*;

    #[test]
    fn rocket_fuel_example_1() {
        assert_eq!(rocket_fuel(&1969), 966);
    }
}

use std::fs;

use crate::utils;

pub fn part01() {
    let input = parse_input();
    let result = input
        .iter()
        .map(|ns| utils::minmax(ns).expect("min n and max cna be found"))
        .map(|(min, max)| max - min)
        .sum::<u64>();
    println!("Day02 P1: {result}");
}

pub fn part02() {
    let mut input = parse_input();
    let result: u64 = input.iter_mut().map(divable).sum();
    println!("Day02 P2: {result}");
}

fn divable(numbers: &mut Vec<u64>) -> u64 {
    numbers.sort();
    for n1 in numbers.iter().rev() {
        for n2 in numbers.iter() {
            if n1 != n2 && n1 % n2 == 0 {
                return n1 / n2;
            }
        }
    }
    unreachable!("We are promissied two numbers tha evenly devide per line")
}

fn parse_input() -> Vec<Vec<u64>> {
    let input: Vec<Vec<u64>> = fs::read_to_string("./inputs/day02")
        .expect("Expected input at ./inputs/day02")
        .trim()
        .lines()
        .map(|line| {
            line.trim()
                .split('\t')
                .map(|x| x.parse::<u64>().expect("numbers"))
                .collect()
        })
        .collect();
    input
}

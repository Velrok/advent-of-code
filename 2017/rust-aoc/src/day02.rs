use std::fs;

use crate::utils;

pub fn part01() {
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
    let result = input
        .iter()
        .map(|ns| utils::minmax(ns).expect("min n and max cna be found"))
        .map(|(min, max)| max - min)
        .sum::<u64>();
    println!("Day02 P1: {result}");
}
pub fn part02() {
    todo!("")
}

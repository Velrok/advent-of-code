use std::collections::HashMap;

fn part1(input: &str) -> HashMap<usize, usize> {
    diff_distribution(&mut parse_numbers(input))
}

fn main() {
    let input = include_str!("../input");
    println!("part1 -> {:#?}", part1(input));
}

fn parse_numbers(input: &str) -> Vec<usize> {
    input.lines().map(|x| x.parse::<usize>().unwrap()).collect()
}

fn device_joltage(js: &Vec<usize>) -> usize {
    js.iter().max().unwrap() + 3
}

fn diff_distribution(joltages: &mut Vec<usize>) -> HashMap<usize, usize> {
    joltages.push(0);
    let dev_j = device_joltage(&joltages);
    joltages.push(dev_j);
    joltages.sort();

    joltages.windows(2).fold(HashMap::new(), |mut acc, slice| {
        let x = slice[0];
        let y = slice[1];
        let diff = y - x;
        match acc.get_mut(&diff) {
            Some(x) => *x += 1,
            None => {
                acc.insert(diff, 1);
            }
        };
        acc
    })
}

#[test]
fn test_1() {
    let input = "16
10
15
5
1
11
7
19
6
12
4";
    let mut joltages: Vec<_> = parse_numbers(input);
    let dev_j = device_joltage(&joltages);

    println!("joltages: {:#?}", joltages);
    println!("windows: {:#?}", joltages.windows(2).collect::<Vec<_>>());
    assert_eq!(dev_j, 22);
    let dist = diff_distribution(&mut joltages);
    println!("diffs: {:#?}", dist);
}

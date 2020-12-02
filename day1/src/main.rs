use std::fs;
// Before you leave, the Elves in accounting just need you to fix your expense report
// (your puzzle input); apparently, something isn't quite adding up.
//
// Specifically, they need you to find the two entries that sum to 2020 and then
// multiply those two numbers together.
fn main() {
    let input = fs::read_to_string("input").unwrap();
    let lines = input.lines();
    let numbers: Vec<u32> = lines.map(|l| l.parse::<u32>().unwrap()).collect();
    match_two(&numbers);
    match_three(&numbers);
    println!("bye");
}

//The Elves in accounting are thankful for your help; one of them even offers you
//a starfish coin they had left over from a past vacation. They offer you a second one
//if you can find three numbers in your expense report that meet the same criteria.
fn match_two(numbers: &Vec<u32>) {
    println!("match two");
    for i in numbers {
        for j in numbers {
            if i == j {
                continue;
            }
            if i + j == 2020 {
                println!("i: {} + j: {} -> 2020", i, j);
                println!("i: {} * j: {} -> {}", i, j, i * j);
                return;
            }
        }
    }
}

fn match_three(numbers: &Vec<u32>) {
    println!("match three");
    for i in numbers {
        for j in numbers {
            for k in numbers {
                if i == j || j == k || k == i {
                    continue;
                }
                if i + j + k == 2020 {
                    println!("i: {} + j: {} + k:{} -> 2020", i, j, k);
                    println!("i: {} * j: {} * k:{} -> {}", i, j, k, i * j * k);
                    return;
                }
            }
        }
    }
}

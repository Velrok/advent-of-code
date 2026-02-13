use std::collections::HashMap;

// use im::vector;

// --- Day 15: Rambunctious Recitation ---
fn main() {
    let mut exmaple_nubers = vec![0, 3, 6];
    let mut puzzle_numbers = vec![9, 6, 0, 10, 18, 2];
    let mut numbers = puzzle_numbers;
    // keep a HashMap of
    let mut recitation: HashMap<_, _> = HashMap::new();

    for (i, num) in numbers.iter().enumerate() {
        recitation.insert(*num, (0, i + 1));
    }

    for i in numbers.len()..2022 {
        let turn = i + 1;
        let last_number_spoken = numbers.last().unwrap();
        let age = match recitation.get(last_number_spoken) {
            None => 0,
            Some((turn1, turn2)) if *turn1 > 0 => turn2 - turn1,
            Some(_) => 0,
        };

        // println!("turn: {turn}, last_number_spoken: {last_number_spoken}, age: {age}",);

        // remember as new last
        numbers.push(age);

        match recitation.get(&age) {
            None => recitation.insert(age, (0, turn)),
            Some((_, t2)) => recitation.insert(age, (*t2, turn)),
        };
    }
    if numbers == exmaple_nubers {
        assert_eq!(
            numbers.iter().copied().take(10).collect::<Vec<usize>>(),
            vec![0, 3, 6, 0, 3, 3, 1, 0, 4, 0]
        );
    }
    dbg!(numbers.iter().collect::<Vec<_>>());
    dbg!(numbers[2020 - 1]);
}

use im::HashMap;

// --- Day 15: Rambunctious Recitation ---
fn main() {
    let example_numbers = vec![0, 3, 6];
    let puzzle_numbers = vec![9, 6, 0, 10, 18, 2, 1];
    let mut numbers = puzzle_numbers.clone();
    // let mut numbers = example_numbers.clone();
    let mut recitation: HashMap<usize, usize> = HashMap::new();

    // let end = 2020;
    let end = 30000000;
    for i in 1..end {
        print!(".");
        // println!("i: {i}");
        let needle_index = i - 1;
        let needle = numbers[needle_index];
        // println!(" needle: {needle}");
        let previous_occurence = recitation.get(&needle);
        let age = match previous_occurence {
            Some(previous_index) => needle_index - previous_index,
            None => 0,
        };
        // println!(" age: {age}");

        match numbers.get(i) {
            Some(_) => (), // skipp
            None => numbers.push(age),
        }
        // println!(" numbers: {:?}", numbers);

        recitation.insert(needle, needle_index);
    }

    if numbers == example_numbers {
        assert_eq!(
            numbers.iter().copied().take(10).collect::<Vec<usize>>(),
            vec![0, 3, 6, 0, 3, 3, 1, 0, 4, 0]
        );
    }

    println!("-> {:?}", numbers.last());
}

// --- Day 15: Rambunctious Recitation ---
fn main() {
    let example_numbers = vec![0, 3, 6];
    let puzzle_numbers = vec![9, 6, 0, 10, 18, 2, 1];
    let mut numbers = puzzle_numbers.clone();
    // let mut numbers = example_numbers.clone();

    // 0, 3, 6
    // 0, 1, 2
    //        , 3
    for i in numbers.len()..2020 {
        println!("Turn: {}", i + 1);
        let needle = numbers[i - 1];
        println!(" needle: {needle}");
        let last_occurences: Vec<_> = numbers
            .iter()
            .enumerate() // get a hold of the original indecies as well
            .rev() // we are going backwards
            .filter(|(_, x)| **x == needle)
            .take(2)
            .map(|(index, _)| index)
            .collect::<Vec<_>>();
        println!(" last_occurences: {:?}", last_occurences.as_slice());
        let age = match last_occurences.as_slice() {
            [] => 0,
            [_] => 0,
            [b, a] => b - a,
            _ => unreachable!(), // take 2 means no more than 2
        };
        println!(" age: {age}");
        numbers.push(age);
    }

    if numbers == example_numbers {
        assert_eq!(
            numbers.iter().copied().take(10).collect::<Vec<usize>>(),
            vec![0, 3, 6, 0, 3, 3, 1, 0, 4, 0]
        );
    }

    println!("-> {:?}", numbers.last());
}

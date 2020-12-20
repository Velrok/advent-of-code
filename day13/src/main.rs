fn main() {
    let input = include_str!("../input");
    print!("part1 -> {}", part1(input));
}

fn parse_input(i: &str) -> (i32, Vec<i32>) {
    let mut lines = i.lines();
    let ts = lines.next().unwrap().parse::<i32>().unwrap();
    let bus_lines = lines
        .next()
        .unwrap()
        .split(",")
        .flat_map(|n| n.parse::<i32>()) // see https://stackoverflow.com/questions/28572101/what-is-a-clean-way-to-convert-a-result-into-an-option as to why this works
        .collect();
    (ts, bus_lines)
}

fn part1(i: &str) -> i32 {
    let (ts, bus_lines) = parse_input(i);
    // println!("ts: {}, busses: {:?}", ts, bus_lines);
    //bus_lines.map(|bl| (bl, quick_bus_times(ts, bl)));
    let mut next_bus_in = 99999999;
    let mut result = -1;

    for bl in bus_lines {
        let wait_time = quick_bus_times(ts, bl);
        if (wait_time < next_bus_in) {
            println!("Next bus is a {}, in {}.", bl, wait_time);
            next_bus_in = wait_time;
            result = bl * wait_time;
        }
    }
    result
}

fn quick_bus_times(ts: i32, bus_every: i32) -> i32 {
    bus_every - ts.rem_euclid(bus_every)
}

#[test]
fn quick_bus_times_test() {
    let bl = 7;
    assert_eq!(4, quick_bus_times(10, 7))
}

#[test]
fn test_part1() {
    let i = "939
7,13,x,x,59,x,31,19";
    assert_eq!(295, part1(i));
}

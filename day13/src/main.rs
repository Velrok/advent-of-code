use rayon::prelude::*;

fn main() {
    let input = include_str!("../input");
    // print!("part1 -> {}", part1(input));
    println!("part2 -> {}", part2(input, 100000000000000..std::i64::MAX));
}

fn parse_input(i: &str) -> (i64, Vec<i64>) {
    let mut lines = i.lines();
    let ts = lines.next().unwrap().parse::<i64>().unwrap();
    let bus_lines = lines
        .next()
        .unwrap()
        .split(",")
        .flat_map(|n| n.parse::<i64>()) // see https://stackoverflow.com/questions/28572101/what-is-a-clean-way-to-convert-a-result-into-an-option as to why this works
        .collect();
    (ts, bus_lines)
}

fn part1(i: &str) -> i64 {
    let (ts, bus_lines) = parse_input(i);

    let (bl, wait_time) = bus_lines
        .iter()
        .map(|bl| (bl, quick_bus_times(ts, *bl)))
        .min_by_key(|(bl, wait)| wait.clone())
        .unwrap();
    bl * wait_time
}

fn quick_bus_times(ts: i64, bus_freq: i64) -> i64 {
    bus_freq - ts.rem_euclid(bus_freq)
}

#[test]
fn quick_bus_times_test() {
    assert_eq!(4, quick_bus_times(10, 7))
}

#[test]
fn test_part1() {
    let i = "939
7,13,x,x,59,x,31,19";
    assert_eq!(295, part1(i));
}

fn part2(i: &str, ts_range: std::ops::Range<i64>) -> i64 {
    let bus_wait_req: Vec<_> = i
        .lines()
        .nth(1) // skip first lines
        .unwrap()
        .split(",")
        .map(|x| x.parse::<i64>().ok())
        .enumerate() // basically index each line
        .filter_map(|(required_wait, bus_o)| match bus_o {
            // use filter_map to unwrap the Option
            Some(bus) => Some((required_wait, bus)),
            _ => None, // filter out x's, we only need them as a means to encode the index aka wait time
        })
        .collect();
    // lets get a lazy iter for all natural numbers, where we can search for a timestamp that fits
    // the bus wait requirements
    println!("bus_wait_req: {:?}", bus_wait_req);
    ts_range
        .into_par_iter()
        .filter(|ts| {
            bus_wait_req
                .iter()
                .all(|(req_wait, bus)| (*ts + *req_wait as i64).rem_euclid(*bus) == 0)
        })
        .min()
        .unwrap()
}

#[test]
fn p2_test() {
    let input = "____\n7,13,x,x,59,x,31,19";
    assert_eq!(1068781, part2(input, 0..1068789));
}

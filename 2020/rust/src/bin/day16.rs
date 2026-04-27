use std::ops::RangeInclusive;

struct Field {
    name: String,
    ranges: [RangeInclusive<usize>; 2],
}

fn main() {
    let input = include_str!("../../inputs/day16.txt");
    let parts: Vec<_> = input.split("\n\n").collect();
    let fields = parse_fields(parts[0]);
    let _your_ticket_str = parts[1];
    let nearby_tickets: Vec<Vec<usize>> = parse_nearby_tickets(parts[2]);
    dbg!(parts[2]);
}

fn parse_fields(fields_str: &str) -> Vec<Field> {
    fields_str
        .lines()
        .map(|line| {
            let (name, ranges) = line
                .split_once(": ")
                .unwrap_or_else(|| panic!("expected {line} to be <name>: <ranges>"));
            let (left_range, right_range) = ranges
                .split_once(" or ")
                .unwrap_or_else(|| panic!("expected {ranges} to be <range> or <range>"));
            Field {
                name: name.to_owned(),
                ranges: [parse_range(left_range), parse_range(right_range)],
            }
        })
        .collect()
}

fn parse_range(range: &str) -> RangeInclusive<usize> {
    let (lower, upper) = range
        .split_once('-')
        .unwrap_or_else(|| panic!("expected {range} to be <usize>-<usize>"));
    let lower_int = lower
        .parse::<usize>()
        .unwrap_or_else(|_| panic!("expected {lower} to be usize parseable"));
    let upper_int = upper
        .parse::<usize>()
        .unwrap_or_else(|_| panic!("expected {upper} to be usize parseable"));
    lower_int..=upper_int
}

fn parse_nearby_tickets(str: &str) -> Vec<Vec<usize>> {
    str.lines()
        .skip(1)
        .map(|line| {
            line.split(',')
                .map(|x| {
                    x.parse::<usize>()
                        .unwrap_or_else(|_| panic!("cant parse {x} as usize"))
                })
                .collect()
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    fn test_parse_nearby_tickets() {
        assert_eq!(
            parse_nearby_tickets(
                "nearby tickets:
136,368,517
144,452,191
"
            ),
            [[136, 368, 517], [144, 452, 191],]
        )
    }
}

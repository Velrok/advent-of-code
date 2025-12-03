use std::fs;
fn main() {
    let p1_answer = invalid_sum(is_invalid_p1);
    println!("P1: {p1_answer:?}");
}

fn invalid_sum(invalid_fn: fn(u64) -> bool) -> u64 {
    let input = fs::read_to_string("inputs/day02.txt").unwrap();
    input
        .trim()
        .split_terminator(',')
        .map(parse_range)
        .flat_map(|range| range.filter(|&id| invalid_fn(id)))
        .sum()
}

fn is_invalid_p1(id: u64) -> bool {
    let id_s = id.to_string();
    let chars: Vec<char> = id_s.chars().collect();
    let chars_count = chars.len();
    if chars_count % 2 == 1 {
        // odd length can't be similar
        false
    } else {
        // if we have a number like 123123
        // we can half the lenght and iterate from the start and middle with two pointers
        // so 123123 length = 6 -> mid is 3 -> pointer 1 starts 0, pointer two starts at 3
        // 123123
        // ^  ^
        // 012345
        let half_way = chars_count / 2;
        let mut all_eq = true;
        for i in 0..half_way {
            if chars[i] != chars[i + half_way] {
                all_eq = false
            }
        }
        all_eq
    }
}

mod tests {
    use super::*;

    #[test]
    fn test_is_invalid() {
        assert!(is_invalid_p1(123123));
        assert!(is_invalid_p1(11));
        assert!(is_invalid_p1(22));
        assert!(is_invalid_p1(99));
        assert!(is_invalid_p1(1010));
        assert!(is_invalid_p1(1188511885));
        assert!(is_invalid_p1(222222));
        assert!(is_invalid_p1(446446));
        assert!(is_invalid_p1(38593859));

        assert!(!is_invalid_p1(1));
        assert!(!is_invalid_p1(111));
    }
}

fn parse_range(str: &str) -> std::ops::Range<u64> {
    let Some((from, to)) = str.split_once('-') else {
        panic!("Cant split range {str}")
    };
    let from: u64 = from.parse().unwrap();
    let to: u64 = to.parse().unwrap();
    from..to
}

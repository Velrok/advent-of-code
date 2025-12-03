use std::fs;
fn main() {
    let input = fs::read_to_string("inputs/day02.txt").unwrap();
    let ranges = input
        .trim()
        .split_terminator(',')
        .map(parse_range)
        .collect::<Vec<_>>();

    let mut invalid_id_sum = 0;
    for range in ranges {
        for id in range {
            if is_invalid(id) {
                invalid_id_sum += id;
            }
        }
    }
    println!("P1: {invalid_id_sum:?}")
}

fn is_invalid(id: u64) -> bool {
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
        assert_eq!(true, is_invalid(123123));
        assert_eq!(true, is_invalid(11));
        assert_eq!(true, is_invalid(22));
        assert_eq!(true, is_invalid(99));
        assert_eq!(true, is_invalid(1010));
        assert_eq!(true, is_invalid(1188511885));
        assert_eq!(true, is_invalid(222222));
        assert_eq!(true, is_invalid(446446));
        assert_eq!(true, is_invalid(38593859));

        assert_eq!(false, is_invalid(1));
        assert_eq!(false, is_invalid(111));
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

fn count_valid_pass (i: &str) -> usize {
    // TODO: figure out how to parse the str blocks into structs
    // Note: I miss clojures parition_by which can give more than one parition :(
    // let fields = i.lines().fold(||)
    // println!("fields: {:#?}", fields);
    0
}

fn main() {
    let input = include_str!("../input");
}

#[test]
fn test_part_1 () {
    let input = "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in";
    assert_eq!(3, count_valid_pass(input));
}

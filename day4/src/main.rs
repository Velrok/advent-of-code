fn is_valid_passport(s: &str) -> bool {
    let required_fields = vec!["byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid",
    // "cid" // hack it
    ];
    required_fields.iter().all(|k| s.contains(k))
}

fn count_valid_pass (i: &str) -> usize {
    // TODO: figure out how to parse the str blocks into structs
    // Note: I miss clojures parition_by which can give more than one parition :(
    let passports: Vec<_> = i.split("\n\n").collect();
    println!("passports: {:#?}", passports);
    passports.into_iter().filter(|&s| is_valid_passport(s)).count()
}

fn main() {
    let input = include_str!("../input");
    println!("part 1");
    println!("No of valid passwords: {}", count_valid_pass(input));
}

#[test]
fn is_valid_passport_test() {
    assert!(is_valid_passport("ecl:gry pid:860033327 eyr:2020 hcl:#fffffd\n byr:1937 iyr:2017 cid:147 hgt:183cm"));
    assert!(! is_valid_passport("iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884\n hcl:#cfa07d byr:1929 "));
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
    assert_eq!(2, count_valid_pass(input));
}


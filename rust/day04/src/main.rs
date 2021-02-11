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
    // println!("passports: {:#?}", passports);
    passports.into_iter().filter(|&s| is_valid_passport(s)).count()
}

#[test]
fn test_range() {
    assert!((1..10).contains(&5));
    assert!(!(1..10).contains(&10));
    assert!(valid_attr(("byr", "2000")));
    assert!(!valid_attr(("byr", "2010")));
    assert!(valid_attr(("hgt", "150cm")));
    assert!(!valid_attr(("hgt", "194cm")));
    assert!(valid_attr(("hgt", "59in")));
    assert!(!valid_attr(("hgt", "77in")));
    assert!(valid_attr(("hcl", "#123abc")));
    assert!(!valid_attr(("hcl", "#123abz")));
}

fn only_allowed(allowed: &str, s: &str) -> bool {
    s.chars()
        .all(|sc: char| allowed.contains(sc))
}

fn valid_attr((k, v): (&str, &str)) -> bool {
    let is_valid = match k {
        "byr" => (1920..2003).contains(&v.parse::<usize>().unwrap()),
        "iyr" => (2010..2021).contains(&v.parse::<usize>().unwrap()),
        "eyr" => (2020..2031).contains(&v.parse::<usize>().unwrap()),
        "hgt" => {
            let (measure_str, measure_type) = v.split_at(v.len() -2);
            let measure: usize = measure_str.parse::<usize>().unwrap_or(0);
            match measure_type {
                "cm" => (150..194).contains(&measure),
                "in" => (59..77).contains(&measure),
                _ => false,
            }
        },
        "hcl" => v.len() == 7 && v.chars().nth(0).unwrap() == '#' && only_allowed("0123456789abcdef#", v),
        "ecl" => vec!["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(&v),
        "pid" => v.len() == 9 && only_allowed("1234567890", v),
        "cid" => true,
        _ => false,
    };

    // if !is_valid {println!("{:#?} failed validation", (k, v))};

    is_valid
}

fn is_valid_passport_2(passport: &str) -> bool {
    let required_fields = vec!["byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid",
    // "cid" // hack it
    ];
    let all_present = required_fields.iter().all(|k| passport.contains(k));
    let all_with_valid_fiels = passport.split(|c| c == '\n' || c == ' ')
        .map(|s| {
            let mut i = s.split(":");
            (i.next().unwrap(), i.next().unwrap())
        })
    .all(valid_attr);
    all_present && all_with_valid_fiels

}

fn count_valid_pass_2 (i: &str) -> usize {
    let passports: Vec<_> = i.split("\n\n").collect();
    //println!("passports: {:#?}", passports);
    passports.into_iter().filter(|&s| is_valid_passport_2(s)).count()
}

fn main() {
    let input = include_str!("../input");
    println!("part 1");
    println!("No of valid passports: {}", count_valid_pass(input));
    println!("part 2");
    println!("No of valid passports: {}", count_valid_pass_2(input));
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


#[test]
fn part_2() {
    let invalid = "eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007";

    assert_eq!(0, count_valid_pass_2(invalid));

    let valid = "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719";
    assert_eq!(4, count_valid_pass_2(valid));
}

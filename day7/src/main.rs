use std::str::FromStr;
use std::string::ParseError;

#[derive(Debug)]
struct Bag {
    color: String,
}

#[derive(Debug)]
struct BagRule {
    container: Bag,
    contents: Vec<Bag>,
}

fn trim_bags(s: &str) -> String {
    s.trim().replace(" bags", "")
}

impl FromStr for BagRule {
    type Err = ParseError;

    fn from_str (s: &str) -> Result<Self, Self::Err> {
        // valid rules will produce two entries
        let mut parts = s.split(" contain ");
        // first entry is the containing bag
        let container: String = trim_bags(parts.next().unwrap());
        // next we have a , separated string of bags. Drop the . at the end
        let contents: String = parts.next().unwrap().replace(".","");
        let no_other = "no other bags".to_string();
        let contents: Vec<Bag> = if contents == "no other bags" {
            Vec::new()
        } else {
            contents.split(", ")
                .map(|s| trim_bags(s.split(char::is_numeric).nth(1).unwrap().trim())) // ditch the leading numnbers
                .map(|c| Bag{color: c}) // make Bags
                .collect()
        };

        Ok(BagRule{
            container: Bag{color: container},
            contents: contents,
        })
    }
}

fn testing() {
    let input = "light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.";
    let rules = input.lines()
        .map(|l| {
            l.parse::<BagRule>()
        });

    let bag_str = "dark orange bags contain 3 bright white bags, 4 muted yellow bags.";
    let rules: Vec<_> = input.lines()
        .map(|l| l.parse::<BagRule>())
        .collect();
    println!("Bag: {:#?}", rules);
}

fn main() {
    println!("Day 7");
    testing();
}

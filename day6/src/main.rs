use std::collections::HashSet;

fn part1(i: &str) -> usize {
    i.split("\n\n")
     .map(|group_str: &str| group_str.replace("\n", ""))
     .map(|group_str: String| {
         let mut h = HashSet::new();
         for c in group_str.chars(){
             h.insert(c);
         };
         h})
     .map(|h| h.len())
     .sum::<usize>()
}

fn part2(i: &str) -> usize {
    i.split("\n\n")
     .map(|group_str: &str| group_str.split("\n").collect::<Vec<_>>())
     .map(|group| group.iter()
         .map(|answers| answers.chars().collect::<HashSet<char>>())
         .collect::<Vec<HashSet<char>>>())
     .map(|group| {
         group.iter().cloned()
             .fold(None, |acc, b: HashSet<char>| {
                 match acc {
                     None => Some(b),
                     Some(a) => Some({
                         let mut h = HashSet::new();
                         for x in a.intersection(&b){
                             h.insert(*x);
                         }
                         h
                     })
                 }
             })
     })
     .map(|g| g.unwrap().len())
     .sum()
}


fn testing() {
    let input = "abc

a
b
c

ab
ac

a
a
a
a

b";

    let r = part2(input);
    println!("testing {:#?}", r);
}

fn main() {
    let input = include_str!("../input");
    //testing();
    println!("part 1 {:#?}", part1(input));
    println!("part 2 {:#?}", part2(input));
}

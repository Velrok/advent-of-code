use std::env;

mod day01;
mod day02;
mod utils;

fn main() {
    let args: Vec<_> = env::args().collect();
    let day = args.get(1).map(String::as_str);
    let part = args.get(2).map(String::as_str);

    match (day, part) {
        (Some("day01"), Some("p1")) => day01::part01(),
        (Some("day01"), Some("p2")) => day01::part02(),

        (Some("day02"), Some("p1")) => day02::part01(),
        (Some("day02"), Some("p2")) => day02::part02(),
        _ => {
            panic!("need dayXX pX got {day:?} {part:?}");
        }
    }
}

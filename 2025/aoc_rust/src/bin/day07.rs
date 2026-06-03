use anyhow::Result;
use std::collections::HashSet;
use std::fs;
use std::str::FromStr;

#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
struct Point {
    x: usize,
    y: usize,
}

impl Point {
    fn down(&self) -> Self {
        Self {
            x: self.x,
            y: self.y + 1,
        }
    }

    fn left(&self) -> Self {
        Self {
            x: self.x - 1,
            y: self.y,
        }
    }

    fn right(&self) -> Self {
        Self {
            x: self.x + 1,
            y: self.y,
        }
    }
}

#[derive(Clone, Debug)]
struct Manifold {
    start: Point,
    splitters: Vec<Point>,
    width: usize,
    height: usize,
}

impl Manifold {
    fn splitters_for_line(&self, line: usize) -> Vec<Point> {
        self.splitters
            .iter()
            .filter(|&p| p.y == line)
            .copied()
            .collect()
    }
}

impl FromStr for Manifold {
    type Err = anyhow::Error;

    fn from_str(s: &str) -> Result<Manifold> {
        let mut start: Option<Point> = None;
        let mut splitters: Vec<Point> = Vec::new();

        for (y, line) in s.lines().enumerate() {
            for (x, c) in line.chars().enumerate() {
                match c {
                    'S' => match start {
                        Some(_) => return Err(anyhow::anyhow!("Found a 2nd Start position.")),
                        None => start = Some(Point { x, y }),
                    },
                    '^' => splitters.push(Point { x, y }),
                    '.' => {}
                    _ => return Err(anyhow::anyhow!("Invalid char {c}")),
                }
            }
        }

        Ok(Manifold {
            start: start.unwrap(),
            splitters,
            height: s.lines().count(),
            width: s
                .lines()
                .next()
                .expect("input is expected to have at least one line")
                .chars()
                .count(),
        })
    }
}

fn main() -> Result<()> {
    let input = fs::read_to_string("inputs/day07.example")?;
    let manifold = Manifold::from_str(&input)?;
    let mut beams: HashSet<Point> = HashSet::from([manifold.start.down()]);
    // ☑️TODO: still buggy
    for y in 1..(manifold.height - 1) {
        dbg!(y);
        let next_line_spliters = manifold.splitters_for_line(y + 1);
        dbg!(&next_line_spliters);
        beams = beams
            .iter()
            .flat_map(|&beam| {
                let beam = beam.down();
                dbg!(&beam);
                if next_line_spliters.contains(&beam) {
                    vec![beam.left(), beam.right()]
                } else {
                    vec![beam]
                }
            })
            .collect();
        dbg!(beams.len());
    }
    // dbg!(manifold);
    dbg!(beams.len());
    Ok(())
}

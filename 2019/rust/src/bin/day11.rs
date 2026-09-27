use anyhow::Result;
use std::collections::HashSet;

use aoc19::{
    intcode::{Program, Word},
    vec2d::Vec2D,
};

enum Colour {
    Black,
    White,
}

impl Colour {
    fn from_word(w: &Word) -> Self {
        match *w {
            0 => Colour::Black,
            1 => Colour::White,
            _ => panic!("Can't parse as colour."),
        }
    }
}

enum Turn {
    Left,
    Right,
}

impl Turn {
    fn from_word(w: &Word) -> Self {
        match *w {
            0 => Turn::Left,
            1 => Turn::Right,
            _ => panic!("Can't parse as Turn."),
        }
    }
}

enum Orientation {
    Up,
    Down,
    Left,
    Right,
}

impl Orientation {
    fn turn(&self, turn: Turn) -> Orientation {
        match (self, turn) {
            (Orientation::Up, Turn::Left) => Orientation::Left,
            (Orientation::Up, Turn::Right) => Orientation::Right,
            (Orientation::Down, Turn::Left) => Orientation::Right,
            (Orientation::Down, Turn::Right) => Orientation::Left,
            (Orientation::Left, Turn::Left) => Orientation::Down,
            (Orientation::Left, Turn::Right) => Orientation::Up,
            (Orientation::Right, Turn::Left) => Orientation::Up,
            (Orientation::Right, Turn::Right) => Orientation::Down,
        }
    }
}

struct PaintingRobot {
    brain: Program,
    white_panels: HashSet<Vec2D>,
    position: Vec2D,
    orientation: Orientation,
    stopped: bool,
}

impl PaintingRobot {
    fn new(prog: Program, white_panels: HashSet<Vec2D>) -> Self {
        PaintingRobot {
            brain: prog,
            white_panels,
            orientation: Orientation::Up,
            position: Vec2D::default(),
            stopped: false,
        }
    }

    fn read_camera(&self) -> Word {
        if self.white_panels.contains(&self.position) {
            1
        } else {
            0
        }
    }

    fn turn(&mut self, turn: Turn) {
        self.orientation = self.orientation.turn(turn);
    }

    fn move_forward(&mut self) {
        self.position += match self.orientation {
            Orientation::Up => Vec2D::up(),
            Orientation::Down => Vec2D::down(),
            Orientation::Left => Vec2D::left(),
            Orientation::Right => Vec2D::right(),
        }
    }

    fn paint(&mut self, col: Colour) {
        let cur_pos = self.position;
        match (col, self.white_panels.contains(&cur_pos)) {
            (Colour::White, true) => {}  // alrady white -> no op
            (Colour::Black, false) => {} // allready black -> no op
            (Colour::Black, true) => {
                self.white_panels.remove(&cur_pos);
            }
            (Colour::White, false) => {
                self.white_panels.insert(cur_pos);
            }
        };
    }

    fn step(&mut self) -> Result<bool> {
        self.brain.feed_input(self.read_camera());

        if let Some(col) = self.brain.exec_until_next_output()?
            && let Some(turn) = self.brain.exec_until_next_output()?
        {
            self.paint(Colour::from_word(&col));
            self.turn(Turn::from_word(&turn));
            self.move_forward();
            Ok(true)
        } else {
            self.stopped = true;
            Ok(false)
        }
    }
}

fn main() -> Result<()> {
    let prog = Program::from_file(std::path::Path::new("inputs/day11.txt"))?;
    println!("=== Part 01 ===");
    part1(prog.clone())?;

    println!("=== Part 02 ===");
    part2(prog.clone())?;

    Ok(())
}

fn part1(prog: Program) -> Result<()> {
    let mut robot = PaintingRobot::new(prog, HashSet::new());
    let mut visited: HashSet<Vec2D> = HashSet::new();
    visited.insert(robot.position);

    let mut steps = 0;
    while robot.step().expect("No Errors stepping through") {
        steps += 1;
        let pos = robot.position;
        visited.insert(pos);
        #[cfg(debug_assertions)]
        eprintln!("{steps}: {pos:?}");
    }

    display(&visited, &robot.white_panels);

    let panels_painted = visited.len();
    println!("\nPanels painted at least once: {panels_painted}");

    Ok(())
}

fn part2(prog: Program) -> Result<()> {
    let mut robot = PaintingRobot::new(prog, HashSet::from([Vec2D::default()]));
    let mut visited: HashSet<Vec2D> = HashSet::new();
    visited.insert(robot.position);

    let mut steps = 0;
    while robot.step().expect("No Errors stepping through") {
        steps += 1;
        let pos = robot.position;
        visited.insert(pos);
        #[cfg(debug_assertions)]
        eprintln!("{steps}: {pos:?}");
    }

    display(&visited, &robot.white_panels);

    let panels_painted = visited.len();
    println!("\nPanels painted at least once: {panels_painted}");

    Ok(())
}

fn display(visited: &HashSet<Vec2D>, white_panels: &HashSet<Vec2D>) {
    let mut min_x = i64::MAX;
    let mut max_x = i64::MIN;
    let mut min_y = i64::MAX;
    let mut max_y = i64::MIN;

    for sqare in visited {
        min_x = min_x.min(sqare.x());
        max_x = max_x.max(sqare.x());

        min_y = min_y.min(sqare.y());
        max_y = max_y.max(sqare.y());
    }

    println!("----------------------------");
    for y in (min_y..=max_y).rev() {
        let mut line = String::new();
        for x in min_x..=max_x {
            let pos = Vec2D::new(x, y);
            let char = if white_panels.contains(&pos) {
                '#'
            } else {
                ' '
            };
            line.push(char);
        }
        println!("{line}");
    }
    println!("----------------------------");
}

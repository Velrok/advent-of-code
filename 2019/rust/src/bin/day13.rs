use std::{array::from_fn, collections::HashMap};

use anyhow::{Result, bail};
use aoc19::{
    intcode::Program,
    vec2d::{self, Vec2D},
};
use itertools::Itertools;

fn main() -> Result<()> {
    part02();
    Ok(())
}

fn part01() -> Result<()> {
    let mut game = Program::from_file(std::path::Path::new("inputs/day13.ic"))?;
    game.exec(None, None)?;
    let outputs = std::iter::from_fn(|| game.read_output());

    let mut block_tiles_counter = 0;
    for (_x, _y, tile_type) in outputs.tuples() {
        // let pos = Vec2D::new(x, y);
        if tile_type == 2 {
            block_tiles_counter += 1
        }
    }
    println!("Part01 -> {block_tiles_counter}");

    Ok(())
}

enum Tile {
    // 0 is an empty tile. No game object appears in this tile.
    Empty,
    // 1 is a wall tile. Walls are indestructible barriers.
    Wall,
    // 2 is a block tile. Blocks can be broken by the ball.
    Block,
    // 3 is a horizontal paddle tile. The paddle is indestructible.
    Paddle,
    // 4 is a ball tile. The ball moves diagonally and bounces off objects.
    Ball,
}

impl Tile {
    fn new(i: i64) -> Tile {
        match i {
            0 => Tile::Empty,
            1 => Tile::Wall,
            2 => Tile::Block,
            3 => Tile::Paddle,
            4 => Tile::Ball,
            _ => {
                panic!("Cant construct tile from i")
            }
        }
    }
}

type Tiles = HashMap<Vec2D, Tile>;

struct Frame {
    tiles: Tiles,
    score: i64,
}

enum JoystickCmd {
    Left,
    Right,
    Neutral,
}

fn part02() -> Result<()> {
    let mut game = Program::from_file(std::path::Path::new("inputs/day13.ic"))?;
    game.mem_set(0, 2); // set to 2 to play for free
    println!("Controlls: <- (a) - (s) ->(d) followed by enter.");

    let frame: Frame = next_frame(&mut game);
    display(frame);
    loop {
        match read_from_stdin() {
            Ok(joystick_input) => {
                game.feed_input(joystick_input);
                let frame: Frame = next_frame(&mut game);
                display(frame);
            }
            Err(_) => eprintln!("Invalid Input."),
        }
    }
}

fn display(frame: Frame) {
    let points = frame.tiles.keys();
    let (min_x, max_x, min_y, max_y) = vec2d::bounds(points);
    for y in min_y..=max_y {
        let mut line = String::new();
        for x in min_x..=max_x {
            match frame.tiles.get(&Vec2D::new(x, y)) {
                Some(tile) => line.push(match tile {
                    Tile::Empty => ' ',
                    Tile::Wall => '#',
                    Tile::Block => '+',
                    Tile::Paddle => '=',
                    Tile::Ball => 'o',
                }),
                None => line.push('!'),
            }
        }
    }
}

fn read_from_stdin() -> Result<i64> {
    let mut input = String::new();
    std::io::stdin().read_line(&mut input).unwrap();
    let c = input.trim().chars().next().unwrap();
    Ok(match c {
        'a' => -1, // left
        's' => 0,  //neutral
        'd' => 1,  //right
        _ => bail!("Invalid input: '{c}' Has to be a s or d followed by newline."),
    })
}

fn next_frame(game: &mut Program) -> Frame {
    let mut tiles: Tiles = HashMap::new();
    let mut output_stream = std::iter::from_fn(|| game.exec_until_next_output().unwrap());

    loop {
        if let Some((x, y, tile_num)) = output_stream.next_tuple() {
            match (x, y) {
                (-1, 0) => {
                    return Frame {
                        tiles,
                        score: tile_num,
                    };
                }
                _ => {
                    tiles.insert(Vec2D::new(x, y), Tile::new(tile_num));
                }
            }
        } else {
            panic!("Didnt expect game to end.")
        }
    }
}

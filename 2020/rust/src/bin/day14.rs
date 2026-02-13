enum Instruction {
    SetMask(),
    SetMemory(),
}

fn parse_line(line: &str) -> Result<Instruction, String> {
    if let Some(_mask) = line.strip_prefix("mask = ") {
        Ok(Instruction::SetMask())
    } else if let Some(_mem_data) = line.strip_prefix("mem") {
        Ok(Instruction::SetMemory())
    } else {
        Err(format!("Cant parse line: {line}"))
    }
}

fn main() {
    std::fs::read_to_string("./inputs/day14.txt")
        .expect("Failed to read ./inputs/day14.txt")
        .lines()
        .map(parse_line);

    println!("Hello, world!");
}

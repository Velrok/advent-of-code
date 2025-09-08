const std = @import("std");

const Number = i32;
const Numbers = std.ArrayList(Number);

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input: []Numbers = try parseInput(allocator, "./inputs/day02");
    defer {
        for (input) |list| {
            list.deinit();
        }
        allocator.free(input);
    }

    var result: i32 = 0;
    for (input) |row| {
        result += checksum(row.items);
    }
    std.debug.print("part01: {any}", .{result});
}

fn checksum(row: []i32) i32 {
    var min: i32 = std.math.maxInt(i32);
    var max: i32 = std.math.minInt(i32);

    for (row) |n| {
        if (n < min) {
            min = n;
        }
        if (n > max) {
            max = n;
        }
    }

    return max - min;
}

fn parseInput(allocator: std.mem.Allocator, fileName: []const u8) ![]Numbers {
    var file = try std.fs.cwd().openFile(fileName, .{});
    defer file.close();

    var buff_reader = std.io.bufferedReader(file.reader());
    var reader = buff_reader.reader();

    var input = std.ArrayList(Numbers).init(allocator);

    while (try reader.readUntilDelimiterOrEofAlloc(allocator, '\n', 1024)) |line| {
        defer allocator.free(line);

        var numbers = Numbers.init(allocator);
        var word_it = std.mem.splitScalar(u8, line, '\t');

        while (word_it.next()) |word| {
            const number = try std.fmt.parseInt(Number, word, 10);
            try numbers.append(number);
        }
        try input.append(numbers);
    }

    return input.toOwnedSlice();
}

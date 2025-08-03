pub fn main() !void {
    const file_path = "inputs/day01";
    const file = try std.fs.cwd().openFile(file_path, .{});

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const content = try file.readToEndAlloc(allocator, 1024 * 10);

    const numbers = try utils.parseDigits(allocator, std.mem.trim(u8, content, " \n"));
    print("part 1: {any}\n", .{part01(
        numbers.items,
    )});
    print("part 2: {any}\n", .{part02(
        numbers.items,
    )});
}

fn part01(numbers: []const u8) u32 {
    return captcha(numbers, 1);
}

fn part02(numbers: []const u8) u32 {
    return captcha(numbers, numbers.len / 2);
}

fn captcha(numbers: []const u8, look_ahead: usize) u32 {
    var sum: u32 = 0;
    for (numbers, 0..) |n, i| {
        const next_idx = (i + look_ahead) % numbers.len;
        if (n == numbers[next_idx]) {
            sum += n;
        }
    }
    return sum;
}

test "part01 examples" {
    try testing.expectEqual(3, part01(&.{ 1, 1, 2, 2 }));
    try testing.expectEqual(4, part01(&.{ 1, 1, 1, 1 }));
    try testing.expectEqual(0, part01(&.{ 1, 2, 3, 4 }));
    try testing.expectEqual(9, part01(&.{ 9, 1, 2, 1, 2, 1, 2, 9 }));
}

const utils = @import("utils.zig");
const std = @import("std");
const print = std.debug.print;
const testing = std.testing;

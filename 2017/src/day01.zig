pub fn main() !void {
    const file_path = "inputs/day01";
    const file = try std.fs.cwd().openFile(file_path, .{});

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const content = try file.readToEndAlloc(allocator, 1024 * 10);

    const numbers = try parseInput(allocator, std.mem.trim(u8, content, " \n"));
    print("part 1: {any}", .{part01(
        numbers.items,
    )});
}

fn part01(numbers: []const u8) u32 {
    var sum: u32 = 0;
    for (numbers, 0..) |n, i| {
        const next_idx = (i + 1) % numbers.len;
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

const ParseErrors = error{NaN};

/// Parses string char by char. Returns an ArrayList the consumer owns and needs to deinit.
/// Ignores new lines.
fn parseInput(allocator: std.mem.Allocator, input: []const u8) !std.ArrayList(u8) {
    var result = std.ArrayList(u8).init(allocator);
    errdefer result.deinit();

    for (input) |c| {
        const valid = switch (c) {
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' => true,
            else => false,
        };
        if (valid) {
            try result.append(c - '0');
        } else {
            print("{any} not a number\n", .{c});
            return ParseErrors.NaN;
        }
    }
    return result;
}

test parseInput {
    const result = try parseInput(std.testing.allocator, "1234567890");
    defer result.deinit();
    const expected: []const u8 = &.{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 };
    try testing.expectEqualSlices(u8, expected, result.items);
}

test "parseInput errors if string contains none digits" {
    const result = parseInput(std.testing.allocator, "123A4567890");
    try testing.expectError(ParseErrors.NaN, result);
}

const std = @import("std");
const print = std.debug.print;
const testing = std.testing;

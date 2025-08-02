pub fn main() !void {
    // const file_path = "inputs/"
    print("hello", .{});
}

// fn part01(input: []const u8) !u32 {}

const ParseErrors = error{NaN};

/// Parses string char by char. Returns an ArrayList the consumer owns and needs to deinit.
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
    // defer result.deinit();
    try testing.expectError(ParseErrors.NaN, result);
}

const std = @import("std");
const print = std.debug.print;
const testing = std.testing;

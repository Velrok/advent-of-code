const ParseErrors = error{NaN};

/// Parses string char by char. Returns an ArrayList the consumer owns and needs to deinit.
pub fn parseDigits(allocator: std.mem.Allocator, input: []const u8) !std.ArrayList(u8) {
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

test parseDigits {
    const result = try parseDigits(std.testing.allocator, "1234567890");
    defer result.deinit();
    const expected: []const u8 = &.{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 };
    try testing.expectEqualSlices(u8, expected, result.items);
}

test "parseDigits errors if string contains none digits" {
    const result = parseDigits(std.testing.allocator, "123A4567890");
    try testing.expectError(ParseErrors.NaN, result);
}

const std = @import("std");
const splitAny = std.mem.splitAny;
const print = std.debug.print;
const testing = std.testing;
const ArrayList = std.ArrayList;

const parseInt = std.fmt.parseInt;

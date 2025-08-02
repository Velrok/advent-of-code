pub fn main() !void {
    print("hello", .{});
}

const print = @import("std").debug.print;

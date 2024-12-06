const std = @import("std");
const print = std.debug.print;

pub fn concatStringsSep(allocator: std.mem.Allocator, strings: []const []const u8, sep: []const u8) ![]u8 {
    if (strings.len == 0) return std.fmt.allocPrint(allocator, "", .{});

    // Determine length of the resultant buffer
    var total_len: usize = 0;
    for (strings) |str| {
        total_len += str.len;
    }
    if (strings.len > 1) {
        total_len += sep.len * (strings.len - 1); // Add separators for all but the last string
    }

    // Allocate buffer for the concatenated result
    var buf_index: usize = 0;
    var result: []u8 = try allocator.alloc(u8, total_len);

    // Copy strings and separators into the result buffer
    for (strings, 0..) |string, index| {
        // Copy the current string into the buffer
        std.mem.copyForwards(u8, result[buf_index..], string);
        buf_index += string.len;

        // Add separator if it's not the last string
        if (index < strings.len - 1) {
            std.mem.copyForwards(u8, result[buf_index..], sep);
            buf_index += sep.len;
        }
    }

    return result;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const strings = &[_][]const u8{
        "Hello",
        "world",
        "this",
        "is",
        "Zig",
    };
    const separator = ", ";

    const result = try concatStringsSep(allocator, strings, separator);

    //const result = concatStringsSep(allocator, strings, separator) catch {
    //    unreachable;
    //};

    defer allocator.free(result);
    errdefer allocator.free(result);

    std.debug.print("{s}\n", .{result});
}

const std = @import("std");

const CustomFileError = error{
    FileNotFound,
    PermissionDenied,
    UnknownError,
};

pub fn main() !void {
    const r = openFilePathStr("minji_haerin.txt") catch |err| {
        printError(err);
        unreachable;
    };

    std.debug.print("File opened successfully: {s}\n", .{"minji_haerin.txt"});
    _ = r;
}

fn openFilePathStr(path: []const u8) CustomFileError!std.fs.File {
    var file = std.fs.cwd().openFile(path, .{}) catch |err| switch (err) {
        error.FileNotFound => return CustomFileError.FileNotFound,
        error.AccessDenied => return CustomFileError.PermissionDenied,
        else => return CustomFileError.UnknownError,
    };

    defer file.close();

    return file;
}

fn printError(err: CustomFileError) void {
    switch (err) {
        CustomFileError.FileNotFound => {
            std.debug.print("Error occurred: File not found.\n", .{});
        },
        CustomFileError.PermissionDenied => {
            std.debug.print("Error occurred: Permission denied.\n", .{});
        },
        CustomFileError.UnknownError => {
            std.debug.print("Error occurred: An unknown error occurred.\n", .{});
        },
    }
}

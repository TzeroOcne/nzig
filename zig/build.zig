const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "hello",
        .root_source_file = b.path("src/hello.zig"),
        .target = b.graph.host,
    });

    b.installArtifact(exe);
}

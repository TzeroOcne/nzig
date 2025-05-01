const std = @import("std");

pub fn build(b: *std.Build) void {
    const options = b.option(u16, "app", "App to build") orelse 0;

    if (options == 1) {
        const exe = b.addExecutable(.{
            .name = "hello",
            .root_source_file = b.path("src/hello.zig"),
            .target = b.graph.host,
        });

        b.installArtifact(exe);

        const run_exe = b.addRunArtifact(exe);

        const run_step = b.step("run", "Run the app");
        run_step.dependOn(&run_exe.step);
    }
}

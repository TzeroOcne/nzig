const std = @import("std");

pub fn build(b: *std.Build) void {
    const options = b.option(u16, "app", "App to build") orelse 0;

    if (options == 1) {
        const exe = b.addExecutable(.{
            .name = "hello",
            .root_source_file = b.path("zig/src/hello.zig"),
            .target = b.graph.host,
        });

        b.installArtifact(exe);

        const run_exe = b.addRunArtifact(exe);

        const run_step = b.step("run", "Run the app");
        run_step.dependOn(&run_exe.step);
    } else if (options == 2) {
        const target = b.standardTargetOptions(.{});
        const optimize = b.standardOptimizeOption(.{});

        if (b.option(bool, "enable-demo", "install the demo too") orelse false) {
            const libfizzbuzz = b.addStaticLibrary(.{
                .name = "fizzbuzz",
                .root_source_file = b.path("zig/src/fizzbuzz.zig"),
                .target = target,
                .optimize = optimize,
            });

            b.installArtifact(libfizzbuzz);

            const exe = b.addExecutable(.{
                .name = "demo",
                .root_source_file = b.path("zig/src/demo.zig"),
                .target = target,
                .optimize = optimize,
            });

            exe.linkLibrary(libfizzbuzz);

            b.installArtifact(exe);
        } else if (b.option(bool, "build-shared", "Build a shared library") orelse false) {
            const libfizzbuzz = b.addSharedLibrary(.{
                .name = "fizzbuzz",
                .root_source_file = b.path("zig/src/fizzbuzz.zig"),
                .target = target,
                .optimize = optimize,
                .version = .{ .major = 0, .minor = 0, .patch = 1 },
            });

            b.installArtifact(libfizzbuzz);
        }
    }
}

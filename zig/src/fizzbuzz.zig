const std = @import("std");

// The code here is specific to Lua 5.1
// This has been tested with LuaJIT 5.1, specifically
pub const c = @cImport({
    @cInclude("luaconf.h");
    @cInclude("lua.h");
    @cInclude("lualib.h");
    @cInclude("lauxlib.h");
});

// It can be convenient to store a short reference to the Lua struct when
// it is used multiple times throughout a file.
const LuaState = c.lua_State;
const FnReg = c.luaL_Reg;

export fn fizzbuzz(lua: ?*LuaState) callconv(.C) c_int {
    const n = c.lua_tointeger(lua, 1);
    if (@mod(n, 5) == 0) {
        if (@mod(n, 3) == 0) {
            c.lua_pushstring(lua, "fizzbuzz");
        } else {
            c.lua_pushstring(lua, "fizz");
        }
    } else if (@mod(n, 3) == 0) {
        c.lua_pushstring(lua, "buzz");
    } else {
        c.lua_pushinteger(lua, n);
    }
    return 1;
}

/// Function registration struct for the 'adder' function
const fizzbuzz_reg: FnReg = .{ .name = "fizzbuzz", .func = fizzbuzz };

/// The list of function registrations for our library
/// Note that the last entry must be empty/null as a sentinel value to the luaL_register function
const lib_fn_reg = [_]FnReg{ fizzbuzz_reg, FnReg{} };

/// Register the function with Lua using the special luaopen_x function
/// This is the entrypoint into the library from a Lua script
export fn luaopen_fizzbuzz(lua: ?*LuaState) callconv(.C) c_int {
    c.luaL_register(lua.?, "fizzbuzz", @ptrCast(&lib_fn_reg[0]));
    return 1;
}

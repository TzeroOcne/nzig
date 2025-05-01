local ffi = require("ffi")

-- Update package.cpath to include the DLL location
package.cpath =
  "../zig-out/bin/?.dll;" ..
  "../test/?.dll;" ..
  -- "../test-c/?.dll;" ..
  package.cpath

print("cpath:", package.cpath)
print("looking for: " .. package.searchpath("hello", package.cpath))

-- Load the DLL
-- local lib = ffi.load("../test-c/hello.dll")
local lib = ffi.load("../test/hello.dll")

-- Declare the function signature
ffi.cdef[[
int hello();
]]

print(lib.hello())  -- should print 42

-- -- Test calling the function
-- for i = 1, 20 do
--     local result = fb.fizzbuzz(i)
--     if result ~= nil then
--         print(ffi.string(result))
--     else
--         print(i)
--     end
-- end
--

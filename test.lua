local Regex = require "LuaRegexParser"

local c = Regex("[-A-Za-z0-9_]*?([-A-Za-z_][0-9]|[0-9][-A-Za-z_])[-A-Za-z0-9_]*")

print(c)
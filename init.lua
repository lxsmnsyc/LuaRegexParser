local Parser = require "LuaRegexParser.src.parser"

local Alternation = require "LuaRegexParser.src.rule.alternation"
local Capture = require "LuaRegexParser.src.rule.capture"



local P = Parser("[0-9]{2}%W[0-9]{4}%W[0-9]{7}%W([0-9]{2}|[0-9]{3})")

local function serializeAST(x, prefix, isTail, name)
    prefix = prefix or ""
    name = (name and name..": ") or ""
    
    local report = prefix..(isTail and "└── " or "├── ")..name..(x._token or "Items")
    
    
    prefix = prefix..(isTail and "    " or "│   ")
    
    local function actualSize(t)
        local count = 0
        for k, v in pairs(t) do count = count + 1 end
        return count 
    end
    
    local c = actualSize(x) - (x._token and 1 or 0)
    for k, v in pairs(x) do
        if(type(v) == "table") then
            c = c - 1
            report = report.."\n"..serializeAST(v, prefix, c == 0, k)
        elseif(k ~= "_token") then
            c = c - 1
            report = report.."\n"..prefix..(c == 0 and "└── " or "├── ")..k..": "..tostring(v)
        end
    end
    
    return report
end

local M = {}

local function new(t, pattern)
    local P = Parser(pattern)
    return setmetatable({
        Parser = P,
        AST = Alternation.parse(P)
    }, M)
end

M.__call = new
M.__tostring = function (self)
    return serializeAST(self.AST, "", true)
end

return setmetatable({}, M)
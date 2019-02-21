--[[
    MIT License
    Copyright (c) 2019 Alexis Munsayac
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
--]]
local Parser = require "LuaRegexParser.src.parser"

local OptionFlags = (require "LuaRegexParser.src.rule.optionFlags").parse 

local FLAG = "[iJmsUx]+"

local SET_UNSET_PATTERN = "%(%?"..FLAG.."%-"..FLAG.."%)"

local PATTERNS = {
    ["%(%?"..FLAG.."%)"]    = {"(?", "SET_FLAG",    ")"},
    ["%(%?%-"..FLAG.."%)"]  = {"(?-", "UNSET_FLAG", ")"}
}

local PATTERNS_2 = {
    "NO_START_OPT",
    "UTF8",
    "UTF16",
    "UCP"
}

local M = {}

local function new(t, a, b)
    return setmetatable({
        value = a, unset = b,
        _token = "OPTION"
    }, M)
end

local function parse(parser)
    if(parser:more()) then
        if(parser:eat("(?R)")) then
            return new(nil, "R")
        end
        
        local c = parser:look()
        
        if(c:match(SET_UNSET_PATTERN)) then
            parser:eat("(?")
            local set = OptionFlags(parser)
            parser:eat("-") 
            local unset = OptionFlags(parser)
            parser:eat(")")
            return new(nil, {
                _token = "SET_FLAG",
                value = set
            }, {
                _token = "UNSET_FLAG",
                value = unset
            })
        end
        
        for pattern, e in pairs(PATTERNS) do 
            if(c:match(pattern)) then
                parser:eat(e[1])
                local c = OptionFlags(parser)
                parser:eat(e[3])
                return new(nil, {
                    value = c,
                    _token = e[2]
                })
            end
        end
        
        for k, v in pairs(PATTERNS_2) do
            if(parser:eat("(*"..v..")")) then
                return new(nil, v)
            end
        end
    end
end

M.__call = new

return setmetatable({
    parse = parse
}, M)
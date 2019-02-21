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

local POSIXNamedSet = (require "LuaRegexParser.src.symbol.posixNamedSet").parse 
local POSIXNegatedNamedSet = (require "LuaRegexParser.src.symbol.posixNegatedNamedSet").parse
local ControlChar = (require "LuaRegexParser.src.symbol.controlchar").parse
local CharWithProperty = (require "LuaRegexParser.src.symbol.charWithProperty").parse 
local CharWithoutProperty = (require "LuaRegexParser.src.symbol.charWithoutProperty").parse 


local TABLE = {
    ["%d"] = "DECIMAL_DIGIT",
    ["%D"] = "NOT_DECIMAL_DIGIT",
    ["%h"] = "HORIZONTAL_WHITESPACE",
    ["%H"] = "NOT_HORIZONTAL_WHITESPACE",
    ["%N"] = "NOT_NEW_LINE",
    ["%R"] = "NEW_LINE_SEQUENCE",
    ["%s"] = "WHITESPACE",
    ["%S"] = "NOT_WHITESPACE",
    ["%v"] = "VERTICAL_WHITESPACE",
    ["%V"] = "NOT_VERTICAL_WHITESPACE",
    ["%w"] = "WORD_CHAR",
    ["%W"] = "NOT_WORD_CHAR"
}

local M = {}

local function new(t, a)
    return setmetatable({
        value = a,
        _token = "SHARED_ATOM"
    }, M)
end

local function parse(parser)
    if(parser:more()) then
        local c = POSIXNamedSet(parser)
            or POSIXNegatedNamedSet(parser)
            or ControlChar(parser)
            or CharWithProperty(parser)
            or CharWithoutProperty(parser)
            
        if(c) then
            return new(nil, c)
        end
        
        c = parser:peek(2)

        local r = TABLE[c]
        if(r) then
            parser:eat(c)
            return new(nil, {
                _token = r,
                value = c
            })
        end
    end
end

M.__call = new

return setmetatable({
    parse = parse
}, M)
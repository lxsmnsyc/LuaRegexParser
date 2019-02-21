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
local AlphaNumerics = require "LuaRegexParser.src.fragment.alphanumerics"

local M = {}

local function new(t, a)
    return setmetatable({
        value = a,
        _token = "POSIX_NEGATED_NAMED_SET"
    }, M)
end

local function parse(parser)
    if(parser:more() and parser:eat("[[:^")) then
        local c = AlphaNumerics(parser)
        if(c) then
            if(parser:eat(":]]")) then
                return new(nil, c)
            end
        end
        parser:report("expected ':]]'")
    end
end

M.__call = new

return setmetatable({
    parse = parse
}, M)
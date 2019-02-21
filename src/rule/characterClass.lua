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

local CCAtom = (require "LuaRegexParser.src.rule.ccAtom").parse

local M = {}

local function new(t, a, b)
    return setmetatable({
        value = a, negative = b,
        _token = "CHARACTER_CLASS"
    }, M)
end

local function parse(parser)
    if(parser:more()) then
        local negative = parser:eat("[^")
        if(negative or parser:eat("[")) then 
            local atoms = {}
            local atom = CCAtom(parser)
            while(atom) do 
                atoms[#atoms + 1] = atom 
                atom = CCAtom(parser)
            end 
            if(parser:eat("]")) then 
                return new(nil, atoms, negative)
            end
            parser:report("expected ']'")
        end 
    end
end

M.__call = new

return setmetatable({
    parse = parse
}, M)
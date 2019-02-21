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
local M = {}

local function newParser(_, input)
    return setmetatable({
        _input = input,
        _size = #input,
        _cursor = 1
    }, M)
end

local min = math.min

local function look(parser)
    return parser._input:sub(parser._cursor)
end

local function peek(parser, size)
    local cursor = parser._cursor
    return parser._input:sub(cursor, min(cursor + size - 1, parser._size))
end

local function eat(parser, character)
    if(peek(parser, #character) == character) then 
        parser._cursor = parser._cursor + #character
        return true 
    end
    return false 
end

local function nextc(parser)
    local c = peek(parser)
    eat(c)
    return c
end

local function more(parser)
    return parser._size >= parser._cursor
end

local function report(parser, msg)
    local cursor = parser._cursor 
    local input = parser._input
    error(
        msg.." at character "..cursor..
        "\n"..input..
        "\n"..string.rep(" ", cursor - 1).."^"
    , 0)
end

M.__call = newParser
M.__index = {
    peek = peek,
    eat = eat,
    nextc = nextc,
    more = more,
    report = report,
    look = look
}

return setmetatable({}, M)
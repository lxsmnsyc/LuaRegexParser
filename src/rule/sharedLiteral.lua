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

local OctalChar = (require "LuaRegexParser.src.rule.octalchar").parse
local Letter = (require "LuaRegexParser.src.symbol.letter").parse
local Digit = (require "LuaRegexParser.src.symbol.digit").parse
local HexChar = (require "LuaRegexParser.src.symbol.hexchar").parse
local Quoted = (require "LuaRegexParser.src.symbol.quoted").parse
local BlockQuoted = (require "LuaRegexParser.src.symbol.blockquoted").parse

local TABLE = {
    ["&"] = "AMPERSAND",
    ["!"] = "EXCLAMATION",
    ["="] = "EQUALS",
    ["#"] = "HASH",
    [":"] = "COLON",
    ["_"] = "UNDERSCORE",
    ["'"] = "SINGLE_QUOTE",
    [">"] = "GREATER_THAN",
    ["<"] = "LESS_THAN",
    ["-"] = "HYPHEN",
    [","] = "COMMA",
    ["{"] = "OPEN_BRACE",
    ["}"] = "CLOSE_BRACE",
    ["\a"] = "BELL_CHAR",
    ["\27"] = "ESCAPE_CHAR",
    ["\f"] = "FORM_FEED",
    ["\n"] = "NEW_LINE",
    ["\r"] = "CARRIAGE_RETURN",
    ["\t"] = "TAB"
}

local DTABLE = {
    ["%a"] = "BELL_CHAR",
    ["%e"] = "ESCAPE_CHAR",
    ["%f"] = "FORM_FEED",
    ["%n"] = "NEW_LINE",
    ["%r"] = "CARRIAGE_RETURN",
    ["%t"] = "TAB"
}


local M = {}

local function new(t, a)
    return setmetatable({
        value = a,
        _token = "SHARED_LITERAL"
    }, M)
end

local function parse(parser)
    if(parser:more()) then
        local c = OctalChar(parser)
            or Letter(parser)
            or Digit(parser)
            or HexChar(parser)
            or BlockQuoted(parser)
            or Quoted(parser)
            
        if(c) then
            return new(nil, c)
        end
        
        c = parser:peek(1)

        local r = TABLE[c]
        if(r) then
            parser:eat(c)
            return new(nil, {
                _token = r,
                value = c
            })
        end
        
        c = parser:peek(2)

        r = DTABLE[c]
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
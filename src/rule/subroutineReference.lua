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

local Name = (require "LuaRegexParser.src.rule.name").parse
local Digits = (require "LuaRegexParser.src.rule.digits").parse

local DIGIT = "[0-9]+"
local NAME = "[a-zA-Z_][a-zA-Z0-9_]*"

local DTABLE = {
    ["%(%?"..DIGIT.."%)"]       = {"(?",    "ABSOLUTE_NUMBER", ")"},
    ["%(%?%+"..DIGIT.."%)"]     = {"(?+",   "POSITIVE_NUMBER", ")"},
    ["%(%?%-"..DIGIT.."%)"]     = {"(?-",   "NEGATIVE_NUMBER", ")"},
    ["%%g%<"..DIGIT.."%>"]      = {"%g<",   "ABSOLUTE_NUMBER", ">"},
    ["%%g%'"..DIGIT.."%'"]      = {"%g'",   "ABSOLUTE_NUMBER", "'"},
    ["%%g%<%+"..DIGIT.."%>"]    = {"%g<+",  "POSITIVE_NUMBER", ">"},
    ["%%g%'%+"..DIGIT.."%'"]    = {"%g'+",  "POSITIVE_NUMBER", "'"},
    ["%%g%<%-"..DIGIT.."%>"]    = {"%g<-",  "NEGATIVE_NUMBER", ">"},
    ["%%g%'%-"..DIGIT.."%'"]    = {"%g'-",  "NEGATIVE_NUMBER", "'"},
    
}

local NTABLE = {
    ["%(%?%&"..NAME.."%)"]  = {"(?&",   "NAME", ")"},
    ["%(%?P%>"..NAME.."%)"] = {"(?P>",  "NAME", ")"},
    ["%%g%<"..NAME.."%>"]   = {"%g<",   "NAME", ">"},
    ["%%g%'"..NAME.."%'"]   = {"%g'",   "NAME", "'"}
}

local M = {}

local function new(t, a, b)
    return setmetatable({
        value = a, 
        _token = "SUBROUTINE_REFERENCE"
    }, M)
end

local function parse(parser)
    if(parser:more()) then
        if(parser:eat("(?R)")) then
            return new(nil, "R")
        end
        
        local c = parser:look()
        
        for pattern, e in pairs(DTABLE) do 
            if(c:match(pattern)) then
                parser:eat(e[1])
                local c = Digits(parser)
                parser:eat(e[3])
                return new(nil, {
                    value = c,
                    _token = e[2]
                })
            end
        end
        for pattern, e in pairs(NTABLE) do 
            if(c:match(pattern)) then
                parser:eat(e[1])
                local c = Name(parser)
                parser:eat(e[3])
                return new(nil, {
                    value = c,
                    _token = e[2]
                })
            end
        end
    end
end

M.__call = new

return setmetatable({
    parse = parse
}, M)
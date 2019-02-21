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
local Digits = (require "LuaRegexParser.src.rule.digits").parse 
local Name = (require "LuaRegexParser.src.rule.name").parse

local NUMBER = "[0-9]+"
local NAME = "[a-zA-Z_][a-zA-Z0-9_]*"

local DTABLE = {
    ["%%g"..NUMBER] = {"%g", "BY_NUMBER", ""},
    ["%%g%{"..NUMBER.."%}"] = {"%g{", "BY_NUMBER", "}"},
    ["%%g%{%-"..NUMBER.."%}"] = {"%g{-", "BY_RELATIVE_NUMBER", "}"},
}

local NTABLE = {
    ["%%k%<"..NAME.."%>"] = {"%k<", "BY_NAME", ">"},
    ["%%k%'"..NAME.."%'"] = {"%k'", "BY_NAME", "'"},
    ["%%g%{"..NAME.."%}"] = {"%g{", "BY_NAME", "}"},
    ["%%k%{"..NAME.."%}"] = {"%k{", "BY_NAME", "}"},
    ["%(%?P%="..NAME.."%)"] = {"(?P=", "BY_NAME", ")"}
}

local M = {}

local function new(t, a)
    return setmetatable({
        value = a, 
        _token = "BACKREFERENCE"
    }, M)
end

local function parse(parser)
    if(parser:more()) then
        local c = OctalChar(parser)
        if(c) then
            return new(nil, c)
        end
        
        c = parser:look()
        if(c:match("%%[0-9]")) then
            parser:eat("%")
            c = parser:peek(1):match("[0-9]")
            parser:eat(c)
            return new(t, c) 
        end
        
        for k, v in pairs(DTABLE) do 
            if(c:match(k)) then 
                parser:eat(v[1])
                local r = Digits(parser)
                parser:eat(v[3])
                return new(nil, {
                    value = r,
                    _token = v[2]
                })
            end 
        end
        for k, v in pairs(NTABLE) do 
            if(c:match(k)) then 
                parser:eat(v[1])
                local r = Name(parser)
                parser:eat(v[3])
                return new(nil, {
                    value = r,
                    _token = v[2]
                })
            end 
        end
    end
end

M.__call = new

return setmetatable({
    parse = parse
}, M)
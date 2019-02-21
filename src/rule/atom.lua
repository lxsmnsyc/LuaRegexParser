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

local SubroutineReference = (require "LuaRegexParser.src.rule.subroutineReference").parse
local SharedAtom = (require "LuaRegexParser.src.rule.sharedAtom").parse
local Literal = (require "LuaRegexParser.src.rule.literal").parse
local CharacterClass = (require "LuaRegexParser.src.rule.characterClass").parse
local Capture = (require "LuaRegexParser.src.rule.capture").parse

local Comment = (require "LuaRegexParser.src.rule.comment").parse
local Option = (require "LuaRegexParser.src.rule.option").parse

local Backreference = (require "LuaRegexParser.src.rule.backreference").parse

local BacktrackControl = (require "LuaRegexParser.src.rule.backtrackControl").parse
local NewLineConvention = (require "LuaRegexParser.src.rule.newLineConvention").parse
local Callout = (require "LuaRegexParser.src.rule.callout").parse

local TABLE = {
    ["."] = "DOT",
    ["^"] = "CARET",
    ["$"] = "END_OF_SUBJECT_OR_LINE"
}   

local DTABLE = {
    ["%A"] = "START_OF_SUBJECT",
    ["%b"] = "WORD_BOUNDARY",
    ["%B"] = "NON_WORD_BOUNDARY",
    ["%z"] = "END_OF_SUBJECT",
    ["%Z"] = "END_OR_LINE_END_OF_SUBJECT",
    ["%G"] = "PREVIOUS_MATCH_IN_SUBJECT",
    ["%K"] = "RESET_START_MATCH",
    ["%X"] = "EXTENDED_UNICODE_CHAR",
    ["%C"] = "ONE_DATA_UNIT"
}

local M = {}

local function new(t, a)
    return setmetatable({
        value = a,
        _token = "ATOM"
    }, M)
end

local function parse(parser)
    if(parser:more()) then
        local c = SubroutineReference(parser)
            or SharedAtom(parser)
            or CharacterClass(parser)
            or Capture(parser)
              
            or Comment(parser)
            or Option(parser)
            
            or Backreference(parser)
            
            or BacktrackControl(parser)
            or NewLineConvention(parser)
            or Callout(parser)
            
        if(c) then
            return new(nil, c)
        end 
        
        c = parser:peek(2)
        local r = DTABLE[c]
        if(r) then
            parser:eat(c)
            return new(nil, {
                value = c,
                _token = r
            })
        end
        
        
        
        r = Literal(parser)
        if(r) then 
            return new(nil, r)
        end
    end
end


M.__call = new

return setmetatable({
    parse = parse
}, M)
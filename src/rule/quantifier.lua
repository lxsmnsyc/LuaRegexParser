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
local Digits = (require "LuaRegexParser.src.rule.digits").parse

local DIGITS = "[0-9]+"

local PSTABLE = {
    ["?"] = {"?", "OPTIONAL_NON_GREEDY"},
    ["*"] = {"*", "ZERO_OR_MORE_NON_GREEDY"},
    ["+"] = {"+", "ONE_OR_MORE_NON_GREEDY"},
}

local PTABLE = {
    ["?+"] = {"?+", "OPTIONAL_POSSESSIVE"},
    ["*+"] = {"*+", "ZERO_OR_MORE_POSSESSIVE"},
    ["++"] = {"++", "ONE_OR_MORE_POSSESSIVE"},
    ["??"] = {"??", "OPTIONAL_LAZY"},
    ["*?"] = {"*?", "ZERO_OR_MORE_LAZY"},
    ["+?"] = {"+?", "ONE_OR_MORE_LAZY"},
}

local RSTABLE = {
    ["%{"..DIGITS.."%}"] = {"{", "EXACT_GREEDY", "}"},
    ["%{"..DIGITS.."%,%}"] = {"{", "MORE_GREEDY", "}"},
}

local RTABLE = {
    ["%{"..DIGITS.."%}%+"] = {"{", "EXACT_POSSESSIVE", "}+"},
    ["%{"..DIGITS.."%,%}%+"] = {"{", "MORE_POSSESSIVE", ",}+"},
    ["%{"..DIGITS.."%}%?"] = {"{", "EXACT_LAZY", "}?"},
    ["%{"..DIGITS.."%,%}%?"] = {"{", "MORE_LAZY", ",}?"},
}

local DSTABLE = {
    ["%{"..DIGITS.."%,"..DIGITS.."%}"] = {"{", "RANGE_GREEDY", "}"},
}

local DTABLE = {
    ["%{"..DIGITS.."%,"..DIGITS.."%}%+"] = {"{", "RANGE_POSSESSIVE", "}+"},
    ["%{"..DIGITS.."%,"..DIGITS.."%}%?"] = {"{", "RANGE_LAZY", "}?"},
}

local M = {}

local function new(t, a)
    return setmetatable({
        value = a, 
        _token = "QUANTIFIER"
    }, M)
end

local function parse(parser)
    if(parser:more()) then
        local c = parser:look()
        
        local function iterate(t, fn)
            for k, v in pairs(t) do 
                local x = fn(k, v)
                if(x) then 
                    return x
                end
            end
        end
        
        local function iterateSingle(t)
            return iterate(t, function (k, v)
                if(parser:eat(k)) then 
                    parser:eat(k)
                    return new(nil, v[2])
                end
            end)
        end
        
        local function iterateMore(t)
            return iterate(t, function (k, v)
                if(c:match(k)) then 
                    parser:eat(v[1])
                    local r = Digits(parser)
                    parser:eat(v[3])
                    return new(nil, {
                        value = r,
                        _token = v[2]
                    })
                end
            end)
        end
        
        local function iterateDouble(t)
            return iterate(t, function (k, v)
                if(c:match(k)) then 
                    parser:eat(v[1])
                    local a = Digits(parser)
                    parser:eat(",")
                    local b = Digits(parser)
                    parser:eat(v[3])
                    return new(nil, {
                        min = a, max = b,
                        _token = v[2]
                    })
                end
            end)
        end
        
        return iterateSingle(PTABLE)
            or iterateSingle(PSTABLE)
        
            or iterateMore(RTABLE)
            or iterateMore(RSTABLE)
        
            or iterateDouble(DTABLE)
            or iterateDouble(DSTABLE)
    end
end


M.__call = new

return setmetatable({
    parse = parse
}, M)
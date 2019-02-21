# LuaRegexParser
a PCRE  Regex Parser that outputs an AST of the Regex Pattern

## Example
```lua
local Regex = require "LuaRegexParser"

local c = Regex("[-A-Za-z0-9_]*?([-A-Za-z_][0-9]|[0-9][-A-Za-z_])[-A-Za-z0-9_]*")

print(c)
```
Output:
```
└── ALTERNATION
    └── value: Items
        └── 1: EXPRESSION
            └── value: Items
                ├── 1: ELEMENT
                │   ├── quantifier: QUANTIFIER
                │   │   └── value: ZERO_OR_MORE_LAZY
                │   └── atom: ATOM
                │       └── value: CHARACTER_CLASS
                │           ├── value: Items
                │           │   ├── 1: CC_ATOM
                │           │   │   └── min: CC_LITERAL
                │           │   │       └── value: SHARED_LITERAL
                │           │   │           └── value: HYPHEN
                │           │   │               └── value: -
                │           │   ├── 2: CC_ATOM
                │           │   │   ├── min: CC_LITERAL
                │           │   │   │   └── value: SHARED_LITERAL
                │           │   │   │       └── value: LETTER
                │           │   │   │           └── value: A
                │           │   │   └── max: CC_LITERAL
                │           │   │       └── value: SHARED_LITERAL
                │           │   │           └── value: LETTER
                │           │   │               └── value: Z
                │           │   ├── 3: CC_ATOM
                │           │   │   ├── min: CC_LITERAL
                │           │   │   │   └── value: SHARED_LITERAL
                │           │   │   │       └── value: LETTER
                │           │   │   │           └── value: a
                │           │   │   └── max: CC_LITERAL
                │           │   │       └── value: SHARED_LITERAL
                │           │   │           └── value: LETTER
                │           │   │               └── value: z
                │           │   ├── 4: CC_ATOM
                │           │   │   ├── min: CC_LITERAL
                │           │   │   │   └── value: SHARED_LITERAL
                │           │   │   │       └── value: DIGIT
                │           │   │   │           └── value: 0
                │           │   │   └── max: CC_LITERAL
                │           │   │       └── value: SHARED_LITERAL
                │           │   │           └── value: DIGIT
                │           │   │               └── value: 9
                │           │   └── 5: CC_ATOM
                │           │       └── min: CC_LITERAL
                │           │           └── value: SHARED_LITERAL
                │           │               └── value: UNDERSCORE
                │           │                   └── value: _
                │           └── negative: false
                ├── 2: ELEMENT
                │   └── atom: ATOM
                │       └── value: CAPTURE
                │           └── alt: ALTERNATION
                │               └── value: Items
                │                   ├── 1: EXPRESSION
                │                   │   └── value: Items
                │                   │       ├── 1: ELEMENT
                │                   │       │   └── atom: ATOM
                │                   │       │       └── value: CHARACTER_CLASS
                │                   │       │           ├── value: Items
                │                   │       │           │   ├── 1: CC_ATOM
                │                   │       │           │   │   └── min: CC_LITERAL
                │                   │       │           │   │       └── value: SHARED_LITERAL
                │                   │       │           │   │           └── value: HYPHEN
                │                   │       │           │   │               └── value: -
                │                   │       │           │   ├── 2: CC_ATOM
                │                   │       │           │   │   ├── min: CC_LITERAL
                │                   │       │           │   │   │   └── value: SHARED_LITERAL
                │                   │       │           │   │   │       └── value: LETTER
                │                   │       │           │   │   │           └── value: A
                │                   │       │           │   │   └── max: CC_LITERAL
                │                   │       │           │   │       └── value: SHARED_LITERAL
                │                   │       │           │   │           └── value: LETTER
                │                   │       │           │   │               └── value: Z
                │                   │       │           │   ├── 3: CC_ATOM
                │                   │       │           │   │   ├── min: CC_LITERAL
                │                   │       │           │   │   │   └── value: SHARED_LITERAL
                │                   │       │           │   │   │       └── value: LETTER
                │                   │       │           │   │   │           └── value: a
                │                   │       │           │   │   └── max: CC_LITERAL
                │                   │       │           │   │       └── value: SHARED_LITERAL
                │                   │       │           │   │           └── value: LETTER
                │                   │       │           │   │               └── value: z
                │                   │       │           │   └── 4: CC_ATOM
                │                   │       │           │       └── min: CC_LITERAL
                │                   │       │           │           └── value: SHARED_LITERAL
                │                   │       │           │               └── value: UNDERSCORE
                │                   │       │           │                   └── value: _
                │                   │       │           └── negative: false
                │                   │       └── 2: ELEMENT
                │                   │           └── atom: ATOM
                │                   │               └── value: CHARACTER_CLASS
                │                   │                   ├── value: Items
                │                   │                   │   └── 1: CC_ATOM
                │                   │                   │       ├── min: CC_LITERAL
                │                   │                   │       │   └── value: SHARED_LITERAL
                │                   │                   │       │       └── value: DIGIT
                │                   │                   │       │           └── value: 0
                │                   │                   │       └── max: CC_LITERAL
                │                   │                   │           └── value: SHARED_LITERAL
                │                   │                   │               └── value: DIGIT
                │                   │                   │                   └── value: 9
                │                   │                   └── negative: false
                │                   └── 2: EXPRESSION
                │                       └── value: Items
                │                           ├── 1: ELEMENT
                │                           │   └── atom: ATOM
                │                           │       └── value: CHARACTER_CLASS
                │                           │           ├── value: Items
                │                           │           │   └── 1: CC_ATOM
                │                           │           │       ├── min: CC_LITERAL
                │                           │           │       │   └── value: SHARED_LITERAL
                │                           │           │       │       └── value: DIGIT
                │                           │           │       │           └── value: 0
                │                           │           │       └── max: CC_LITERAL
                │                           │           │           └── value: SHARED_LITERAL
                │                           │           │               └── value: DIGIT
                │                           │           │                   └── value: 9
                │                           │           └── negative: false
                │                           └── 2: ELEMENT
                │                               └── atom: ATOM
                │                                   └── value: CHARACTER_CLASS
                │                                       ├── value: Items
                │                                       │   ├── 1: CC_ATOM
                │                                       │   │   └── min: CC_LITERAL
                │                                       │   │       └── value: SHARED_LITERAL
                │                                       │   │           └── value: HYPHEN
                │                                       │   │               └── value: -
                │                                       │   ├── 2: CC_ATOM
                │                                       │   │   ├── min: CC_LITERAL
                │                                       │   │   │   └── value: SHARED_LITERAL
                │                                       │   │   │       └── value: LETTER
                │                                       │   │   │           └── value: A
                │                                       │   │   └── max: CC_LITERAL
                │                                       │   │       └── value: SHARED_LITERAL
                │                                       │   │           └── value: LETTER
                │                                       │   │               └── value: Z
                │                                       │   ├── 3: CC_ATOM
                │                                       │   │   ├── min: CC_LITERAL
                │                                       │   │   │   └── value: SHARED_LITERAL
                │                                       │   │   │       └── value: LETTER
                │                                       │   │   │           └── value: a
                │                                       │   │   └── max: CC_LITERAL
                │                                       │   │       └── value: SHARED_LITERAL
                │                                       │   │           └── value: LETTER
                │                                       │   │               └── value: z
                │                                       │   └── 4: CC_ATOM
                │                                       │       └── min: CC_LITERAL
                │                                       │           └── value: SHARED_LITERAL
                │                                       │               └── value: UNDERSCORE
                │                                       │                   └── value: _
                │                                       └── negative: false
                └── 3: ELEMENT
                    ├── quantifier: QUANTIFIER
                    │   └── value: ZERO_OR_MORE_NON_GREEDY
                    └── atom: ATOM
                        └── value: CHARACTER_CLASS
                            ├── value: Items
                            │   ├── 1: CC_ATOM
                            │   │   └── min: CC_LITERAL
                            │   │       └── value: SHARED_LITERAL
                            │   │           └── value: HYPHEN
                            │   │               └── value: -
                            │   ├── 2: CC_ATOM
                            │   │   ├── min: CC_LITERAL
                            │   │   │   └── value: SHARED_LITERAL
                            │   │   │       └── value: LETTER
                            │   │   │           └── value: A
                            │   │   └── max: CC_LITERAL
                            │   │       └── value: SHARED_LITERAL
                            │   │           └── value: LETTER
                            │   │               └── value: Z
                            │   ├── 3: CC_ATOM
                            │   │   ├── min: CC_LITERAL
                            │   │   │   └── value: SHARED_LITERAL
                            │   │   │       └── value: LETTER
                            │   │   │           └── value: a
                            │   │   └── max: CC_LITERAL
                            │   │       └── value: SHARED_LITERAL
                            │   │           └── value: LETTER
                            │   │               └── value: z
                            │   ├── 4: CC_ATOM
                            │   │   ├── min: CC_LITERAL
                            │   │   │   └── value: SHARED_LITERAL
                            │   │   │       └── value: DIGIT
                            │   │   │           └── value: 0
                            │   │   └── max: CC_LITERAL
                            │   │       └── value: SHARED_LITERAL
                            │   │           └── value: DIGIT
                            │   │               └── value: 9
                            │   └── 5: CC_ATOM
                            │       └── min: CC_LITERAL
                            │           └── value: SHARED_LITERAL
                            │               └── value: UNDERSCORE
                            │                   └── value: _
                            └── negative: false
```

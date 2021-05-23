Pointer = 1;
Tokens = {};

function Peek(offset)
    return string.sub(Code, Pointer + offset, Pointer + offset);
end

function Current()
    return Peek(0);
end

function EOF()
    return Pointer > string.len(Code);
end

function Step(offset)
    Pointer = Pointer + offset;
end

function LexNumber()
    local num = "";
    while (isDigit(Current()) and not EOF()) do
        num = num .. Current();
        Step(1);
    end
    return num;
end

function LexKeyword()
    local key = "";
    while (isLetter(Current()) and not EOF()) do
        key = key .. Current();
        Step(1);
    end
    return key;
end

function KeywordType(key)
    for k, value in pairs(Keywords) do
        if (key == value) then return value .. "kw"; end
    end
    return "identifier";
end

function LexString()
    local str = "";
    Step(1);

    while (Current() ~= "\"") do
        if EOF() then print("[!] Unterminated string!"); os.exit() end

        str = str .. Current();
        Step(1);
    end
    Step(1);

    return str;
end

function LexComment()
    Step(1);

    while (Current() ~= "\n") do
        if EOF() then break end
        Step(1);
    end
    return "#";
end

function Lex()
    while(Pointer < string.len(Code)) do
        local token = {};
        local index = Pointer;

        -- Whitespaces
        if (Current() == " ") then token.type = "whitespace"; token.value = Current(); Step(1); end
        if (Current() == "\n") then token.type = "whitespace"; token.value = Current(); Step(1); end
        if (Current() == "\r") then token.type = "whitespace"; token.value = Current(); Step(1); end
        if (Current() == "\t") then token.type = "whitespace"; token.value = Current(); Step(1); end

        -- Operators
        if (Current() == "+") then token.type = "plus"; token.value = Current(); Step(1); end
        if (Current() == "-") then token.type = "minus"; token.value = Current(); Step(1); end
        if (Current() == "*") then token.type = "times"; token.value = Current(); Step(1); end
        if (Current() == "/") then token.type = "divide"; token.value = Current(); Step(1); end
        if (Current() == ".") then token.type = "concat"; token.value = Current(); Step(1); end

        -- Comperators
        if (Current() == "=") then token.type = "equals"; token.value = Current(); Step(1); end
        if (Current() == "<" and Peek(1) ~= "=") then token.type = "lessthan"; token.value = Current(); Step(1); end
        if (Current() == ">" and Peek(1) ~= "=") then token.type = "greaterthan"; token.value = Current(); Step(1); end
        if (Current() == "!" and Peek(1) == "=") then token.type = "notequal"; token.value = Current(); Step(2); end
        if (Current() == "<" and Peek(1) == "=") then token.type = "lessequal"; token.value = Current(); Step(2); end
        if (Current() == ">" and Peek(1) == "=") then token.type = "greaterequal"; token.value = Current(); Step(2); end

        -- Brackets
        if (Current() == "{") then token.type = "openbrace"; token.value = Current(); Step(1); end
        if (Current() == "}") then token.type = "closebrace"; token.value = Current(); Step(1); end
        if (Current() == "[") then token.type = "openbracket"; token.value = Current(); Step(1); end
        if (Current() == "]") then token.type = "closebracket"; token.value = Current(); Step(1); end

        -- Prefixes
        if (Current() == ":") then token.type = "labelprefix"; token.value = Current(); Step(1); end

        -- Numbers
        if (isDigit(Current())) then token.type = "number"; token.value = LexNumber(); end

        -- Strings
        if (Current() == "\"") then token.type = "string"; token.value = LexString(); end

        -- Keywords
        if (isLetter(Current())) then token.value = LexKeyword(); token.type = KeywordType(token.value) end

        -- Comments
        if (Current() == "#") then token.type = "whitespace"; token.value = LexComment(); end
        if (Current() == ";") then token.type = "whitespace"; token.value = LexComment(); end

        if (index == Pointer) then
            print("[!] Unknown Symbol: " .. Current());
            os.exit();
        end

        table.insert(Tokens, token);
    end

    local token = {}
    token.type = "EOF"
    token.value = "---"
    table.insert(Tokens, token);
end
Statements = {};

function Cur()
    return Pek(0);
end

function Pek(offset)
    return Tokens[Pointer + offset]
end

function Skip()
    while (Cur().type == "whitespace") do
        Step(1);
    end
end

function Consume(type)
    Skip();
    if (Cur().type == type) then 
        Step(1);
        return Pek(-1);
    else
        print("[!] Expected " .. type .. " but got " .. Cur().type .. " instead.");
        os.exit();
    end
end

function ConsumeNext()
    Skip();
    Step(1);
    return Pek(-1);
end

function ParseKeyword()
    if (Cur().type == "printkw") then
        return ParsePrint();
    elseif (Cur().type == "writekw") then
        return ParseWrite();
    elseif (Cur().type == "inputkw") then
        return ParseInput();
    elseif (Cur().type == "colorkw") then
        return ParseColor();
    elseif (Cur().type == "clearkw") then
        return ParseClear();
    elseif (Cur().type == "setkw") then
        return ParseSet();
    elseif (Cur().type == "addkw") then
        return ParseAdd();
    elseif (Cur().type == "subkw") then
        return ParseSub();
    elseif (Cur().type == "mulkw") then
        return ParseMul();
    elseif (Cur().type == "divkw") then
        return ParseDiv();
    elseif (Cur().type == "conkw") then
        return ParseCon();
    elseif (Cur().type == "intkw") then
        return ParseInt();
    elseif (Cur().type == "gotokw") then
        return ParseGoto();
    elseif (Cur().type == "gotosubkw") then
        return ParseSubroutine();
    elseif (Cur().type == "returnkw") then
        return ParseReturn();
    elseif (Cur().type == "diekw") then
        return ParseDie();
    elseif (Cur().type == "ifkw") then
        return ParseIf();
    end
end

dofile("./parsefuncs.lua");

function Parse()
    Pointer = 1;

    while (Cur().type ~= "EOF") do
        Skip();
        if (string.sub(Cur().type, string.len(Cur().type) - 1, string.len(Cur().type)) == "kw") then
            table.insert(Statements, ParseKeyword());
        elseif (Cur().type == "labelprefix") then
            table.insert(Statements, ParseLabel());
        elseif (Cur().type == "EOF") then
            return;
        else
            print("[!] Only Keywords or Labels are allowed globally! (Got: "..Cur().type..")");
            os.exit();
        end
    end
end
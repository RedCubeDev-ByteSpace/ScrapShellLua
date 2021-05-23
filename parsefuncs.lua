function ParseExpression()
    Skip();

    if (Cur().type == "string") then
        return {["type"] = "string", ["value"] = Consume("string").value};
    elseif (Cur().type == "number") then
        return {["type"] = "number", ["value"] = Consume("number").value};
    elseif (Cur().type == "identifier") then
        return {["type"] = "variable", ["value"] = Consume("identifier").value};
    elseif (Cur().type == "openbracket") then
        Consume("openbracket"); Skip();
        local statement = ParseKeyword();
        Consume("closebracket");
        return {["type"] = "statement", ["value"] = statement};
    end

    print("[!] Failed to parse Expression! Got: " .. Cur().type);
    os.exit();
end

function ParsePrint()
    local printkw = Consume("printkw");
    local args = {};
    table.insert(args, ParseExpression());

    return {["Cmd"] = printkw.value, ["Args"] = args};
end

function ParseWrite()
    local writekw = Consume("writekw");
    local args = {};
    table.insert(args, ParseExpression());

    return {["Cmd"] = writekw.value, ["Args"] = args};
end

function ParseInput()
    local inputkw = Consume("inputkw");
    local args = {};

    return {["Cmd"] = inputkw.value, ["Args"] = args};
end

function ParseColor()
    local colorkw = Consume("colorkw");
    local args = {};
    table.insert(args, ParseExpression());

    return {["Cmd"] = colorkw.value, ["Args"] = args};
end

function ParseClear()
    local clearkw = Consume("clearkw");
    local args = {};

    return {["Cmd"] = clearkw.value, ["Args"] = args};
end

function ParseSet()
    local setkw = Consume("setkw");
    local args = {};
    table.insert(args, Consume("identifier"));
    Consume("equals")
    table.insert(args, ParseExpression());

    return {["Cmd"] = setkw.value, ["Args"] = args};
end

function ParseDie()
    local diekw = Consume("diekw");
    local args = {};

    return {["Cmd"] = diekw.value, ["Args"] = args};
end

function ParseIf()
    local ifkw = Consume("ifkw");
    local args = {};
    table.insert(args, ParseExpression());
    table.insert(args, ConsumeNext());
    table.insert(args, ParseExpression());

    if (Cur().type == "greaterthan") then
        table.insert(args, Consume("greaterthan"));
    else
        table.insert(args, Consume("labelprefix"));
    end

    table.insert(args, Consume("identifier"));

    if (Cur().type == "elsekw") then
        table.insert(args, Consume("elsekw"));
        
        if (Cur().type == "greaterthan") then
            table.insert(args, Consume("greaterthan"));
        else
            table.insert(args, Consume("labelprefix"));
        end
    
        table.insert(args, Consume("identifier"));
    end

    return {["Cmd"] = ifkw.value, ["Args"] = args};
end

function ParseLabel()
    local labelprefix = Consume("labelprefix");
    local args = {};
    table.insert(args, Consume("identifier"));

    return {["Cmd"] = "label", ["Args"] = args};
end

function ParseGoto()
    local gotokw = Consume("gotokw");
    local args = {};
    table.insert(args, Consume("identifier"));

    return {["Cmd"] = gotokw.value, ["Args"] = args};
end

function ParseSubroutine()
    local gotosubkw = Consume("gotosubkw");
    local args = {};
    table.insert(args, Consume("identifier"));

    return {["Cmd"] = gotosubkw.value, ["Args"] = args};
end

function ParseReturn()
    local returnkw = Consume("returnkw");
    local args = {};

    return {["Cmd"] = returnkw.value, ["Args"] = args};
end


function ParseAdd()
    local addkw = Consume("addkw");
    local args = {};
    table.insert(args, ParseExpression());
    table.insert(args, ParseExpression());

    return {["Cmd"] = addkw.value, ["Args"] = args};
end

function ParseSub()
    local subkw = Consume("subkw");
    local args = {};
    table.insert(args, ParseExpression());
    table.insert(args, ParseExpression());

    return {["Cmd"] = subkw.value, ["Args"] = args};
end

function ParseMul()
    local mulkw = Consume("mulkw");
    local args = {};
    table.insert(args, ParseExpression());
    table.insert(args, ParseExpression());

    return {["Cmd"] = mulkw.value, ["Args"] = args};
end

function ParseDiv()
    local divkw = Consume("divkw");
    local args = {};
    table.insert(args, ParseExpression());
    table.insert(args, ParseExpression());

    return {["Cmd"] = divkw.value, ["Args"] = args};
end

function ParseCon()
    local conkw = Consume("conkw");
    local args = {};
    table.insert(args, ParseExpression());
    table.insert(args, ParseExpression());

    return {["Cmd"] = conkw.value, ["Args"] = args};
end

function ParseInt()
    local intkw = Consume("intkw");
    local args = {};
    table.insert(args, ParseExpression());

    return {["Cmd"] = intkw.value, ["Args"] = args};
end
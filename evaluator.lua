Variables = {};
CallStack = {};

function GetValue(expression)
    if (expression.type == "string") then return expression.value end
    if (expression.type == "number") then return tonumber(expression.value) end
    if (expression.type == "statement") then return EvaluateStatement(expression.value) end
    if (expression.type == "variable") then return Variables[expression.value] end
end

function Goto(label)
    for key, value in pairs(Statements) do
        if (value.Cmd == "label" and value.Args[1].value == label) then
            Pointer = key;
            return key;
        end
    end
    print("[!] Couldnt find Label! Got: " .. label);
    os.exit();
end

function GotoSub(label)
    for key, value in pairs(Statements) do
        if (value.Cmd == "label" and value.Args[1].value == label) then
            table.insert(CallStack, Pointer);
            Pointer = key;
            return key;
        end
    end
    print("[!] Couldnt find Label! Got: " .. label);
    os.exit();
end

function EvaluateStatement(stmt)
    if (stmt.Cmd == "print") then
        local v = GetValue(stmt.Args[1]);
        print(v);
        return v;
    elseif (stmt.Cmd == "write") then
        local v = GetValue(stmt.Args[1]);
        io.write(v);
        return v;
    elseif (stmt.Cmd == "input") then
        return io.read();
    elseif (stmt.Cmd == "color") then
        local v = GetValue(stmt.Args[1]);
        io.write(Colors[v]);
        return v;
    elseif (stmt.Cmd == "clear") then
        io.write("\027[H\027[2J")
        return 0;
    elseif (stmt.Cmd == "set") then
        local v = GetValue(stmt.Args[2]);
        Variables[stmt.Args[1].value] = v;
        return v;
    elseif (stmt.Cmd == "goto") then
        Goto(stmt.Args[1].value);
    elseif (stmt.Cmd == "gotosub") then
        GotoSub(stmt.Args[1].value);
    elseif (stmt.Cmd == "return") then
        if (count(CallStack) == 0) then
            print("[!] Callstack empty!");
            os.exit();
        else
            Pointer = CallStack[count(CallStack)]
            table.remove(CallStack, count(CallStack));
        end
    elseif (stmt.Cmd == "die") then
        os.exit();
    elseif (stmt.Cmd == "add") then
        local a = GetValue(stmt.Args[1]);
        local b = GetValue(stmt.Args[2]);
        return tonumber(a) + tonumber(b);
    elseif (stmt.Cmd == "sub") then
        local a = GetValue(stmt.Args[1]);
        local b = GetValue(stmt.Args[2]);
        return tonumber(a) - tonumber(b);
    elseif (stmt.Cmd == "mul") then
        local a = GetValue(stmt.Args[1]);
        local b = GetValue(stmt.Args[2]);
        return tonumber(a) * tonumber(b);
    elseif (stmt.Cmd == "div") then
        local a = GetValue(stmt.Args[1]);
        local b = GetValue(stmt.Args[2]);
        return tonumber(a) / tonumber(b);
    elseif (stmt.Cmd == "con") then
        local a = GetValue(stmt.Args[1]);
        local b = GetValue(stmt.Args[2]);
        return tostring(a) .. tostring(b);
    elseif (stmt.Cmd == "int") then
        local a = GetValue(stmt.Args[1]);
        return math.floor(tonumber(a));
    elseif (stmt.Cmd == "if") then
        local a = GetValue(stmt.Args[1]);
        local b = GetValue(stmt.Args[3]);
        local hasElse = stmt.Args[6] ~= nil;
        
        if (stmt.Args[2].value == "=") then if (a == b) then if (stmt.Args[4].value == ">") then GotoSub(stmt.Args[5].value) else Goto(stmt.Args[5].value) end elseif (hasElse) then if (stmt.Args[7].value == ">") then GotoSub(stmt.Args[8].value) else Goto(stmt.Args[8].value) end end end
        if (stmt.Args[2].value == "<") then if (a < b) then if (stmt.Args[4].value == ">") then GotoSub(stmt.Args[5].value) else Goto(stmt.Args[5].value) end elseif (hasElse) then if (stmt.Args[7].value == ">") then GotoSub(stmt.Args[8].value) else Goto(stmt.Args[8].value) end end end
        if (stmt.Args[2].value == ">") then if (a > b) then if (stmt.Args[4].value == ">") then GotoSub(stmt.Args[5].value) else Goto(stmt.Args[5].value) end elseif (hasElse) then if (stmt.Args[7].value == ">") then GotoSub(stmt.Args[8].value) else Goto(stmt.Args[8].value) end end end
        if (stmt.Args[2].value == "!=") then if (a ~= b) then if (stmt.Args[4].value == ">") then GotoSub(stmt.Args[5].value) else Goto(stmt.Args[5].value) end elseif (hasElse) then if (stmt.Args[7].value == ">") then GotoSub(stmt.Args[8].value) else Goto(stmt.Args[8].value) end end end
        if (stmt.Args[2].value == "<=") then if (a <= b) then if (stmt.Args[4].value == ">") then GotoSub(stmt.Args[5].value) else Goto(stmt.Args[5].value) end elseif (hasElse) then if (stmt.Args[7].value == ">") then GotoSub(stmt.Args[8].value) else Goto(stmt.Args[8].value) end end end
        if (stmt.Args[2].value == ">=") then if (a >= b) then if (stmt.Args[4].value == ">") then GotoSub(stmt.Args[5].value) else Goto(stmt.Args[5].value) end elseif (hasElse) then if (stmt.Args[7].value == ">") then GotoSub(stmt.Args[8].value) else Goto(stmt.Args[8].value) end end end
    end
end

function Evaluate()
    Pointer = 1;
    local len = count(Statements);

    while (Pointer <= len) do
        EvaluateStatement(Statements[Pointer]);
        Pointer = Pointer + 1;
    end
end
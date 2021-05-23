function read_file(path)
    local file = io.open(path, "rb")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

function isDigit(str)
    local set = "1234567890"
    for i = 1, string.len(set), 1 do
        if (string.sub(set, i, i) == str) then return true; end
    end

    return false;
end

function isLetter(str)
    local set = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    for i = 1, string.len(set), 1 do
        if (string.sub(set, i, i) == str) then return true; end
    end

    return false;
end

function genWhitespace(len, max)
    local space = "";
    for i = len, max, 1 do
        space = space .. " ";
    end
    return space;
end

function PrettyPrintTokens()
    Longestkw = 0;
    for key, value in pairs(Tokens) do
        if (value.type ~= "whitespace") then 
            if (string.len(value.type) > Longestkw) then Longestkw = string.len(value.type) end
        end
    end

    Longestval = 0;
    for key, value in pairs(Tokens) do
        if (value.type ~= "whitespace") then 
            if (string.len(value.value) > Longestval) then Longestval = string.len(value.value) end
        end
    end

    for key, value in pairs(Tokens) do
        if (value.type ~= "whitespace") then 
            print("[ Token: \27[32m" .. value.type .. "\27[37m"..genWhitespace(string.len(value.type), Longestkw)..", Value: \27[36m" .. value.value .. "\27[37m"..genWhitespace(string.len(value.value), Longestval).."]");
    
        end
    end
end
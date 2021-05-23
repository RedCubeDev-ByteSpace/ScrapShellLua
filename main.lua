dofile("./helpers.lua");

Verbose = false;
Cod = read_file("./fib.scs");
Code = "";

dofile("./keywords.lua");
dofile("./lexer.lua");
dofile("./parser.lua");
dofile("./evaluator.lua");

local inString = false;
for i = 1, Cod:len(), 1 do
    local char = Cod:sub(i, i);
    if (char == "\"") then inString = not inString; end
    if ((char == "[" or char == "]" or char == ":") and not inString) then Code = Code .. " "; end
    Code = Code .. char;
    if ((char == "[" or char == "]" or char == ":" or char == ">") and not inString) then Code = Code .. " "; end
end

if (Verbose) then print("\nLexer Output:"); end
Lex();
if (Verbose) then PrettyPrintTokens(); end

if (Verbose) then print("\nParser Output:"); end

Parse();

if (Verbose) then 
    for key, value in pairs(Statements) do
        print("\27[37m" .. key .. ": \27[31m" .. value.Cmd);
        for k, v in pairs(value.Args) do
            print("\27[37m |- [ Type: \27[32m" .. v.type .. "\27[37m ]");
        end
    end
end

if (Verbose) then print("\n\27[37mEvaluator Output:"); end

Evaluate();
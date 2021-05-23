dofile("./helpers.lua");

Code = read_file("./test.scs");

dofile("./keywords.lua");
dofile("./lexer.lua");
dofile("./parser.lua");

print("\nLexer Output:");
Lex();
PrettyPrintTokens();

print("\nParser Output:");

Parse();

for key, value in pairs(Statements) do
    print(key .. ": \27[31m" .. value.Cmd);
    for k, v in pairs(value.Args) do
        print("\27[37m |- [ Type: \27[32m" .. v.type .. "\27[37m ]");
    end
end
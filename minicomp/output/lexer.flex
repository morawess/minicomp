import java_cup.runtime.Symbol;

%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{
    private Symbol token(int tipo) {
        return new Symbol(tipo, yyline + 1, yycolumn + 1, yytext());
    }
    private Symbol token(int tipo, Object valor) {
        return new Symbol(tipo, yyline + 1, yycolumn + 1, valor);
    }
%}

LETRA      = [a-zA-Z_]
DIGITO     = [0-9]
ESPACIO    = [ \t\r\n]+
COMENTARIO = "//" [^\n]*

%%

"System.Out.Println"        { return token(sym.IMPRIMIR); }
"IF"                        { return token(sym.IF); }
"ELSE"                      { return token(sym.ELSE); }
"WHILE" | "while"           { return token(sym.WHILE); }
"boolean"                   { return token(sym.BOOLEAN); }
"int"                       { return token(sym.INT); }
"true"                      { return token(sym.LIT_BOOLEANO, Boolean.TRUE); }
"false"                     { return token(sym.LIT_BOOLEANO, Boolean.FALSE); }

{LETRA}({LETRA}|{DIGITO})*  { return token(sym.ID, yytext()); }
{DIGITO}+                   { return token(sym.LIT_ENTERO, Integer.valueOf(yytext())); }
\"[^\"\n]*\"                { return token(sym.CADENA, yytext().substring(1, yytext().length() - 1)); }

"++"                        { return token(sym.INC); }
">="                        { return token(sym.MAYIG); }
"<="                        { return token(sym.MENIG); }
"=="                        { return token(sym.IGUAL); }
"!="                        { return token(sym.DIST); }
">"                         { return token(sym.MAYOR); }
"<"                         { return token(sym.MENOR); }
"+"                         { return token(sym.MAS); }
"-"                         { return token(sym.MENOS); }
"*"                         { return token(sym.POR); }
"/"                         { return token(sym.DIV); }
"%"                         { return token(sym.MOD); }
"="                         { return token(sym.ASIG); }
","                         { return token(sym.COMA); }
";"                         { return token(sym.PYC); }
"("                         { return token(sym.LPAREN); }
")"                         { return token(sym.RPAREN); }
"{"                         { return token(sym.LLAVEA); }
"}"                         { return token(sym.LLAVEC); }

{ESPACIO}                   { /* ignorar */ }
{COMENTARIO}                { /* ignorar */ }
\uFEFF                      { /* ignorar BOM */ }

[^]                         { System.out.println("Error léxico en línea " + (yyline + 1) + ", columna "
                                                 + (yycolumn + 1) + ": carácter no reconocido '" + yytext() + "'");
                              System.exit(1); }
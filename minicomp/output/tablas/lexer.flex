/* Generado por minicomp a partir de la tabla del TP1 — entrada de JFlex */
import java_cup.runtime.Symbol;
import java.util.ArrayList;
import java.util.List;

%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{
    public List<String> errores = new ArrayList<>();

    private Symbol token(int tipo, Object valor) {
        return new Symbol(tipo, yyline + 1, yycolumn + 1, valor);
    }
%}

/* ---------- Definiciones regulares ---------- */
/* NOMBRE = expresión regular   →   se usa en la tabla como {NOMBRE} */
LETRA      = [a-zA-Z_]
DIGITO     = [0-9]
ESPACIO    = [ \t\r\n]+
COMENTARIO = "//" [^\n]*

%%

/* ---------- Reglas (en orden de prioridad) ---------- */
"System.Out.Println"           { /* fila  1 */ return token(sym.IMPRIMIR, yytext()); }
"IF"                           { /* fila  2 */ return token(sym.IF, yytext()); }
"ELSE"                         { /* fila  3 */ return token(sym.ELSE, yytext()); }
"boolean"                      { /* fila  4 */ return token(sym.T_BOOLEANO, yytext()); }
"int"                          { /* fila  5 */ return token(sym.T_ENTERO, yytext()); }
"true" | "false"               { /* fila  6 */ return token(sym.LIT_BOOLEANO, Boolean.valueOf(yytext().equals("verdadero") || yytext().equals("true"))); }
{LETRA}({LETRA}|{DIGITO})*     { /* fila  7 */ return token(sym.ID, yytext()); }
{DIGITO}+                      { /* fila  8 */ return token(sym.LIT_ENTERO, Integer.valueOf(yytext())); }
\"[^\"\n]*\"                   { /* fila  9 */ return token(sym.LIT_CADENA, yytext().substring(1, yytext().length() - 1)); }
"="                            { /* fila 10 */ return token(sym.ASIG, yytext()); }
";"                            { /* fila 11 */ return token(sym.PYC, yytext()); }
"("                            { /* fila 12 */ return token(sym.LPAREN, yytext()); }
")"                            { /* fila 13 */ return token(sym.RPAREN, yytext()); }
"{"                            { /* fila 14 */ return token(sym.LLAVEA, yytext()); }
"}"                            { /* fila 15 */ return token(sym.LLAVEC, yytext()); }
{ESPACIO}                      { /* fila 16: descartar */ }
{COMENTARIO}                   { /* fila 17: descartar */ }

/* ---------- Marca invisible (BOM) que agregan algunos editores al guardar en UTF-8 ---------- */
\uFEFF  { /* ignorar */ }

/* ---------- Cualquier otro carácter: ERROR LÉXICO ---------- */
[^]  { errores.add("Error léxico en línea " + (yyline + 1) + ", columna " + (yycolumn + 1)
                   + ": carácter no reconocido '" + yytext() + "'"); }

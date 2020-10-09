%{
    #include "y.tab.h"
%}

NON_DIGIT           [a-zA-Z_]
DIGIT               [0-9]
ZERO                "0"
IDENTIFIER          ({NON_DIGIT}({NON_DIGIT}|{DIGIT})*)

NON_ZERO_DIGIT      [1-9]
INT_CONST           (({NON_ZERO_DIGIT}{DIGIT}*)|{ZERO}+)
DOT                 "."
DIGIT_SEQ           {DIGIT}+
SIGN                [+-]
EXP_PART            ([eE]{SIGN}?{DIGIT_SEQ})
FLOAT_CONST         (({FRAC_CONST}{EXP_PART}?)|({DIGIT_SEQ}{EXP_PART}))
FRAC_CONST          (({DIGIT_SEQ}?{DOT}{DIGIT_SEQ})|({DIGIT_SEQ}{DOT}))
ESC_SEQ             ([\\][\'\"\?\\abfnrtv])
C_CHAR              ([^\'\\\n']|{ESC_SEQ})
C_CHAR_SEQ          ({C_CHAR}+)
CHAR_CONST          ([\']{C_CHAR_SEQ}[\'])
CONST               ({INT_CONST}|{FLOAT_CONST}|{CHAR_CONST})

S_CHAR              {C_CHAR}
S_CHAR_SEQ          ({S_CHAR}+)
STR_LIT             ([\"]{S_CHAR_SEQ}?[\"])

SINGLE_COMMENT      [/][/].*
MULTI_START         [/][\*]+
INSIDE_MULTI        ([^\*]|([\*]+[^/\*]))
MULTI_END           [\*]+[/]
MULTI_COMMENT       ({MULTI_START}{INSIDE_MULTI}*{MULTI_END})
COMMENT             {MULTI_COMMENT}|{SINGLE_COMMENT}

WHITESPACE          [ \n\t]
PUNCTUATOR          "["|"]"|"("|")"|"{"|"}"|"."|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<"|">"|"^"|"|"|"?"|":"|";"|"="|","|"#"

%%
"break"             { return BREAK;}
"float"             { return FLOAT;}
"static"            { return STATIC;}
"case"              { return CASE;}
"for"               { return FOR;}
"struct"            { return STRUCT;}
"char"              { return CHAR;}
"goto"              { return GOTO;}
"switch"            { return SWITCH;}
"continue"          { return CONTINUE;}
"if"                { return IF;}
"typedef"           { return TYPEDEF;}
"default"           { return DEFAULT;}
"int"               { return INT;}
"union"             { return UNION;}
"do"                { return DO;}
"long"              { return LONG;}
"void"              { return VOID;}
"double"            { return DOUBLE;}
"return"            { return RETURN;}
"while"             { return WHILE;}
"else"              { return ELSE;}
"short"             { return SHORT;}
"extern"            { return EXTERN;}
"sizeof"            { return SIZEOF;}
"volatile"          { return VOLATILE;}
"const"             { return CONST;}
"restrict"          { return RESTRICT;}
"inline"            { return INLINE;}

"->"						{ return ARROW;}
"++"						{ return INCREMENT;}
"--"						{ return DECREMENT;}
"<<"						{ return LEFT_SHIFT;}
">>"						{ return RIGHT_SHIFT;}
"<="						{ return LEQ;}
">="						{ return GEQ;}
"=="						{ return IS_EQUAL;}
"!="						{ return NOT_EQUAL;}
"&&"						{ return AND;}
"||"						{ return OR;}
"..."						{ return TRIPLE_DOT;}
"*="						{ return MULTIPLY_EQUAL;}
"/="						{ return DIVIDE_EQUAL;}
"%="						{ return MOD_EQUAL;}
"+="						{ return PLUS_EQUAL;}
"-="						{ return MINUS_EQUAL;}
"<<="						{ return LEFT_SHIFT_EQUAL;}
">>="                       { return RIGHT_SHIFT_EQUAL;}
"&="						{ return AND_EQUAL;}
"^="						{ return XOR_EQUAL;}
"|="     					{ return OR_EQUAL;}



{COMMENT}           {;}
{PUNCTUATOR}        { return yytext[0];}
{IDENTIFIER}        { return IDENTIFIER;}
{FLOAT_CONST}       { return FLOAT_CONSTANT;}
{CHAR_CONST}        { return CHAR_CONSTANT;}
{STR_LIT}           { return STRING_LITERAL;}
{INT_CONST}         { return INTEGER_CONSTANT;}
{WHITESPACE}        {;}
%%
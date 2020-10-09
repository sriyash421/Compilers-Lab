%{
    #include "header.h"
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

%%
"break"             { return KEYWORD; }
"float"             { return KEYWORD; }
"static"            { return KEYWORD; }
"case"              { return KEYWORD; }
"for"               { return KEYWORD; }
"struct"            { return KEYWORD; }
"char"              { return KEYWORD; }
"goto"              { return KEYWORD; }
"switch"            { return KEYWORD; }
"continue"          { return KEYWORD; }
"if"                { return KEYWORD; }
"typedef"           { return KEYWORD; }
"default"           { return KEYWORD; }
"int"               { return KEYWORD; }
"union"             { return KEYWORD; }
"do"                { return KEYWORD; }
"long"              { return KEYWORD; }
"void"              { return KEYWORD; }
"double"            { return KEYWORD; }
"return"            { return KEYWORD; }
"while"             { return KEYWORD; }
"else"              { return KEYWORD; }
"short"             { return KEYWORD; }
"extern"            { return KEYWORD; }
"sizeof"            { return KEYWORD; }

"..."               { return PUNCTUATOR; }
"="                 { return PUNCTUATOR; }
"%="                { return PUNCTUATOR; }
"+="                { return PUNCTUATOR; }
"*="                { return PUNCTUATOR; }
"/="                { return PUNCTUATOR; }
"-="                { return PUNCTUATOR; }
"<<="               { return PUNCTUATOR; }
">>="               { return PUNCTUATOR; }
"["                 { return PUNCTUATOR; }
"]"                 { return PUNCTUATOR; }
"("                 { return PUNCTUATOR; }
")"                 { return PUNCTUATOR; }
"{"                 { return PUNCTUATOR; }
"}"                 { return PUNCTUATOR; }
"."                 { return PUNCTUATOR; }
"->"                { return PUNCTUATOR; }
"++"                { return PUNCTUATOR; }
"--"                { return PUNCTUATOR; }
"&"                 { return PUNCTUATOR; }
"*"                 { return PUNCTUATOR; }
"+"                 { return PUNCTUATOR; }
"-"                 { return PUNCTUATOR; }
"~"                 { return PUNCTUATOR; }
"!"                 { return PUNCTUATOR; }
"/"                 { return PUNCTUATOR; }
"%"                 { return PUNCTUATOR; }
"<<"                { return PUNCTUATOR; }
">>"                { return PUNCTUATOR; }
"<"                 { return PUNCTUATOR; }
">"                 { return PUNCTUATOR; }
"<="                { return PUNCTUATOR; }
">="                { return PUNCTUATOR; }
"=="                { return PUNCTUATOR; }
"!="                { return PUNCTUATOR; }
"^"                 { return PUNCTUATOR; }
"|"                 { return PUNCTUATOR; }
"&&"                { return PUNCTUATOR; }
"||"                { return PUNCTUATOR; }
"?"                 { return PUNCTUATOR; }
":"                 { return PUNCTUATOR; }
";"                 { return PUNCTUATOR; }
"&="                { return PUNCTUATOR; }
"^="                { return PUNCTUATOR; }
"|="                { return PUNCTUATOR; }
","                 { return PUNCTUATOR; }
"#"                 { return PUNCTUATOR; }


{COMMENT}           {printf("< Comment: %s >\n", yytext);}
{IDENTIFIER}        { return IDENTIFIER;}
{CONST}             { return CONSTANT;}
{STR_LIT}           { return STRING_LITERAL;}
{WHITESPACE}        {;}
%%
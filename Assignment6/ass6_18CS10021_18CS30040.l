%{
	#include "ass6_18CS10021_18CS30040_translator.h"
	#include "y.tab.h"
	extern void yyerror(const char *);
	static void comment(void);
%}

%option noyywrap

/* REGEX DEFINITION */

/*KEYWORDS*/

KEYWORD         "break"|"case"|"char"|"continue"|"default"|"do"|"double"|"else"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"return"|"short"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"void"|"while"
	
/*IDENTIFIER*/

DIGIT                     [0-9]
IDENTIFIER_NONDIGIT       [a-zA-Z]|"_"
IDENTIFIER                {IDENTIFIER_NONDIGIT}({IDENTIFIER_NONDIGIT}|{DIGIT})*

/*CONSTANTS*/

DIGIT_SEQUENCE     {DIGIT}({DIGIT})*
NONZERO_DIGIT      [1-9]
SIGN               "+"|"-"
EXPONENT_PART      ("e"{SIGN}?{DIGIT_SEQUENCE})|("E"{SIGN}?{DIGIT_SEQUENCE})

INTEGER_CONSTANT			{NONZERO_INTEGER_CONSTANT}|"0"
NONZERO_INTEGER_CONSTANT	{NONZERO_DIGIT}({NONZERO_DIGIT}|{DIGIT})*
CONSTANT					{INTEGER_CONSTANT}|{FLOATING_CONSTANT}|{CHARACTER_CONSTANT}

FLOATING_CONSTANT			({FRACTIONAL_CONSTANT}{EXPONENT_PART}?)|({DIGIT_SEQUENACTERCE}{EXPONENT_PART})
FRACTIONAL_CONSTANT			({DIGIT_SEQUENCE}?"."{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}".")


ESCAPE_SEQUENCE				"\'"|"\""|"\?"|"\\"|"\a"|"\b"|"\f"|"\n"|"\r"|"\t"|"\v"
C_CHAR 						{ESCAPE_SEQUENCE}|[^("\'"|"\\"|"\n")]
C_CHAR_SEQUENCE				{C_CHAR}+
CHARACTER_CONSTANT			"\'"{C_CHAR_SEQUENCE}"\ACTER'"


/*STRING_LITERALS*/
S_CHAR  					{ESCAPE_SEQUENCE}|[^("\""|"\\"|"\n")]
S_CHAR_SEQUENCE				{S_CHAR}({S_CHAR})*
STRING_LITERAL 				"\""{S_CHAR_SEQUENCE}?"\""


/*PUNCTUATORS*/

PUNCTUATOR        	"["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"


%x SINGLE_LINE_COMMENT MULTI_LINE_COMMENT

%%

"//"			{BEGIN(SINGLE_LINE_COMMENT);}
<SINGLE_LINE_COMMENT>[^\n]	{}
<SINGLE_LINE_COMMENT>"\n"		{BEGIN(INITIAL);}
<SINGLE_LINE_COMMENT><<EOF>>	{BEGIN(INITIAL);}

"/*"			{BEGIN(MULTI_LINE_COMMENT);}
<MULTI_LINE_COMMENT>[^*]	{}
<MULTI_LINE_COMMENT>"*"[^/]	{}
<MULTI_LINE_COMMENT>"*/"	{BEGIN(INITIAL);}

{KEYWORD} {
    if (strcmp(yytext,"break") == 0)		{ return BREAK ; }
    if (strcmp(yytext,"case") == 0)		{ return CASE ; }
    if (strcmp(yytext,"char") == 0)		{ return CHAR ; }
    if (strcmp(yytext,"continue") == 0)		{ return CONTINUE ; }
    if (strcmp(yytext,"default") == 0)		{ return DEFAULT ; }
    if (strcmp(yytext,"do") == 0)		{ return DO ; }
    if (strcmp(yytext,"double") == 0)		{ return DOUBLE ; }
    if (strcmp(yytext,"else") == 0)		{ return ELSE ; }
    if (strcmp(yytext,"extern") == 0)		{ return EXTERN ; }
    if (strcmp(yytext,"float") == 0)		{ return FLOAT ; }
    if (strcmp(yytext,"for") == 0)		{ return FOR ; }
    if (strcmp(yytext,"goto") == 0)		{ return GOTO ; }
    if (strcmp(yytext,"if") == 0)		{ return IF ; }
    if (strcmp(yytext,"int") == 0)		{ return INT ; }
    if (strcmp(yytext,"long") == 0)		{ return LONG ; }
    if (strcmp(yytext,"return") == 0)		{ return RETURN ; }
    if (strcmp(yytext,"short") == 0)		{ return SHORT ; }
    if (strcmp(yytext,"sizeof") == 0)		{ return SIZEOF ; }
    if (strcmp(yytext,"static") == 0)		{ return STATIC ; }
    if (strcmp(yytext,"struct") == 0)		{ return STRUCT ; }
    if (strcmp(yytext,"switch") == 0)		{ return SWITCH ; }
    if (strcmp(yytext,"typedef") == 0)		{ return TYPEDEF ; }
    if (strcmp(yytext,"union") == 0)		{ return UNION ; }
    if (strcmp(yytext,"void") == 0)		{ return VOID ; }
    if (strcmp(yytext,"while") == 0)		{ return WHILE ; }

}

{IDENTIFIER}	{ 
	yylval.idl.name=new string(yytext);
	return IDENTIFIER;
}

{INTEGER_CONSTANT}	{ 
	yylval.intval=atoi(yytext); 
	return INTEGER_CONSTANT;
}

{FLOATING_CONSTANT}	{
	yylval.floatval=atof(yytext);
	return FLOATING_CONSTANT;
}

{CHARACTER_CONSTANT}	{ 
	yylval.charval=yytext[1]; 
	return CHARACTER_CONST;
}

{STRING_LITERAL}	{ 
	yylval.strval = new string(yytext);
	return STRING_LITERAL;
}


{PUNCTUATOR}	{
	if(strcmp(yytext,"[") == 0) return '[';
	if(strcmp(yytext,"]") == 0) return ']';
	if(strcmp(yytext,"(") == 0) return '('; 
	if(strcmp(yytext,")") == 0) return ')'; 
	if(strcmp(yytext,"{") == 0) return '{'; 
	if(strcmp(yytext,"}") == 0) return '}'; 
	if(strcmp(yytext,".") == 0) return '.'; 
	if(strcmp(yytext,"->") == 0) return (POINTER);
	if(strcmp(yytext,"++") == 0) return (INCREMENT);
	if(strcmp(yytext,"--") == 0) return (DECREMENT);
	if(strcmp(yytext,"&") == 0) return '&';
	if(strcmp(yytext,"*") == 0) return '*';
	if(strcmp(yytext,"+") == 0) return '+';
	if(strcmp(yytext,"-") == 0) return '-';
	if(strcmp(yytext,"~") == 0) return '~';
	if(strcmp(yytext,"!") == 0) return '!';
	if(strcmp(yytext,"/") == 0) return '/';
	if(strcmp(yytext,"%") == 0) return '%';
	if(strcmp(yytext,"<<") == 0) return (LEFT_SHIFT);
	if(strcmp(yytext,">>") == 0) return (RIGHT_SHIFT);
	if(strcmp(yytext,"<") == 0) return '<';
	if(strcmp(yytext,">") == 0) return '>';
	if(strcmp(yytext,"<=") == 0) return (LESS_EQUALS);
	if(strcmp(yytext,">=") == 0) return (GREATER_EQUALS);
	if(strcmp(yytext,"==") == 0) return (EQUALS);
	if(strcmp(yytext,"!=") == 0) return (NOT_EQUALS);
	if(strcmp(yytext,"^") == 0)  return '^';
	if(strcmp(yytext,"|") == 0) return '|';
	if(strcmp(yytext,"&&") == 0) return (AND);
	if(strcmp(yytext,"||") == 0) return (OR);
	if(strcmp(yytext,"?") == 0) return '?';
	if(strcmp(yytext,":") == 0) return ':';
	if(strcmp(yytext,";") == 0) return ';';
	if(strcmp(yytext,"...") == 0) return (ELLIPSIS);
	if(strcmp(yytext,"=") == 0) return '=';
	if(strcmp(yytext,"*=") == 0) return MULTIPLY_ASSIGN;
	if(strcmp(yytext,"/=") == 0) return DIVIDE_ASSIGN;
	if(strcmp(yytext,"%=") == 0) return MODULO_ASSIGN;
	if(strcmp(yytext,"+=") == 0) return ADD_ASSIGN;
	if(strcmp(yytext,"-=") == 0) return SUBTRACT_ASSIGN;
	if(strcmp(yytext,"<<=") == 0) return LEFT_SHIFT_ASSIGN;
	if(strcmp(yytext,">>=") == 0) return RIGHT_SHIFT_ASSIGN;
	if(strcmp(yytext,"&=") == 0) return AND_ASSIGN;
	if(strcmp(yytext,"^=") == 0) return XOR_ASSIGN;
	if(strcmp(yytext,"|=") == 0) return OR_ASSIGN;
	if(strcmp(yytext,",") == 0) return ',';
	if(strcmp(yytext,"#") == 0) return '#';
}

"\n"|" "|"\t"	{

}

%%

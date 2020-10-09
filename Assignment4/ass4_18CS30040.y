%{/*C Declarations and Definitions */
    #include <stdio.h>
    
    extern int yylex();
    void yyerror(const char *);
    
%}

%union {
    int inval;
    float floatval;
    char charval;
    char *stringval;
}

%token <floatval> FLOAT_CONSTANT
%token <charval> CHAR_CONSTANT
%token <stringval> STRING_LITERAL
%token <intval> INTEGER_CONSTANT

%token IDENTIFIER
%token BREAK
%token FLOAT
%token STATIC
%token CASE
%token FOR
%token STRUCT
%token CHAR
%token GOTO
%token SWITCH
%token CONTINUE
%token IF
%token TYPEDEF
%token DEFAULT
%token INT
%token UNION
%token DO
%token LONG
%token VOID
%token DOUBLE
%token RETURN
%token WHILE
%token ELSE
%token SHORT
%token EXTERN
%token SIZEOF
%token VOLATILE
%token CONST
%token RESTRICT
%token INLINE
%token ARROW
%token INCREMENT
%token DECREMENT
%token LEFT_SHIFT
%token RIGHT_SHIFT
%token LEQ
%token GEQ
%token IS_EQUAL
%token NOT_EQUAL
%token AND
%token OR
%token TRIPLE_DOT
%token MULTIPLY_EQUAL
%token DIVIDE_EQUAL
%token MOD_EQUAL
%token PLUS_EQUAL
%token MINUS_EQUAL
%token LEFT_SHIFT_EQUAL
%token RIGHT_SHIFT_EQUAL
%token AND_EQUAL
%token XOR_EQUAL
%token OR_EQUAL
%token WHITESPACE
%token COMMENT

%start translation_unit

%nonassoc THEN
%nonassoc ELSE

%%

constant: INTEGER_CONSTANT
    { printf("constant -> INTEGER_CONSTANT\n"); }
	| FLOAT_CONSTANT
    { printf("constant -> FLOAT_CONSTANT\n"); }
	| CHAR_CONSTANT
    { printf("constant -> CHAR_CONSTANT\n"); }
	;

primary_expression: IDENTIFIER
    { printf("primary_expression -> INDENTIFIER\n"); }
    | constant
    { printf("primary_expression -> constant\n"); }
    | STRING_LITERAL
    { printf("primary_expression -> STRING_LITERAL\n"); }
    | '(' expression ')'
    { printf("primary_expression -> (expression)\n"); }
    ;

postfix_expression: primary_expression
    { printf("postfix_expression -> primary_expression\n"); }
    | postfix_expression '[' expression ']'
    { printf("postfix_expression -> postfix_expression[expression]\n"); }
    | postfix_expression '(' argument_expression_list_opt ')'
    { printf("postfix_expression -> postfix_expression(argument_expression_list_opt)\n"); }
    | postfix_expression '.' IDENTIFIER
    { printf("postfix_expression -> postfix-expression . IDENTIFIER\n"); }
    | postfix_expression ARROW IDENTIFIER
    { printf("postfix_expression -> postfix-expression -> IDENTIFIER\n"); }
    | postfix_expression INCREMENT
    { printf("postfix_expression -> postfix-expression ++\n"); }
    | postfix_expression DECREMENT
    { printf("postfix_expression -> postfix-expression --\n"); }
    | '(' type_name ')' '{' initializer_list '}'
    { printf("postfix_expression -> (type_name){initializer_list}\n"); }
    | '(' type_name ')' '{' initializer_list ',' '}'
    { printf("postfix_expression -> (type_name){initializer_list,}\n"); }
    ;

argument_expression_list: assignment_expression
    { printf("argument_expression_list -> assignment_expression\n"); }
    | argument_expression_list ',' assignment_expression
    { printf("argument_expression_list -> argument_expression_list,assignment_expression\n"); }
    ;

argument_expression_list_opt: argument_expression_list
    { printf("argument_expression_list_opt -> argument_expression_list"); }
    | %empty
    { printf("argument_expression_list_opt -> epsilon"); }
    ;

unary_expression: postfix_expression
    { printf("unary_expression -> postfix_expression\n"); }
    | INCREMENT unary_expression
    { printf("unary_expression -> INCREMENT unary_expression\n"); }
    | DECREMENT unary_expression
    { printf("unary_expression -> DECREMENT unary_expression\n"); }
    | unary_operator cast_expression
    { printf("unary_expression -> unary_operator cast_expression\n"); }
    | SIZEOF unary_expression
    { printf("unary_expression -> SIZEOF unary_expression\n"); }
    | SIZEOF '(' type_name ')'
    { printf("unary_expression -> SIZEOF (type_name)\n"); }
    ;

unary_operator: '&'
    { printf("unary_operator -> &\n"); }
    | '*'
    { printf("unary_operator -> *\n"); }
    | '+'
    { printf("unary_operator -> +\n"); }
    | '-'
    { printf("unary_operator -> -\n"); }
    | '~'
    { printf("unary_operator -> ~\n"); }
    | '!'
    { printf("unary_operator -> !\n"); }
    ;

cast_expression: unary_expression
    { printf("cast_expression -> unary_expression\n"); }
    | '(' type_name ')' cast_expression
    { printf("cast_expression -> (type_name)cast_expression\n"); }
    ;

multiplicative_expression: cast_expression
    { printf("multiplicative_expression -> cast_expression\n"); }
    | multiplicative_expression '*' cast_expression
    { printf("multiplicative_expression -> multiplicative_expression * cast_expression\n"); }
    | multiplicative_expression '/' cast_expression
    { printf("multiplicative_expression -> multiplicative_expression / cast_expression\n"); }
    | multiplicative_expression '%' cast_expression
    { printf("multiplicative_expression -> multiplicative_expression %% cast_expression\n"); }
    ;

additive_expression: multiplicative_expression
    { printf("additive_expression -> multiplicative_expression\n"); }
    | additive_expression '+' multiplicative_expression
    { printf("additive_expression -> additive_expression + multiplicative_expression\n"); }
    | additive_expression '-' multiplicative_expression
    { printf("additive_expression -> additive_expression - multiplicative_expression\n"); }
    ;

shift_expression: additive_expression
    { printf("shift_expression -> additive_expression\n"); }
    | shift_expression LEFT_SHIFT additive_expression
    { printf("shift_expression -> shift_expression << additive_expression\n"); }
    | shift_expression RIGHT_SHIFT additive_expression
    { printf("shift_expression -> shift_expression >> additive_expression\n"); }
    ;

relational_expression: shift_expression
    { printf("relational_expression -> shift_expression\n"); }
    | relational_expression '<' shift_expression
    { printf("relational_expression -> relational_expression < shift_expression\n"); }
    | relational_expression '>' shift_expression
    { printf("relational_expression -> relational_expression > shift_expression\n"); }
    | relational_expression LEQ shift_expression
    { printf("relational_expression -> relational_expression <= shift_expression\n"); }
    | relational_expression GEQ shift_expression
    { printf("relational_expression -> relational_expression >= shift_expression\n"); }
    ;

equality_expression: relational_expression
    { printf("equality_expression -> relational_expression\n"); }
    | equality_expression IS_EQUAL relational_expression
    { printf("equality_expression -> equality_expression == relational_expression\n"); }
    | equality_expression NOT_EQUAL relational_expression
    { printf("equality_expression -> equality_expression != relational_expression\n"); }
    ;

and_expression: equality_expression
    { printf("and_expression -> equality_expression\n"); }
    | and_expression '&' equality_expression
    { printf("and_expression -> and_expression & equality_expression\n"); }
    ;

exclusive_or_expression: and_expression
    { printf("exclusive_or_expression -> and_expression\n"); }
    | exclusive_or_expression '^' and_expression
    { printf("exclusive_or_expression -> exclusive_or_expression ^ and_expression\n"); }
    ;

inclusive_or_expression: exclusive_or_expression
    { printf("inclusive_or_expression -> exclusive_or_expression\n"); }
    | inclusive_or_expression '|' exclusive_or_expression
    { printf("inclusive_or_expression -> inclusive_or_expression | exclusive_or_expression\n"); }
    ;

logical_and_expression: inclusive_or_expression
    { printf("logical_and_expression -> inclusive_or_expression\n"); }
    | logical_and_expression AND inclusive_or_expression
    { printf("logical_and_expression -> logical_and_expression && inclusive_or_expression\n"); }
    ;

logical_or_expression: logical_and_expression
    { printf("logical_or_expression -> logical_and_expression\n"); }
    | logical_or_expression OR logical_and_expression
    { printf("logical_or_expression -> logical_or_expression || logical_and_expression\n"); }
    ;

conditional_expression: logical_or_expression
    { printf("conditional_expression -> logical_or_expression\n"); }
    | logical_or_expression '?' expression ':' conditional_expression
    { printf("conditional_expression -> logical_or_expression ? expression : conditional_expression\n"); }
    ;

assignment_expression: conditional_expression
    { printf("assignment_expression -> conditional_expression\n"); }
    | unary_expression assignment_operator assignment_expression
    { printf("assignment_expression -> unary_expression assignment_operator assignment_expression\n"); }
    ;

assignment_operator: '='
    { printf("assignment_operator -> =\n"); }
    | MULTIPLY_EQUAL
    { printf("assignment_operator -> *=\n"); }
    | DIVIDE_EQUAL
    { printf("assignment_operator -> /=\n"); }
    | MOD_EQUAL
    { printf("assignment_operator -> %%=\n"); }
    | PLUS_EQUAL
    { printf("assignment_operator -> +=\n"); }
    | MINUS_EQUAL
    { printf("assignment_operator -> -=\n"); }
    | LEFT_SHIFT_EQUAL
    { printf("assignment_operator -> <<=\n"); }
    | RIGHT_SHIFT_EQUAL
    { printf("assignment_operator -> >>=\n"); }
    | AND_EQUAL
    { printf("assignment_operator -> &&=\n"); }
    | XOR_EQUAL
    { printf("assignment_operator -> ^=\n"); }
    | OR_EQUAL
    { printf("assignment_operator -> |=\n"); }
    ;

expression: assignment_expression
    { printf("expression -> assignment_expression\n"); }
    | expression ',' assignment_expression
    { printf("expression -> expression , assignment_expression\n"); }
    ;

constant_expression: conditional_expression
    { printf("constant_expression -> conditional_expression\n"); }
    ;

declaration: declaration_specifiers init_declarator_list_opt ";"
    { printf("declaration -> declaration_specifiers init_declarator_list_opt ;\n"); }
    ;

init_declarator_list_opt: init_declarator_list
    { printf("init_declarator_list_opt -> init_declarator_list\n"); }
    | %empty
    { printf("init_declarator_list_opt -> epsilon\n"); }
    ;

declaration_specifiers: storage_class_specifier declaration_specifiers_opt
    { printf("declaration_specifiers -> storage_class_specifier declaration_specifiers_opt\n"); }
    | type_specifier declaration_specifiers_opt
    { printf("declaration_specifiers -> type_specifier declaration_specifiers_opt\n"); }
    | type_qualifier declaration_specifiers_opt
    { printf("declaration_specifiers -> type_qualifier declaration_specifiers_opt\n"); }
    | function_specifier declaration_specifiers_opt
    { printf("declaration_specifiers -> function_specifier declaration_specifiers_opt\n"); }
    ;

declaration_specifiers_opt: declaration_specifiers
    { printf("declaration_specifiers_opt -> declaration_specifiers\n"); }
    | %empty
    { printf("declaration_specifiers_opt -> epsilon\n"); }
    ;

init_declarator_list: init_declarator
    { printf("init_declarator_list -> init_declarator\n"); }
    | init_declarator_list ',' init_declarator
    { printf("init_declarator_list -> init_declarator_list , init_declarator\n"); }
    ;

init_declarator: declarator
    { printf("init_declarator -> declarator\n"); }
    | declarator '=' initializer
    { printf("init_declarator -> declarator = initializer\n"); }
    ;

storage_class_specifier: EXTERN
    { printf("storage_class_specifier -> extern\n"); }
    | STATIC
    { printf("storage_class_specifier -> static\n"); }
    ;

type_specifier: VOID
    { printf("type_specifier -> VOID\n"); }
    | CHAR
    { printf("type_specifier -> CHAR\n"); }
    | SHORT
    { printf("type_specifier -> SHORT\n"); }
    | INT
    { printf("type_specifier -> INT\n"); }
    | LONG
    { printf("type_specifier -> LONG\n"); }
    | FLOAT
    { printf("type_specifier -> FLOAT\n"); }
    | DOUBLE
    { printf("type_specifier -> DOUBLE\n"); }
    ;

specific_qualifier_list: type_specifier specific_qualifier_list_opt
    { printf("specific_qualifier_list -> type_specifier specific_qualifier_list_opt\n"); }
    | type_qualifier specific_qualifier_list_opt
    { printf("specific_qualifier_list -> type_qualifier specific_qualifier_list_opt\n"); }
    ;

specific_qualifier_list_opt: specific_qualifier_list
    { printf("specific_qualifier_list_opt -> specific_qualifier_list\n"); }
    | %empty
    { printf("specific_qualifier_list_opt -> epsilon\n"); }
    ;

type_qualifier: CONST
    { printf("type_qualifier -> CONST\n"); }
    | RESTRICT
    { printf("type_qualifier -> RESTRICT\n"); }
    | VOLATILE
    { printf("type_qualifier -> VOLATILE\n"); }
    ;

function_specifier: INLINE
    { printf("function_specifier -> INLINE\n"); }
    ;

declarator: pointer_opt direct_declarator
    { printf("declarator -> pointer_opt direct_declarator\n"); }
    ;

direct_declarator: IDENTIFIER
    { printf("direct_declarator -> IDENTIFIER\n"); }
    | '(' declarator ')'
    { printf("direct_declarator -> ( declarator )\n"); }
    | direct_declarator '[' type_qualifier_list_opt assignment_expression_opt ']'
    { printf("direct_declarator -> direct_declarator [ type_qualifier_list_opt assignment_expression_opt ]\n"); }
    | direct_declarator '[' STATIC type_qualifier_list_opt assignment_expression ']'
    { printf("direct_declarator -> direct_declarator [ STATIC type_qualifier_list_opt assignment_expression ]\n"); }
    | direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'
    { printf("direct_declarator -> direct_declarator [ type_qualifier_list STATIC assignment_expression ]\n"); }
    | direct_declarator '[' type_qualifier_list_opt '*' ']'
    { printf("direct_declarator -> direct_declarator [ type_qualifier_list_opt * ]\n"); }
    | direct_declarator '(' parameter_type_list ')'
    { printf("direct_declarator -> direct_declarator ( parameter_type_list )\n"); }
    | direct_declarator '(' identifier_list_opt ')'
    { printf("direct_declarator -> direct_declarator ( identifier_list_opt )\n"); }
    ;

identifier_list_opt: identifier_list
    { printf("identifier_list_opt -> identifier_list\n"); }
    | %empty
    { printf("identifier_list_opt -> epsilon\n"); }
    ;

type_qualifier_list_opt: type_qualifier_list
    { printf("type_qualifier_list_opt -> type_qualifier_list\n"); }
    | %empty
    { printf("type_qualifier_list_opt -> epsilon\n"); }
    ;

assignment_expression_opt: assignment_expression
    { printf("assignment_expression_opt -> assignment_expression\n"); }
    | %empty
    { printf("assignment_expression_opt -> epsilon\n"); }
    ;

pointer_opt: pointer
    { printf("pointer_opt -> pointer\n"); }
    | %empty
    { printf("pointer_opt -> epsilon\n"); }
    ;

pointer: '*' type_qualifier_list_opt
    { printf("pointer -> * type_qualifier_list_opt\n"); }
    | '*' type_qualifier_list_opt pointer
    { printf("pointer -> * type_qualifier_list_opt pointer\n"); }
    ;

type_qualifier_list: type_qualifier
    { printf("type_qualifier_list -> type_qualifier\n"); }
    | type_qualifier_list type_qualifier
    { printf("type_qualifier_list -> type_qualifier_list type_qualifier\n"); }
    ;

parameter_type_list: parameter_list
    { printf("parameter_type_list -> parameter_list\n"); }
    | parameter_list ',' TRIPLE_DOT
    { printf("parameter_type_list -> parameter_list , ...\n"); }
    ;

parameter_list: parameter_declaration
    { printf("parameter_list -> parameter_declaration\n"); }
    | parameter_list ',' parameter_declaration
    { printf("parameter_list -> parameter_list , parameter_declaration\n"); }
    ;

parameter_declaration: declaration_specifiers declarator
    { printf("parameter_declaration -> declaration_specifiers declarator\n"); }
    | declaration_specifiers
    { printf("parameter_declaration -> declaration_specifiers\n"); }
    ;

identifier_list: IDENTIFIER
    { printf("identifier_list -> IDENTIFIER\n"); }
    | identifier_list ',' IDENTIFIER
    { printf("identifier_list -> identifier_list , IDENTIFIER\n"); }
    ;

type_name: specific_qualifier_list
    { printf("type_name -> specific_qualifier_list\n"); }
    ;

initializer: assignment_expression
    { printf("initializer -> assignment_expression\n"); }
    | '{' initializer_list '}'
    { printf("initializer -> { initializer_list }\n"); }
    | '{' initializer_list ',' '}'
    { printf("initializer -> { initializer_list , }\n"); }
    ;

initializer_list: designation_opt initializer
    { printf("initializer_list -> designation_opt initializer\n"); }
    | initializer_list ',' designation_opt initializer
    { printf("initializer_list -> initializer_list , designation_opt initializer\n"); }
    ;

designation_opt: designation
    { printf("designation_opt -> designation\n"); }
    | %empty
    { printf("designation_opt -> epsilon\n"); }
    ;

designation: designator_list '='
    { printf("designation -> designator_list =\n"); }
    ;

designator_list: designator
    { printf("designator_list -> designator\n"); }
    | designator_list designator
    { printf("designator_list -> designator_list designator\n"); }
    ;

designator: '[' constant_expression ']'
    { printf("designator -> [ constant_expression ]\n"); }
    | '.' IDENTIFIER
    { printf("designator -> . IDENTIFIER\n"); }
    ;

statement: labeled_statement
    { printf("statement -> labeled_statement\n"); }
    | compound_statement
    { printf("statement -> compound_statement\n"); }
    | expression_statement
    { printf("statement -> expression_statement\n"); }
    | selection_statement
    { printf("statement -> selection_statement\n"); }
    | iteration_statement
    { printf("statement -> iteration_statement\n"); }
    | jump_statement
    { printf("statement -> jump_statement\n"); }
    ;

labeled_statement: IDENTIFIER ':' statement
    { printf("labeled_statement -> IDENTIFIER : statement\n"); }
    | CASE constant_expression ':' statement
    { printf("labeled_statement -> CASE constant_expression : statement\n"); }
    | DEFAULT ':' statement
    { printf("labeled_statement -> DEFAULT : statement\n"); }
    ;

compound_statement: '{' block_item_list_opt '}'
    { printf("compound_statement -> { block_item_list_opt }\n"); }
    ;

block_item_list_opt: block_item_list
    { printf("block_item_list_opt -> block_item_list\n"); }
    | %empty
    { printf("block_item_list_opt -> epsilon\n"); }
    ;

block_item_list: block_item
    { printf("block_item_list -> block_item\n"); }
    | block_item_list block_item
    { printf("block_item_list -> block_item_list block_item\n"); }
    ;

block_item: declaration
    { printf("block_item -> declaration\n"); }
    | statement
    { printf("block_item -> statement\n"); }
    ;

expression_statement: expression_opt ';'
    { printf("expression_statement -> expression_opt;\n"); }
    ;

expression_opt: expression
    { printf("expression_opt -> expression\n"); }
    | %empty
    { printf("expression_opt -> epsilon\n"); }
    ;

selection_statement: IF '(' expression ')' statement %prec THEN
    { printf("selection_statement -> IF ( expression ) statement\n"); }
    | IF '(' expression ')' statement ELSE statement
    { printf("selection_statement -> IF ( expression ) statement ELSE statement\n"); }
    | SWITCH '(' expression ')' statement
    { printf("selection_statement -> SWITCH ( expression ) statement\n"); }
    ;

iteration_statement: WHILE '(' expression ')' statement
    { printf("iteration_statement -> WHILE ( expression ) statement\n"); }
    | DO statement WHILE '(' expression ')' ';'
    { printf("iteration_statement -> DO statement WHILE ( expression ) ;\n"); }
    | FOR '(' expression_opt ';' expression_opt ';' expression_opt ')' statement
    { printf("iteration_statement -> FOR ( expression_opt ; expression_opt ; expression_opt ) statement\n"); }
    | FOR '(' declaration expression_opt ';' expression_opt ')' statement
    { printf("iteration_statement -> FOR ( declaration expression_opt ; expression_opt ) statement\n"); }
    ;

jump_statement: GOTO IDENTIFIER ';'
    { printf("jump_statement -> GOTO IDENTIFIER ;\n"); }
    | CONTINUE ';'
    { printf("jump_statement -> CONTINUE ;\n"); }
    | BREAK ';'
    { printf("jump_statement -> BREAK ;\n"); }
    | RETURN expression_opt ';'
    { printf("jump_statement -> RETURN expression_opt ;\n"); }
    ;

translation_unit: external_declaration
    { printf("translation_unit -> external_declaration\n"); }
    | translation_unit external_declaration
    { printf("translation_unit -> translation_unit external_declaration\n"); }
    ;

external_declaration: function_definition
    { printf("external_declaration -> function_definition\n"); }
    | declaration
    { printf("external_declaration -> declaration\n"); }
    ;

function_definition: declaration_specifiers declarator declaration_list_opt compound_statement
    { printf("function_definition -> declaration_specifiers declarator declaration_list_opt compound_statement\n"); }
    ;

declaration_list_opt: declaration_list
    { printf("declaration_list_opt -> declaration_list"); }
    | %empty
    { printf("declaration_list_opt -> epsilon"); }
    ;

declaration_list: declaration
    { printf("declaration_list -> declaration\n"); }
    | declaration_list declaration
    { printf("declaration_list -> declaration_list declaration\n"); }
    ;

%%

void yyerror(const char *s) {
    printf("ERROR: %s", s);
}
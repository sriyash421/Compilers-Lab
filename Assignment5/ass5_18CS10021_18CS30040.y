%{ /* C Declarations and Definitions */
	
	#include <iostream>              
	#include <cstdlib>
	#include <sstream>
	#include <string.h>
	#include <stdio.h>

	#include "ass5_18CS10021_18CS30040_translator.h"
	extern int yylex();
	void yyerror(string s);
	extern string var_type;
	
	using namespace std;
%}

%union {
	char unaryOp;	//unaryoperator		
	char *char_value;	//char value

	int instr_number;		//instruction number: for backpatching
	int intval;		//integer value	
	int num_params;			//number of parameters
	Expression *expr;		//expression
	Statement *stat;		//statement		
	symboltype *sym_type;	//symbol type  
	sym *symp;		//symbol
	Array *A;  //Array type
}

%token BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE EXTERN FLOAT FOR GOTO IF INLINE INT LONG REGISTER RESTRICT RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION VOID VOLATILE WHILE 
%token <symp> IDENTIFIER 		 		
%token <intval> INTEGER_CONSTANT			
%token <char_value> FLOATING_CONSTANT
%token <char_value> CHARACTER_CONSTANT				
%token <char_value> STRING_LITERAL 		
%token SQUARE_BRACKET_OPEN SQUARE_BRACKET_CLOSE ROUND_BRACKET_OPEN ROUND_BRACKET_CLOSE CURLY_BRACKET_OPEN CURLY_BRACKET_CLOSE
%token DOT IMPLIES INC DEC BITWISE_AND MUL ADD SUB BITWISE_NOT EXCLAIM DIV MOD SHIFT_LEFT SHIFT_RIGHT BIT_SL BIT_SR 
%token LTE GTE EQ NEQ BITWISE_XOR BITWISE_OR AND OR QUESTION COLON SEMICOLON DOTS ASSIGN 
%token STAR_EQ DIV_EQ MOD_EQ ADD_EQ SUB_EQ SL_EQ SR_EQ BITWISE_AND_EQ BITWISE_XOR_EQ BITWISE_OR_EQ 
%token COMMA HASH 
%start translation_unit

//to remove dangling else problem
%right "then" ELSE

//unary operator
%type <unaryOp> unary_operator

//number of parameters
%type <num_params> argument_expression_list argument_expression_list_opt



//Expressions
%type <expr>
	expression
	constant
	primary_expression 
	multiplicative_expression
	additive_expression
	shift_expression
	relational_expression
	equality_expression
	and_expression
	exclusive_or_expression
	inclusive_or_expression
	logical_and_expression
	logical_or_expression
	conditional_expression
	assignment_expression
	expression_statement

//Statements
%type <stat>  statement
	compound_statement
	selection_statement
	iteration_statement
	labeled_statement 
	jump_statement
	block_item
	block_item_list
	block_item_list_opt

//symbol type
%type <sym_type> pointer

//symbol
%type <symp> initializer
%type <symp> direct_declarator init_declarator declarator

//arr1s
%type <A> postfix_expression
	unary_expression
	cast_expression

//Auxillary non-terminals M and N
%type <instr_number> M
%type <stat> N



%%

M
	: %empty 
	{
		// backpatching,stores the index of the next quad to be generated
		// Used in various control statements
		$$=nextinstr();
	}   
	;

N
	: %empty
	{
		// backpatching,inserts a goto and stores the index of the next goto statement to guard against fallthrough
		$$ =new Statement();            //N->nextlist=makelist(nextinstr) we have defined nextlist for Statements
		$$->nextlist=makelist(nextinstr());
		emit("goto","");
	}
	;

constant
	: INTEGER_CONSTANT 
	{
		$$ =  new Expression();	
		string p=convertIntToString($1);
		$$->loc=gentemp(new symboltype("int"),p);
		emit("=",$$->loc->name,p);
	}
	| FLOATING_CONSTANT 
	{
		$$=new Expression();
		$$->loc=gentemp(new symboltype("float"),$1);
		emit("=",$$->loc->name,string($1));
	}
	| CHARACTER_CONSTANT
	{
		$$=new Expression();
		$$->loc=gentemp(new symboltype("char"),$1);
		emit("=",$$->loc->name,string($1));
	}
	;



primary_expression
	: IDENTIFIER
	{	
		$$=new Expression();                      //create new expression and store pointer to ST entry in the location					 
		$$->loc=$1;
		$$->type="not-boolean";
	}
	| constant
	{
		$$ = $1;
	}
	| STRING_LITERAL
	{
		$$=new Expression();
		$$->loc=gentemp(new symboltype("ptr"),$1);
		$$->loc->type->arrtype=new symboltype("char");
	}
	| ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE
	{
		$$ = $2;
	}
	;


unary_operator
	: BITWISE_AND
	{ $$ = '&';}
	| MUL
	{ $$ = '*';}
	| ADD
	{ $$ = '+';}
	| SUB
	{ $$ = '-';}
	| BITWISE_NOT
	{ $$ = '~';}
	| EXCLAIM
	{ $$ = '!';}
	;

postfix_expression
	:primary_expression      				       //create new Array and store the location of primary expression in it
	{ 

		$$=new Array();
		$$->Array=$1->loc;	
		$$->type=$1->loc->type;	
		$$->loc=$$->Array;

	}
	| postfix_expression SQUARE_BRACKET_OPEN expression SQUARE_BRACKET_CLOSE 
	{ 	

		$$=new Array();
		$$->type=$1->type->arrtype;				// type=type of element				
		$$->Array=$1->Array;						// copy the base
		$$->loc=gentemp(new symboltype("int"));		// store computed address
		$$->array_type="arr";						//array_type is arr.
		if($1->array_type=="arr") 
		{		
			sym* t=gentemp(new symboltype("int"));
			int p=computeSize($$->type);
			string str=convertIntToString(p);
			emit("*",t->name,$3->loc->name,str);
			emit("+",$$->loc->name,$1->loc->name,t->name);
		}
		else 
		{                        //if a 1D Array, simply calculate size
			int p = computeSize($$->type);

			string str=convertIntToString(p);

			emit("*",$$->loc->name,$3->loc->name,str);

	
		}
	}
	| postfix_expression ROUND_BRACKET_OPEN argument_expression_list_opt ROUND_BRACKET_CLOSE       
	//call the function with number of parameters from argument_expression_list_opt
	{

		$$=new Array();	
		$$->Array=gentemp($1->type);
		string str=convertIntToString($3);
		emit("call",$$->Array->name,$1->Array->name,str);

	}
	| postfix_expression INC               //generate new temporary, equate it to old one and then add 1
	{ 

		$$=new Array();
		$$->Array=gentemp($1->Array->type);	
		emit("=",$$->Array->name,$1->Array->name);

		emit("+",$1->Array->name,$1->Array->name,"1");

	}
	| postfix_expression DEC                //generate new temporary, equate it to old one and then subtract 1
	{

		$$=new Array();	
		$$->Array=gentemp($1->Array->type);
		emit("=",$$->Array->name,$1->Array->name);

		emit("-",$1->Array->name,$1->Array->name,"1");

	}
	| ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE CURLY_BRACKET_OPEN initializer_list CURLY_BRACKET_CLOSE {  }
	| ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE CURLY_BRACKET_OPEN initializer_list COMMA CURLY_BRACKET_CLOSE {  }
	;

argument_expression_list_opt
	: argument_expression_list {$$ = $1;}
	| %empty {$$ = 0;}
    ;

argument_expression_list
	: assignment_expression
	{
	    $$=1;                                      //one argument and emit param
		emit("param",$1->loc->name);	
	}
	| argument_expression_list COMMA assignment_expression
	{
		$$=$1+1;                                  //one more argument and emit param		 
		emit("param",$3->loc->name);
	}
	;

unary_expression
	: postfix_expression
	{ 
		$$ = $1;
	}
	| INC unary_expression
	{
		emit("+",$2->Array->name,$2->Array->name,"1");
		$$=$2;
	}
	| DEC unary_expression
	{
		emit("-",$2->Array->name,$2->Array->name,"1");

		$$=$2;
	}
	| unary_operator cast_expression
	{
		$$=new Array();
		switch($1)
		{	  
			case '&':                                       //address of something, then generate a pointer temporary and emit the quad
				
				$$->Array=gentemp((new symboltype("ptr")));
				$$->Array->type->arrtype=$2->Array->type; 
				emit("=&",$$->Array->name,$2->Array->name);
				break;
			case '*':                          //value of something, then generate a temporary of the corresponding type and emit the quad	
				$$->array_type="ptr";
				$$->loc=gentemp($2->Array->type->arrtype);
				$$->Array=$2->Array;
				emit("=*",$$->loc->name,$2->Array->name);
				break;
			case '+':  
				$$=$2;
		
				break;                    //unary plus, do nothing
			case '-':				   //unary minus, generate new temporary of the same base type and make it negative of current one
				$$->Array=gentemp(new symboltype($2->Array->type->type));
	
				emit("uminus",$$->Array->name,$2->Array->name);
	
		
				break;
			case '~':                   //bitwise not, generate new temporary of the same base type and make it negative of current one
				$$->Array=gentemp(new symboltype($2->Array->type->type));
	
				emit("~",$$->Array->name,$2->Array->name);
	
		
				break;
			case '!':				//logical not, generate new temporary of the same base type and make it negative of current one
				$$->Array=gentemp(new symboltype($2->Array->type->type));
	
				emit("!",$$->Array->name,$2->Array->name);
	
		
				break;
		}
	}
	| SIZEOF unary_expression
	{ }
	| SIZEOF ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE
	{ }
	;


cast_expression
	: unary_expression
	{
		$$ = $1;
	}
	| ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE cast_expression
	{
		$$=new Array();	
		$$->Array=convertType($4->Array,var_type);             //generate a new symbol of the given type
	}
	;

multiplicative_expression
	: cast_expression  
	{

		$$ = new Expression();             //generate new expression							    
		if($1->array_type=="arr") 			   //if it is of type arr
		{
			$$->loc = gentemp($1->loc->type);	

			emit("=[]", $$->loc->name, $1->Array->name, $1->loc->name);     //emit with Array right

	
		}
		else if($1->array_type=="ptr")         //if it is of type ptr
		{ 
			$$->loc = $1->loc;        //equate the locs

	
		}
		else
		{
			$$->loc = $1->Array;

	
		}
	}
	| multiplicative_expression MUL cast_expression           //if we have multiplication
	{ 

		if(!compareSymbolType($1->loc, $3->Array))         
			cout<<"Type Error in Program"<< endl;	// error
		else 								 //if types are compatible, generate new temporary and equate to the product
		{
			$$ = new Expression();	

			$$->loc = gentemp(new symboltype($1->loc->type->type));

			emit("*", $$->loc->name, $1->loc->name, $3->Array->name);

	
		}
	}
	| multiplicative_expression DIV cast_expression      //if we have division
	{

		if(!compareSymbolType($1->loc, $3->Array))
			cout << "Type Error in Program"<< endl;
		else    //if types are compatible, generate new temporary and equate to the quotient
		{
			$$ = new Expression();

			$$->loc = gentemp(new symboltype($1->loc->type->type));

			emit("/", $$->loc->name, $1->loc->name, $3->Array->name);
	
							
		}
	}
	| multiplicative_expression MOD cast_expression    //if we have mod
	{

		if(!compareSymbolType($1->loc, $3->Array))
			cout << "Type Error in Program"<< endl;		
		else 		 //if types are compatible, generate new temporary and equate to the quotient
		{
			$$ = new Expression();

			$$->loc = gentemp(new symboltype($1->loc->type->type));

			emit("%", $$->loc->name, $1->loc->name, $3->Array->name);	
	
		
		}
	}
	;

additive_expression
	: multiplicative_expression   { $$=$1; }            //simply equate
	| additive_expression ADD multiplicative_expression      //if we have addition
	{

		if(!compareSymbolType($1->loc, $3->loc))
			cout << "Type Error in Program"<< endl;
		else    	//if types are compatible, generate new temporary and equate to the sum
		{
			$$ = new Expression();	

			$$->loc = gentemp(new symboltype($1->loc->type->type));

			emit("+", $$->loc->name, $1->loc->name, $3->loc->name);

	
		}
	}
	| additive_expression SUB multiplicative_expression    //if we have subtraction
	{

		if(!compareSymbolType($1->loc, $3->loc))
			cout << "Type Error in Program"<< endl;		
		else        //if types are compatible, generate new temporary and equate to the difference
		{	
			$$ = new Expression();	

			$$->loc = gentemp(new symboltype($1->loc->type->type));

			emit("-", $$->loc->name, $1->loc->name, $3->loc->name);

	
		}
	}
;

shift_expression
	: additive_expression   { $$=$1; }              //simply equate
	| shift_expression SHIFT_LEFT additive_expression   
	{ 

		if(!($3->loc->type->type == "int"))
			cout << "Type Error in Program"<< endl; 		
		else            //if base type is int, generate new temporary and equate to the shifted value
		{		
			$$ = new Expression();	

			$$->loc = gentemp(new symboltype("int"));

			emit("<<", $$->loc->name, $1->loc->name, $3->loc->name);

	
		}
	}
	| shift_expression SHIFT_RIGHT additive_expression
	{ 	
		if(!($3->loc->type->type == "int"))
		{
	
			cout << "Type Error in Program"<< endl; 		
		}
		else  		//if base type is int, generate new temporary and equate to the shifted value
		{		
	
			$$ = new Expression();	

			$$->loc = gentemp(new symboltype("int"));

			emit(">>", $$->loc->name, $1->loc->name, $3->loc->name);

	
		}
	}
	;

relational_expression
	: shift_expression   { $$=$1; }              //simply equate
	| relational_expression BIT_SL shift_expression
	{
		if(!compareSymbolType($1->loc, $3->loc)) 
		{
	
			cout << "Type Error in Program"<< endl;
		}
		else 
		{      //check compatible types		
								
			$$ = new Expression();

			$$->type = "bool";                         //new type is boolean
		
			$$->truelist = makelist(nextinstr());     //makelist for truelist and falselist

			$$->falselist = makelist(nextinstr()+1);

			emit("<", "", $1->loc->name, $3->loc->name);     //emit statement if a<b goto .. 

	
			emit("goto", "");	//emit statement goto ..

	
		}
	}
	| relational_expression BIT_SR shift_expression          //similar to above, check compatible types,make new lists and emit
	{
		if(!compareSymbolType($1->loc, $3->loc)) 
		{
	
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
	
			$$ = new Expression();	

			$$->type = "bool";

			$$->truelist = makelist(nextinstr());

			$$->falselist = makelist(nextinstr()+1);

			emit(">", "", $1->loc->name, $3->loc->name);

	
			emit("goto", "");

	
		}	
	}
	| relational_expression LTE shift_expression			 //similar to above, check compatible types,make new lists and emit
	{
		if(!compareSymbolType($1->loc, $3->loc)) 
		{
	
			cout << "Type Error in Program"<< endl;
		}
		else 
		{		
	
			$$ = new Expression();		

			$$->type = "bool";

			$$->truelist = makelist(nextinstr());

			$$->falselist = makelist(nextinstr()+1);

			emit("<=", "", $1->loc->name, $3->loc->name);

	
			emit("goto", "");

	
		}		
	}
	| relational_expression GTE shift_expression 			 //similar to above, check compatible types,make new lists and emit
	{
		if(!compareSymbolType($1->loc, $3->loc))
		{
	 
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
	
			$$ = new Expression();

			$$->type = "bool";

			$$->truelist = makelist(nextinstr());

			$$->falselist = makelist(nextinstr()+1);

			emit(">=", "", $1->loc->name, $3->loc->name);

	
			emit("goto", "");

	
		}
	}
	;

equality_expression
	: relational_expression  { $$=$1; }						//simply equate
	| equality_expression EQ relational_expression 
	{
		if(!compareSymbolType($1->loc, $3->loc))                //check compatible types
		{
	
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
	
			convertBoolToInt($1);                  //convert bool to int
	
			convertBoolToInt($3);

			$$ = new Expression();

			$$->type = "bool";

			$$->truelist = makelist(nextinstr());            //make lists for new expression

			$$->falselist = makelist(nextinstr()+1); 

			emit("==", "", $1->loc->name, $3->loc->name);      //emit if a==b goto ..

	
			emit("goto", "");				//emit goto ..

	
		}
		
	}

	| equality_expression NEQ relational_expression   //Similar to above, check compatibility, convert bool to int, make list and emit
	{
		if(!compareSymbolType($1->loc, $3->loc)) 
		{
	
			cout << "Type Error in Program"<< endl;
		}
		else 
		{			
	
			convertBoolToInt($1);	

			convertBoolToInt($3);

			$$ = new Expression();                 //result is boolean

			$$->type = "bool";

			$$->truelist = makelist(nextinstr());

			$$->falselist = makelist(nextinstr()+1);

			emit("!=", "", $1->loc->name, $3->loc->name);

	
			emit("goto", "");

	
		}
	}
	;

and_expression
	: equality_expression  { $$=$1; }						//simply equate
	| and_expression BITWISE_AND equality_expression 
	{
		if(!compareSymbolType($1->loc, $3->loc))         //check compatible types 
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
	              
			convertBoolToInt($1);                             //convert bool to int

			convertBoolToInt($3);

			$$ = new Expression();

			$$->type = "not-boolean";                   //result is not boolean

			$$->loc = gentemp(new symboltype("int"));

			emit("&", $$->loc->name, $1->loc->name, $3->loc->name);               //emit the quad

	
		}
	}
	;

exclusive_or_expression
	: and_expression  { $$=$1; }				//simply equate
	| exclusive_or_expression BITWISE_XOR and_expression    
	{
		if(!compareSymbolType($1->loc, $3->loc))    //same as and_expression: check compatible types, make non-boolean expression and convert bool to int and emit
		{
	
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
	
			convertBoolToInt($1);	

			convertBoolToInt($3);

			$$ = new Expression();

			$$->type = "not-boolean";

			$$->loc = gentemp(new symboltype("int"));

			emit("^", $$->loc->name, $1->loc->name, $3->loc->name);

	
		}
	}
	;

inclusive_or_expression
	: exclusive_or_expression { $$=$1; }			//simply equate
	| inclusive_or_expression BITWISE_OR exclusive_or_expression          
	{ 
		if(!compareSymbolType($1->loc, $3->loc))   //same as and_expression: check compatible types, make non-boolean expression and convert bool to int and emit
		{
	
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
	
			convertBoolToInt($1);		

			convertBoolToInt($3);

			$$ = new Expression();

			$$->type = "not-boolean";

			$$->loc = gentemp(new symboltype("int"));

			emit("|", $$->loc->name, $1->loc->name, $3->loc->name);

	
		} 
	}
	;

logical_and_expression
	: inclusive_or_expression  { $$=$1; }				//simply equate
	| logical_and_expression N AND M inclusive_or_expression      //backpatching involved here
	{ 

		convertIntToBool($5);         //convert inclusive_or_expression int to bool
		backpatch($2->nextlist, nextinstr());        //$2->nextlist goes to next instruction
		convertIntToBool($1);                  //convert logical_and_expression to bool
		$$ = new Expression();     //make new boolean expression 
		$$->type = "bool";
		backpatch($1->truelist, $4);        //if $1 is true, we move to $5
		$$->truelist = $5->truelist;        //if $5 is also true, we get truelist for $$
		$$->falselist = merge($1->falselist, $5->falselist);    //merge their falselists

	}
	;

logical_or_expression
	: logical_and_expression   { $$=$1; }				//simply equate
	| logical_or_expression N OR M logical_and_expression        //backpatching involved here
	{ 

		convertIntToBool($5);			 //convert logical_and_expression int to bool
		backpatch($2->nextlist, nextinstr());	//$2->nextlist goes to next instruction
		convertIntToBool($1);			//convert logical_or_expression to bool
		$$ = new Expression();			//make new boolean expression
		$$->type = "bool";
		backpatch($1->falselist, $4);		//if $1 is true, we move to $5
		$$->truelist = merge($1->truelist, $5->truelist);		//merge their truelists
		$$->falselist = $5->falselist;		 	//if $5 is also false, we get falselist for $$

	}
	;
conditional_expression 
	: logical_or_expression {$$=$1;}       //simply equate
	| logical_or_expression N QUESTION M expression N COLON M conditional_expression 
	{

		//normal conversion method to get conditional expressions
		$$->loc = gentemp($5->loc->type);       //generate temporary for expression
		$$->loc->update($5->loc->type);
		emit("=", $$->loc->name, $9->loc->name);      //make it equal to sconditional_expression

		list<int> l = makelist(nextinstr());        //makelist next instruction
		emit("goto", "");              //prevent fallthrough

		backpatch($6->nextlist, nextinstr());        //after N, go to next instruction
		emit("=", $$->loc->name, $5->loc->name);

		list<int> m = makelist(nextinstr());         //makelist next instruction
		l = merge(l, m);						//merge the two lists
		emit("goto", "");						//prevent fallthrough

		backpatch($2->nextlist, nextinstr());   //backpatching
		convertIntToBool($1);                   //convert expression to boolean
		backpatch($1->truelist, $4);           //$1 true goes to expression
		backpatch($1->falselist, $8);          //$1 false goes to conditional_expression
		backpatch(l, nextinstr());

	}
	;

assignment_expression
	: conditional_expression {$$=$1;}         //simply equate
	| unary_expression assignment_operator assignment_expression 
	 {
		if($1->array_type=="arr")       //if type is arr, simply check if we need to convert and emit
		{
	
			$3->loc = convertType($3->loc, $1->type->type);

			emit("[]=", $1->Array->name, $1->loc->name, $3->loc->name);		

	
		}
		else if($1->array_type=="ptr")     //if type is ptr, simply emit
		{
	
			emit("*=", $1->Array->name, $3->loc->name);		

	
		}
		else                              //otherwise assignment
		{
	
			$3->loc = convertType($3->loc, $1->Array->type->type);
			emit("=", $1->Array->name, $3->loc->name);

	
		}
		
		$$ = $3;

		
	}
	;

assignment_operator
	: ASSIGN
	{ }
	| STAR_EQ
	{ }
	| DIV_EQ
	{ }
	| MOD_EQ
	{ }
	| ADD_EQ
	{ }
	| SUB_EQ
	{ }
	| SL_EQ
	{ }
	| SR_EQ
	{ }
	| BITWISE_AND_EQ
	{ }
	| BITWISE_XOR_EQ
	{ }
	| BITWISE_OR_EQ
	{ }
	;

expression
	: assignment_expression
	{ $$ = $1; }
	| expression COMMA assignment_expression
	{}
	;

constant_expression
	: conditional_expression
	{}
	;

declaration
	: declaration_specifiers init_declarator_list_opt SEMICOLON
	{ }
	;

declaration_specifiers
	: storage_class_specifier declaration_specifiers_opt
	{ }
	| type_specifier declaration_specifiers_opt
	{ }
	| type_qualifier declaration_specifiers_opt
	{ }
	| function_specifier declaration_specifiers_opt
	{ }
	;

declaration_specifiers_opt
	: declaration_specifiers
	| %empty
	;

init_declarator_list
	: init_declarator
	{ }
	| init_declarator_list COMMA init_declarator
	{ }
	;

init_declarator_list_opt
	: init_declarator_list
	| %empty
	;

init_declarator
	: declarator
	{
		$$ = $1;
	}
	| declarator ASSIGN initializer
	{		
		if($3->val!="") $1->val=$3->val;        //get the initial value and  emit it
		emit("=", $1->name, $3->name);
	}
	;

storage_class_specifier
	: EXTERN
	{ }
	| STATIC
	{ }
	;

type_specifier
	: VOID
	{ var_type="void"; }
	| CHAR
	{ var_type="char"; }
	| SHORT
	{ }
	| INT
	{ var_type="int"; }
	| LONG
	{ }
	| FLOAT
	{ var_type="float"; }
	| DOUBLE
	{ }
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list_opt
	{ }
	| type_qualifier specifier_qualifier_list_opt
	{ }
	;

specifier_qualifier_list_opt
	: specifier_qualifier_list
	| %empty
	;


type_qualifier
	: CONST
	{ }
	| VOLATILE
	{ }
	| RESTRICT
	{ }
	;

function_specifier
	: INLINE
	{ } 
	;

declarator
	: pointer direct_declarator
	{ 
		symboltype *t = $1;
		while(t->arrtype!=NULL) t = t->arrtype; //for multidimensional arr1s, move in depth till you get the base type
		t->arrtype = $2->type;                  //add the base type 
		$$ = $2->update($1);                    //update
	}
	|direct_declarator 
	{ }
	;


direct_declarator
	: IDENTIFIER                 //if ID, simply add a new variable of var_type
	{

		$$ = $1->update(new symboltype(var_type));
		currSymPtr = $$;

	}
	| ROUND_BRACKET_OPEN declarator ROUND_BRACKET_CLOSE {$$=$2;}        //simply equate
	| direct_declarator SQUARE_BRACKET_OPEN type_qualifier_list assignment_expression SQUARE_BRACKET_CLOSE {	}
	| direct_declarator SQUARE_BRACKET_OPEN type_qualifier_list SQUARE_BRACKET_CLOSE {	}
	| direct_declarator SQUARE_BRACKET_OPEN assignment_expression SQUARE_BRACKET_CLOSE 
	{

		symboltype *t = $1 -> type;
		symboltype *prev = NULL;
		while(t->type == "arr") 
		{
			prev = t;	
			t = t->arrtype;      //keep moving recursively to get basetype

		}
		if(prev==NULL) 
		{
	
			int temp = atoi($3->loc->val.c_str());      //get initial value

			symboltype* s = new symboltype("arr", $1->type, temp);        //create new symbol with that initial value

			$$ = $1->update(s);   //update the symbol table

	
		}
		else 
		{
	
			prev->arrtype =  new symboltype("arr", t, atoi($3->loc->val.c_str()));     //similar arguments as above		

			$$ = $1->update($1->type);

	
		}
	}
	| direct_declarator SQUARE_BRACKET_OPEN SQUARE_BRACKET_CLOSE 
	{

		symboltype *t = $1 -> type;
		symboltype *prev = NULL;
		while(t->type == "arr") 
		{
			prev = t;	
			t = t->arrtype;         //keep moving recursively to base type

		}
		if(prev==NULL) 
		{
	
			symboltype* s = new symboltype("arr", $1->type, 0);    //no initial values, simply keep 0

			$$ = $1->update(s);

		
		}
		else 
		{
	
			prev->arrtype =  new symboltype("arr", t, 0);

			$$ = $1->update($1->type);

	
		}
	}
	| direct_declarator SQUARE_BRACKET_OPEN STATIC type_qualifier_list assignment_expression SQUARE_BRACKET_CLOSE {	}
	| direct_declarator SQUARE_BRACKET_OPEN STATIC assignment_expression SQUARE_BRACKET_CLOSE {	}
	| direct_declarator SQUARE_BRACKET_OPEN type_qualifier_list MUL SQUARE_BRACKET_CLOSE {	}
	| direct_declarator SQUARE_BRACKET_OPEN MUL SQUARE_BRACKET_CLOSE {	}
	| direct_declarator ROUND_BRACKET_OPEN changetable parameter_type_list ROUND_BRACKET_CLOSE 
	{

		ST->name = $1->name;
		if($1->type->type !="void") 
		{
			sym *s = ST->lookup("return");         //lookup for return value	
			s->update($1->type);	
		}
		$1->nested = ST;       	
		ST->parent = globalST;
		changeTable(globalST);				// Come back to globalsymbol table
		currSymPtr = $$;

	}
	| direct_declarator ROUND_BRACKET_OPEN identifier_list ROUND_BRACKET_CLOSE {	}
	| direct_declarator ROUND_BRACKET_OPEN changetable ROUND_BRACKET_CLOSE 
	{        //similar as above

		ST->name = $1->name;
			if($1->type->type !="void") 
		{
			sym *s = ST->lookup("return");
			s->update($1->type);

				
		}
		$1->nested=ST;
		ST->parent = globalST;
		changeTable(globalST);				// Come back to globalsymbol table
		currSymPtr = $$;
		

	}
	;

type_qualifier_list_opt
	: type_qualifier_list
	| %empty
	;


changetable
	: %empty 
	{ 														// Used for changing to symbol table for a function
		
		
		
		if(currSymPtr->nested==NULL) 
		{
			
			changeTable(new symtable(""));	// Function symbol table doesn't already exist

		}
		else 
		{
			
			
			changeTable(currSymPtr ->nested);						// Function symbol table already exists
			
			emit("label", ST->name);
		}
	}
	;

pointer
	: MUL type_qualifier_list_opt
	{$$ = new symboltype("ptr");}
	| MUL type_qualifier_list_opt pointer
	{$$ = new symboltype("ptr",$3);}
	;

type_qualifier_list
	: type_qualifier
	{ }
	| type_qualifier_list type_qualifier
	{ }
	;


parameter_type_list
	: parameter_list
	{ }
	| parameter_list COMMA DOTS
	{ }
	;

parameter_list
	: parameter_declaration
	{ }
	| parameter_list COMMA parameter_declaration
	{ }
	;

parameter_declaration
	: declaration_specifiers declarator
	{ }
	| declaration_specifiers
	{ }
	;

identifier_list
	: IDENTIFIER
	{ }
	| identifier_list COMMA IDENTIFIER
	{ }
	;

type_name
	: specifier_qualifier_list
	{ }
	;

initializer
	: assignment_expression
	{  $$=$1->loc; }
	| CURLY_BRACKET_OPEN initializer_list CURLY_BRACKET_CLOSE
	{ }
	| CURLY_BRACKET_OPEN initializer_list COMMA CURLY_BRACKET_CLOSE
	{ }
	;

initializer_list
	: designation_opt initializer
	{ }
	| initializer_list COMMA designation_opt initializer
	{ }
	;

designation_opt
	: designation
	| %empty
	;

designation
	: designator_list ASSIGN
	{ }
	;

designator_list
	: designator
	{ }
	| designator_list designator
	{ }
	;

designator
	: SQUARE_BRACKET_OPEN constant_expression SQUARE_BRACKET_CLOSE
	{ }
	| DOT IDENTIFIER
	{ }
	;

statement
	: labeled_statement
	{ }
	| compound_statement
	{ $$ = $1;}
	| expression_statement
	{   
		$$=new Statement();
		$$->nextlist=$1->nextlist;
	}
	| selection_statement
	{$$ = $1;}
	| iteration_statement
	{$$ = $1;}
	| jump_statement
	{$$ = $1;}
	;

labeled_statement
	: IDENTIFIER COLON statement
	{ }
	| CASE constant_expression COLON statement
	{ }
	| DEFAULT COLON statement
	{ }
	;

compound_statement
	: CURLY_BRACKET_OPEN block_item_list_opt CURLY_BRACKET_CLOSE
	{ $$ = $2;}
	;

block_item_list_opt
	: %empty  { $$=new Statement(); }      //create new statement
	| block_item_list   { $$=$1; }        //simply equate
	;

block_item_list
	: block_item   { $$=$1; }			//simply equate
	| block_item_list M block_item    
	{ 
		$$=$3;
		backpatch($1->nextlist,$2);     //after $1, move to block_item via $2
	}
	;

block_item
	: declaration   { $$=new Statement(); }          //new statement
	| statement   { $$=$1; }				//simply equate
	;


expression_statement
	: expression SEMICOLON {$$=$1;}			//simply equate
	| SEMICOLON {$$ = new Expression();}      //new  expression
	;


selection_statement
	: IF ROUND_BRACKET_OPEN expression N ROUND_BRACKET_CLOSE M statement N %prec "then"      // if statement without else
	{

		backpatch($4->nextlist, nextinstr());        //nextlist of N goes to nextinstr
		convertIntToBool($3);         //convert expression to bool
		$$ = new Statement();        //make new statement
		backpatch($3->truelist, $6);        //is expression is true, go to M i.e just before statement body
		list<int> temp = merge($3->falselist, $7->nextlist);   //merge falselist of expression, nextlist of statement and second N
		$$->nextlist = merge($8->nextlist, temp);

	}
	| IF ROUND_BRACKET_OPEN expression N ROUND_BRACKET_CLOSE M statement N ELSE M statement   //if statement with else
	{

		backpatch($4->nextlist, nextinstr());		//nextlist of N goes to nextinstr
		convertIntToBool($3);        //convert expression to bool
		$$ = new Statement();       //make new statement
		backpatch($3->truelist, $6);    //when expression is true, go to M1 else go to M2
		backpatch($3->falselist, $10);
		list<int> temp = merge($7->nextlist, $8->nextlist);       //merge the nextlists of the statements and second N
		$$->nextlist = merge($11->nextlist,temp);	
	
	}
	| SWITCH ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE statement {	}       //not to be modelled
	;

iteration_statement	
	: WHILE M ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE M statement      //while statement
	{

		$$ = new Statement();    //create statement
		convertIntToBool($4);     //convert expression to bool
		backpatch($7->nextlist, $2);	// M1 to go back to expression again
		backpatch($4->truelist, $6);	// M2 to go to statement if the expression is true
		$$->nextlist = $4->falselist;   //when expression is false, move out of loop
		// Emit to prevent fallthrough
		string str=convertIntToString($2);			
		emit("goto", str);

			
	}
	| DO M statement M WHILE ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE SEMICOLON      //do statement
	{

		$$ = new Statement();     //create statement
		convertIntToBool($7);      //convert to bool
		backpatch($7->truelist, $2);						// M1 to go back to statement if expression is true
		backpatch($3->nextlist, $4);						// M2 to go to check expression if statement is complete
		$$->nextlist = $7->falselist;                       //move out if statement is false
		
	}
	| FOR ROUND_BRACKET_OPEN expression_statement M expression_statement ROUND_BRACKET_CLOSE M statement      //for loop
	{

		$$ = new Statement();   //create new statement
		convertIntToBool($5);    //convert check expression to boolean
		backpatch($5->truelist,$7);        //if expression is true, go to M2
		backpatch($8->nextlist,$4);        //after statement, go back to M1
		string str=convertIntToString($4);
		emit("goto", str);                 //prevent fallthrough

		$$->nextlist = $5->falselist;      //move out if statement is false

	}
	| FOR ROUND_BRACKET_OPEN expression_statement M expression_statement M expression N ROUND_BRACKET_CLOSE M statement
	{

		$$ = new Statement();		 //create new statement
		convertIntToBool($5);  //convert check expression to boolean
		backpatch($5->truelist, $10);	//if expression is true, go to M2
		backpatch($8->nextlist, $4);	//after N, go back to M1
		backpatch($11->nextlist, $6);	//statement go back to expression
		string str=convertIntToString($6);
		emit("goto", str);				//prevent fallthrough

		$$->nextlist = $5->falselist;	//move out if statement is false	
	
	}
	;

jump_statement
	: GOTO IDENTIFIER SEMICOLON
	{$$ = new Statement();}
	| CONTINUE SEMICOLON
	{$$ = new Statement();}
	| BREAK SEMICOLON
	{$$ = new Statement();}
	| RETURN expression SEMICOLON               
	{
		$$ = new Statement();
		emit("return",$2->loc->name);               //emit return with the name of the return value
	}
	| RETURN SEMICOLON 
	{
		$$ = new Statement();
		emit("return","");                         //simply emit return
	}
	;

translation_unit
	: external_declaration
	{}
	| translation_unit external_declaration
	{}
	;

external_declaration
	: function_definition
	{ }
	| declaration
	{ }
	;

function_definition
	: declaration_specifiers declarator declaration_list_opt changetable compound_statement
	{	
		ST->parent = globalST;
		changeTable(globalST);               
	}
	;


declaration_list
	: declaration
	{ }
	| declaration_list declaration
	{ }
	;

declaration_list_opt
	: %empty {  }
	| declaration_list   {  }
	;

%%

void yyerror(string s) 
{
	cout<<s<<endl;
}


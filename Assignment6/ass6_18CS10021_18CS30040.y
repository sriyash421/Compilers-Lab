%{
    #include "ass6_18CS10021_18CS30040_translator.h"
    void yyerror(const char*);
    extern int yylex(void);
    using namespace std;
%}


%union{
    int intval;   //to hold the value of integer constant
    char charval; //to hold the value of character constant
    idStr idl;    // to define the type for Identifier
    float floatval; //to hold the value of floating constant
    string *strval; // to hold the value of enumberation scnstant
    decStr decl;   //to define the declarators
    ArgumentList argsl; //to define the argumnets list
    int instr;  // to defin the type used by M->(epsilon)
    expresn expon;   // to define the structure of expression
    list *nextlist;  //to define the nextlist type for N->(epsilon)
}

%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INLINE INT LONG REGISTER RESTRICT RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE _BOOL _COMPLEX _IMAGINARY 
%token POINTER INCREMENT DECREMENT LEFT_SHIFT RIGHT_SHIFT LESS_EQUALS GREATER_EQUALS EQUALS NOT_EQUALS
%token AND OR ELLIPSIS MULTIPLY_ASSIGN DIVIDE_ASSIGN MODULO_ASSIGN ADD_ASSIGN SUBTRACT_ASSIGN
%token LEFT_SHIFT_ASSIGN RIGHT_SHIFT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN SINGLE_LINE_COMMENT MULTI_LINE_COMMENT
%token <idl> IDENTIFIER  
%token <intval> INTEGER_CONSTANT
%token <floatval> FLOATING_CONSTANT
%token <charval> CHAR_CONST
%token <strval> STRING_LITERAL
%type <expon> primary_expression postfix_expression unary_expression cast_expression multiplicative_expression additive_expression shift_expression relational_expression equality_expression AND_expression exclusive_OR_expression inclusive_OR_expression logical_AND_expression logical_OR_expression conditional_expression assignment_expression_opt assignment_expression constant_expression expression expression_statement expression_opt declarator direct_declarator initializer identifier_opt declaration init_declarator_list init_declarator_list_opt init_declarator
%type <nextlist> block_item_list block_item statement labeled_statement compound_statement selection_statement iteration_statement jump_statement block_item_list_opt
%type <argsl> argument_expression_list argument_expression_list_opt
%type <decl> type_specifier declaration_specifiers specifier_qualifier_list type_name pointer pointer_opt
%type <instr>       M
%type <nextlist>    N
%type <charval>     unary_operator

%start translation_unit

%left '+' '-'
%left '*' '/' '%'
%nonassoc UNARY
%nonassoc IF_CONFLICT
%nonassoc ELSE

%%
M:
{
    $$ = next_instr;
};

N:
{
    $$ = makelist(next_instr);
    global_quad_table.emit(Q_GOTO, -1);
};

/*Expressions*/
primary_expression:             IDENTIFIER {
                                                //Check whether its a function
                                                symdata * check_func = glob_st->search(*$1.name);
                                                
                                                if(check_func == NULL)
                                                {
                                                    $$.loc  =  Current_ST->lookup_2(*$1.name);
                                                    
                                                    if($$.loc->tp_n != NULL && $$.loc->tp_n->basetp == tp_arr)
                                                    {
                                                        //If Array
                                                        $$.arr = $$.loc;
                                                        
                                                        $$.loc = Current_ST->gentemp(new type_n(tp_int));
                                                        
                                                        $$.loc->i_val.int_val = 0;
                                                        
                                                        $$.loc->isInitialized = true;
                                                        
                                                        global_quad_table.emit(Q_ASSIGN,0,$$.loc->name);
                                                        
                                                        $$.type = $$.arr->tp_n;
                                                        
                                                        $$.poss_array = $$.arr;
                                                        
                                                    }
                                                    else
                                                    {
                                                        // If not an Array
                                                        $$.type = $$.loc->tp_n;
                                                        
                                                        $$.arr = NULL;
                                                        
                                                        $$.isPointer = false;
                                                        
                                                    }
                                                }
                                                else
                                                {
                                                    // It is a function
                                                    $$.loc = check_func;
                                                    
                                                    $$.type = check_func->tp_n;
                                                    
                                                    $$.arr = NULL;
                                                    
                                                    $$.isPointer = false;
                                                    
                                                }
                                            } |
                                INTEGER_CONSTANT {
                                                    // Declare and initialize the value of the temporary variable with the integer
                                                    $$.loc  = Current_ST->gentemp(new type_n(tp_int));
                                                    
                                                    $$.type = $$.loc->tp_n;
                                                    
                                                    $$.loc->i_val.int_val = $1;
                                                    
                                                    $$.loc->isInitialized = true;
                                                    
                                                    $$.arr = NULL;
                                                    
                                                    global_quad_table.emit(Q_ASSIGN, $1, $$.loc->name);
                                                    
                                                } |
                                FLOATING_CONSTANT {
                                                    // Declare and initialize the value of the temporary variable with the floatval
                                                    $$.loc  = Current_ST->gentemp(new type_n(tp_double));
                                                    
                                                    $$.type = $$.loc->tp_n;
                                                    
                                                    $$.loc->i_val.double_val = $1;
                                                    
                                                    $$.loc->isInitialized = true;
                                                    
                                                    $$.arr = NULL;
                                                    
                                                    global_quad_table.emit(Q_ASSIGN, $1, $$.loc->name);
                                                    
                                                  } |
                                CHAR_CONST {
                                                // Declare and initialize the value of the temporary variable with the character
                                                $$.loc  = Current_ST->gentemp(new type_n(tp_char));
                                                
                                                $$.type = $$.loc->tp_n;
                                                
                                                $$.loc->i_val.char_val = $1;
                                                
                                                $$.loc->isInitialized = true;
                                                
                                                $$.arr = NULL;
                                                
                                                global_quad_table.emit(Q_ASSIGN, $1, $$.loc->name);
                                                
                                            } |
                                STRING_LITERAL {
                                                    
                                                    strings_label.push_back(*$1);
                                                    
                                                    $$.loc = NULL;
                                                    
                                                    $$.isString = true;
                                                    
                                                    $$.ind_str = strings_label.size()-1;
                                                    
                                                    $$.arr = NULL;
                                                    
                                                    $$.isPointer = false;
                                                    
                                                } |
                                '(' expression ')' {
                                                        $$ = $2;
                                                   };

enumeration_constant:           IDENTIFIER {};

postfix_expression :            primary_expression {
                                                         $$ = $1;
                                                    } |
                                postfix_expression '[' expression ']' {
                                                                        //Explanation of Array handling
                                        
                                                                        $$.loc = Current_ST->gentemp(new type_n(tp_int));
                                                                        
                                                                        
                                                                        symdata* temporary = Current_ST->gentemp(new type_n(tp_int));
                                                                        
                                                                        
                                                                        char temp[10];
                                                                        
                                                                        sprintf(temp,"%d",$1.type->next->getSize());
                                                                        
                                                                        
                                                                        global_quad_table.emit(Q_MULT,$3.loc->name,temp,temporary->name);
                                                                        
                                                                        global_quad_table.emit(Q_PLUS,$1.loc->name,temporary->name,$$.loc->name);
                                                                        
                                                                        
                                                                        // the new size will be calculated and the temporary variable storing the size will be passed on a $$.loc
                                                                        
                                                                        //$$.arr <= base pointer
                                                                        $$.arr = $1.arr;
                                                                        
                                                                        
                                                                        //$$.type <= basetp(arr)
                                                                        $$.type = $1.type->next;
                                                                        
                                                                        $$.poss_array = NULL;
                                                                        

                                                                        //$$.arr->tp_n has the full type of the arr which will be used for size calculations
                                                                     } |
                                postfix_expression '(' argument_expression_list_opt ')' {
                                                                                            //Explanation of Function Handling
                                                                                            if(!$1.isPointer && !$1.isString && ($1.type) && ($1.type->basetp==tp_void))
                                                                                            {
                                                                                                     
                                                                                            }
                                                                                            else
                                                                                                $$.loc = Current_ST->gentemp(CopyType($1.type));
                                                                                            //temporary is created 
                                                                                            char str[10];
                                                                                            
                                                                                            if($3.arguments == NULL)
                                                                                            {
                                                                                                //No function Parameters
                                                                                                sprintf(str,"0");
                                                                                                
                                                                                                if($1.type->basetp!=tp_void)
                                                                                                    global_quad_table.emit(Q_CALL,$1.loc->name,str,$$.loc->name);
                                                                                                else
                                                                                                    global_quad_table.emit2(Q_CALL,$1.loc->name,str);
                                                                                                
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                if((*$3.arguments)[0]->isString)
                                                                                                {
                                                                                                    str[0] = '_';
                                                                                                    
                                                                                                    sprintf(str+1,"%d",(*$3.arguments)[0]->ind_str);
                                                                                                    
                                                                                                    global_quad_table.emit(Q_PARAM,str);
                                                                                                    
                                                                                                    global_quad_table.emit(Q_CALL,$1.loc->name,"1",$$.loc->name);
                                                                                                    
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    for(int i=0;i<$3.arguments->size();i++)
                                                                                                    {
                                                                                                        // To print the parameters 
                                                                                                        if((*$3.arguments)[i]->poss_array != NULL && $1.loc->name != "printInt")
                                                                                                            global_quad_table.emit(Q_PARAM,(*$3.arguments)[i]->poss_array->name);
                                                                                                        else
                                                                                                            global_quad_table.emit(Q_PARAM,(*$3.arguments)[i]->loc->name);
                                                                        
                                                                                                    }
                                                                                                    
                                                                                                    sprintf(str,"%ld",$3.arguments->size());
                                                                                                    
                                                                                                    if($1.type->basetp!=tp_void)
                                                                                                        global_quad_table.emit(Q_CALL,$1.loc->name,str,$$.loc->name);
                                                                                                    else
                                                                                                        global_quad_table.emit2(Q_CALL,$1.loc->name,str);
                                                                                                    
                                                                                                }
                                                                                            }

                                                                                            $$.arr = NULL;
                                                                                            
                                                                                            $$.type = $$.loc->tp_n;
                                                                                            
                                                                                         } |
                                postfix_expression '.' IDENTIFIER {/*Struct Logic to be Skipped*/}|
                                postfix_expression POINTER IDENTIFIER {
                                                                            /*----*/
                                                                      } |
                                postfix_expression INCREMENT {
                                                                $$.loc = Current_ST->gentemp(CopyType($1.type));
                                                                
                                                                if($1.arr != NULL)
                                                                {
                                                                    // Post increment of an Array element
                                                                    symdata * temp_elem = Current_ST->gentemp(CopyType($1.type));
                                                                    
                                                                    global_quad_table.emit(Q_RINDEX,$1.arr->name,$1.loc->name,$$.loc->name);
                                                                    
                                                                    global_quad_table.emit(Q_RINDEX,$1.arr->name,$1.loc->name,temp_elem->name);
                                                                    
                                                                    global_quad_table.emit(Q_PLUS,temp_elem->name,"1",temp_elem->name);
                                                                    
                                                                    global_quad_table.emit(Q_LINDEX,$1.loc->name,temp_elem->name,$1.arr->name);
                                                                    
                                                                    $$.arr = NULL;
                                                                    
                                                                }
                                                                else
                                                                {
                                                                    //post increment of an simple element
                                                                    global_quad_table.emit(Q_ASSIGN,$1.loc->name,$$.loc->name);
                                                                    
                                                                    global_quad_table.emit(Q_PLUS,$1.loc->name,"1",$1.loc->name); 
                                                                       
                                                                }
                                                                $$.type = $$.loc->tp_n;                  
                                                                               
                                                             } |
                                postfix_expression DECREMENT {
                                                                $$.loc = Current_ST->gentemp(CopyType($1.type));
                                                                
                                                                if($1.arr != NULL)
                                                                {
                                                                    // Post decrement of an Array element
                                                                    symdata * temp_elem = Current_ST->gentemp(CopyType($1.type));
                                                                    
                                                                    global_quad_table.emit(Q_RINDEX,$1.arr->name,$1.loc->name,$$.loc->name);
                                                                    
                                                                    global_quad_table.emit(Q_RINDEX,$1.arr->name,$1.loc->name,temp_elem->name);
                                                                    
                                                                    global_quad_table.emit(Q_MINUS,temp_elem->name,"1",temp_elem->name);
                                                                    
                                                                    global_quad_table.emit(Q_LINDEX,$1.loc->name,temp_elem->name,$1.arr->name);
                                                                    
                                                                    $$.arr = NULL;
                                                                    
                                                                }
                                                                else
                                                                {
                                                                    //post decrement of an simple element
                                                                    global_quad_table.emit(Q_ASSIGN,$1.loc->name,$$.loc->name);
                                                                    
                                                                    global_quad_table.emit(Q_MINUS,$1.loc->name,"1",$1.loc->name);
                                                                    
                                                                }
                                                                $$.type = $$.loc->tp_n;
                                                                
                                                              } |
                                '(' type_name ')' '{' initializer_list '}' {
                                                                                /*------*/
                                                                           }|
                                '(' type_name ')' '{' initializer_list ',' '}' {
                                                                                    /*------*/
                                                                               };

argument_expression_list:       assignment_expression {
                                                        $$.arguments = new vector<expresn*>;
                                                        
                                                        expresn * tex = new expresn($1);
                                                        
                                                        $$.arguments->push_back(tex);
                                                        
                                                        
                                                     }|
                                argument_expression_list ',' assignment_expression {
                                                                                        expresn * tex = new expresn($3);
                                                                                        
                                                                                        $$.arguments->push_back(tex);
                                                                                        
                                                                                    };

argument_expression_list_opt:   argument_expression_list {
                                                            $$ = $1;
                                                            
                                                          }|
                                /*epsilon*/ {
                                                $$.arguments = NULL;
                                                
                                            };

unary_expression:               postfix_expression {
                                                        $$ = $1;
                                                        
                                                   }|
                                INCREMENT unary_expression {
                                                                $$.loc = Current_ST->gentemp($2.type);
                                                                
                                                                if($2.arr != NULL)
                                                                {
                                                                    // pre increment of an Array element 
                                                                    symdata * temp_elem = Current_ST->gentemp(CopyType($2.type));
                                                                    
                                                                    global_quad_table.emit(Q_RINDEX,$2.arr->name,$2.loc->name,temp_elem->name);
                                                                    
                                                                    global_quad_table.emit(Q_PLUS,temp_elem->name,"1",temp_elem->name);
                                                                    
                                                                    global_quad_table.emit(Q_LINDEX,$2.loc->name,temp_elem->name,$2.arr->name);
                                                                    
                                                                    global_quad_table.emit(Q_RINDEX,$2.arr->name,$2.loc->name,$$.loc->name);
                                                                    
                                                                    $$.arr = NULL;
                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // pre increment
                                                                    global_quad_table.emit(Q_PLUS,$2.loc->name,"1",$2.loc->name);
                                                                    
                                                                    global_quad_table.emit(Q_ASSIGN,$2.loc->name,$$.loc->name);
                                                                    
                                                                }
                                                                $$.type = $$.loc->tp_n;
                                                                
                                                            }|
                                DECREMENT unary_expression {
                                                                $$.loc = Current_ST->gentemp(CopyType($2.type));
                                                                
                                                                if($2.arr != NULL)
                                                                {
                                                                    //pre decrement of  Array Element 
                                                                    symdata * temp_elem = Current_ST->gentemp(CopyType($2.type));
                                                                    
                                                                    global_quad_table.emit(Q_RINDEX,$2.arr->name,$2.loc->name,temp_elem->name);
                                                                    
                                                                    global_quad_table.emit(Q_MINUS,temp_elem->name,"1",temp_elem->name);
                                                                    
                                                                    global_quad_table.emit(Q_LINDEX,$2.loc->name,temp_elem->name,$2.arr->name);
                                                                    
                                                                    global_quad_table.emit(Q_RINDEX,$2.arr->name,$2.loc->name,$$.loc->name);
                                                                    
                                                                    $$.arr = NULL;
                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // pre decrement
                                                                    global_quad_table.emit(Q_MINUS,$2.loc->name,"1",$2.loc->name);
                                                                    
                                                                    global_quad_table.emit(Q_ASSIGN,$2.loc->name,$$.loc->name);
                                                                    
                                                                }
                                                                $$.type = $$.loc->tp_n;
                                                                
                                                            }|
                                unary_operator cast_expression
                                                                {
                                                                    type_n * temp_type;
                                                                    
                                                                    switch($1)
                                                                    {
                                                                        case '&':
                                                                            //create a temporary type store the type
                                                                            temp_type = new type_n(tp_ptr,1,$2.type);
                                                                            
                                                                            $$.loc = Current_ST->gentemp(CopyType(temp_type));
                                                                            
                                                                            $$.type = $$.loc->tp_n;
                                                                            
                                                                            global_quad_table.emit(Q_ADDR,$2.loc->name,$$.loc->name);
                                                                            
                                                                            $$.arr = NULL;
                                                                            
                                                                            break;
                                                                        case '*':
                                                                            $$.isPointer = true;
                                                                            
                                                                            $$.type = $2.loc->tp_n->next;
                                                                            
                                                                            $$.loc = $2.loc;
                                                                            
                                                                            $$.arr = NULL;
                                                                            
                                                                            break;
                                                                        case '+':
                                                                            $$.loc = Current_ST->gentemp(CopyType($2.type));
                                                                            
                                                                            $$.type = $$.loc->tp_n;
                                                                            
                                                                            global_quad_table.emit(Q_ASSIGN,$2.loc->name,$$.loc->name);
                                                                            
                                                                            break;
                                                                        case '-':
                                                                            $$.loc = Current_ST->gentemp(CopyType($2.type));
                                                                            
                                                                            $$.type = $$.loc->tp_n;
                                                                            
                                                                            global_quad_table.emit(Q_UNARY_MINUS,$2.loc->name,$$.loc->name);
                                                                            
                                                                            break;
                                                                        case '~':
                                                                            /*Bitwise Not to be implemented Later on*/
                                                                            $$.loc = Current_ST->gentemp(CopyType($2.type));
                                                                            
                                                                            $$.type = $$.loc->tp_n;
                                                                            
                                                                            global_quad_table.emit(Q_NOT,$2.loc->name,$$.loc->name);
                                                                            
                                                                            break;
                                                                        case '!':
                                                                            $$.loc = Current_ST->gentemp(CopyType($2.type));
                                                                            
                                                                            $$.type = $$.loc->tp_n;
                                                                            
                                                                            $$.truelist = $2.falselist;
                                                                            
                                                                            $$.falselist = $2.truelist;
                                                                            
                                                                            break;
                                                                        default:
                                                                            
                                                                            break;
                                                                    }
                                                                }|
                                SIZEOF unary_expression {}|
                                SIZEOF '(' type_name ')' {};

unary_operator  :               '&' {
                                        $$ = '&';
                                    }|
                                '*' {
                                        $$ = '*';
                                    }|
                                '+' {
                                        $$ = '+';
                                    }|
                                '-' {
                                        $$ = '-';
                                    }|
                                '~' {
                                        $$ = '~';
                                    }|
                                '!' {
                                        $$ = '!';
                                    };

cast_expression :               unary_expression {
                                                    if($1.arr != NULL && $1.arr->tp_n != NULL&& $1.poss_array==NULL)
                                                    {
                                                        //Right Indexing of an Array element as unary expression is converted into cast expression
                                                        $$.loc = Current_ST->gentemp(new type_n($1.type->basetp));
                                                        
                                                        global_quad_table.emit(Q_RINDEX,$1.arr->name,$1.loc->name,$$.loc->name);
                                                        
                                                        $$.arr = NULL;
                                                        
                                                        $$.type = $$.loc->tp_n;
                                                        
                                                        //$$.poss_array=$1.arr;
                                                        
                                                    }
                                                    else if($1.isPointer == true)
                                                    {
                                                        //RDereferencing as its a pointer
                                                        $$.loc = Current_ST->gentemp(CopyType($1.type));
                                                        
                                                        $$.isPointer = false;
                                                        
                                                        global_quad_table.emit(Q_RDEREF,$1.loc->name,$$.loc->name);
                                                        
                                                    }
                                                    else
                                                        $$ = $1;
                                                }|
                                '(' type_name ')' cast_expression{
                                                                    /*--------*/
                                                                 };

multiplicative_expression:      cast_expression {
                                                    $$ = $1;
                                                }|
                                multiplicative_expression '*' cast_expression {
                                                                                    typecheck(&$1,&$3);
                                                                                    
                                                                                    $$.loc = Current_ST->gentemp($1.type);
                                                                                    
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    
                                                                                    global_quad_table.emit(Q_MULT,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                    
                                                                              }|
                                multiplicative_expression '/' cast_expression {
                                                                                    typecheck(&$1,&$3);
                                                                                    
                                                                                    $$.loc = Current_ST->gentemp($1.type);
                                                                                    
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    
                                                                                    global_quad_table.emit(Q_DIVIDE,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                    
                                                                              }|
                                multiplicative_expression '%' cast_expression{
                                                                                    typecheck(&$1,&$3);
                                                                                    
                                                                                    $$.loc = Current_ST->gentemp($1.type);
                                                                                    
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    
                                                                                    global_quad_table.emit(Q_MODULO,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                    
                                                                             };

additive_expression :           multiplicative_expression {
                                                                $$ = $1;
                                                          }|
                                additive_expression '+' multiplicative_expression {
                                                                                        typecheck(&$1,&$3);
                                                                                        
                                                                                        $$.loc = Current_ST->gentemp($1.type);
                                                                                        
                                                                                        $$.type = $$.loc->tp_n;
                                                                                        
                                                                                        global_quad_table.emit(Q_PLUS,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                        
                                                                                  }|
                                additive_expression '-' multiplicative_expression {
                                                                                        typecheck(&$1,&$3);
                                                                                        
                                                                                        $$.loc = Current_ST->gentemp($1.type);
                                                                                        
                                                                                        $$.type = $$.loc->tp_n;
                                                                                        
                                                                                        global_quad_table.emit(Q_MINUS,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                        
                                                                                  };

shift_expression:               additive_expression {
                                                        $$ = $1;
                                                    }|
                                shift_expression LEFT_SHIFT additive_expression {
                                                                                    $$.loc = Current_ST->gentemp($1.type);
                                                                                    
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    
                                                                                    global_quad_table.emit(Q_LEFT_OP,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                    
                                                                                }|
                                shift_expression RIGHT_SHIFT additive_expression{
                                                                                    $$.loc = Current_ST->gentemp($1.type);
                                                                                    
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    
                                                                                    global_quad_table.emit(Q_RIGHT_OP,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                    
                                                                                };

relational_expression:          shift_expression {
                                                        $$ = $1;
                                                 }|
                                relational_expression '<' shift_expression {
                                                                                typecheck(&$1,&$3);
                                                                                
                                                                                $$.type = new type_n(tp_bool);
                                                                                
                                                                                $$.truelist = makelist(next_instr);
                                                                                
                                                                                $$.falselist = makelist(next_instr+1);
                                                                                
                                                                                global_quad_table.emit(Q_IF_LESS,$1.loc->name,$3.loc->name,"-1");
                                                                                
                                                                                global_quad_table.emit(Q_GOTO,"-1");
                                                                                
                                                                           }|
                                relational_expression '>' shift_expression {
                                                                                typecheck(&$1,&$3);
                                                                                
                                                                                $$.type = new type_n(tp_bool);
                                                                                
                                                                                $$.truelist = makelist(next_instr);
                                                                                
                                                                                $$.falselist = makelist(next_instr+1);
                                                                                
                                                                                global_quad_table.emit(Q_IF_GREATER,$1.loc->name,$3.loc->name,"-1");
                                                                                
                                                                                global_quad_table.emit(Q_GOTO,"-1");
                                                                                
                                                                           }|
                                relational_expression LESS_EQUALS shift_expression {
                                                                                        typecheck(&$1,&$3);
                                                                                        
                                                                                        $$.type = new type_n(tp_bool);
                                                                                        
                                                                                        $$.truelist = makelist(next_instr);
                                                                                        
                                                                                        $$.falselist = makelist(next_instr+1);
                                                                                        
                                                                                        global_quad_table.emit(Q_IF_LESS_OR_EQUAL,$1.loc->name,$3.loc->name,"-1");
                                                                                        
                                                                                        global_quad_table.emit(Q_GOTO,"-1");
                                                                                        
                                                                                    }|
                                relational_expression GREATER_EQUALS shift_expression {
                                                                                            typecheck(&$1,&$3);
                                                                                            
                                                                                            $$.type = new type_n(tp_bool);
                                                                                            
                                                                                            $$.truelist = makelist(next_instr);
                                                                                            
                                                                                            $$.falselist = makelist(next_instr+1);
                                                                                            
                                                                                            global_quad_table.emit(Q_IF_GREATER_OR_EQUAL,$1.loc->name,$3.loc->name,"-1");
                                                                                            
                                                                                            global_quad_table.emit(Q_GOTO,"-1");
                                                                                            
                                                                                      };

equality_expression:            relational_expression {
                                                            $$ = $1;
                                                      }|
                                equality_expression EQUALS relational_expression {
                                                                                        typecheck(&$1,&$3);
                                                                                        
                                                                                        $$.type = new type_n(tp_bool);
                                                                                        
                                                                                        $$.truelist = makelist(next_instr);
                                                                                        
                                                                                        $$.falselist = makelist(next_instr+1);
                                                                                        
                                                                                        global_quad_table.emit(Q_IF_EQUAL,$1.loc->name,$3.loc->name,"-1");
                                                                                        
                                                                                        global_quad_table.emit(Q_GOTO,"-1");
                                                                                        
                                                                                 }|
                                equality_expression NOT_EQUALS relational_expression {
                                                                                            typecheck(&$1,&$3);
                                                                                            
                                                                                            $$.type = new type_n(tp_bool);
                                                                                            
                                                                                            $$.truelist = makelist(next_instr);
                                                                                            
                                                                                            $$.falselist = makelist(next_instr+1);
                                                                                            
                                                                                            global_quad_table.emit(Q_IF_NOT_EQUAL,$1.loc->name,$3.loc->name,"-1");
                                                                                            
                                                                                            global_quad_table.emit(Q_GOTO,"-1");
                                                                                            
                                                                                     };

AND_expression :                equality_expression {
                                                        $$ = $1;
                                                    }|
                                AND_expression '&' equality_expression {
                                                                            $$.loc = Current_ST->gentemp($1.type);
                                                                            
                                                                            $$.type = $$.loc->tp_n;
                                                                            
                                                                            global_quad_table.emit(Q_LOG_AND,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                            
                                                                        };

exclusive_OR_expression:        AND_expression {
                                                    $$ = $1;
                                               }|
                                exclusive_OR_expression '^' AND_expression {
                                                                                $$.loc = Current_ST->gentemp($1.type);
                                                                                
                                                                                $$.type = $$.loc->tp_n;
                                                                                
                                                                                global_quad_table.emit(Q_XOR,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                
                                                                           };

inclusive_OR_expression:        exclusive_OR_expression {
                                                            $$ = $1;
                                                        }|
                                inclusive_OR_expression '|' exclusive_OR_expression {
                                                                                        $$.loc = Current_ST->gentemp($1.type);
                                                                                        
                                                                                        $$.type = $$.loc->tp_n;
                                                                                        
                                                                                        global_quad_table.emit(Q_LOG_OR,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                        
                                                                                    };

logical_AND_expression:         inclusive_OR_expression {
                                                            $$ = $1;
                                                        }|
                                logical_AND_expression AND M inclusive_OR_expression {
                                                                                        if($1.type->basetp != tp_bool)
                                                                                            conv2Bool(&$1);
                                                                                        if($4.type->basetp != tp_bool)
                                                                                            conv2Bool(&$4);
                                                                                        
                                                                                        backpatch($1.truelist,$3);
                                                                                        
                                                                                        $$.type = new type_n(tp_bool);
                                                                                        
                                                                                        $$.falselist = merge($1.falselist,$4.falselist);
                                                                                        
                                                                                        $$.truelist = $4.truelist;
                                                                                        
                                                                                    };

logical_OR_expression:          logical_AND_expression {
                                                            $$ = $1;
                                                       }|
                                logical_OR_expression OR M logical_AND_expression   {
                                                                                        if($1.type->basetp != tp_bool)
                                                                                            conv2Bool(&$1);
                                                                                        if($4.type->basetp != tp_bool)
                                                                                            conv2Bool(&$4); 
                                                                                        
                                                                                        backpatch($1.falselist,$3);
                                                                                        
                                                                                        $$.type = new type_n(tp_bool);
                                                                                        
                                                                                        $$.truelist = merge($1.truelist,$4.truelist);
                                                                                        
                                                                                        $$.falselist = $4.falselist;
                                                                                        
                                                                                    };

/*It is assumed that type of expression and conditional expression are same*/
conditional_expression:         logical_OR_expression {
                                                            $$ = $1;
                                                      }|
                                logical_OR_expression N '?' M expression N ':' M conditional_expression {
                                                                                                            $$.loc = Current_ST->gentemp($5.type);
                                                                                                            
                                                                                                            $$.type = $$.loc->tp_n;
                                                                                                            
                                                                                                            global_quad_table.emit(Q_ASSIGN,$9.loc->name,$$.loc->name);
                                                                                                            
                                                                                                            list* TEMP_LIST = makelist(next_instr);
                                                                                                            
                                                                                                            global_quad_table.emit(Q_GOTO,"-1");
                                                                                                            
                                                                                                            backpatch($6,next_instr);
                                                                                                            
                                                                                                            global_quad_table.emit(Q_ASSIGN,$5.loc->name,$$.loc->name);
                                                                                                            
                                                                                                            TEMP_LIST = merge(TEMP_LIST,makelist(next_instr));
                                                                                                            
                                                                                                            global_quad_table.emit(Q_GOTO,"-1");
                                                                                                            
                                                                                                            backpatch($2,next_instr);
                                                                                                            
                                                                                                            conv2Bool(&$1);
                                                                                                            
                                                                                                            backpatch($1.truelist,$4);
                                                                                                            
                                                                                                            backpatch($1.falselist,$8);
                                                                                                            
                                                                                                            backpatch(TEMP_LIST,next_instr);
                                                                                                            
                                                                                                        };

assignment_operator:            '='                                                     |
                                MULTIPLY_ASSIGN                                         |
                                DIVIDE_ASSIGN                                           |
                                MODULO_ASSIGN                                           |
                                ADD_ASSIGN                                              |
                                SUBTRACT_ASSIGN                                         |
                                LEFT_SHIFT_ASSIGN                                       |
                                RIGHT_SHIFT_ASSIGN                                      |
                                AND_ASSIGN                                              |
                                XOR_ASSIGN                                              |
                                OR_ASSIGN                                               ;

assignment_expression:          conditional_expression {
                                                            $$ = $1;
                                                        }|
                                unary_expression assignment_operator assignment_expression {
                                                                                                //LDereferencing
                                                                                                if($1.isPointer)
                                                                                                {
                                                                                                    global_quad_table.emit(Q_LDEREF,$3.loc->name,$1.loc->name);
                                                                                                    
                                                                                                }
                                                                                                typecheck(&$1,&$3,true);
                                                                                                
                                                                                                if($1.arr != NULL)
                                                                                                {
                                                                                                    global_quad_table.emit(Q_LINDEX,$1.loc->name,$3.loc->name,$1.arr->name);
                                                                                                    
                                                                                                }
                                                                                                else if(!$1.isPointer)
                                                                                                    global_quad_table.emit(Q_ASSIGN,$3.loc->name,$1.loc->name);
                                                                                                
                                                                                                $$.loc = Current_ST->gentemp($3.type);
                                                                                                
                                                                                                $$.type = $$.loc->tp_n;
                                                                                                
                                                                                                global_quad_table.emit(Q_ASSIGN,$3.loc->name,$$.loc->name);
                                                                                                
                                                                                            };

/*A constant value of this expression exists*/
constant_expression:            conditional_expression {
                                                            $$ = $1;
                                                            
                                                       };

expression :                    assignment_expression {
                                                            $$ = $1;
                                                            
                                                      }|
                                expression ',' assignment_expression {
                                                                        $$ = $3;
                                                                        
                                                                     };

/*Declarations*/ 

declaration:                    declaration_specifiers init_declarator_list_opt ';' {
                                                                                        if($2.loc != NULL && $2.type != NULL && $2.type->basetp == tp_func)
                                                                                        {
                                                                                            /*Delete Current_ST*/
                                                                                            Current_ST = new symtab();
                                                                                            
                                                                                        }
                                                                                    };

init_declarator_list_opt:       init_declarator_list {
                                                        if($1.type != NULL && $1.type->basetp == tp_func)
                                                        {
                                                            $$ = $1;
                                                            
                                                        }
                                                     }|
                                /*epsilon*/ {
                                                $$.loc = NULL;
                                                
                                            };

declaration_specifiers:         storage_class_specifier declaration_specifiers_opt {}|
                                type_specifier declaration_specifiers_opt               |
                                type_qualifier declaration_specifiers_opt {}|
                                function_specifier declaration_specifiers_opt {};

declaration_specifiers_opt:     declaration_specifiers                                  |
                                /*epsilon*/                                             ;

init_declarator_list:           init_declarator {
                                                    /*Expecting only function declaration*/
                                                    $$ = $1;
                                                    
                                                }|
                                init_declarator_list ',' init_declarator                ;

init_declarator:                declarator {
                                                /*Nothing to be done here*/
                                                if($1.type != NULL && $1.type->basetp == tp_func)
                                                {
                                                    $$ = $1;
                                                    
                                                }
                                            }|
                                declarator '=' initializer {
                                                                //initializations of declarators
                                                                if($3.type!=NULL)
                                                                {
                                                                    if($3.type->basetp==tp_int)
                                                                    {
                                                                        $1.loc->i_val.int_val= $3.loc->i_val.int_val;
                                                                        
                                                                        $1.loc->isInitialized = true;
                                                                        
                                                                        symdata *temp_ver=Current_ST->search($1.loc->name);
                                                                        
                                                                        if(temp_ver!=NULL)
                                                                        {
                                                                            temp_ver->i_val.int_val= $3.loc->i_val.int_val;
                                                                            
                                                                            temp_ver->isInitialized = true;
                                                                            
                                                                        }
                                                                    }
                                                                    else if($3.type->basetp==tp_char)
                                                                    {
                                                                        $1.loc->i_val.char_val= $3.loc->i_val.char_val;
                                                                        
                                                                        $1.loc->isInitialized = true;
                                                                        
                                                                        symdata *temp_ver=Current_ST->search($1.loc->name);
                                                                        
                                                                        if(temp_ver!=NULL)
                                                                        {
                                                                            temp_ver->i_val.char_val= $3.loc->i_val.char_val;
                                                                            
                                                                            temp_ver->isInitialized = true;
                                                                            
                                                                        }
                                                                    }
                                                                }
                                                                //typecheck(&$1,&$3,true);
                                                                global_quad_table.emit(Q_ASSIGN,$3.loc->name,$1.loc->name);
                                                                
                                                            };

storage_class_specifier:        EXTERN {}|
                                STATIC {}|
                                AUTO {}|
                                REGISTER {};

type_specifier:                 VOID {
                                        glob_type = new type_n(tp_void);
                                        
                                    }|
                                CHAR {
                                        glob_type = new type_n(tp_char);
                                        
                                    }|
                                SHORT {}|
                                INT {
                                        glob_type = new type_n(tp_int);
                                        
                                    }|
                                LONG {}|
                                FLOAT {}|
                                DOUBLE {
                                            glob_type = new type_n(tp_double);
                                            
                                        }|
                                SIGNED {}|
                                UNSIGNED {}|
                                _BOOL {}|
                                _COMPLEX {}|
                                _IMAGINARY {}|
                                enum_specifier {};

specifier_qualifier_list:       type_specifier specifier_qualifier_list_opt {
                                                                                /*----------*/
                                                                            }|
                                type_qualifier specifier_qualifier_list_opt {}; 

specifier_qualifier_list_opt:   specifier_qualifier_list {}|
                                /*epsilon*/ {};

enum_specifier:                 ENUM identifier_opt '{' enumerator_list '}' {}|
                                ENUM identifier_opt '{' enumerator_list ',' '}' {}|
                                ENUM IDENTIFIER {};

identifier_opt:                 IDENTIFIER {
                                                $$.loc  = Current_ST->lookup(*$1.name);
                                                
                                                
                                                $$.type = new type_n(glob_type->basetp);
                                                
                                            }|
                                /*epsilon*/ {};

enumerator_list:                enumerator {}|
                                enumerator_list ',' enumerator {};

enumerator:                     enumeration_constant {}|
                                enumeration_constant '=' constant_expression {};

type_qualifier:                 CONST {}|
                                RESTRICT {}|
                                VOLATILE {};

function_specifier:             INLINE {};

declarator :                    pointer_opt direct_declarator {
                                                                if($1.type == NULL)
                                                                {
                                                                    /*--------------*/
                                                                    
                                                                }
                                                                else
                                                                {
                                                                    if($2.loc->tp_n->basetp != tp_ptr)
                                                                    {
                                                                        type_n * test = $1.type;
                                                                        
                                                                        while(test->next != NULL)
                                                                        {
                                                                            test = test->next;
                                                                            
                                                                        }
                                                                        test->next = $2.loc->tp_n;
                                                                        
                                                                        $2.loc->tp_n = $1.type;
                                                                        
                                                                    }
                                                                }

                                                                if($2.type != NULL && $2.type->basetp == tp_func)
                                                                {
                                                                    $$ = $2;
                                                                    
                                                                }
                                                                else
                                                                {
                                                                    //its not a function
                                                                    $2.loc->size = $2.loc->tp_n->getSize();
                                                                    
                                                                    $2.loc->offset = Current_ST->offset;
                                                                    
                                                                    Current_ST->offset += $2.loc->size;
                                                                    
                                                                    $$ = $2;
                                                                    
                                                                    $$.type = $$.loc->tp_n;
                                                                    
                                                                }
                                                            };

pointer_opt:                    pointer {
                                            $$ = $1;
                                            
                                        }|
                                /*epsilon*/ {
                                                $$.type = NULL;
                                                
                                            };

direct_declarator:              IDENTIFIER {
                                                    $$.loc = Current_ST->lookup(*$1.name);
                                                    
                                                    if($$.loc->var_type == "")
                                                    {
                                                        //Type initialization
                                                        $$.loc->var_type = "local";
                                                        
                                                        $$.loc->tp_n = new type_n(glob_type->basetp);
                                                        
                                                        //$$.loc->tp_n->print();
                                                    }
                                                    $$.type = $$.loc->tp_n;
                                                    
                                            }|
                                '(' declarator ')' {
                                                        $$ = $2;
                                                        
                                                    }|
                                direct_declarator '[' type_qualifier_list_opt assignment_expression_opt ']' {
                                                                                                                if($1.type->basetp == tp_arr)
                                                                                                                {
                                                                                                                    /*if type is already an arr*/
                                                                                                                    type_n * typ1 = $1.type,*typ = $1.type;
                                                                                                                    
                                                                                                                    typ1 = typ1->next;
                                                                                                                    
                                                                                                                    while(typ1->next != NULL)
                                                                                                                    {
                                                                                                                        typ1 = typ1->next;
                                                                                                                        
                                                                                                                        typ = typ->next;
                                                                                                                        
                                                                                                                    }
                                                                                                                    typ->next = new type_n(tp_arr,$4.loc->i_val.int_val,typ1);
                                                                                                                    
                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                                    //add the type of Array to list
                                                                                                                    if($4.loc == NULL)
                                                                                                                        $1.type = new type_n(tp_arr,-1,$1.type);
                                                                                                                    else
                                                                                                                        $1.type = new type_n(tp_arr,$4.loc->i_val.int_val,$1.type);
                                                                                                                    
                                                                                                                }
                                                                                                                $$ = $1;
                                                                                                                
                                                                                                                $$.loc->tp_n = $$.type;
                                                                                                                
                                                                                                            }|
                                direct_declarator '[' STATIC type_qualifier_list_opt assignment_expression ']' {}|
                                direct_declarator '[' type_qualifier_list STATIC assignment_expression ']' {}|
                                direct_declarator '[' type_qualifier_list_opt '*' ']' {/*Not sure but mostly we don't have to implement this*/}|
                                direct_declarator '(' parameter_type_list ')' {
                                                                                   int params_no=Current_ST->no_params;
                                                                                    
                                                                                    
                                                                                   Current_ST->no_params=0;
                                                                                    
                                                                                   int dec_params=0;
                                                                                    
                                                                                   int over_params=params_no;
                                                                                    
                                                                                   for(int i=Current_ST->symb_tab.size()-1;i>=0;i--)
                                                                                   {
                                                                                        
                                                                                    }
                                                                                   for(int i=Current_ST->symb_tab.size()-1;i>=0;i--)
                                                                                   {
                                                                                        string detect=Current_ST->symb_tab[i]->name;
                                                                                        
                                                                                        if(over_params==0)
                                                                                        {
                                                                                            break;
                                                                                            
                                                                                        }
                                                                                        if(detect.size()==4)
                                                                                        {
                                                                                            if(detect[0]=='t')
                                                                                            {
                                                                                                if('0'<=detect[1]&&detect[1]<='9')
                                                                                                {
                                                                                                    if('0'<=detect[2]&&detect[2]<='9')
                                                                                                    {
                                                                                                        if('0'<=detect[3]&&detect[3]<='9')
                                                                                                            dec_params++;
                                                                                                        
                                                                                                    }
                                                                                                    
                                                                                                }
                                                                                                
                                                                                            }
                                                                                            
                                                                                        }
                                                                                        else
                                                                                            over_params--;
                                                                                        

                                                                                   }
                                                                                   params_no+=dec_params;
                                                                                    
                                                                                   int temp_i=Current_ST->symb_tab.size()-params_no;
                                                                                    
                                                                                   symdata * new_func = glob_st->search(Current_ST->symb_tab[temp_i-1]->name);
                                                                                    
                                                                                    if(new_func == NULL)
                                                                                    {
                                                                                        new_func = glob_st->lookup(Current_ST->symb_tab[temp_i-1]->name);
                                                                                        
                                                                                        $$.loc = Current_ST->symb_tab[temp_i-1];
                                                                                        
                                                                                        for(int i=0;i<(temp_i-1);i++)
                                                                                        {
                                                                                            Current_ST->symb_tab[i]->ispresent=false;
                                                                                            
                                                                                            if(Current_ST->symb_tab[i]->var_type=="local"||Current_ST->symb_tab[i]->var_type=="temp")
                                                                                            {
                                                                                                symdata *glob_var=glob_st->search(Current_ST->symb_tab[i]->name);
                                                                                                
                                                                                                if(glob_var==NULL)
                                                                                                {
                                                                                                    
                                                                                                    glob_var=glob_st->lookup(Current_ST->symb_tab[i]->name);
                                                                                                    
                                                                                                    int t_size=Current_ST->symb_tab[i]->tp_n->getSize();
                                                                                                    
                                                                                                    glob_var->offset=glob_st->offset;
                                                                                                    
                                                                                                    glob_var->size=t_size;
                                                                                                    
                                                                                                    glob_st->offset+=t_size;
                                                                                                    
                                                                                                    glob_var->nest_tab=glob_st;
                                                                                                    
                                                                                                    glob_var->var_type=Current_ST->symb_tab[i]->var_type;
                                                                                                    
                                                                                                    glob_var->tp_n=Current_ST->symb_tab[i]->tp_n;
                                                                                                    
                                                                                                    if(Current_ST->symb_tab[i]->isInitialized)
                                                                                                    {
                                                                                                        glob_var->isInitialized=Current_ST->symb_tab[i]->isInitialized;
                                                                                                        
                                                                                                        glob_var->i_val=Current_ST->symb_tab[i]->i_val;
                                                                                                        
                                                                                                    }

                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        if(new_func->var_type == "")
                                                                                        {
                                                                                            // Declaration of the function for the first time
                                                                                            new_func->tp_n = CopyType(Current_ST->symb_tab[temp_i-1]->tp_n);
                                                                                            
                                                                                            new_func->var_type = "func";
                                                                                            
                                                                                            new_func->isInitialized = false;
                                                                                            
                                                                                            new_func->nest_tab = Current_ST;
                                                                                            
                                                                                            Current_ST->name = Current_ST->symb_tab[temp_i-1]->name;
                                                                                            
                                                                                            
                                                                                            /*for(int i=0;i<Current_ST->symb_tab.size();i++)
                                                                                            {
                                                                                                printf("naminST-->%s\n",Current_ST->symb_tab[i]->name.c_str());
                                                                                                
                                                                                            }*/
                                                                                            Current_ST->symb_tab[temp_i-1]->name = "retVal";
                                                                                            
                                                                                            Current_ST->symb_tab[temp_i-1]->var_type = "return";
                                                                                            
                                                                                            Current_ST->symb_tab[temp_i-1]->size = Current_ST->symb_tab[temp_i-1]->tp_n->getSize();
                                                                                            
                                                                                            Current_ST->symb_tab[temp_i-1]->offset = 0;
                                                                                            
                                                                                            Current_ST->offset = 16;
                                                                                            
                                                                                            int count=0;
                                                                                            
                                                                                            for(int i=(Current_ST->symb_tab.size())-params_no;i<Current_ST->symb_tab.size();i++)
                                                                                            {
                                                                                                
                                                                                                Current_ST->symb_tab[i]->var_type = "param";
                                                                                                
                                                                                                Current_ST->symb_tab[i]->offset = count- Current_ST->symb_tab[i]->size;
                                                                                                
                                                                                                count=count-Current_ST->symb_tab[i]->size;
                                                                                                
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        Current_ST = new_func->nest_tab;
                                                                                        
                                                                                    }
                                                                                    Current_ST->start_quad = next_instr;
                                                                                    
                                                                                    $$.loc = new_func;
                                                                                    
                                                                                    $$.type = new type_n(tp_func);
                                                                                    
                                                                                }|
                                direct_declarator '(' identifier_list_opt ')' {
                                                                                int temp_i=Current_ST->symb_tab.size();
                                                                                
                                                                                symdata * new_func = glob_st->search(Current_ST->symb_tab[temp_i-1]->name);
                                                                                
                                                                                /*if(Current_ST->symb_tab.size()>2)
                                                                                {
                                                                                    
                                                                                    printf("%s\n",Current_ST->symb_tab[0]->name.c_str());
                                                                                    
                                                                                    printf("%s\n",Current_ST->symb_tab[1]->name.c_str());
                                                                                    
                                                                                    printf("%s\n",Current_ST->symb_tab[2]->name.c_str());
                                                                                    
                                                                                }*/
                                                                                if(new_func == NULL)
                                                                                {
                                                                                    new_func = glob_st->lookup(Current_ST->symb_tab[temp_i-1]->name);
                                                                                    
                                                                                    $$.loc = Current_ST->symb_tab[temp_i-1];
                                                                                    
                                                                                    for(int i=0;i<temp_i-1;i++)
                                                                                    {
                                                                                        Current_ST->symb_tab[i]->ispresent=false;
                                                                                        
                                                                                        if(Current_ST->symb_tab[i]->var_type=="local"||Current_ST->symb_tab[i]->var_type=="temp")
                                                                                        {
                                                                                            symdata *glob_var=glob_st->search(Current_ST->symb_tab[i]->name);
                                                                                            
                                                                                            if(glob_var==NULL)
                                                                                            {
                                                                                                
                                                                                                glob_var=glob_st->lookup(Current_ST->symb_tab[i]->name);
                                                                                                
                                                                                                int t_size=Current_ST->symb_tab[i]->tp_n->getSize();
                                                                                                
                                                                                                glob_var->offset=glob_st->offset;
                                                                                                
                                                                                                glob_var->size=t_size;
                                                                                                
                                                                                                glob_st->offset+=t_size;
                                                                                                
                                                                                                glob_var->nest_tab=glob_st;
                                                                                                
                                                                                                glob_var->var_type=Current_ST->symb_tab[i]->var_type;
                                                                                                
                                                                                                glob_var->tp_n=Current_ST->symb_tab[i]->tp_n;
                                                                                                
                                                                                                if(Current_ST->symb_tab[i]->isInitialized)
                                                                                                {
                                                                                                    glob_var->isInitialized=Current_ST->symb_tab[i]->isInitialized;
                                                                                                    
                                                                                                    glob_var->i_val=Current_ST->symb_tab[i]->i_val;
                                                                                                    
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    if(new_func->var_type == "")
                                                                                    {
                                                                                        /*Function is being declared here for the first time*/
                                                                                        new_func->tp_n = CopyType(Current_ST->symb_tab[temp_i-1]->tp_n);
                                                                                        
                                                                                        new_func->var_type = "func";
                                                                                        
                                                                                        new_func->isInitialized = false;
                                                                                        
                                                                                        new_func->nest_tab = Current_ST;
                                                                                        
                                                                                        /*Change the first element to retval and change the rest to param*/
                                                                                        Current_ST->name = Current_ST->symb_tab[temp_i-1]->name;
                                                                                        
                                                                                        Current_ST->symb_tab[temp_i-1]->name = "retVal";
                                                                                        
                                                                                        Current_ST->symb_tab[temp_i-1]->var_type = "return";
                                                                                        
                                                                                        Current_ST->symb_tab[temp_i-1]->size = Current_ST->symb_tab[0]->tp_n->getSize();
                                                                                        
                                                                                        Current_ST->symb_tab[temp_i-1]->offset = 0;
                                                                                        
                                                                                        Current_ST->offset = 16;
                                                                                        
                                                                                    }
                                                                                }
                                                                                else
                                                                                {
                                                                                    // Already declared function. Therefore drop the new table and connect current symbol table pointer to the previously created funciton symbol table
                                                                                    Current_ST = new_func->nest_tab;
                                                                                    
                                                                                }
                                                                                Current_ST->start_quad = next_instr;
                                                                                
                                                                                $$.loc = new_func;
                                                                                
                                                                                $$.type = new type_n(tp_func);
                                                                                
                                                                            };

type_qualifier_list_opt:        type_qualifier_list {}|
                                /*epsilon*/ {};

assignment_expression_opt:      assignment_expression {
                                                            $$ = $1;
                                                            
                                                        }|
                                /*epsilon*/ {
                                                $$.loc = NULL;
                                                
                                            };

identifier_list_opt:            identifier_list                                         |
                                /*epsilon*/                                             ;

pointer:                        '*' type_qualifier_list_opt {
                                                                $$.type = new type_n(tp_ptr);
                                                                
                                                            }|
                                '*' type_qualifier_list_opt pointer {
                                                                        $$.type = new type_n(tp_ptr,1,$3.type);
                                                                        
                                                                    };

type_qualifier_list:            type_qualifier {}|
                                type_qualifier_list type_qualifier {};

parameter_type_list:            parameter_list {
                                                    /*-------*/
                                                }|
                                parameter_list ',' ELLIPSIS {};

parameter_list:                 parameter_declaration {
                                                            /*---------*/
                                                            (Current_ST->no_params)++;
                                                            
                                                        }|
                                parameter_list ',' parameter_declaration {
                                                                            /*------------*/
                                                                            (Current_ST->no_params)++;
                                                                            
                                                                        };

parameter_declaration:          declaration_specifiers declarator {
                                                                        /*The parameter is already added to the current Symbol Table*/
                                                                        
                                                                  }|
                                declaration_specifiers {};

identifier_list :               IDENTIFIER                                              |
                                identifier_list ',' IDENTIFIER                          ;

type_name:                      specifier_qualifier_list                                ;

initializer:                    assignment_expression {
                                    $$ = $1;
                                }|
                                '{' initializer_list '}' {}|
                                '{' initializer_list ',' '}' {};

initializer_list:               designation_opt initializer                             |
                                initializer_list ',' designation_opt initializer        ;                                                                                                                           

designation_opt:                designation                                             |
                                /*Epslion*/                                             ;

designation:                    designator_list '='                                     ;

designator_list:                designator                                              |
                                designator_list designator                              ;

designator:                     '[' constant_expression ']'                             |
                                '.' IDENTIFIER {};

/*Statements*/
statement:                      labeled_statement {/*Switch Case*/}|
                                compound_statement {
                                                        $$ = $1;
                                                        
                                                    }|
                                expression_statement {
                                                        $$ = NULL;
                                                        
                                                    }|
                                selection_statement {
                                                        $$ = $1;
                                                        
                                                    }|
                                iteration_statement {
                                                        $$ = $1;
                                                        
                                                    }|
                                jump_statement {
                                                    $$ = $1;
                                                    
                                                };

labeled_statement:              IDENTIFIER ':' statement {}|
                                CASE constant_expression ':' statement {}|
                                DEFAULT ':' statement {};

compound_statement:             '{' block_item_list_opt '}' {
                                                                $$ = $2;
                                                                
                                                            };

block_item_list_opt:            block_item_list {
                                                    $$ = $1;
                                                    
                                                }|  
                                /*Epslion*/ {
                                                $$ = NULL;
                                                
                                            };

block_item_list:                block_item {
                                                $$ = $1;
                                                
                                            }|
                                block_item_list M block_item {
                                                                    backpatch($1,$2);
                                                                    
                                                                    $$ = $3;
                                                                    
                                                             };

block_item:                     declaration {
                                                $$ = NULL;
                                                
                                            }|
                                statement {
                                                $$ = $1;
                                                
                                          };

expression_statement:           expression_opt ';'{
                                                        $$ = $1;
                                                        
                                                  };

expression_opt:                 expression {
                                                $$ = $1;
                                                
                                           }|
                                /*Epslion*/ {
                                                /*Initialize Expression to NULL*/
                                                $$.loc = NULL;
                                                
                                            };

selection_statement:            IF '(' expression N ')' M statement N ELSE M statement {
                                                                                            /*N1 is used for falselist of expression, M1 is used for truelist of expression, N2 is used to prevent fall through, M2 is used for falselist of expression*/
                                                                                            $7 = merge($7,$8);
                                                                                            
                                                                                            $11 = merge($11,makelist(next_instr));
                                                                                            
                                                                                            global_quad_table.emit(Q_GOTO,"-1");
                                                                                            
                                                                                            backpatch($4,next_instr);
                                                                                            

                                                                                            conv2Bool(&$3);
                                                                                            

                                                                                            backpatch($3.truelist,$6);
                                                                                            
                                                                                            backpatch($3.falselist,$10);
                                                                                            
                                                                                            $$ = merge($7,$11);
                                                                                            
                                                                                        }|
                                IF '(' expression N ')' M statement %prec IF_CONFLICT{
                                                                        /*N is used for the falselist of expression to skip the block and M is used for truelist of expression*/
                                                                        $7 = merge($7,makelist(next_instr));
                                                                        
                                                                        global_quad_table.emit(Q_GOTO,"-1");
                                                                        
                                                                        backpatch($4,next_instr);
                                                                        
                                                                        conv2Bool(&$3);
                                                                        
                                                                        backpatch($3.truelist,$6);
                                                                        
                                                                        $$ = merge($7,$3.falselist);
                                                                        
                                                                    }|
                                SWITCH '(' expression ')' statement {};

iteration_statement:            WHILE '(' M expression N ')' M statement {
                                                                            /*The first 'M' takes into consideration that the control will come again at the beginning of the condition checking.'N' here does the work of breaking condition i.e. it generate goto which wii be useful when we are exiting from while loop. Finally, the last 'M' is here to note the startinf statement that will be executed in every loop to populate the truelists of expression*/
                                                                            global_quad_table.emit(Q_GOTO,$3);
                                                                            
                                                                            backpatch($8,$3);           /*S.nextlist to M1.instr*/
                                                                            backpatch($5,next_instr);    /*N1.nextlist to next_instr*/
                                                                            conv2Bool(&$4);
                                                                            
                                                                            backpatch($4.truelist,$7);
                                                                            
                                                                            $$ = $4.falselist;
                                                                            
                                                                        }|
                                DO M statement  WHILE '(' M expression N ')' ';' {  
                                                                                    /*M1 is used for coming back again to the statement as it stores the instruction which will be needed by the truelist of expression. M2 is neede as we have to again to check the condition which will be used to populate the nextlist of statements. Further N is used to prevent from fall through*/
                                                                                    backpatch($8,next_instr);
                                                                                    
                                                                                    backpatch($3,$6);           /*S1.nextlist to M2.instr*/
                                                                                    
                                                                                    conv2Bool(&$7);
                                                                                    
                                                                                    backpatch($7.truelist,$2);  /*B.truelist to M1.instr*/
                                                                                    
                                                                                    $$ = $7.falselist;
                                                                                    
                                                                                }|
                                FOR '(' expression_opt ';' M expression_opt N ';' M expression_opt N ')' M statement {
                                                                                                                       /*M1 is used for coming back to check the epression at every iteration. N1 is used  for generating the goto which will be used for exit conditions. M2 is used for nextlist of statement and N2 is used for jump to check the expression and M3 is used for the truelist of expression*/
                                                                                                                        backpatch($11,$5);          /*N2.nextlist to M1.instr*/
                                                                                                                        
                                                                                                                        backpatch($14,$9);          /*S.nextlist to M2.instr*/
                                                                                                                        
                                                                                                                        global_quad_table.emit(Q_GOTO,$9);
                                                                                                                        
                                                                                                                        backpatch($7,next_instr);    /*N1.nextlist to next_instr*/
                                                                                                                        
                                                                                                                        conv2Bool(&$6);
                                                                                                                        
                                                                                                                        backpatch($6.truelist,$13);
                                                                                                                        
                                                                                                                        $$ = $6.falselist;
                                                                                                                        
                                                                                                                    }|
                                FOR '(' declaration expression_opt ';' expression_opt ')' statement {};

jump_statement:                 GOTO IDENTIFIER ';' {}|
                                CONTINUE ';' {}|
                                BREAK ';' {}|
                                RETURN expression_opt ';' {
                                                                if($2.loc == NULL)
                                                                    global_quad_table.emit(Q_RETURN);
                                                                else
                                                                {
                                                                    expresn * dummy = new expresn();
                                                                    
                                                                    dummy->loc = Current_ST->symb_tab[0];
                                                                    
                                                                    dummy->type = dummy->loc->tp_n;
                                                                    
                                                                    typecheck(dummy,&$2,true);
                                                                    
                                                                    delete dummy;
                                                                    
                                                                    global_quad_table.emit(Q_RETURN,$2.loc->name);
                                                                    
                                                                }
                                                                $$=NULL;
                                                                
                                                          };

/*External Definitions*/
translation_unit:               external_declaration                                    |
                                translation_unit external_declaration                   ;

external_declaration:           function_definition                                     |
                                declaration      {

                                                                                        for(int i=0;i<Current_ST->symb_tab.size();i++)
                                                                                        {
                                                                                            if(Current_ST->symb_tab[i]->nest_tab==NULL)
                                                                                                {
                                                                                                    if(Current_ST->symb_tab[i]->var_type=="local"||Current_ST->symb_tab[i]->var_type=="temp")
                                                                                                    {
                                                                                                        symdata *glob_var=glob_st->search(Current_ST->symb_tab[i]->name);
                                                                                                        
                                                                                                        if(glob_var==NULL)
                                                                                                        {
                                                                                                            glob_var=glob_st->lookup(Current_ST->symb_tab[i]->name);
                                                                                                            
                                                                                                            
                                                                                                            int t_size=Current_ST->symb_tab[i]->tp_n->getSize();
                                                                                                            
                                                                                                            glob_var->offset=glob_st->offset;
                                                                                                            
                                                                                                            glob_var->size=t_size;
                                                                                                            
                                                                                                            glob_st->offset+=t_size;
                                                                                                            
                                                                                                            glob_var->nest_tab=glob_st;
                                                                                                            
                                                                                                            glob_var->var_type=Current_ST->symb_tab[i]->var_type;
                                                                                                            
                                                                                                            glob_var->tp_n=Current_ST->symb_tab[i]->tp_n;
                                                                                                            
                                                                                                            if(Current_ST->symb_tab[i]->isInitialized)
                                                                                                            {
                                                                                                                glob_var->isInitialized=Current_ST->symb_tab[i]->isInitialized;
                                                                                                                
                                                                                                                glob_var->i_val=Current_ST->symb_tab[i]->i_val;
                                                                                                                
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                        }
                                                                                        
                                                    }                                       ;

function_definition:    declaration_specifiers declarator declaration_list_opt compound_statement {
                                                                                                    symdata * func = glob_st->lookup($2.loc->name);
                                                                                                    
                                                                                                    func->nest_tab->symb_tab[0]->tp_n = CopyType(func->tp_n);
                                                                                                    
                                                                                                    func->nest_tab->symb_tab[0]->name = "retVal";
                                                                                                    
                                                                                                    func->nest_tab->symb_tab[0]->offset = 0;
                                                                                                    
                                                                                                    //If return type is pointer then change the offset
                                                                                                    if(func->nest_tab->symb_tab[0]->tp_n->basetp == tp_ptr)
                                                                                                    {
                                                                                                        int diff = size_pointer - func->nest_tab->symb_tab[0]->size;
                                                                                                        
                                                                                                        func->nest_tab->symb_tab[0]->size = size_pointer;
                                                                                                        
                                                                                                        for(int i=1;i<func->nest_tab->symb_tab.size();i++)
                                                                                                        {
                                                                                                            func->nest_tab->symb_tab[i]->offset += diff;
                                                                                                            
                                                                                                        }
                                                                                                    }
                                                                                                    int offset_size = 0;
                                                                                                    
                                                                                                    for(int i=0;i<func->nest_tab->symb_tab.size();i++)
                                                                                                    {
                                                                                                        offset_size += func->nest_tab->symb_tab[i]->size;
                                                                                                        
                                                                                                    }
                                                                                                    func->nest_tab->end_quad = next_instr-1;
                                                                                                    
                                                                                                    //Create a new Current Symbol Table
                                                                                                    Current_ST = new symtab();
                                                                                                    
                                                                                                };

declaration_list_opt:           declaration_list                                        |
                                /*epsilon*/                                             ;

declaration_list:               declaration                                             |
                                declaration_list declaration                            ;

%%
void yyerror(const char*s)
{
    printf("%s",s);
}

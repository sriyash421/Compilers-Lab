#ifndef _TRANSLATE_H
#define _TRANSLATE_H

#include <bits/stdc++.h>
using namespace std;
extern char *yytext;
extern int yyparse();


#define listsym_itr list<sym>::iterator
#define list_int list<int>
#define list_sym list<sym>


class sym;          //entry in ST
class symboltype;   //type of symbol
class symtable;     //symbol table
class quad;         //entry in quadArray
class quadArray;    //quadArray

class sym{
    /*
    name: name of symbol
    type: type of symbol
    size: size of symbol
    offset: offset of symbol in ST
	nested: points to the nested symbol table
	val: initial value of the symbol if specified
    sym(): constructor
    update() : method to update different fields of an existing symbol
    */
    public :
        string name;
        symboltype *type;
        int size;
        int offset;
        symtable *nested;
        string val;

        sym (string, string type_="int", symboltype *ptr = NULL, int width = 0);
        sym *update(symboltype*);
};

class symboltype{
    /*
    type: type of symbol 
	width: stores the size of Array (if we encounter an Array)
	arrtype: for multidimensional arrs
	symboltype(): constructor
    */
    public :
        string type;
        int width;
        symboltype* arrtype;

        symboltype(string, symboltype *arrtype = NULL, int width = 1);
};

class symtable{
    /*
    stri name: name of the Table
	count: count of the temporary variables
	table: table of symbols
	parent: parent ST
	symmtable(): constructor
	lookup(): lookup for a symbol in ST
	print(): print the ST
	update(): update the ST
    */
    public :
        string name;
        int count;
        list_sym table;
        symtable *parent;
        symtable(string name="NULL");
        sym *lookup(string);
        void print();
        void update();
};

class quad{
    /*
    result: result
    op: operator
    arg1: argument 1
    arg2: argument 2
    print(): printing quad
    type(): printing type1
    type_(): printing type2
    quad(): overloaded constructors
    */
    public :
        string result;
        string op;
        string arg1;
        string arg2;

        void print();
        void type();
        void type_();

        quad(string, string, string op = "=", string arg2 = "");
        quad(string, int, string op = "=", string arg2 = "");
        quad(string, float, string op = "=", string arg2 = "");
};

class quadArray{
    /*
    array: list of quads
    print(): print array
    */
    public:
        vector<quad> array;
        void print();
};

class basicType{
    /*
    type: type name
    size: size of type
    */
    public :
        vector<string> type;
        vector<int> size;
        void addType(string, int);
};


extern symtable *ST; // current Symbol Table
extern symtable *globalST; // Global Symbol Table
extern sym *currSymPtr; // latest encountered symbol
extern quadArray qA; // quad Array
extern basicType bt; // Type ST
extern long long int instr_count; // count of instr

string convertIntToString(int);
string convertFloatToString(float);
string generateSpaces(int);

//generate a temporary variable and insert it in the current ST
sym *gentemp(symboltype*, string init = "");

//Emit functions
void emit(string, string, string arg1="", string arg2="");
void emit(string, string, int, string arg2="");
void emit(string, string, float, string arg2="");

//Managing boolean expression
void backpatch(list_int, int);
list_int makelist(int );
list_int merge(list_int &l1, list_int &l2);

int nextinstr();
void update_nextinst();

sym *convertType(sym *, string);
bool compareSymbolType(sym *&s1, sym *&s2);
bool compareSymbolType(symboltype *t1, symboltype *t2);
int computeSize(symboltype *);
string printType(symboltype *);
void changeTable(symtable *);
void debug(string s);

struct Statement{
    list_int nextlist;  // next list for given statement
};

struct Array {
    string array_type;  //Array: may be ptr or arr
    sym *loc;           //address of Array
    sym *Array;         //pointer to the symbol table entry
    symboltype *type;   //type of the subarr1 generated (for multidimensional arr1s)
};

struct Expression{
    sym *loc;           //pointer to the symbol table entry
    string type;
    list_int truelist;  //fruelist for boolean expressions
    list_int falselist; //falselist for boolean expressions
    list_int nextlist;  //for statement expressions
};

Expression *convertIntToBool(Expression *);
Expression *convertBoolToInt(Expression *);
bool typeCheck(Expression, Expression);

#endif
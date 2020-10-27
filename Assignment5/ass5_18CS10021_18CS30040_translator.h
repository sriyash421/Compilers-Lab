#ifndef _TRANSLATE_H
#define _TRANSLATE_H

#include <bits/stdc++.h>

extern char *yytext;
extern int yyparse();

using namespace std;

#define listsym_itr list<sym>::iterator
#define list_int list<int>
#define list_sym list<sym>

class sym;
class symboltype;
class symtable;
class quad;
class quadArray;

class sym{
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
    public :
        string type;
        int width;
        symboltype* arrtype;

        symboltype(string, symboltype *ptr = NULL, int width = 1);
};

class symtable{
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
    public:
        vector<quad> array;
        void print();
};

class basicType{
    public :
        vector<string> type;
        vector<int> size;
        void addType(string, int);
};


extern symtable *ST;
extern symtable *globalST;
extern sym *currSymPtr;
extern quadArray qA;
extern basicType bt;
extern long long int instr_count;

string convertIntToString(int);
string convertFloatToString(float);
string generateSpaces(int);

sym *gentemp(symboltype*, string init = "");

void emit(string, string, string arg1="", string arg2="");
void emit(string, string, int, string arg2="");
void emit(string, string, float, string arg2="");

void backpatch(list_int, int);
list_int makelist(int );
list_int merge(list_int &l1, list_int &l2);

int nextinstr();
void update_nextinst();

sym *convertType(sym *, string);
bool compareSymbolType(sym *&s1, sym *&s2);
bool compareSymbolType(symboltype *&t1, symboltype *&t2);
int computeSize(symboltype *);
string printType(symboltype *);
void changeTable(symtable *);

struct Statement{
    list_int nextlist;
};

struct Array {
    string array_type;
    sym *loc;
    sym *array;
    symboltype *type;
};

struct Expression{
    sym *loc;
    string type;
    list_int truelist;
    list_int falselist;
    list_int nextlist;
};

Expression *convertIntToBool(Expression *);
Expression *convertBoolToInt(Expression *);
bool typeCheck(Expression, Expression);

#endif
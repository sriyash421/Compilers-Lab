#include "ass5_18CS10021_18CS30040_translator.h"
#include "sstream"
#include "string"
#include "iostream"

symtable *globalST; // global symbol table
quadArray qA;       // quad array
string var_type;    // latest type
symtable *ST;       // current symbol table
sym *currSymPtr;    // current symbol
basicType bt;       // basic types

void debug(string s){
    /*debugging function*/
    cout << "debugging !!! " << s << endl;
}

sym::sym(string name, string type_, symboltype *arrtype, int width){
    /*Constructor for symbol*/
    (*this).name=name;
    (*this).type=new symboltype(type_, arrtype,width);
    (*this).size=computeSize(type);
    (*this).offset=0;
    (*this).val="-";
    (*this).nested=NULL;
}

sym* sym::update(symboltype* type_){
    /*Function to update a symbol*/
    (*this).type = type_;//
    (*this).size = computeSize(type_);
    return this;
}

symboltype::symboltype(string type,symboltype* arrtype,int width){
    /*Constructor for symboltype*/
	(*this).type=type;
	(*this).width=width;
	(*this).arrtype=arrtype;
}

symtable::symtable(string name){
    /*Constructor for symbol table*/
    (*this).name=name;
    (*this).count = 0;//
}

sym *symtable::lookup(string name){
    /*Function to look up or add(if non existent) a symbol by name in the ST*/
    sym *symbol;
    listsym_itr itr;
    itr = (*this).table.begin();//
    while(itr != (*this).table.end()){//
        if(itr->name==name)
            return &(*itr);
        itr++;
    }

    symbol = new sym(name);
    (*this).table.push_back(*symbol);
    return &(*this).table.back();
}

void symtable::update(){
    /*Function to update the table*/
    list <symtable*> tb;
    int offset_;
    listsym_itr itr = (*this).table.begin();
    while(itr != (*this).table.end()){
        if(itr == (*this).table.begin()){
            itr->offset = 0;
            offset_ = itr->size;
        }
        else{
            itr->offset = offset_;
            offset_ = itr->offset+itr->size;
        }
        if(itr->nested!=NULL)
            tb.push_back(itr->nested);
        itr++;
    }
    list <symtable *>::iterator itr_;
    itr_ = tb.begin();
    while(itr_ != tb.end()){
        (*itr_)->update();
        itr_++;
    }
}

void symtable::print(){
    /*Function to print the table*/
    int next_inst = 0;
    list<symtable *>table;
    
    for(int i=0; i<50; i++)
        cout << "__";
    cout << "\n";
    
    cout<<"Table Name: "<<(*this).name<<"\t\t\t Parent Name: ";
    if((*this).parent==NULL)
        cout << "NULL\n";
    else
        cout << (*this).parent->name << "\n" ;
    
    for(int i=0; i<50; i++)
        cout << "__";
    cout << "\n";

    cout << "Name" + generateSpaces(11) +
            "Type" + generateSpaces(16) +
            "Initial Value" + generateSpaces(7) +
            "Size" + generateSpaces(11) +
            "Offset" + generateSpaces(9) +
            "Nested\n" + generateSpaces(100) +
	        "\n";
	ostringstream str_;

    for(listsym_itr itr=this->table.begin(); itr!=this->table.end();itr++){//
        string type_r = printType(itr->type);
        cout << itr->name + generateSpaces(15-itr->name.length()) +
                type_r + generateSpaces(20-type_r.length()) +
                itr->val + generateSpaces(20-itr->val.length()) +
                to_string(itr->size) + generateSpaces(20-to_string(itr->size).length()) +
                to_string(itr->offset) + generateSpaces(15-to_string(itr->offset).length());
        if(itr->nested==NULL) {                             //print nested	
			cout<<"NULL"<<endl;
		}
		else{
			cout<<itr->nested->name<<endl;	
			table.push_back(itr->nested);
		}
    }
    for(int i=0;i<100;i++) 
		cout<<"-";
	cout<<"\n\n";
	for(list<symtable*>::iterator itr=table.begin(); itr !=table.end(); ++itr){
    	(*itr)->print();
	}
}

quad::quad(string result, string arg1, string op, string arg2){
    /*Overloaded Constructor for quad*/
	(*this).result = result;
	(*this).arg1 = arg1;
	(*this).op = op;
	(*this).arg2 = arg2;
}

quad::quad(string result, float arg1, string op, string arg2){
    /*Overloaded Constructor for quad*/
	(*this).result = result;
	(*this).arg1 = convertFloatToString(arg1);
	(*this).op = op;
	(*this).arg2 = arg2;
}

quad::quad(string result, int arg1, string op, string arg2){
    /*Overloaded Constructor for quad*/
	(*this).result = result;
	(*this).arg1 = convertFloatToString(arg1);
	(*this).op = op;
	(*this).arg2 = arg2;
}

void quad::print(){
    /*Function to print quad*/
    int next_inst = 0;
    if(op=="+"){		
		(*this).type();
	}
	else if(op=="-"){				
		(*this).type();
	}
	else if(op=="*"){
		(*this).type();
	}
	else if(op=="/"){		
		(*this).type();
	}
	else if(op=="%"){
		(*this).type();
	}
	else if(op=="|"){
		(*this).type();
	}
	else if(op=="^"){	
		(*this).type();
	}
	else if(op=="&"){				
		(*this).type();
	}
	else if(op=="=="){
		(*this).type_();
	}
	else if(op=="!="){
		(*this).type_();
	}
	else if(op=="<="){
		(*this).type_();
	}
	else if(op=="<"){				
		(*this).type_();
	}
	else if(op==">"){
		(*this).type_();
	}
	else if(op==">="){				
		(*this).type_();
	}
	else if(op=="goto"){				
		cout<<"goto "<<result;
	}	
	// Shift Operations
	else if(op==">>"){
		(*this).type();
	}
	else if(op=="<<"){				
		(*this).type();
	}
	else if(op=="="){				
		cout<<result<<" = "<<arg1 ;
	}					
	//Unary Operators..
	else if(op=="=&"){				
		cout<<result<<" = &"<<arg1;
	}
	else if(op=="=*"){
		cout<<result	<<" = *"<<arg1 ;
	}
	else if(op=="*="){				
		cout<<"*"<<result	<<" = "<<arg1 ;
	}
	else if(op=="uminus"){
		cout<<result<<" = -"<<arg1;
	}
	else if(op=="~"){				
		cout<<result<<" = ~"<<arg1;
	}
	else if(op=="!"){
		cout<<result<<" = !"<<arg1;
	}
	else if(op=="=[]"){
		cout<<result<<" = "<<arg1<<"["<<arg2<<"]";
	}
	else if(op=="[]="){	 
	    cout<<result<<"["<<arg1<<"]"<<" = "<< arg2;
	}
	else if(op=="return"){ 			
		cout<<"return "<<result;
	}
	else if(op=="param"){ 			
		cout<<"param "<<result;
	}
	else if(op=="call"){ 			
		cout<<result<<" = "<<"call "<<arg1<<", "<<arg2;
	}
	else if(op=="label"){
		cout<<result<<": ";
	}	
	else{	
		cout<<"Can't find "<<op;
	}			
	cout<<endl;
}

void quad::type(){
    /*Overloaded Function to print quad*/
    cout << (*this).result << " = " << (*this).arg1 << " " << (*this).op << " " << (*this).arg2;
}

void quad::type_(){
    /*Overloaded Function to print quad*/
    cout << "if " << (*this).arg1 << " " << (*this).op << " " << (*this).arg2 << " goto " << (*this).result;
}

void basicType::addType(string type_, int size){
    /*Function to add a basic type*/
    (*this).type.push_back(type_);
    (*this).size.push_back(size);
}

string generateSpaces(int n){
    /*Function to generate spaced for prettying printing*/
    string temp="";
    while(n--){
        temp+=" ";
    }
    return temp;
}

void quadArray::print(){
    /*Function to print quad arrays*/
    for(int i=0; i<50; i++)
        cout << "__";
    cout << "\n";
    cout << "Three Address Code:\n";
    for(int i=0; i<50; i++)
        cout << "__";
    cout << "\n";
    
    int j=0;
    for(vector<quad>::iterator itr=(*this).array.begin(); itr!=(*this).array.end(); itr++, j++){
        if(itr->op == "label"){
            cout << "\nL" << j << ": "+generateSpaces(2);
            itr->print();
        }
        else{
            cout << "L" << j << ": "+generateSpaces(4);
            itr->print();
        }
    }
    for(int i=0; i<50; i++)
        cout << "__";
    cout << "\n";
}

string convertFloatToString(float x){
    /*Function to convert float to string*/
    string temp = to_string(x);
    return temp;
}

string convertIntToString(int x){
    /*Function to convert int to string*/
    string temp = to_string(x);
    return temp;
}

void emit(string op, string result, string arg1, string arg2){
    /*Overloaded Function to emit a quad*/
    quad *q = new quad(result, arg1, op, arg2);
    qA.array.push_back(*q);
}

void emit(string op, string result, int arg1, string arg2){
    /*Overloaded Function to emit a quad*/
    quad *q = new quad(result, arg1, op, arg2);
    qA.array.push_back(*q);
}

void emit(string op, string result, float arg1, string arg2){
    /*Overloaded Function to emit a quad*/
    quad *q = new quad(result, arg1, op, arg2);
    qA.array.push_back(*q);
}

sym* convertType(sym* sym_, string return_type){
    /*Function to convert to symbol to given return type*/
    sym* temp = gentemp(new symboltype(return_type));

    if((*sym_).type->type == "int"){
		if(return_type == "float"){
			emit("=",temp->name,"int2float("+(*sym_).name+")");
			return temp;
		}
		else if(return_type == "char"){
			emit("=",temp->name,"int2char("+(*sym_).name+")");
			return temp;
		}
		return sym_;
	}
	else if((*sym_).type->type == "float"){
		if(return_type == "int"){
			emit("=",temp->name,"float2int("+(*sym_).name+")");
			return temp;
		}
		else if(return_type == "char"){
			emit("=",temp->name,"float2char("+(*sym_).name+")");
			return temp;
		}
		return sym_;
	}
	else if((*sym_).type->type == "char"){
		if(return_type == "int"){
			emit("=",temp->name,"char2int("+(*sym_).name+")");
			return temp;
		}
		if(return_type == "double"){
			emit("=",temp->name,"char2double("+(*sym_).name+")");
			return temp;
		}
		return sym_;
	}
	return sym_;
}

void changeTable(symtable *newTable){
    /*Function to change current ST*/
    ST = newTable;   
}

bool typeCheck(Expression e1, Expression e2){
    /*Function to compare two expression types*/
    return (e1.type.compare(e2.type) == 0);
}

Expression *convertIntToBool(Expression *e){
    /*Function to convert expression from int to bool*/
    if(e->type != "bool"){
        e->falselist = makelist(nextinstr());
        emit("==", "", e->loc->name, "0");
        e->truelist = makelist(nextinstr());
        emit("goto", "");
    }
}

Expression *convertBoolToInt(Expression *e){
    /*Function to convert expression from bool to init*/
    if(e->type != "int"){
        e->loc = gentemp(new symboltype("int"));
        backpatch(e->truelist, nextinstr());
        emit("=", e->loc->name, "true");
		string str_ = convertIntToString(nextinstr()+1);
		emit("goto", str_);
		backpatch(e->falselist, nextinstr());
		emit("=",e->loc->name, "false");
    }
}

bool compareSymbolType(sym *&s1, sym *&s2){
    /*Function to compare two symbol types*/
    symboltype *type1 = s1->type;
    symboltype *type2 = s2->type;
    int flag = 0;
    if(compareSymbolType(type1, type2))
        flag = 1;
    else if(s1 = convertType(s1, type2->type))
        flag = 1;
    else if(s2 = convertType(s2, type1->type))
        flag = 1;
    
    return (bool)flag;
}

bool compareSymbolType(symboltype *t1, symboltype *t2){
    /*Function to compare two symbol types*/
    int flag = 0;
    if(t1 == NULL && t2 == NULL)
        return true;
    else if(t1 == NULL || t2 == NULL || t1->type!=t2->type)
        return false;
    else
        return compareSymbolType(t1->arrtype, t2->arrtype);
}

void backpatch(list_int l1, int addr){
    /*Function to backpatch list of instructions to address*/
    string str_ =  convertIntToString(addr);
    for(list_int:: iterator itr = l1.begin(); itr != l1.end(); itr++){
        qA.array[*itr].result = str_;
    }
}

list_int makelist(int init){
    /*Function to create a list*/
    list_int temp(1, init);
    return temp;
}

list_int merge(list_int &l1, list_int &l2){
    /*Function to merge two lists*/
    l1.merge(l2);
    return l1;
}

sym *gentemp(symboltype *t, string str_){
    /*Function to generate temporary symbols and add it to current table*/
    string temp_name = "t"+convertIntToString(ST->count++);
    sym *s = new sym(temp_name);
    s->type = t;
    s->size = computeSize(t);
    s->val = str_;
    ST->table.push_back(*s);
    return &ST->table.back();
}

int computeSize(symboltype *type_){
    /*Function to compute size of given symbol type*/
    if(type_->type.compare("void") == 0)
        return bt.size[1];
    else if(type_->type.compare("char") == 0)
        return bt.size[2];
    else if(type_->type.compare("int") == 0)
        return bt.size[3];
    else if(type_->type.compare("float") == 0)
        return bt.size[4];
    else if(type_->type.compare("arr") == 0)
        return type_->width*computeSize(type_->arrtype);
    else if(type_->type.compare("ptr") == 0)
        return bt.size[5];
    else if(type_->type.compare("func") == 0)
        return bt.size[6];
    else
        return -1;
}

string printType(symboltype *type_){
    /*Function to print given symbol type*/
    if(type_ == NULL)
        return bt.type[0];
	if(type_->type.compare("void") == 0)
        return bt.type[1];
	else if(type_->type.compare("char") == 0)
        return bt.type[2];
	else if(type_->type.compare("int") == 0)
        return bt.type[3];
	else if(type_->type.compare("float") == 0)
        return bt.type[4];
	else if(type_->type.compare("ptr") == 0)
        return bt.type[5]+"("+printType(type_->arrtype)+")";
	else if(type_->type.compare("arr") == 0)
		return bt.type[6]+"("+convertIntToString(type_->width)+","+printType(type_->arrtype)+")";
	else if(type_->type.compare("func") == 0)
        return bt.type[7];
	else
        return "NA";
}

int nextinstr(){
    /*Function to find instruction number*/
	return qA.array.size();
}

int main(){
    /*Driver function*/
    bt.addType("null",0);
	bt.addType("void",0);
	bt.addType("char",1);
	bt.addType("int",4);
	bt.addType("float",8);
	bt.addType("ptr",4);
	bt.addType("arr",0);
	bt.addType("func",0);
	globalST = new symtable("Global");
	ST = globalST;
	yyparse();
	globalST->update();
	cout<<"\n";
	qA.print();	
	globalST->print();
}
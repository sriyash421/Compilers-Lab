#include "ass6_18CS10021_18CS30040_translator.h"
#include "y.tab.h"
#include<sstream>
#include<string>
#include<iostream>

#define pf printf

long long int instr_count;	// count of instr (used for sanity check)
bool debug_on;			// bool for printing debug output
#define pb push_back
type_n *glob_type;
int glob_width;
int next_instr;
int temp_count=0;
symtab *glob_st =new symtab();
symtab *Current_ST = new symtab();
quad_arr global_quad_table;
vector <string> vs;
vector <string> cs;
int size_int=4;
int size_double=8;
int size_pointer=8;
int size_char=1;
int size_bool=1;
vector<string> strings_label;
type_n::type_n(types t,int sz,type_n *n)
{
	basetp=t;
	size=sz;
	next=n;
}

int type_n::getSize()
{
	if(this==NULL)
		return 0;
	//return the size of the Array by calling the recursive function 
	//here we are not checking for null as if it will reach the final type it will enter the below conditions
	if(((*this).basetp) == tp_arr)
		return (((*this).size)*((*this).next->getSize()));
	if(((*this).basetp) == tp_void)
		return 0;
	if(((*this).basetp) == tp_int)
		return size_int;
	if(((*this).basetp) == tp_double)
		return size_double;
	if(((*this).basetp) == tp_bool)
		return size_bool;
	if(((*this).basetp) == tp_char)
		return size_char;
	if(((*this).basetp) == tp_ptr)
		return size_pointer;
}

types type_n::getBasetp()
{
	if(this!=NULL)
	{

		return (*this).basetp;

	}	
	else
	{

		return tp_void;

	}	
		
}

void type_n::printSize()
{
	pf("%d\n",size);
}

void type_n::print()
{
	if(basetp ==  tp_void)
	{
	
		pf("Void");
	}

	else if(basetp == tp_bool)
	{

		pf("Bool");

	}	
	else if(basetp == tp_int)	
	{

		pf("Int");
	}

	else if(basetp == tp_char)	
	{

		pf("Char");

	}
	
	else if(basetp == tp_double)
	{

		pf("Double");
	}

	else if(basetp == tp_ptr)	
	{	

		pf("ptr(");
		if((*this).next!=NULL)
			(*this).next->print();
		pf(")");

	}
	else if(basetp == tp_arr)
	{	
		pf("Array(%d,",size);
		if((*this).next!=NULL)
			(*this).next->print();
			pf(")");
	
	}		
	else if(basetp == tp_func)
	{
		pf("Function()");

	}	
	else
	{
	
			pf("TYPE NOT FOUND\n");
			exit(-1);
	}
	

}

Array::Array(string s,int sz,types t)
{
	(*this).base_arr=s;
	(*this).tp=t;
	(*this).bsize=sz;
	(*this).dimension_size=1;
}

void Array::addindex(int i)
{
	(*this).dimension_size=(*this).dimension_size+1;
	(*this).dims.pb(i);
}

void funct::print()
{

	pf("Funct(");
	int i;
	for(i=0;i<typelist.size();i++)
	{

		if(i!=0)
			pf(",");

		pf("%d ",typelist[i]);

	}
	pf(")");
}

funct::funct(vector<types> tpls)
{
	typelist=tpls;
}
symdata::symdata(string n)
{
	name=n;
	//pf("sym%s\n",n.c_str());
	size=0;
	tp_n=NULL;
	offset=-1;
	var_type="";
	isInitialized=false;
	isFunction=false;
	isArray=false;
	ispresent=true;
	arr=NULL;
	fun=NULL;
	nest_tab=NULL;
	isdone=false;
	isptrarr=false;
	isGlobal=false;
}

void symdata::createarray()
{
	arr=new Array((*this).name,(*this).size,tp_arr);
}


symtab::symtab()
{
	name="";
	offset=0;
	no_params=0;
}

symtab::~symtab()
{
	int i=0;
	for(;i<symb_tab.size();i++)
	{

		type_n *p1=(*symb_tab[i]).tp_n;

		type_n *p2;
		while(true)
		{
	
			if(p1 == NULL)
				break;
	
			p2=p1;
	
			p1=(*p1).next;
	
			delete p2;
		}
	}
}
int symtab::findg(string n)
{
	for(int i=0;i<vs.size();i++)
	{

		if(vs[i]==n)
			return 1;
	}
	for(int i=0;i<cs.size();i++)
	{

		if(cs[i]==n)
			return 2;
	}
	return 0;
}
type_n *CopyType(type_n *t)
{
	/*Duplicates the input type and returns the pointer to the newly created type*/
	if(t == NULL) 
		return t;
	type_n *ret = new type_n((*t).basetp);
	(*ret).size = (*t).size;
	(*ret).basetp = (*t).basetp;
	(*ret).next = CopyType((*t).next);
	return ret;
}

symdata* symtab::lookup(string n)
{
	int i;
	//pf("%s-->%s\n",name.c_str(),n.c_str());
	for(i=0;i<symb_tab.size();i++)
	{

		//pf("Flag1\n");
		if((*symb_tab[i]).name == n)
		{
	
			return symb_tab[i];
		}
	}
	//pf("Flag2\n");
	//pf("k%d\n",symb_tab.size());
	symdata *temp_o=new symdata(n);
	(*temp_o).i_val.int_val=0;
	symb_tab.pb(temp_o);
	//pf("lol%s\n",temp_o->name.c_str());
	//pf("%d\n",symb_tab.size());
	return symb_tab[symb_tab.size()-1];
}

symdata* symtab::lookup_2(string n)
{
	int i;
	for(i=0;i<symb_tab.size();i++)
	{

		if(symb_tab[i]->name == n)
		{
	
			return symb_tab[i];
		}
	}
	for(i=0;i<(*glob_st).symb_tab.size();i++)
	{

		if((*glob_st).symb_tab[i]->name == n)
		{
	
			return (*glob_st).symb_tab[i];
		}
	}
	symdata *temp_o=new symdata(n);
	(*temp_o).i_val.int_val=0;
	symb_tab.pb(temp_o);
	return symb_tab[symb_tab.size()-1];
}

symdata* symtab::search(string n)
{
	int i;
	for(i=0;i<symb_tab.size();i++)
	{

		if((*symb_tab[i]).name==n && symb_tab[i]->ispresent)
		{
	
			return (symb_tab[i]);
		}
	}
	return NULL;
}

symdata* symtab::gentemp(type_n *type)
{
	char c[10];
	sprintf(c,"t%03d",temp_count);
	temp_count++;
	symdata *temp=lookup(c);
	int temp_sz;
	if(type==NULL)
		temp_sz=0;
	else if(((*type).basetp) == tp_void)
		temp_sz=0;
	else if(((*type).basetp) == tp_int)
		temp_sz=size_int;
	else if(((*type).basetp) == tp_double)
		temp_sz=size_double;
	else if(((*type).basetp) == tp_bool)
		temp_sz=size_bool;
	else if(((*type).basetp) == tp_char)
		temp_sz=size_char;
	else if(((*type).basetp) == tp_ptr)
		temp_sz=size_pointer;
	else
		temp_sz=(*type).getSize();
	(*temp).size=temp_sz;
	(*temp).var_type="temp";
	(*temp).tp_n=type;
	(*temp).offset=(*this).offset;
	(*this).offset=(*this).offset+((*temp).size);
	return temp;
}

void symtab::update(symdata *sm,type_n *type,basic_val initval,symtab *next)
{
	(*sm).tp_n=CopyType(type);
	(*sm).i_val=initval;
	(*sm).nest_tab=next;
	int temp_sz;
	if((*sm).tp_n==NULL)
		temp_sz=0;
	else if((((*sm).tp_n)->basetp) == tp_void)
		temp_sz=0;
	else if((((*sm).tp_n)->basetp) == tp_int)
		temp_sz=size_int;
	else if((((*sm).tp_n)->basetp) == tp_double)
		temp_sz=size_double;
	else if((((*sm).tp_n)->basetp) == tp_bool)
		temp_sz=size_bool;
	else if((((*sm).tp_n)->basetp) == tp_char)
		temp_sz=size_char;
	else if((((*sm).tp_n)->basetp) == tp_ptr)
		temp_sz=size_pointer;
	else
		temp_sz=(*sm).tp_n->getSize();
	(*sm).size=temp_sz;
	(*sm).offset=(*this).offset;
	(*this).offset=(*this).offset+((*sm).size);
	(*sm).isInitialized=false;
}

void symtab::print()
{
	pf("____________________________________________ %s ____________________________________________\n",name.c_str());
	pf("Offset = %d\nStart Quad Index = %d\nEnd Quad Index =  %d\n",offset,start_quad,end_quad);
	pf("Name\tValue\tvar_type\tsize\tOffset\tType\n\n");
    for(int i = 0; i<(symb_tab).size(); i++)
    {

        if(symb_tab[i]->ispresent==false)
        	continue;

        symdata * t = symb_tab[i];

        pf("%s\t",symb_tab[i]->name.c_str()); 
        if((*t).isInitialized)
        {
    
        	if(((*t).tp_n)->basetp == tp_char) 
        		pf("%c\t",((*t).i_val).char_val);
        	else if(((*t).tp_n)->basetp == tp_int) 
        		pf("%d\t",((*t).i_val).int_val);
        	else if(((*t).tp_n)->basetp == tp_double) 
        		pf("%.3lf\t",((*t).i_val).double_val);
       	 	else pf("----\t");
    
      	}
      	else
      		pf("null\t");

        pf("%s",(*t).var_type.c_str());

        pf("\t\t%d\t%d\t",(*t).size,(*t).offset);

		if((*t).var_type == "func")
			pf("ptr-to-St( %s )",(*t).nest_tab->name.c_str());

		if((*t).tp_n != NULL)
			((*t).tp_n)->print();
		pf("\n");
	}
	pf("\n");
	pf("x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-\n");
}
list* makelist(int i)
{
	list *temp = (list*)malloc(sizeof(list));
	(*temp).index=i;
	(*temp).next=NULL;
	return temp;
}
list* merge(list *lt1,list *lt2)
{
	list *temp = (list*)malloc(sizeof(list));
	list *p1=temp;
	int flag=0;
	list *l1=lt1;
	list *l2=lt2;
	while(l1!=NULL)
	{
		flag=1;

		(*p1).index=(*l1).index;

		if((*l1).next!=NULL)
		{
			(*p1).next=(list*)malloc(sizeof(list));
			p1=(*p1).next;
		}

		l1=(*l1).next;
	}
	while(l2!=NULL)
	{

		if(flag==1)
		{
	
			(*p1).next=(list*)malloc(sizeof(list));
	
			p1=(*p1).next;
	
			flag=0;
	
		}
		(*p1).index=l2->index;

		if(l2->next!=NULL)
		{
	
			(*p1).next=(list*)malloc(sizeof(list));
	
			p1=(*p1).next;
	
		}
		l2=l2->next;

	}
	(*p1).next=NULL;
	return temp;
}

quad::quad(opcode opc,string a1,string a2,string rs)
{
	(*this).op=opc;
	(*this).arg1=a1;
	(*this).result=rs;
	(*this).arg2=a2;
}

void quad::print_arg()
{
	pf("\t%s\t=\t%s\top\t%s\t",result.c_str(),arg1.c_str(),arg2.c_str());
}

quad_arr::quad_arr()
{
	next_instr=0;
}

void quad_arr::emit(opcode opc, string arg1, string arg2, string result)
{
	if(result.size()!=0)
	{

		quad new_elem(opc,arg1,arg2,result);

		arr.pb(new_elem);

	}
	else if(arg2.size()!=0)
	{

		quad new_elem(opc,arg1,"",arg2);

		arr.pb(new_elem);

	}
	else if(arg1.size()!=0)
	{

		quad new_elem(opc,"","",arg1);

		arr.pb(new_elem);

	}
	else
	{

		quad new_elem(opc,"","","");

		arr.pb(new_elem);

	}
	next_instr++;
}
void quad_arr::emit2(opcode opc,string arg1, string arg2, string result)
{
	if(result.size()==0)
	{

		quad new_elem(opc,arg1,arg2,"");

		arr.pb(new_elem);
	}
}
void quad_arr::emit(opcode opc, int val, string operand)
{
	char str[20];
	sprintf(str, "%d", val);
	if(operand.size()==0)
	{

		quad new_quad(opc,"","",str);

		arr.pb(new_quad);

	}
	else
	{

		quad new_quad(opc,str,"",operand);

		arr.pb(new_quad);

	}
	next_instr=next_instr+1;
}

void quad_arr::emit(opcode opc, double val, string operand)
{
	char str[20];
	sprintf(str, "%lf", val);
	if(operand.size()==0)
	{

		quad new_quad(opc,"","",str);

		arr.pb(new_quad);

	}
	else
	{

		quad new_quad(opc,str,"",operand);

		arr.pb(new_quad);

	}
	next_instr=next_instr+1;
}

void quad_arr::emit(opcode opc, char val, string operand)
{
	char str[20];
	sprintf(str, "'%c'", val);
	if(operand.size()==0)
	{

		quad new_quad(opc,"","",str);

		arr.pb(new_quad);

	}
	else
	{

		quad new_quad(opc,str,"",operand);

		arr.pb(new_quad);

	}
	next_instr=next_instr+1;
}

void quad_arr::print()
{
	opcode op;
	string arg1;
	string arg2;
	string result;
	for(int i=0;i<next_instr;i++)
	{

		op=arr[i].op;

		arg1=arr[i].arg1;

		arg2=arr[i].arg2;

		result=arr[i].result;

		pf("%3d : ",i);

		if(Q_PLUS<=op && op<=Q_NOT_EQUAL)
	    {
	        pf("%s",result.c_str());
	
	        pf("\t=\t");
	
	        pf("%s",arg1.c_str());
	
	        pf(" ");
	
            if( Q_PLUS == op) 
            	pf("+"); 
            else if( Q_MINUS == op) 
            	pf("-"); 
            else if (Q_MULT == op) 
            	pf("*"); 
            else if(op == Q_DIVIDE) 
            	pf("/");
            else if( Q_MODULO ==op) 
            	pf("%%"); 
            else if( Q_LEFT_OP == op) 
            	pf("<<"); 
            else if (op == Q_RIGHT_OP) 
            	pf(">>"); 
            else if(op == Q_XOR) 
            	pf("^"); 
            else if (op== Q_AND) 
            	pf("&"); 
            else if( Q_OR == op) 
            	pf("|"); 
            else if (Q_LOG_AND == op) 
            	pf("&&"); 
            else if(op == Q_LOG_OR) 
            	pf("||"); 
            else if( Q_LESS == op) 
            	pf("<"); 
            else if( Q_LESS_OR_EQUAL == op) 
            	pf("<="); 
            else if(Q_GREATER_OR_EQUAL == op) 
            	pf(">="); 
            else if (Q_GREATER == op) 
            	pf(">"); 
            else if (Q_EQUAL == op) 
            	pf("=="); 
            else if(Q_NOT_EQUAL == op) 
            		pf("!=");
        
	        pf(" ");
	
	       	pf("%s\n",arg2.c_str());
	
	    }
	    else if(Q_UNARY_MINUS<=op && op<=Q_ASSIGN)
	    {
	        pf("%s",result.c_str());
	
	        pf("\t=\t");
	    
            if( Q_UNARY_MINUS == op) 
            	pf("-"); 
            else if (op == Q_UNARY_PLUS)  
            	pf("+"); 
            else if(op == Q_COMPLEMENT) 
            	pf("~"); 
            else if(op== Q_NOT)  
            	pf("!"); 
    
	        pf("%s\n",arg1.c_str());
	
	    }
	    else if(op == Q_GOTO)
	    {
	    	pf("goto ");
	
	    	pf("%s\n",result.c_str());
	
	    }
	    else if(Q_IF_EQUAL<=op && op<=Q_IF_GREATER_OR_EQUAL)
	    {
	        pf("if  ");pf("%s",arg1.c_str());pf(" ");
	
            //Conditional Jump
            if(Q_IF_LESS == op) 
            	pf("<"); 
            else if( Q_IF_GREATER == op) 
            	pf(">"); 
            else if(op == Q_IF_LESS_OR_EQUAL ) 
            	pf("<="); 
            else if(op == Q_IF_GREATER_OR_EQUAL ) 
            	pf(">="); 
            else if (op == Q_IF_EQUAL ) 
            	pf("=="); 
            else if(op == Q_IF_NOT_EQUAL )
            	pf("!="); 
            else if (op == Q_IF_EXPRESSION ) 
            	pf("!= 0"); 
            else if (op == Q_IF_NOT_EXPRESSION)  
            	pf("== 0"); 
	        pf("%s",arg2.c_str());
	
	        pf("\tgoto ");
	
	        pf("%s\n",result.c_str()); 
	           
	    }
	    else if(Q_CHAR2INT<=op && op<=Q_DOUBLE2INT)
	    {
	        pf("%s",result.c_str());pf("\t=\t");
	
            if(op == Q_CHAR2INT) 
            { 
            	pf(" Char2Int(");
        
            	pf("%s",arg1.c_str());pf(")\n"); 
            }
            else if(op == Q_CHAR2DOUBLE) 
            {
            	pf(" Char2Double(");
        
            	pf("%s",arg1.c_str());pf(")\n"); 
            }
            else if(op == Q_INT2CHAR) 
            {
            	pf(" Int2Char(");
        
            	pf("%s",arg1.c_str());
        
            	pf(")\n"); 
        	}
            else if(op == Q_DOUBLE2CHAR ) 
            {
            	pf(" Double2Char(");
        
            	pf("%s",arg1.c_str());
        
            	pf(")\n");
            }
            else if(op == Q_INT2DOUBLE)
            { 
            	pf(" Int2Double(");
        
            	pf("%s",arg1.c_str());
        
            	pf(")\n"); 
            }
            else if(op == Q_DOUBLE2INT)
            { 
            	pf(" Double2Int(");
        
            	pf("%s",arg1.c_str());
        
            	pf(")\n"); 
            }	
    
	                    
	    }
	    else if(op == Q_PARAM)
	    {
	
	        pf("param\t");pf("%s\n",result.c_str());
	
	    }
	    else if(op == Q_CALL)
	    {
	
	        if(!result.c_str())
					pf("call %s, %s\n", arg1.c_str(), arg2.c_str());
			else if(result.size()==0)
			{
		
				pf("call %s, %s\n", arg1.c_str(), arg2.c_str());
			}
			else
			{
		
				pf("%s\t=\tcall %s, %s\n", result.c_str(), arg1.c_str(), arg2.c_str());
			}	    
	    }
	    else if(op == Q_RETURN)
	    {
	        pf("return\t");
	
	        pf("%s\n",result.c_str());
	
	    }
	    else if( op == Q_RINDEX)
	    {
	
	        pf("%s\t=\t%s[%s]\n", result.c_str(), arg1.c_str(), arg2.c_str());
	
	    }
	    else if(op == Q_LINDEX)
	    {
	
	        pf("%s[%s]\t=\t%s\n", result.c_str(), arg1.c_str(), arg2.c_str());
	
	    }
	    else if(op == Q_LDEREF)
	    {
	
	        pf("*%s\t=\t%s\n", result.c_str(), arg1.c_str());
	    }
	    else if(op == Q_RDEREF)
	    {
	
	    	pf("%s\t=\t* %s\n", result.c_str(), arg1.c_str());
	    }
	    else if(op == Q_ADDR)
	    {
	
	    	pf("%s\t=\t& %s\n", result.c_str(), arg1.c_str());
	    }
	}
}

void backpatch(list *l,int i)
{
	list *temp =l;
	list *temp2;
	char str[10];
	sprintf(str,"%d",i);
	while(temp!=NULL)
	{

		global_quad_table.arr[(*temp).index].result = str;

		temp2=temp;

		temp=(*temp).next;

		free(temp2);
	}
}

void typecheck(expresn *e1,expresn *e2,bool isAssign)
{
	types type1,type2;
	//if((*e2).type)
	if(e1->type==NULL)
	{

		e1->type = CopyType((*e2).type);
	}
	else if((*e2).type==NULL)
	{

		(*e2).type =CopyType(e1->type);
	}
	type1=((*e1).type)->basetp;
	type2=((*e2).type)->basetp;
	if(type1==type2)
	{

		return;
	}
	if(!isAssign)
	{
		if(type1>type2)
		{
	
			symdata *temp = (*Current_ST).gentemp((*e1).type);
	
			if(type1 == tp_int && type2 == tp_char)
				global_quad_table.emit(Q_CHAR2INT, (*e2).loc->name, (*temp).name);
			else if(type1 == tp_double && type2 == tp_int)
				global_quad_table.emit(Q_INT2DOUBLE,(*e2).loc->name, (*temp).name);
			(*e2).loc = temp;
	
			(*e2).type = (*temp).tp_n;
	
		}
		else
		{
	
			symdata *temp = (*Current_ST).gentemp((*e2).type);
	
			if(type2 == tp_int && type1 == tp_char)
				global_quad_table.emit(Q_CHAR2INT, e1->loc->name, (*temp).name);
			else if(type2 == tp_double && type1 == tp_int)
				global_quad_table.emit(Q_INT2DOUBLE, e1->loc->name, (*temp).name);	
	
			e1->loc = temp;
	
			e1->type = (*temp).tp_n;
		}		
	}
	else
	{

		symdata *temp = (*Current_ST).gentemp(e1->type);
		if(type1 == tp_int && type2 == tp_double)
			global_quad_table.emit(Q_DOUBLE2INT, (*e2).loc->name, (*temp).name);
		else if(type1 == tp_double && type2 == tp_int)
			global_quad_table.emit(Q_INT2DOUBLE, (*e2).loc->name, (*temp).name);
		else if(type1 == tp_char && type2 == tp_int)
			global_quad_table.emit(Q_INT2CHAR, (*e2).loc->name, (*temp).name);
		else if(type1 == tp_int && type2 == tp_char)
			global_quad_table.emit(Q_CHAR2INT, (*e2).loc->name, (*temp).name);
		else
		{
	
			pf("%s %s Types compatibility not defined\n",e1->loc->name.c_str(),(*e2).loc->name.c_str());
	
			exit(-1);
		}
		(*e2).loc = temp;

		(*e2).type = (*temp).tp_n;

	}
}

void print_list(list *root)
{
	int flag=0;
	while(root!=NULL)
	{
		pf("%d ",root->index);

		flag=1;

		root=root->next;
	}
	if(flag==0)
	{

		pf("Empty List\n");
	}
	else
	{

		pf("\n");
	}
}
void conv2Bool(expresn *e)
{
	if(((*e).type)->basetp!=tp_bool)
	{
		((*e).type) = new type_n(tp_bool);

		(*e).falselist=makelist(next_instr);

		global_quad_table.emit(Q_IF_EQUAL,(*e).loc->name,"0","-1");

		(*e).truelist = makelist(next_instr);

		global_quad_table.emit(Q_GOTO,-1);

	}
}
void update_nextinstr()
{
	instr_count++;
	if(debug_on==1)
	{
		std::cout<<"Current Line Number:"<<instr_count<<std::endl;

		std::cout<<"Press [ENTER] to continue:";

		std::cin.get();

	}
}
void debug()
{
	if(debug_on==1)
		std::cout<<instr_count<<std::endl;
}

int main()
{
	instr_count = 0;   // count of instr (used for sanity check)
	debug_on= 0;       // debugging is off
	symdata *temp_printi=new symdata("printInt");
	(*temp_printi).tp_n=new type_n(tp_int);
	(*temp_printi).var_type="func";
	(*temp_printi).nest_tab=glob_st;
	(*glob_st).symb_tab.pb(temp_printi);
	
	symdata *temp_readi=new symdata("readInt");
	temp_readi->tp_n=new type_n(tp_int);
	temp_readi->var_type="func";
	temp_readi->nest_tab=glob_st;
	(*glob_st).symb_tab.pb(temp_readi);
	
	symdata *temp_prints=new symdata("printStr");
	(*temp_prints).tp_n=new type_n(tp_int);
	(*temp_prints).var_type="func";
	(*temp_prints).nest_tab=glob_st;
	(*glob_st).symb_tab.pb(temp_prints);
	yyparse();
	(*glob_st).name="Global";
	pf("_________________________________________________________________________________");
	pf("\nGenerated Quads for the program\n");
	global_quad_table.print();
	pf("_________________________________________________________________________________\n");
	pf("Symbol table Maintained For the Given Program\n");
	(*glob_st).print();
	set<string> setty;
	setty.insert("Global");
	pf("_________________________________________________________________________________\n");
	FILE *fp;
	fp = fopen("output.s","w");
	fprintf(fp,"\t.file\t\"output.s\"\n");
	for (int i = 0; i < strings_label.size(); ++i)
	{
		fprintf(fp,"\n.STR%d:\t.string %s",i,strings_label[i].c_str());	
	}
	set<string>setty_1;
	(*glob_st).mark_labels();
	(*glob_st).global_variables(fp);
	setty_1.insert("Global");
	int count_l=0;
	for (int i = 0; i < (*glob_st).symb_tab.size(); ++i)
	{
		if((((*glob_st).symb_tab[i])->nest_tab)!=NULL)
		{
			if(setty_1.find((((*glob_st).symb_tab[i])->nest_tab)->name)==setty_1.end())
			{
				(*glob_st).symb_tab[i]->nest_tab->assign_offset();
				(*glob_st).symb_tab[i]->nest_tab->print();
				(*glob_st).symb_tab[i]->nest_tab->function_prologue(fp,count_l);
				(*glob_st).symb_tab[i]->nest_tab->function_restore(fp);
				(*glob_st).symb_tab[i]->nest_tab->gen_internal_code(fp,count_l);
				setty_1.insert((((*glob_st).symb_tab[i])->nest_tab)->name);
				(*glob_st).symb_tab[i]->nest_tab->function_epilogue(fp,count_l,count_l);
				count_l++;
			}
		}
	}
	fprintf(fp,"\n");
	return 0;
}

#include "ass6_18CS10021_18CS30040_translator.h"
#include "y.tab.h"

#define fpf fprintf

extern quad_arr global_quad_table;
extern int next_instr;
map<int,int> mp_set;
stack<string> params_stack;
stack<int> types_stack;
stack<int> offset_stack;
stack<int> ptrarr_stack;
extern std::vector< string > vs;
extern std::vector<string> cs;
int add_off;
void symtab::mark_labels()
{
	int count=1;
	
	for(int i=0;i<next_instr;i++)
	{
		
		switch(global_quad_table.arr[i].op)
		{
			case Q_GOTO: 
			case Q_IF_EQUAL: 
			case Q_IF_NOT_EQUAL: 
			case Q_IF_EXPRESSION: 
			case Q_IF_NOT_EXPRESSION: 
			case Q_IF_LESS: 
			case Q_IF_GREATER: 
			case Q_IF_LESS_OR_EQUAL: 
			case Q_IF_GREATER_OR_EQUAL: 
			if(global_quad_table.arr[i].result!="-1")
			{	
				
				if(mp_set.find(atoi(global_quad_table.arr[i].result.c_str()))==mp_set.end())
				{
					
					mp_set[atoi(global_quad_table.arr[i].result.c_str())]=count;
					
					count++;
									
				}
			}
		}
	}
}

void symtab::function_prologue(FILE *fp,int count)
{
	
	fpf(fp,"\n\t.globl\t%s",name.c_str());
	
	fpf(fp,"\n\t.type\t%s, @function",name.c_str());
	
	fpf(fp,"\n%s:",name.c_str());
	
	fpf(fp,"\n.LFB%d:",count);
	
	fpf(fp,"\n\tpushq\t%%rbp");
	
	fpf(fp,"\n\tmovq\t%%rsp, %%rbp");
	
	int t=-offset;
	
	fpf(fp,"\n\tsubq\t$%d, %%rsp",t);
	
}

void symtab::global_variables(FILE *fp)
{
	
	for(int i=0;i<symb_tab.size();i++)
	{
		
		if(symb_tab[i]->name[0]!='t' &&symb_tab[i]->tp_n!=NULL&&symb_tab[i]->var_type!="func")
		{
			
			if(symb_tab[i]->tp_n->basetp==tp_int)
			{
				
				vs.push_back(symb_tab[i]->name);
				
				if(symb_tab[i]->isInitialized==false)
				{
					
					fpf(fp,"\n\t.comm\t%s,4,4",symb_tab[i]->name.c_str());
					
				}
				else
				{
					
					fpf(fp,"\n\t.globl\t%s",symb_tab[i]->name.c_str());
					
					fpf(fp,"\n\t.data");
					
					fpf(fp,"\n\t.align 4");
					
					fpf(fp,"\n\t.type\t%s, @object",symb_tab[i]->name.c_str());
					
					fpf(fp,"\n\t.size\t%s ,4",symb_tab[i]->name.c_str());
					
					fpf(fp,"\n%s:",symb_tab[i]->name.c_str());
					
					fpf(fp,"\n\t.long %d",symb_tab[i]->i_val.int_val);
					
				}
		    }
		    if(symb_tab[i]->tp_n->basetp==tp_char)
			{
				
				cs.push_back(symb_tab[i]->name);
				
				if(symb_tab[i]->isInitialized==false)
				{
					
					fpf(fp,"\n\t.comm\t%s,1,1",symb_tab[i]->name.c_str());
					
				}
				else
				{
					
					fpf(fp,"\n\t.globl\t%s",symb_tab[i]->name.c_str());
					
					fpf(fp,"\n\t.data");
					
					fpf(fp,"\n\t.type\t%s, @object",symb_tab[i]->name.c_str());
					
					fpf(fp,"\n\t.size\t%s ,1",symb_tab[i]->name.c_str());
					
					fpf(fp,"\n%s:",symb_tab[i]->name.c_str());
					
					fpf(fp,"\n\t.byte %c",symb_tab[i]->i_val.char_val);
					
				}
				
		    }
			
		}
		
	}
	
	fpf(fp,"\n\t.text");
	
}
void symtab::assign_offset()
{
	int curr_offset=0;
	int param_offset=16;
	no_params=0;
	
	for(int i = (symb_tab).size()-1; i>=0; i--)
    {
		
        if(symb_tab[i]->ispresent==false)
        	continue;
		
        if(symb_tab[i]->var_type=="param" && symb_tab[i]->isdone==false)
        {
			
        	no_params++;
			
        	if(symb_tab[i]->tp_n && symb_tab[i]->tp_n->basetp==tp_arr)
        	{
				
        		if(symb_tab[i]->tp_n->size==-1)
        		{
					
        			symb_tab[i]->isptrarr=true;
					
        		}
				
        		symb_tab[i]->size=8;
				
        	}
			
        	symb_tab[i]->offset=curr_offset-symb_tab[i]->size;
			
        	curr_offset=curr_offset-symb_tab[i]->size;
			
        	symb_tab[i]->isdone=true;
			
        }
        if(no_params==6)
        	break;
		
    }
    for(int i = 0; i<(symb_tab).size(); i++)
    {
        if(symb_tab[i]->ispresent==false)
        	continue;
		
        if(symb_tab[i]->var_type!="return"&&symb_tab[i]->var_type!="param" && symb_tab[i]->isdone==false)
        {
			
        	symb_tab[i]->offset=curr_offset-symb_tab[i]->size;
			
        	curr_offset=curr_offset-symb_tab[i]->size;
			
        	symb_tab[i]->isdone=true;
			
        }
        else if(symb_tab[i]->var_type=="param" && symb_tab[i]->isdone==false)
        {
			
        	if(symb_tab[i]->tp_n && symb_tab[i]->tp_n->basetp==tp_arr)
        	{
				
        		if(symb_tab[i]->tp_n->size==-1)
        		{
					
        			symb_tab[i]->isptrarr=true;
					
        		}
				
        		symb_tab[i]->size=8;
				
        	}
			
        	symb_tab[i]->isdone=true;
			
        	no_params++;
			
        	symb_tab[i]->offset=param_offset;
			
        	param_offset=param_offset+symb_tab[i]->size;
			
        }
		
    }
	
    offset=curr_offset;
	
}
string symtab::assign_reg(int type_of,int no)
{
	string s="NULL";
	
	if(type_of==tp_char){
		
        switch(no){
            case 0: 
					
            		s = "dil";
					
                    break;
            case 1: 
					
            		s = "sil";
					
                    break;
            case 2: 
					
            		s = "dl";
					
                    break;
            case 3: 
					
            		s = "cl";
					
                    break;
            case 4: 
					
            		s = "r8b";
					
                    break;
            case 5: 
					
            		s = "r9b";
					
                    break;
        }
		
    }
    else if(type_of == tp_int){
        switch(no){
            case 0: 
					
            		s = "edi";
					
                    break;
            case 1: 
            		
            		s = "esi";
					
                    break;
            case 2: 
            		
            		s = "edx";
					
                    break;
            case 3: 
            		
            		s = "ecx";
					
                    break;
            case 4: 
            		
            		s = "r8d";
					
                    break;
            case 5: 
            		
            		s = "r9d";
					
                    break;
        }
		
    }
    else
    {
        switch(no){
            case 0: 
            		
            		s = "rdi";
					
                    break;
            case 1: 
            		
            		s = "rsi";
					
                    break;
            case 2: 
            		
            		s = "rdx";
					
                    break;
            case 3: 
            		
            		s = "rcx";
					
                    break;
            case 4: 
            		
            		s = "r8";
					
                    break;
            case 5: 
            		
            		s = "r9";
					
                    break;
        }
		
    }
	
    return s;
}
int symtab::function_call(FILE *fp)
{
	
	int c=0;
	
	fpf(fp,"\n\tpushq %%rbp");
	
	int count=0;
	
	while(count<6 && params_stack.size())
	{
		
		string p=params_stack.top();
		
		int btp=types_stack.top();
		
		int off=offset_stack.top();
		
		int parr=ptrarr_stack.top();
		
		params_stack.pop();
		
		types_stack.pop();
		
		offset_stack.pop();
		
		ptrarr_stack.pop();
		
		string temp_str=assign_reg(btp,count);
		
		if(temp_str!="NULL")
		{
			
			if(btp==tp_int)
			{	
				
				fpf(fp,"\n\tmovl\t%d(%%rbp) , %%%s",off,temp_str.c_str());
				
			}
			else if(btp==tp_char)
			{
				
				fpf(fp,"\n\tmovb\t%d(%%rbp), %%%s",off,temp_str.c_str());
				
			}
			else if(btp==tp_arr && parr==1)
			{
				
				fpf(fp,"\n\tmovq\t%d(%%rbp), %%%s",off,temp_str.c_str());
				
			}
			else if(btp==tp_arr)
			{
				
				fpf(fp,"\n\tleaq\t%d(%%rbp), %%%s",off,temp_str.c_str());
				
			}
			else
			{
				
				fpf(fp,"\n\tmovq\t%d(%%rbp), %%%s",off,temp_str.c_str());
				
			}
			
			count++;
			
		}
		
	}
	while(params_stack.size())
	{
		
		string p=params_stack.top();
		
		int btp=types_stack.top();
		
		int off=offset_stack.top();
		
		int parr=ptrarr_stack.top();
		
		params_stack.pop();
		
		types_stack.pop();
		
		offset_stack.pop();
		
		ptrarr_stack.pop();
		
		if(btp==tp_int)
		{	
			
			fpf(fp,"\n\tsubq $4, %%rsp");
			
			fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off);
			
			fpf(fp,"\n\tmovl\t%%eax, (%%rsp)");
			
			c+=4;
			
		}
		else if(btp==tp_arr && parr==1)
		{
			
			fpf(fp,"\n\tsubq $8, %%rsp");
			
			fpf(fp,"\n\tmovq\t%d(%%rbp), %%rax",off);
			
			fpf(fp,"\n\tmovq\t%%rax, (%%rsp)");
			
			c+=8;
			
		}
		else if(btp==tp_arr)
		{
			
			fpf(fp,"\n\tsubq $8, %%rsp");
			
			fpf(fp,"\n\tleaq\t%d(%%rbp), %%rax",off);
			
			fpf(fp,"\n\tmovq\t%%rax, (%%rsp)");
			
			c+=8;
			
		}
		else if(btp==tp_char)
		{
			
			fpf(fp,"\n\tsubq $4, %%rsp");
			
			fpf(fp,"\n\tmovsbl\t%d(%%rbp), %%eax",off);
			
			fpf(fp,"\n\tmovl\t%%eax, (%%rsp)");
			
			c+=4;
			
		}
		else
		{
			
			fpf(fp,"\n\tsubq $8, %%rsp");
			
			fpf(fp,"\n\tmovq\t%d(%%rbp), %%rax",off);
			
			fpf(fp,"\n\tmovq\t%%rax, (%%rsp)");
			
			c+=8;
			
		}
		
	}
	
	return c;
	
}
void symtab::function_restore(FILE *fp)
{
	
	int count=0;
	
	string regname;
	
	for(int i=symb_tab.size()-1;i>=0;i--)
	{
		
	    if(symb_tab[i]->ispresent==false)
	    	continue;
		
	    if(symb_tab[i]->var_type=="param" && symb_tab[i]->offset<0)
	    {
			
		    if(symb_tab[i]->tp_n->basetp == tp_char){
				
	            regname = assign_reg(tp_char,count);
				
	            fpf(fp,"\n\tmovb\t%%%s, %d(%%rbp)",regname.c_str(),symb_tab[i]->offset);
				
	        }
	        else if(symb_tab[i]->tp_n->basetp == tp_int){
				
	            regname = assign_reg(tp_int,count);
				
	            fpf(fp,"\n\tmovl\t%%%s, %d(%%rbp)",regname.c_str(),symb_tab[i]->offset);
				
	        }
	        else {
				
	            regname = assign_reg(10,count);
				
	            fpf(fp,"\n\tmovq\t%%%s, %d(%%rbp)",regname.c_str(),symb_tab[i]->offset);
				
	        }
			
	    	count++;
			
	    }
		
	    if(count==6)
	    	break;
		
    }
}
void symtab::gen_internal_code(FILE *fp,int ret_count)
{
	int i;			
		
	for(i = start_quad; i <=end_quad; i++)
	{
		
		opcode &opx =global_quad_table.arr[i].op;
		
		string &arg1x =global_quad_table.arr[i].arg1;
		
		string &arg2x =global_quad_table.arr[i].arg2;
		
		string &resx =global_quad_table.arr[i].result;
		
		int offr,off1,off2;
		
		int flag1=1;
		
		int flag2=1;
		
		int flag3=1;
		
		int j;
		
		fpf(fp,"\n# %d:",i);
		
		if(search(resx))
		{
			
			offr = search(resx)->offset;
			
			fpf(fp,"res = %s ",search(resx)->name.c_str());
			
		}
		else if(global_quad_table.arr[i].result!=""&& findg(global_quad_table.arr[i].result))
		{
			
			flag3=0;
			
		}
		if(search(arg1x))
		{
			
			off1 = search(arg1x)->offset;
			
			fpf(fp,"arg1 = %s ",search(arg1x)->name.c_str());
			
		}
		else if(global_quad_table.arr[i].arg1!="" && findg(global_quad_table.arr[i].arg1))
		{
			
			flag1=0;
					
		}
		if(search(arg2x))
		{
			
			off2 = search(arg2x)->offset;
			
			fpf(fp,"arg2 = %s ",search(arg2x)->name.c_str());
			
		}
		else if(global_quad_table.arr[i].arg2!="" && findg(global_quad_table.arr[i].arg2))
		{
			
			flag2=0;
			
		}
		if(flag1==0)
		{
			
			if(findg(arg1x)==2)
			{
				
				fpf(fp,"\n\tmovzbl\t%s(%%rip), %%eax",arg1x.c_str());
				
			}
			else
			{
				
				fpf(fp,"\n\tmovl\t%s(%%rip), %%eax",arg1x.c_str());
				
			}
			
		}
		if(flag2==0)
		{
			
			if(findg(arg1x)==2)
			{
				
				fpf(fp,"\n\tmovzbl\t%s(%%rip), %%edx",arg2x.c_str());
				
			}
			else
			{
				
				fpf(fp,"\n\tmovl\t%s(%%rip), %%edx",arg2x.c_str());
				
			}
			
		}
		if(mp_set.find(i)!=mp_set.end())
		{
			//Generate Label here
			
			fpf(fp,"\n.L%d:",mp_set[i]);
			
		}
		switch(opx)
		{
			case Q_PLUS:
				if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					
					if(flag1!=0)
						fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					
					if(flag2!=0)
						fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%edx",off2);
					
					fpf(fp,"\n\taddl\t%%edx, %%eax");
					
					if(flag3!=0)
					{
						
						fpf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
						
					}
					else
					{
						
						fpf(fp,"\n\tmovb\t%%al, %s(%%rip)",resx.c_str());
						
					}
					
				}
				else 
				{
					
					if(flag1!=0)
						fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					
					if(flag2!=0)
					{
						if(arg2x[0]>='0' && arg2x[0]<='9')
						{
							
							fpf(fp,"\n\tmovl\t$%s, %%edx",arg2x.c_str());
							
						}
						else
						{
							
							fpf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);
							
						}
						
					}
					
					fpf(fp,"\n\taddl\t%%edx, %%eax");
					
					if(flag3!=0)
					{
						
						fpf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
						
					}
					else
					{
						
						fpf(fp,"\n\tmovl\t%%eax, %s(%%rip)",resx.c_str());
						
					}
					
				}
				
				break;
			case Q_MINUS:
				if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					
					if(flag1!=0)
					{
						
						fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
						
					}
					
					if(flag2!=0)
					{
						
						fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%edx",off2);
						
					}
					
					fpf(fp,"\n\tsubl\t%%edx, %%eax");
					
					if(flag3!=0)
					{
						
						fpf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
						
					}
					else
					{
						
						fpf(fp,"\n\tmovb\t%%al, %s(%%rip)",resx.c_str());
						
					}
					
				}
				else
				{
					
					if(flag1!=0)
					{
						
						fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
						
					}
					
					// Direct Number access
					if(flag2!=0)
					{
						if(arg2x[0]>='0' && arg2x[0]<='9')
						{
							
							fpf(fp,"\n\tmovl\t$%s, %%edx",arg2x.c_str());
							
						}
						else
						{
							
							fpf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);
							
						}
						
					}
					fpf(fp,"\n\tsubl\t%%edx, %%eax");
					
					if(flag3!=0)
					{
						
						fpf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
						
					}
					else
					{
						
						fpf(fp,"\n\tmovl\t%%eax, %s(%%rip)",resx.c_str());
						
					}
					
				}
				
				break;
			case Q_MULT:
				if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					
					if(flag1!=0)
					{
						
						fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
						
					}
					
					if(flag2!=0)
					{
						
						fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%edx",off2);
						
					}
					
					fpf(fp,"\n\timull\t%%edx, %%eax");
					
					if(flag3!=0)
					{
						
						fpf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
						
					}
					else
					{
						
						fpf(fp,"\n\tmovb\t%%al, %s(%%rip)",resx.c_str());
						
					}
					
				}
				else
				{
					
					if(flag1!=0)
					{
						
						fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
						
					}
					
					if(flag2!=0)
					{
						
						if(arg2x[0]>='0' && arg2x[0]<='9')
						{
							
							fpf(fp,"\n\tmovl\t$%s, %%ecx",arg2x.c_str());
							
							fpf(fp,"\n\timull\t%%ecx, %%eax");
							
						}
						else
						{
							
							fpf(fp,"\n\timull\t%d(%%rbp), %%eax",off2);
							
						}
						
					}
					if(flag3!=0)
					{
						
						fpf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
						
					}
					else
					{
						
						fpf(fp,"\n\tmovl\t%%eax, %s(%%rip)",resx.c_str());
						
					}
					
				}
				
				break;
			case Q_DIVIDE:
				if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					
					if(flag1!=0)
					{
						
						fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
						
					}
					
					fpf(fp,"\n\tcltd");
					
					if(flag2!=0)
					{
						
						fpf(fp,"\n\tidivl\t%d(%%rbp), %%eax",off2);
						
					}
					else
					{
						
						fpf(fp,"\n\tidivl\t%%edx, %%eax");
						
					}
					
					if(flag3!=0)
					{
						
						fpf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
						
					}
					else
					{
						
						fpf(fp,"\n\tmovb\t%%al, %s(%%rip)",resx.c_str());
						
					}
					
				}
				else
				{
					
					if(flag1!=0)
					{
						
						fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
						
					}
					
					fpf(fp,"\n\tcltd");
					
					if(flag2!=0)
					{
						
						fpf(fp,"\n\tidivl\t%d(%%rbp), %%eax",off2);
						
					}
					else
					{
						
						fpf(fp,"\n\tidivl\t%%edx, %%eax");
						
					}
					
					if(flag3!=0)
					{
						
						fpf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
						
					}
					else
					{
						
						fpf(fp,"\n\tmovl\t%%eax, %s(%%rip)",resx.c_str());
						
					}
					
				}	
				
				break;
			case Q_MODULO:
				if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					
					fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tcltd");
					
					fpf(fp,"\n\tidivl\t%d(%%rbp), %%eax",off2);
					
					fpf(fp,"\n\tmovl\t%%edx, %%eax");
					
					fpf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
					
				}
				else
				{
					
					fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tcltd");
					
					fpf(fp,"\n\tidivl\t%d(%%rbp), %%eax",off2);
					
					fpf(fp,"\n\tmovl\t%%edx, %d(%%rbp)",offr);
					
				}
				
				break;
			case Q_UNARY_MINUS:
				if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					
					fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tnegl\t%%eax");
					
					fpf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
					
				}
				else
				{
					
					fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tnegl\t%%eax");
					
					fpf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
					
				}
				
				break;
			case Q_ASSIGN:
				if(arg1x[0]>='0' && arg1x[0]<='9')
				{
					
					if(flag1!=0)
					{
						
						fpf(fp,"\n\tmovl\t$%s, %d(%%rbp)",arg1x.c_str(),offr);
						
					}
					
				}
				else if(arg1x[0] == '\'')
				{
					//Character
					
					fpf(fp,"\n\tmovb\t$%d, %d(%%rbp)",(int)arg1x[1],offr);
					
				}
				else if(flag1 && search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					
					fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
					
				}
				else if(flag1&&search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_int)
				{
					
					if(flag1!=0)
					{
						
						fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
						
					}
					
					fpf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
					
				}
				else if(search(resx)!=NULL && search(resx)->tp_n!=NULL)
				{
					
					fpf(fp,"\n\tmovq\t%d(%%rbp), %%rax",off1);
					
					fpf(fp,"\n\tmovq\t%%rax, %d(%%rbp)",offr);
					
				}
				else
				{
					
					if(flag3!=0)
					{
						
						fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
						
						fpf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
						
					}
					else
					{
						
						fpf(fp,"\n\tmovl\t%%eax, %s(%%rip)",resx.c_str());
						
					}
				}
				
				break;
			case Q_PARAM:
				if(resx[0] == '_')
				{
					//string
					
					char* temp = (char*)resx.c_str();
					
					fpf(fp,"\n\tmovq\t$.STR%d,\t%%rdi",atoi(temp+1));
					
				}
				else
				{
					params_stack.push(resx);
					
					//printf("resx--> %s\n",resx.c_str());
					// 
					types_stack.push(search(resx)->tp_n->basetp);
					
					offset_stack.push(offr);
					
					if(search(resx)->isptrarr==true)
					{
						ptrarr_stack.push(1);
						
					}
					else
					{
						ptrarr_stack.push(0);
						
					}
				}
				
				break;
			case Q_GOTO:
				if(resx!="-1"&& atoi(resx.c_str())<=end_quad)
					fpf(fp,"\n\tjmp .L%d",mp_set[atoi(resx.c_str())]);
				else 
					fpf(fp,"\n\tjmp\t.LRT%d",ret_count);
				
				break;
			case Q_CALL:
				add_off=function_call(fp);
				
				fpf(fp,"\n\tcall\t%s",arg1x.c_str());
				
				if(resx=="")
				{
					
				}
				else if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_int)
				{
					fpf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
					
				}
				else if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					
					fpf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
				}
				else if(search(resx)!=NULL && search(resx)->tp_n!=NULL)
				{
					
					fpf(fp,"\n\tmovq\t%%rax, %d(%%rbp)",offr);	
				}
				else
				{	
					
					fpf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
				}
				if(arg1x=="printStr")
				{
					
					fpf(fp,"\n\taddq $8 , %%rsp");
				}
				else 
				{
					
					fpf(fp,"\n\taddq $%d , %%rsp",add_off);
				}
				
				break;
			case Q_IF_LESS:
				if(search(arg1x)!=NULL && search(arg1x)->tp_n!=NULL&&search(arg1x)->tp_n->basetp == tp_char)
				{
					
					fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);
					
					fpf(fp,"\n\tjl .L%d",mp_set[atoi(resx.c_str())]);
					
				}
				else
				{
					fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);
					
					fpf(fp,"\n\tcmpl\t%%edx, %%eax");
					
					fpf(fp,"\n\tjl .L%d",mp_set[atoi(resx.c_str())]);
					
				}
				break;
			case Q_IF_LESS_OR_EQUAL:
				if(search(arg1x)!=NULL && search(arg1x)->tp_n!=NULL&&search(arg1x)->tp_n->basetp == tp_char)
				{
					fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);
					
					fpf(fp,"\n\tjle .L%d",mp_set[atoi(resx.c_str())]);
					
				}
				else
				{
					fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);
					
					fpf(fp,"\n\tcmpl\t%%edx, %%eax");
					
					fpf(fp,"\n\tjle .L%d",mp_set[atoi(resx.c_str())]);
					
				}
				
				break;
			case Q_IF_GREATER:
				if(search(arg1x)!=NULL && search(arg1x)->tp_n!=NULL&&search(arg1x)->tp_n->basetp == tp_char)
				{
					fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);
					
					fpf(fp,"\n\tjg .L%d",mp_set[atoi(resx.c_str())]);
					
				}
				else
				{
					fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);
					
					fpf(fp,"\n\tcmpl\t%%edx, %%eax");
					
					fpf(fp,"\n\tjg .L%d",mp_set[atoi(resx.c_str())]);
					
				}
				
				break;
			case Q_IF_GREATER_OR_EQUAL:
				if(search(arg1x)!=NULL && search(arg1x)->tp_n!=NULL&&search(arg1x)->tp_n->basetp == tp_char)
				{
					
					fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);
					
					fpf(fp,"\n\tjge .L%d",mp_set[atoi(resx.c_str())]);
					
				}
				else
				{
					
					fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);
					
					fpf(fp,"\n\tcmpl\t%%edx, %%eax");
					
					fpf(fp,"\n\tjge .L%d",mp_set[atoi(resx.c_str())]);
					
				}
				
				break;
			case Q_IF_EQUAL:
				if(search(arg1x)!=NULL && search(arg1x)->tp_n!=NULL&&search(arg1x)->tp_n->basetp == tp_char)
				{
					
					fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);
					
					fpf(fp,"\n\tje .L%d",mp_set[atoi(resx.c_str())]);
					
				}
				else
				{
					
					fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);
					
					fpf(fp,"\n\tcmpl\t%%edx, %%eax");
					
					fpf(fp,"\n\tje .L%d",mp_set[atoi(resx.c_str())]);
					
				}
				break;
			case Q_IF_NOT_EQUAL:
				if(search(arg1x)!=NULL && search(arg1x)->tp_n!=NULL&&search(arg1x)->tp_n->basetp == tp_char)
				{
					
					fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);
					
					fpf(fp,"\n\tjne .L%d",mp_set[atoi(resx.c_str())]);
					
				}
				else
				{
					
					fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					
					fpf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);
					
					fpf(fp,"\n\tcmpl\t%%edx, %%eax");
					
					fpf(fp,"\n\tjne .L%d",mp_set[atoi(resx.c_str())]);
					
				}
				
				break;
			case Q_ADDR:
				
				fpf(fp,"\n\tleaq\t%d(%%rbp), %%rax",off1);
				
				fpf(fp,"\n\tmovq\t%%rax, %d(%%rbp)",offr);
				
				break;
			case Q_LDEREF:
				
				fpf(fp,"\n\tmovq\t%d(%%rbp), %%rax",offr);
				
				fpf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off1);
				
				fpf(fp,"\n\tmovl\t%%edx, (%%rax)");
				
				break;
			case Q_RDEREF:
				
				fpf(fp,"\n\tmovq\t%d(%%rbp), %%rax",off1);
				
				fpf(fp,"\n\tmovl\t(%%rax), %%eax");
				
				fpf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
				
				break;
			case Q_RINDEX:
				// Get Address, subtract offset, get memory
				if(search(arg1x)&&search(arg1x)->isptrarr==true)
				{
					fpf(fp,"\n\tmovq\t%d(%%rbp), %%rdx",off1);
					
					fpf(fp,"\n\tmovslq\t%d(%%rbp), %%rax",off2);
					
					fpf(fp,"\n\taddq\t%%rax, %%rdx");
					
				}
				else
				{
					
					fpf(fp,"\n\tleaq\t%d(%%rbp), %%rdx",off1);
					
					fpf(fp,"\n\tmovslq\t%d(%%rbp), %%rax",off2);
					
					fpf(fp,"\n\taddq\t%%rax, %%rdx");
					
				}
				if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->next&&search(resx)->tp_n->next->basetp == tp_char)
				{
					
					fpf(fp,"\n\tmovzbl\t(%%rdx), %%eax");
					
					fpf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
					
				}
				else
				{
					
					fpf(fp,"\n\tmovl\t(%%rdx), %%eax");
					
					fpf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
					
				}
				break;
			case Q_LINDEX:
				if(search(resx)&&search(resx)->isptrarr==true)
				{
					
					fpf(fp,"\n\tmovq\t%d(%%rbp), %%rdx",offr);
					
					fpf(fp,"\n\tmovslq\t%d(%%rbp), %%rax",off1);
					
					fpf(fp,"\n\taddq\t%%rax, %%rdx");
					
				}
				else
				{
					
					fpf(fp,"\n\tleaq\t%d(%%rbp), %%rdx",offr);
					
					fpf(fp,"\n\tmovslq\t%d(%%rbp), %%rax",off1);
					
					fpf(fp,"\n\taddq\t%%rax, %%rdx");
					
				}
				if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->next && search(resx)->tp_n->next->basetp == tp_char)
				{
					
					fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off2);
					
					fpf(fp,"\n\tmovb\t%%al, (%%rdx)");
					
				}
				else
				{
					
					fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off2);
					
					fpf(fp,"\n\tmovl\t%%eax, (%%rdx)");
					
				}
				
				break;
			case Q_RETURN:
				//printf("return %s\n",resx.c_str());
				if(resx!="")
				{
					
					if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
					{
						fpf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",offr);
						
					}
					else
					{
						fpf(fp,"\n\tmovl\t%d(%%rbp), %%eax",offr);
						
					}
					
				}
				else
				{
					fpf(fp,"\n\tmovl\t$0, %%eax");
					
				}
				//printf("Happy\n");
				fpf(fp,"\n\tjmp\t.LRT%d",ret_count);
				
				break;
			default:
			break;
		}
	}
}

void symtab::function_epilogue(FILE *fp,int count,int ret_count)
{
	
	fpf(fp,"\n.LRT%d:",ret_count);
	
	fpf(fp,"\n\taddq\t$%d, %%rsp",offset);
	
	fpf(fp,"\n\tmovq\t%%rbp, %%rsp");
	
	fpf(fp,"\n\tpopq\t%%rbp");
	
	fpf(fp,"\n\tret");
	
	fpf(fp,"\n.LFE%d:",count);
	
	fpf(fp,"\n\t.size\t%s, .-%s",name.c_str(),name.c_str());
	
}
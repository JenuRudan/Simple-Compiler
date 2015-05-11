%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "Test2.h"

/* prototypes */
nodeType *opr(int oper, int nops, ...);
nodeType *id(int i);
nodeType *con(int value);
nodeType *conf(float value);
nodeType *conC(int value);
void freeNode(nodeType *p);
int ex(nodeType *p);
int yylex(void);
int AddVariable(int type,int name);
int Check_Compare_Error(int name,int value);
int Check_isFound_Error(int name);
int Get_Variable_Type_Error(int name);
int Last_Variable_Name=0;
int Error_FLAG=0;
void yyerror(char *s);
/////Sym is currently useless ....check variables array////////
int sym[50];                    /* symbol table */
int Variables_Type_Error[200];
int Variables_Name_Error[200];
////////
int FOR_Flag=0;
////////////////for the scopes////
void closeTheFlag();
void openTheFlag();
int scopeLevel[200];
int scopeCount[200];
int scopeLevelCount=0;
int scopeCountCount=0;
int variableCount=0;
int closeFlag=0;
int bracket_flag=0;
int Open_SCOPES_COUNT=0;
////////////////////////////
int Variables_Count_Error=0;
int Last_Type=0;
int symIndex = 0;
%}

%union {
    int iValue;                 /* integer value */
	float fValue;
	int cValue;
    int sIndex;                /* symbol table index */
    nodeType *nPtr;             /* node pointer */
};

%token <iValue> INT
%token <fValue> FLOAT
%token <sIndex> VARIABLE
%token <cValue> CHAR
%token TYPE_INT TYPE_FLOAT TYPE_CHAR CONST WHILE UNTIL REPEAT BREAK IF THEN ELSE ENDIF FOR SWITCH CASE INC ENDPROGRAM
%nonassoc IFX
%nonassoc ELSE

%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%type <nPtr> stmt expr stmt_list logicExpr case_stmt case_stmts loop_stmt1 loop_stmt2 bracket_stmt_list bracket_repeat_list

%%

program:
        function                { exit(0); }
        ;

function:
          function stmt         { ex($2); freeNode($2); }
        | /* NULL */
        ;
///add $$=NULL in variable=expr
stmt:
		  CONST TYPE_INT VARIABLE '=' expr ';'										{ if(AddVariable(11,$3)){sym[symIndex] = $3; symIndex++; $$ = opr('=', 2, id($3), $5); }}
		| CONST TYPE_FLOAT VARIABLE '=' expr ';'									{ if(AddVariable(12,$3)){sym[symIndex] = $3; symIndex++; $$ = opr('=', 2, id($3), $5); }}
		| CONST TYPE_CHAR VARIABLE '=' expr ';'										{ if(AddVariable(13,$3)){sym[symIndex] = $3; symIndex++; $$ = opr('=', 2, id($3), $5); }}
		| TYPE_INT VARIABLE '=' expr ';'											{ if(Error_FLAG==0){if((Get_Variable_Type_Error(Last_Variable_Name)==1 ||Get_Variable_Type_Error(Last_Variable_Name)==0||Get_Variable_Type_Error(Last_Variable_Name)==3)&& Last_Type!=2){if(AddVariable(1,$2)){sym[symIndex] = $2; symIndex++; $$ = opr('=', 2, id($2), $4); }else $$=NULL;}else{printf("Can't Equalize Integer with this value\n");$$=NULL;}}else {Error_FLAG=0; $$=NULL;}}
		| TYPE_FLOAT VARIABLE '=' expr ';'											{ if(AddVariable(2,$2)){ sym[symIndex] = $2; symIndex++; $$ = opr('=', 2, id($2), $4); }}
		| TYPE_CHAR VARIABLE '=' expr ';'											{ if(AddVariable(3,$2)){sym[symIndex] = $2; symIndex++; $$ = opr('=', 2, id($2), $4); }}
        | VARIABLE '=' expr ';'          											{ if(Error_FLAG==0){if(Last_Type!=2){if(Get_Variable_Type_Error($1)<10){ if(Error_FLAG==0){if(!Check_isFound_Error($1))printf("Variable not found !\n"); else $$ = opr('=', 2, id($1), $3);}else{Error_FLAG=0;$$=NULL;}}else{Error_FLAG=0; printf("Cann't Change Const Variable %d \n",Get_Variable_Type_Error($1));$$=NULL;}}else{Last_Type=0;$$=NULL;printf("Can't Equalize Integer with this value\n");}}else{$$=NULL;}}
		| WHILE '(' logicExpr ')' '{' bracket_stmt_list								{ closeFlag=1; openTheFlag(); $$ = opr(WHILE, 2, $3, $6); }
		| IF '(' logicExpr ')' THEN stmt_list ENDIF									{ $$ = opr(IF, 2, $3, $6); }
		| IF '(' logicExpr ')' THEN stmt_list ELSE stmt_list ENDIF					{ $$ = opr(IF, 3, $3, $6, $8); }
		| REPEAT '{' bracket_repeat_list											{ $$ = $3; }
		| SWITCH '(' VARIABLE ')' '{' case_stmts '}'								{ $$ = opr(SWITCH, 2, id($3), $6); }
		| FOR '(' loop_stmt1 ';' logicExpr ';' loop_stmt2 ')' '{' stmt_list '}'		{  $$ = opr(FOR, 4, $3, $5, $7, $10); }
        | '{'								           								{ openTheFlag(); closeFlag = 1; $$ = NULL;}
		| stmt_list																	{ $$ = $1; }
		| '}'																		{ $$ = NULL; if (closeFlag == 1) { closeFlag == 0; closeTheFlag();} else { printf("Bracket Error\n"); } }
		| ENDPROGRAM																{ $$ = NULL; if (closeFlag == 1) { printf("Error: Bracket(s) Missing"); } }
        ;
		
bracket_repeat_list:
		  '}' UNTIL '(' logicExpr ')'		{ $$ = $4; if (closeFlag == 1) { closeFlag == 0; closeTheFlag();} else { printf("Bracket Error\n"); } }
		| stmt								{ $$ = $1; }
		| stmt_list stmt        			{ $$ = opr(';', 2, $1, $2); }
		;
		
bracket_stmt_list:
		  stmt                  { $$ = $1; }
        | stmt_list stmt        { $$ = opr(';', 2, $1, $2); }
        ;
		
loop_stmt1:
		  /*TYPE_INT VARIABLE '=' expr	{ sym[symIndex] = $2; symIndex++; $$ = opr('=', 2, id($2), $4); }*/
			VARIABLE '=' expr	{ sym[symIndex] = $1; symIndex++; $$ = opr('=', 2, id($1), $3); }
		;
		
loop_stmt2:
		  VARIABLE '=' expr		{ $$ = opr('=', 2, id($1), $3); }
		| VARIABLE INC			{ $$ = opr(INC, 1, id($1)); }
		;

stmt_list:
          stmt                  { $$ = $1; }
        | stmt_list stmt        { $$ = opr(';', 2, $1, $2); }
        ;
		
case_stmt:
		  CASE INT ':' stmt_list BREAK ';'		{ $$ = opr(CASE, 2, $2, $4); }
		;
		
case_stmts:
		  case_stmt					{ $$ = $1; }
		| case_stmts case_stmt		{ $$ = opr(';', 2, $1, $2); }
		
logicExpr:
		  expr '<' expr         { $$ = opr('<', 2, $1, $3); }
        | expr '>' expr         { $$ = opr('>', 2, $1, $3); }
		| expr GE expr          { $$ = opr(GE, 2, $1, $3); }
        | expr LE expr          { $$ = opr(LE, 2, $1, $3); }
        | expr NE expr          { $$ = opr(NE, 2, $1, $3); }
        | expr EQ expr          { $$ = opr(EQ, 2, $1, $3); }
		| '(' logicExpr ')'		{ $$ = $2; }
		;

expr:
          INT               	{ Last_Type=1;$$ = con($1); Error_FLAG=0;}
		| FLOAT               	{ Last_Variable_Name=0; Last_Type=2;$$ = conf($1);Error_FLAG=0;} 
        | VARIABLE              { if(Check_isFound_Error($1) || FOR_Flag==1){ FOR_Flag=0; Last_Variable_Name=$1; $$ = id($1);Error_FLAG=0;}else{printf("Variable isn't declared before\n");$$=NULL;Last_Variable_Name=0;Error_FLAG=1;}} 
		| CHAR					{Last_Type=3; $$ = conC($1); }
        | '-' expr %prec UMINUS { $$ = opr(UMINUS, 1, $2); }
        | expr '+' expr         { $$ = opr('+', 2, $1, $3); }
        | expr '-' expr         { $$ = opr('-', 2, $1, $3); }
        | expr '*' expr         { $$ = opr('*', 2, $1, $3); }
        | expr '/' expr         { $$ = opr('/', 2, $1, $3); }
        | '(' expr ')'          { $$ = $2; }
        ;

%%

void openTheFlag()
{
	//printf("opened\n");
	closeFlag=1;
	scopeLevelCount++;
	scopeCountCount++;
	Open_SCOPES_COUNT++;
	printf("Scope level is now %d \n",scopeLevelCount);
}

void closeTheFlag()
{
	//printf("closed\n");
	//if(closeFlag==1)
	//{
	closeFlag=0;
	if(scopeLevelCount>1)
		scopeCountCount--;
	scopeLevelCount--;
	Open_SCOPES_COUNT--;
	//}
	//else
	//printf("syntax error\n");
}

int Get_Variable_Type_Error(int name){
	int i=0;
	for( i=0;i<Variables_Count_Error;i++)
	{
		if(Variables_Name_Error[i]==name)
		return Variables_Type_Error[i];
	}
	return 0;
};

int AddVariable(int type,int name){

if(Check_isFound_Error(name))
{printf("Syntax Error,Variable is Already Identified\n");
return 0;}
else
{Variables_Type_Error[Variables_Count_Error]=type;
Variables_Name_Error[Variables_Count_Error]=name;
scopeLevel[Variables_Count_Error]=scopeLevelCount;
//printf("added with SL %d\n",scopeLevel);
printf("added with SC %d\n",scopeLevelCount);
scopeCount[Variables_Count_Error]=scopeCountCount;
Variables_Count_Error++;
return 1;
}
};

int Check_Compare_Error(int name,int value){

};
int Check_isFound_Error(int name){
	int i=0;
	for( i=0;i<Variables_Count_Error;i++)
		{
			if(Variables_Name_Error[i]==name )
				if(scopeLevel[i]==0)
				{//printf("Scope is %d\n",scopeLevel[i]);
				return 1;
				}
				else if(scopeLevel[i]<scopeLevelCount && scopeCount[i]>=scopeCountCount-Open_SCOPES_COUNT)
				return 1;
				else
				return 0;
		}
	return 0;
};
nodeType *conC(int value) {
    nodeType *p;

    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");

    /* copy information */
	p->con.floatflag = 0;
	p->con.charflag = 1;
    p->type = typeCon;
	p->con.c_value = value;
    return p;
}

nodeType *conf(float value) {
    nodeType *p;

    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");

    /* copy information */
	p->con.floatflag = 1;
	p->con.charflag = 0;
    p->type = typeCon;
    p->con.ffvalue = value;
    return p;
}

nodeType *con(int value) {
    nodeType *p;

    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");

    /* copy information */
	p->con.floatflag = 0;
	p->con.charflag = 0;
    p->type = typeCon;
    p->con.value = value;

    return p;
}

nodeType *id(int i) {
    nodeType *p;

    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeId;
    p->id.i = i;

    return p;
}

nodeType *opr(int oper, int nops, ...) {
    va_list ap;
    nodeType *p;
    int i;

    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");
    if ((p->opr.op = malloc(nops * sizeof(nodeType *))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeOpr;
    p->opr.oper = oper;
    p->opr.nops = nops;
    va_start(ap, nops);
    for (i = 0; i < nops; i++)
        p->opr.op[i] = va_arg(ap, nodeType*);
    va_end(ap);
    return p;
}

void freeNode(nodeType *p) {
    int i;

    if (!p) return;
    if (p->type == typeOpr) {
        for (i = 0; i < p->opr.nops; i++)
            freeNode(p->opr.op[i]);
		free (p->opr.op);
    }
    free (p);
}

void yyerror(char *s) {
    fprintf(stdout, "%s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}

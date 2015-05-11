#include <stdio.h>
#include <string.h>
#include "Test2.h"
#include "y.tab.h"

static int lbl;
static char s_switch;
static int scopes_types[100];
static char scopes_variables[100][14];
static int scopes_no[100];
int ex(nodeType *p) {
    int lbl1, lbl2;

    if (!p) return 0;
    switch(p->type) {
    case typeCon: 
		if (p->con.floatflag)
		printf("\tpush\t%f\n", p->con.ffvalue);
		else if (p->con.charflag)
		printf("\tpush\t'%c'\n", p->con.c_value + 'a');
		else
        printf("\tpush\t%d\n", p->con.value); 
        break;
    case typeId:        
        printf("\tpush\t%c\n", p->id.i + 'a'); 
        break;
    case typeOpr:
        switch(p->opr.oper) {
        case WHILE:
			printf("L%03d:\n", lbl1 = lbl++);
			ex(p->opr.op[1]);
			ex(p->opr.op[0]);
			printf("\tjmpTrue\tL%03d\n", lbl1);
            break;
        case IF:
            ex(p->opr.op[0]);
            if (p->opr.nops > 2) {
                /* if else */
				printf("\tjmpFalse\tL%03d\n", lbl2 = lbl++);
				ex(p->opr.op[1]);
				printf("\tjmp\tL%03d\n", lbl1 = lbl++);
				printf("L%03d:\n", lbl2);
				ex(p->opr.op[2]);
				printf("L%03d:\n", lbl1);
            } else {
                /* if */
				printf("\tjmpFalse\tL%03d\n", lbl2 = lbl++);
				ex(p->opr.op[1]);
				printf("L%03d:\n", lbl2);
            }
            break;
		case REPEAT:
			printf("L%03d:\n", lbl1 = lbl++);
			ex(p->opr.op[0]);
			ex(p->opr.op[1]);
			printf("\tjmpFalse\tL%03d\n", lbl1);
			break;
		case SWITCH:
			s_switch = p->opr.op[0]->id.i + 'a';
			ex(p->opr.op[1]);
			break;
		case CASE:
			printf("\tpush\t%c\n", s_switch);
			printf("\tpush\t%d\n", p->opr.op[0]);
			printf("\tcompEQ\n");
			printf("\tjmpFalse\tL%03d\n", lbl1 = lbl++);
			ex(p->opr.op[1]);
			printf("L%03d:\n", lbl1);
			break;
		case FOR:
			ex(p->opr.op[0]);
			printf("L%03d:\n", lbl1 = lbl++);
			ex(p->opr.op[1]);
			printf("\tjmpFalse\tL%03d\n", lbl2 = lbl++);
			ex(p->opr.op[3]);
			ex(p->opr.op[2]);
			printf("\tjmp\tL%03d\n", lbl1);
			printf("L%03d:\n", lbl2);
			break;
		case INC:
			ex(p->opr.op[0]);
			printf("\tpush\t1\n");
			printf("\tadd\n");
			printf("\tpop\t%c\n", p->opr.op[0]->id.i + 'a');
			break;
        case '=':       
            ex(p->opr.op[1]);
            printf("\tpop\t%c\n", p->opr.op[0]->id.i + 'a');
            break;
        case UMINUS:    
            ex(p->opr.op[0]);
            printf("\tneg\n");
            break;
        default:
            ex(p->opr.op[0]);
            ex(p->opr.op[1]);
            switch(p->opr.oper) {
            case '+':   printf("\tadd\n"); break;
            case '-':   printf("\tsub\n"); break; 
            case '*':   printf("\tmul\n"); break;
            case '/':   printf("\tdiv\n"); break;
            case '<':   printf("\tcompLT\n"); break;
            case '>':   printf("\tcompGT\n"); break;
            case GE:    printf("\tcompGE\n"); break;
            case LE:    printf("\tcompLE\n"); break;
            case NE:    printf("\tcompNE\n"); break;
            case EQ:    printf("\tcompEQ\n"); break;
            }
        }
    }
    return 0;
}
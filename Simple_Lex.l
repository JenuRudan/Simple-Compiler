%{
#include <stdlib.h>
#include <string.h>
#include "Test2.h"
#include "y.tab.h"
void yyerror(char *);
%}

%%

"endprogram"	return ENDPROGRAM;

"while"		return WHILE;
"until"		return UNTIL;
"repeat"	return REPEAT;
"break"		return BREAK;
"if"		return IF;
"then"		return THEN;
"else"		return ELSE;
"endif"		return ENDIF;
"for"		return FOR;
"switch"	return SWITCH;
"case"		return CASE;
"int"		return TYPE_INT;
"float"		return TYPE_FLOAT;
"char"		return TYPE_CHAR;
"const"		return CONST;

[a-zA-Z][a-zA-Z0-9]*	{ 
							yylval.sIndex = *yytext - 'a';
							/* yylval.sIndex = (char *) strdup(yytext); */
							return VARIABLE;
						}
						
[0-9]+[.][0-9]+	{
					yylval.fValue = atof(yytext);
					return FLOAT;
				}

[0-9]+	{
			yylval.iValue = atoi(yytext);
			return INT;
		}
		
\'[a-zA-Z0-9]\'	{
					yylval.cValue = yytext[1] - 'a';
					return CHAR;
				}

[-()<>=+*/;{}.:]	{
					return *yytext;
				}

"++"			return INC;

">="            return GE;
"<="            return LE;
"=="            return EQ;
"!="            return NE;
\n				;		/* ignore end of line */
[ \t]+        	;       /* ignore whitespace */

%%
int yywrap(void) {
    return 1;
}

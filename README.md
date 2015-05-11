# Simple-Compiler
Simple Lex and Yac files for Compiler

#How to use
flex Simple_Lex.l
bison -y Simple_Yacc.y
gcc -c y.tab.c lex.yy.c
gcc y.tab.o lex.yy.o Code.c -o Compiler.exe

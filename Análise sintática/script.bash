echo "Iniciando o BISON"
bison -d knot.y
echo "Iniciando FLEX"
flex knot.l
echo "Compilando arquivos"
gcc -c lex.yy.c -o knot.flex.o
gcc -c knot.tab.c -o knot.y.o
gcc -o knot knot.flex.o knot.y.o -lfl -lm
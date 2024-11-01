%{
  int linhas = 1, erros = 0;
%}

NUMBER      [0-9]
ID          [A-Za-z_][A-Za-z0-9_]*
ESPACO      [\t\r" "]+
STRING      \"([^\\"]|\\.)*\"
OP_REL      "=="|"!="|"<"|">"|"<="|">="
OP_ARIT     "+"|"-"|"*"|"/"
OP_LOG      "&&"|"||"|"!"
ATRIBUICAO  "="
DELIMITADOR_COMENTARIO  "//"
DELIMITADOR [(){}[],;]
KEY_WORD    "if"|"else"|"while"|"for"|"int"|"float"|"bool"|"string"

%%

#Caractéres_válidos 

{ESPACO}* {
  printf("Espaço: %s\n", yytext);
}

\n { linhas++; }

{KEY_WORD} {
  printf("PLAVRA RESERVADA: %s\n", yytext);
}

{DELIMITADOR} {
  printf("DELIMITADOR: %s\n", yytext);
}

{DELIMITADOR_COMENTARIO}[^\n]* {
  printf("COMENTÁRIO\n");
}

{ID} {
  printf("IDENTIFICADOR: %s\n", yytext);
}

{ID}{NUMBER}*{ID}* { 
  printf("IDENTIFICADOR: %s\n", yytext); 
}

{NUMBER}+ { 
  printf("INTEIRO: %s\n", yytext); 
}

{NUMBER}+"."{NUMBER}+ { 
  printf("REAL: %s\n", yytext); 
}

"-"|"+"{NUMBER}+"."{NUMBER}+ { printf("REAL COM SINAL: %s\n", yytext); }

"-"|"+"{NUMBER}+ {
  printf("INTEIRO COM SINAL: %s - ", yytext);
}

{STRING} { printf("STRING: %s\n", yytext); }

{OP_REL} { printf("OPERADOR RELACIONAL: %s\n", yytext); }

{OP_ARIT} { printf("OPERADOR ARITMÈTICO: %s\n", yytext); }

{OP_LOG} { printf("OPERADOR LÓGICO: %s\n", yytext); }

{ATRIBUICAO} { printf("OPERADOR DE ATRIBUIÇÃO: %s\n", yytext); }

#Erros

{NUMBER}+","{NUMBER}+ {
  printf("Número não suportado: %s (Utilize . como separador) - ", yytext);
  erros++;
  printf("Linha: %d\n", linhas);
}

{NUMBER}+"."{NUMBER}*{ID}+ {
  printf("Número mal formatado: %s - ", yytext);
  erros++;
  printf("Linha: %d\n", linhas);
}

{NUMBER}+{ID}  {
  printf("Identificador inválido: %s - ", yytext);
  erros++;
  printf("Linha: %d\n", linhas);
}

. {
  printf("Token inválido: %s - ", yytext);
  erros++;
  printf("Linha: %d\n", linhas);
}

%%

int yywrap();

int main() {
  yylex();
  printf("Total de erros encontrados: %d\n", erros);
  if (erros == 0)
    puts("\nCódigo analisado com sucesso!\n");
}

int yywrap() { return 1; }



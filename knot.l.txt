%{
  #include "knot.tab.h" 
  extern void yyerror(const char *, int linhas);

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
ABRE_PARENTESES "("       
FECHA_PARENTESES  ")"       
ABRE_CHAVE  "{"       
FECHA_CHAVE  "}"       
ABRE_COLCHETES  "["       
FECHA_COLCHETES  "]"       
VIRGULA  ","       
PONTO_E_VIRGULA  ";"       
FLOAT  "float"		
INT  "int"     
BOOL  "boolean" 
STRING_TIPO  "string"  
SE  "if"      
SENAO  "else"    
WHILE  "while"   
MAIN  "main"    
PRINTF  "printf"  
NOT  "!"       
VERDADEIRO  "true"    
FALSO  "false"   
FOR   "for"

%%

"("                     { return (ABRE_PARENTESES); } 
")"                     { return (FECHA_PARENTESES); }
"{"                     { return (ABRE_CHAVE); }
"}"                     { return (FECHA_CHAVE); }
"["                     { return (ABRE_COLCHETES); }
"]"                     { return (FECHA_COLCHETES); }
","                     { return (VIRGULA); }
";"                     { return (PONTO_E_VIRGULA); }
"float"			            { return (FLOAT); } 
"int"                   { return (INT); }
"boolean"               { return (BOOL); }
"string"                { return (STRING_TIPO); }
"if"                    { return (SE); }
"else"                  { return (SENAO); }
"while"                 { return (WHILE); }
"for"                   { return (FOR); }
"main"                  { return (MAIN); } 
"printf"                { return (PRINTF); }
"!"                     { return (NOT); } 
"true"                  { return (VERDADEIRO); } 
"false"                 { return (FALSO); }
{ATRIBUICAO}	          { return (IGUAL); }  
{ID}                    { return (IDENTIFICADOR); }
{NUMBER}+               { return (INTEIRO); }
{NUMBER}+"."{NUMBER}+   { return (REAL); }
{STRING}                { return (STRING); }
{OP_REL}                { return (OP_RELACIONAL); }
{OP_ARIT}               { return (OP_ARIT); }
{OP_LOG}                { return (OP_LOGICO); }

{ESPACO}                { /* VAZIO */ }
\n                      { linhas++; }

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

int yywrap() {
	return 1;
}
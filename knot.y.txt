%{
  #include <stdio.h>
  #include <stdlib.h>
  extern int linhas;
  extern int erros;
  extern FILE *yyin;
  int yylex();

  int yyerror(const char *str) {
    erros++;
    printf("%s ", str);
    printf("\nO erro aparece próximo à linha %d\n", linhas);
    return erros;
  }
%}

%token MAIN ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVE FECHA_CHAVE ABRE_COLCHETES FECHA_COLCHETES PONTO_E_VIRGULA VIRGULA
%token IDENTIFICADOR INT FLOAT BOOL STRING_TIPO INTEIRO REAL STRING VERDADEIRO FALSO IGUAL
%token SE SENAO WHILE FOR NOT PRINTF
%token OP_ARIT OP_LOGICO OP_RELACIONAL

%left OP_LOGICO
%left OP_RELACIONAL
%left OP_ARIT
%right NOT

%%

Programa_principal: 
  MAIN ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVE Comandos FECHA_CHAVE 
  | error { yyerror("Erro sintático: função main mal estruturada"); };

Comandos: 
  Comando Comandos 
  | Comando 
  ;

Comando: 
  Declaracao 
  | Atribuicao 
  | Condicional 
  | Whileloop 
  | Forloop 
  | Print 
  | error { yyerror("Erro sintático: Comando não existente"); };

Declaracao: 
  Tipo Lista_var PONTO_E_VIRGULA 
  ;

Tipo: 
  INT 
  | FLOAT 
  | STRING_TIPO 
  | BOOL 
  ;

Lista_var: 
  IDENTIFICADOR 
  | IDENTIFICADOR VIRGULA Lista_var 
  | IDENTIFICADOR ABRE_COLCHETES INTEIRO FECHA_COLCHETES 
  ;

Atribuicao: 
  IDENTIFICADOR IGUAL Expressao PONTO_E_VIRGULA 
  ;

Expressao: 
  Valor 
  | IDENTIFICADOR 
  | Expressao OP_ARIT Expressao 
  | ABRE_PARENTESES Expressao FECHA_PARENTESES 
  ;

Valor: 
  INTEIRO 
  | REAL 
  | VERDADEIRO 
  | FALSO 
  | STRING 
  | error { yyerror("Erro sintático: Atribuição mal formatada"); };

Print: 
  PRINTF ABRE_PARENTESES STRING FECHA_PARENTESES PONTO_E_VIRGULA 
  ;

Condicional: 
  SE ABRE_PARENTESES Exp_logica FECHA_PARENTESES ABRE_CHAVE Comandos FECHA_CHAVE 
  | SE ABRE_PARENTESES Exp_logica FECHA_PARENTESES ABRE_CHAVE Comandos FECHA_CHAVE SENAO ABRE_CHAVE Comandos FECHA_CHAVE 
  ;

Exp_logica: 
  Exp_logica OP_LOGICO Exp_logica 
  | Exp_relacional
  | NOT Exp_logica 
  | ABRE_PARENTESES Exp_logica FECHA_PARENTESES 
  | VERDADEIRO 
  | FALSO 
  | IDENTIFICADOR 
  ;

Exp_relacional: 
  Exp_aritmetica OP_RELACIONAL Exp_aritmetica 
  | IDENTIFICADOR OP_RELACIONAL Exp_aritmetica 
  | Exp_aritmetica OP_RELACIONAL IDENTIFICADOR
  | IDENTIFICADOR OP_RELACIONAL IDENTIFICADOR
  ;

Exp_aritmetica: 
  Exp_aritmetica OP_ARIT Exp_aritmetica 
  | Num  
  | ABRE_PARENTESES Exp_aritmetica FECHA_PARENTESES 
  ;

Num: 
  INTEIRO 
  | REAL 
  ;

Whileloop:
  WHILE ABRE_PARENTESES Exp_logica FECHA_PARENTESES ABRE_CHAVE Comandos FECHA_CHAVE 
  ;

Forloop: 
  FOR ABRE_PARENTESES Atribuicao Exp_logica PONTO_E_VIRGULA Atribuicao FECHA_PARENTESES ABRE_CHAVE Comandos FECHA_CHAVE 
  ;

%%

int main (int argc, char **argv) {
  int result;
  if(argc > 1) {
    yyin = fopen(argv[1], "r");
  } else {
    puts("Falha ao abrir arquivo, nome incorreto ou não especificado. Digite o comando novamente.");
    exit(1);
  }

  printf("Iniciando análise sintática...\n");
  do {
    result = yyparse();
  } while (!feof(yyin));

   if(result == 0 && erros == 0) {
        printf("Análise sintática concluída com sucesso!\n");
    } else {
        printf("Análise sintática concluída com %d erros.\n", erros);
    }

  if(erros == 0) {
    puts("Análise concluída com sucesso!");
  }
}

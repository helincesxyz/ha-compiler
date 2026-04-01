
/* C declarations */
%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);

%}

/* Token Declarations */

%token tDEVICE tRULE tWHEN tTHEN tTIME tIN
%token tAND tOR tNOT
%token tSENSOR tLIGHT tSWITCH
%token tACCENT tAMBIENT tTASK
%token tON tOFF
%token tLBRACE tRBRACE tLPAREN tRPAREN
%token tCOLON tSEMI tEQ tDOTDOT
%token tGT tLT tGE tLE tEQEQ tNE
%token tID tSTRING tINT tTIMEVALUE

/* priority rules */
%left tOR
%left tAND
%right tNOT

%% 

/*Grammar Rules */

/* program is a list of declarations, possibly empty */
program: declaration_list ;

declaration_list : declaration_list declaration
                 | /* empty */
                 ;

/* declaration: device or rule */
declaration : device_decl
            | rule_decl
            ;

/* device declaration : device id colon type semi-- types: sensor, light, switch */

device_decl : tDEVICE tID tCOLON device_type tSEMI
            ;

device_type : tSENSOR
            | tLIGHT
            | tSWITCH
            ;

/* rule declaration: "rule", rule name , {when xx; then yy;} */

rule_decl : tRULE tSTRING tLBRACE when_clause then_clause tRBRACE
          ;

/* when_clause = when bool semi  */

when_clause : tWHEN bool_expr tSEMI 
            ;        
 
/* then clause: then action_list */

then_clause : tTHEN action_list
            ; 

/* action_list : one or more actions, cannot be empty */

action_list : action_list action
            | action 
            ;

/* action: id equality switch/light semi (switch:O/F) (light: acc-ambi-ta) */

action : tID tEQ state tSEMI 
       ;

state : switch_state 
      | light_state
      ;

switch_state : tON
             | tOFF
             ;

light_state : tACCENT 
            | tAMBIENT
            | tTASK
            ;

/* boolean expr: priority(most to least) = () > not > and > or */

/* least prior written first */

bool_expr : bool_expr tOR bool_term
          | bool_term 
          ;


bool_term : bool_term tAND bool_factor 
          | bool_factor 
          ;

bool_factor : tNOT bool_factor 
            | tLPAREN bool_expr tRPAREN
            | predicate 
            ;

/* predicates */


/* compare: id relational-op int */
/* time range: time in value .. value */
/* time point: time in value */
/* state comparison: id eqeq-or-noteq light_state-or-switch_state */
 
predicate : tID relop tINT 
          | tTIME tIN tTIMEVALUE tDOTDOT tTIMEVALUE 
          | tTIME tIN tTIMEVALUE 
          | tID tEQEQ state
          | tID tNE state
          ;



relop : tGT 
      | tLT 
      | tGE 
      | tLE 
      | tEQEQ
      | tNE 
      ; 


%% 

/* print only OK or ERROR */

void yyerror(const char *s) { }

int main (){
 if (yyparse()){
	printf("ERROR\n");
        return 1;
 } else{
        printf("OK\n");
        return 0;
 }
}





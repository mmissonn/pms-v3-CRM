
PROCEDURE pmsv3
* pmsv3.PRG
*SET COMPATIBLE DB4 ON
!CD C:\PMSV3
clear all
close all
SET PROCEDURE TO BIBLIO
DO ENVIRON

@0,0 say "같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같"       
save screen to fond
@12,30 say "Patientez S-V-P ..." COLOR W+/BG
on key label ctrl-q do echaper
declare element[110,5]
t1 = 0
t2 = 0
t3 = 0
rep =' '
nom_proced = ""
Menu = ""
Menu_vert = ""
opt_quitter = "W+/BG"
opt_Erreur  = "W+/R"
opt_menu    = "GR+/B"
opt_attent  = "W+/G"
Ind = 0  
Do Relier

Define MENU Main
  Op1 = " Gestion des ventes      "
  Op2 = " Gestion des achats      "
  Op3 = " Gestion de l'inventaire "
  Op4 = " Purge                   "
  Op5 = " Quitter                 "
  row_ = 7
  Cl = 27

*  Define PAD PAD0  OF main prompt "컴컴 MENU PRINCIPALE 컴컴"   AT ROW_, CL   &&MESSAGE ;
 
*  Define PAD PAD0  OF main prompt " "   AT ROW_, CL   &&MESSAGE ;

  Define PAD PAD1  OF main prompt op1 AT ROW_, CL MESSAGE ;
"                               Gestion des ventes                             "

  define PAD PAD2  OF main prompt op2 AT ROW_+1, CL MESSAGE ;
"                               Gestion des achats                             "

  Define PAD PAD3 OF main prompt op3 AT ROW_+2, CL MESSAGE ;
"                             Gestion de l'inventaire                          "

  Define PAD PAD4 OF main prompt op4  AT ROW_+3, CL MESSAGE ;
"                              Purge la facturation                            "

  Define PAD PAD5 OF main prompt op5 AT ROW_+4, CL MESSAGE ;
"                                 Retour au DOS                                "

  on selection PAD PAD1 OF main do gest_ven
  on selection PAD PAD2 OF main do gest_ach
  on selection PAD PAD3 OF main do gest_sto
  on selection PAD PAD4 OF main do purge_proc
  on selection PAD PAD5 OF main exit
M = ""
do while .t.
  restore screen from fond
  @row_,cl+1 fill to row_+6,cl+27 color W/N
  @row_-1,cl-1 to row_+5,cl+25 color W+/BG
  Activate MENU main
  if pad() = "PAD5" .or. M = "PAD5"
    do sortir_
    exit
  endif
enddo
return


PROCEDURE Purge_proc
 MENU ="PAD4"
 do purge
return


PROCEDURE sortir_
    restore screen from fond
    do fenetre with 8,25,13,57,"MISE A JOUR", opt_quitter
    @10,27  say " Restructuration des fichiers" COLOR W+/BG
    @11,27 say " Veuillez patienter..." COLOR W+/BG

    select a
    pack
    select b
    pack
    select c
    pack
    select d
    pack
    select e
    pack
    select f
    pack
    select g
    pack
    select h
    pack
    select i
    pack

 set status on
 release all
 close all
 quit
return

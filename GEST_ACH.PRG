PROCEDURE gest_ach
on key label ctrl-q do echaper
out =.F.            
rep =' '
nom_proced = ""
Menu = ""
Menu_vert = ""
nom_menu = "GEST_ACHAT"
Ind = 0  

Define MENU gest_achat
  Opt1 = "Compte fournisseur"
  Opt2 = "Facturation"
  Opt3 = "Edition journal"
  Opt4 = "Quitter"
  Room = 6  
  Row = 0

  Define pad pad1 OF Gest_achat prompt opt1 at row, 0 MESSAGE ;
"                  Gestion des comptes fournisseurs / Mailing                  "

  define pad pad2 OF Gest_achat prompt opt2 at row, Len(opt1)+Room MESSAGE ;
"                      Bon de commande / R‚ception marchandise                 "

  Define pad pad3 OF Gest_achat prompt opt3 at row, Len(opt1+opt2)+Room*2 MESSAGE ;
"                   Journal des achats / Journal des d‚penses                  "


  Define pad pad4 OF Gest_achat prompt opt4 at row, Len(opt1+opt2+opt3)+Room*3 MESSAGE ;
"                               Fin du traitement                              "
 
  on pad pad1 OF Gest_achat activate popup Compte
  on pad pad2 OF Gest_achat activate popup Fact
  on pad pad3 OF Gest_achat activate popup Jour
  on selection pad pad4 OF Gest_achat deactivate menu

  Define popup Compte From row+1,0

  Define BAR 1 OF Compte Prompt "Etiquetage" 
  Define BAR 2 OF Compte Prompt "Modifier"
  Define BAR 3 OF Compte Prompt "Visualisation" 
  Define BAR 4 OF Compte Prompt "D‚biter"
  Define BAR 5 OF Compte Prompt "Relev‚ de compte"
  Define BAR 6 OF Compte Prompt "Comptes cr‚diteurs"

  on selection popup Compte Do Compte_proc

  Define popup Fact From row+1,Len(opt1)+room
  Define BAR 1 OF Fact Prompt "Commande" 
  Define BAR 2 OF Fact Prompt "Facture" 
  Define BAR 3 OF Fact Prompt "Note de cr‚dit" 
  Define BAR 4 OF Fact Prompt "Annulation"
  Define BAR 5 OF Fact Prompt "Visualisation" 
  Define BAR 6 OF Fact Prompt "Impression"
  Define BAR 7 OF Fact Prompt "Achat/D‚pense"
  on selection popup Fact Do Fact_proc

  Define popup Jour From row+1,Len(opt1+opt2)+room*2
  Define BAR 1 OF Jour Prompt "Quotidien"
  Define BAR 2 OF Jour Prompt "Hebdomadaire"
  Define BAR 3 OF Jour Prompt "Mensuel"
  Define BAR 4 OF Jour Prompt "Par la date"
  on selection popup Jour Do jour_proc

save screen to menu_
do while .t.
  menu = ""
  restore screen from fond
  on key label ctrl-i
  Activate MENU Gest_achat
  if pad() = "PAD4" .or. menu = ""
    restore screen from menu_
    release screen menu_
    exit
  endif
enddo
return


PROCEDURE Jour_proc
  save screen to Ecran_menu
  menu = "PAD3"
  menu_vert = bar()
  do case
    case bar() = 1
      Do quotidie
    case bar() = 2
      Do hebdomad
    case bar() = 3
      Do mensuel
      @6,25 fill to 19,35 color W+/B
    case bar() = 4
      Do jour_dat
  endcase
  menu= ""
return

PROCEDURE Compte_proc
  save screen to Ecran_menu
  MENU = "PAD1"
  do case
    case bar() = 1
      Ordre = 'E'
      do visual
      restore screen from ecran_menu
    case bar() = 2
      do Modif_cl
    case bar() = 3
      Ordre = 'V'
      do visual
      @8,32 fill to 12,49 color W+/B
    case bar() = 4
      do Init_cre
    case bar() = 5
      do releve
    case bar() = 6
      Ordre = 'I'
      do debiteur
   endcase   
   menu = ""
return


PROCEDURE Fact_proc
  save screen to Ecran_menu
  MENU = "PAD2"
  do case
    case bar() = 1
      do proforma
    case bar() = 2
      do facture
    case bar() = 3
      Ordre = 'V'
      do Avoir
    case bar() = 4
       do annu_fac
    case bar() = 5
      do visu_fac
    case bar() = 6
      do impr_fac
    case bar() = 7
      do crea_dep
  endcase
  menu = ""
return


PROCEDURE visual
  nom_inf = chr(0)
  nom_sup = chr(255)
  do Menu_Choix
return

PROCEDURE Menu_Choix
  save screen to ecran_menu
  DEFINE POPUP pop_client FROM 7,30
  DEFINE BAR 1 OF pop_client PROMPT "Tous les fournisseurs"
  DEFINE BAR 2 OF pop_client PROMPT "Intervalle"
  DEFINE BAR 3 OF pop_client PROMPT "Retour au menu"
  ON SELECTION POPUP pop_client Do Choix_cl
  @8,32 fill to 12,49 color W/N
  activate popup pop_client
  @8,32 fill to 12,49 color W+/B
return


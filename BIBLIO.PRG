*** MODIF le 30-06-93 POUR TAXE ONTARIO
*** MODIF le 07-08-94 POUR PURGE
PROCEDURE BIBLIO
  
PROCEDURE ATTRIB_FACT
  goto bottom
  if eof()
    nofact =6472
     
  else
    NoFact = No_fact + 1
  endif
RETURN


PROCEDURE Relier
**--- Zone commune pour les nomenclatures
  select H
  use nomencla alias znomen
  set order to code_nomen

**--- Zones pour la gestion des ventes
  select A
  use client alias zclient
  set order to ind_compt
  select B
  use facture alias zfact
  set relation to code_clien into zclient
  *** set order to ind_fact
  set order to ind_date
  select C
  use detail_v alias zdet_v
  set order to ind_fact
  set relation to no_fact into zfact
  
**--- Zone commune qui contient l'‚tat du stock
  select D
  use article alias zart
  set order to code_art
  select C
  set relation to code_art into zart
  select H
  set relation to code_nomen into zart

**--- Zones pour la gestion des achats
  select E
  use fnisseur alias zfour
  set order to ind_four
  select F
  use achat alias zach
  set relation to code_four into zfour
  set order to ind_ach
  select G
  use detail_a alias zdet_a
  set order to ind_fact
  set relation to code_art into zart
  set relation to no_fact into zach 
  select D
  set relation to no_compte into zfour
  select I
  use depense alias zdep
  set order to date
return


PROCEDURE Effacer_message
 @24,10 CLEAR to 24,col()
 @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
return

PROCEDURE DEPLACE
 @8,0 say "<Ctrl-Q>-Quitter" COLOR gr+/B
 @8,62 say "<Ctrl-End>-Sauver" color gr+/b
 @8,32 say "PgUp "+ chr(24)+"  PgDn "+chr(25) COLOR GR+/B
RETURN

PROCEDURE sortie_option
  rep = ' '
  @24,20 say "Fin du traitement ? (O/N) " get rep picture "Y";
  COLOR N/BG 
  read 
  @24,20 clear to 24,col() 
return 

PROCEDURE Valider
  rep =' '
  @24,20 say "VALIDER LES DONNEES ? (O/N) " get Rep PICTURE "Y";
  COLOR N/BG 
  read
  @24,20 clear to 24,79 
return 

PROCEDURE ECHAPER     
  val = menu()
  on key label ctrl-q 
*  on key label F2
  C = col()
  L = row()
  define MENU Echap
  define pad pad1 of echap prompt "Oui" at 12,32
  define pad pad2 of echap prompt "Non" at 12,42
  on selection pad pad1 of echap do sortie
  on selection pad pad2 of echap do rester
  out = .F.
    release screen ecran
    save screen to ecran
    if nom_proced = "description"
      activate screen
    endif
    do fenetre with 7,25,14,51,"QUITTER", opt_quitter
    @9,27 say "  Confirmer l'abandon   " COLOR N/BG
    @10,27 say "  de l'op‚ration ?" COLOR N/BG
    activate menu echap
    on key label ctrl-q do echaper
    if out
      release element
      if val = "MAIN" .and. MENU <> "PAD4"
         M = "PAD5"
         deactivate menu 
      endif
      on key label ctrl-i
      do environ
      SET FILTER TO
      on readerror
      on error
      deactivate  window all
      if menu= ""
        restore screen from menu_
        deactivate menu 
      endif
      restore screen from ecran_menu
      do case
        case menu = "PAD1"
          return to compte_proc
        case menu = "PAD2"
          return to fact_proc
        case menu = "PAD3"
          return to jour_proc
        case menu = "PAD4"
          return to purge_proc
        case menu = "PAD1S"
          return to article_proc
        case menu = "PAD2S"
          return to etat_proc
        case menu = "PAD3S"
          return to mvt_proc
       endcase  
    else
      if nom_proced = "description"
        activate window descrip
      endif
        restore screen from ecran
        @L,C say ""
    endif
return

PROCEDURE Sortie
  out = .T.
  deactivate MENU
  release MENU echap
return

PROCEDURE rester
  deactivate MENU
return

  ***** MODIF LE 26/06/93 POUR TVO ONTARIO
PROCEDURE afficher_montant
  pos = 1
  @24,0 say "<Ctrl-End>-Sauver"

  do while pos <= indice_max
    if option= "Note de cr‚dit"
      element[pos,3] = -element[pos,3]      
    endif


    if element[pos,5] = "O"
      serv = serv + element[pos,3] * element[pos,4]
    else
      prod = prod + element[pos,3] * element[pos,4]
    endif

    pos = pos + 1
  enddo         

  tot_ht = prod + serv

  deduc  = tot_ht * reduc /100
  deduc1 = prod * reduc / 100
  deduc2 = serv * reduc / 100

  taxe1 = (tot_ht - deduc) * t1
  tps1 = (prod - deduc1) * t1
  tps2 = (serv - deduc2) * t1

  if prod = 0
    taxe2 = (serv-deduc2 + tps2) * t3
  else 
    if serv = 0
      taxe2 = (prod-deduc1 + tps1) * t2   
    else
      taxe2 = (prod-deduc1 + tps1) * t2 + (serv-deduc2 + tps2) * t3
    endif
  endif    
  
  ***** MODIF LE 26/06/93 POUR TVO ONTARIO
  if t3 = 1000
    taxe2 = (tot_ht - deduc ) * t2
  endif

  DO FENETRE WITH 8,24,21,57,"TOTAL", opt_QUITTER
  @10,28 say "Total ht    : " COLOR W+/BG
  @10,COL() SAY tot_ht PICTURE "99,999,999.99" COLOR W+/BG
  @11,28 say "% r‚duction : "  COLOR W+/BG
  @12,28 say "D‚duction   : " COLOR W+/BG
  @13,28 say "              --------------" color W+/bg
  @14,28 say "Total ht    : " COLOR W+/BG
  @16,28 say "TPS 7%      : " COLOR W+/BG
  @17,28 say "TVQ/TVO     : " COLOR W+/BG
  @18,28 say "Total ttc   : " COLOR W+/BG
  do while .t.
    set cursor off
    @12,41 say -deduc PICTURE "999,999,999.99" COLOR W+/BG
    @14,42 SAY tot_ht - deduc  PICTURE "99,999,999.99" COLOR W+/BG
    @18,42 SAY (tot_ht-deduc+taxe1+taxe2)  PICTURE "99,999,999.99" COLOR W+/BG
    @16,42 say taxe1 PICTURE "99,999,999.99" COLOR W+/BG
    @17,42 say taxe2 PICTURE "99,999,999.99" COLOR W+/BG
    @11,48 get reduc picture "999.99%" message "Entrer le pourcentage de r‚duction"  range 0,100 
    set cursor on
    read
    deduc = tot_ht * reduc /100
    deduc1 = prod * reduc / 100
    deduc2 = serv * reduc / 100

    taxe1 = (tot_ht - deduc) * t1
    tps1 = (prod - deduc1) * t1
    tps2 = (serv - deduc2) * t1
    if prod = 0
      taxe2 = (serv-deduc2 + tps2) *t3
    else 
      if serv = 0
        taxe2 = (prod-deduc1 + tps1) * t2   
      else
        taxe2 = (prod-deduc1 + tps1) * t2 + (serv-deduc2 + tps2) *t3
      endif
    endif    

  ***** MODIF LE 26/06/93 POUR TVO ONTARIO
  if t3 = 1000
    taxe2 = (tot_ht - deduc ) * t2
  endif

    if readkey() <> 270
      set cursor off
      @11,48 say reduc picture "999.99%"  COLOR W+/BG
      @14,42 SAY tot_ht - deduc PICTURE "99,999,999.99" COLOR W+/BG
      @18,42 SAY (tot_ht-deduc+taxe1+taxe2)  PICTURE "99,999,999.99" COLOR W+/BG
      @16,42 say taxe1 PICTURE "99,999,999.99" COLOR W+/BG
      @17,42 say taxe2 PICTURE "99,999,999.99" COLOR W+/BG
      @12,42 get deduc PICTURE "99,999,999.99" message "Entrer le montant de l'escompte" range 0,abs(tot_ht)
      set cursor on
      read
*      if deduc > 0 .and. option = "Note de cr‚dit"
*         deduc = -deduc 
*      endif
    endif

    reduc = (100 * deduc / tot_ht)
    deduc1 = prod * reduc / 100
    deduc2 = serv * reduc / 100
*    if option = "Note de cr‚dit"
*       deduc1 = -deduc1
*       deduc2 = -deduc2 
*    endif

    taxe1 = (tot_ht - deduc) * t1
    tps1 = (prod - deduc1) * t1
    tps2 = (serv - deduc2) * t1
    if prod = 0
      taxe2 = (serv-deduc2 + tps2) * t3
    else 
      if serv = 0
        taxe2 = (prod-deduc1 + tps1) * t2   
      else
        taxe2 = (prod-deduc1 + tps1) * t2 + (serv-deduc2 + tps2) * t3
      endif
    endif    

  ***** MODIF LE 26/06/93 POUR TVO ONTARIO
  if t3 = 1000
    taxe2 = (tot_ht - deduc ) * t2
  endif



    if readkey() = 270
      tot_ht = tot_ht - deduc
      @11,48 say reduc picture "999.99%"  COLOR W+/BG
      @12,41 say deduc PICTURE "999,999,999.99" COLOR W+/BG
      @14,42 SAY tot_ht  PICTURE "99,999,999.99" COLOR W+/BG
      @16,42 say taxe1 PICTURE "99,999,999.99" COLOR W+/BG
      @17,42 say taxe2 PICTURE "99,999,999.99" COLOR W+/BG
      @18,42 SAY (tot_ht+taxe1+taxe2)  PICTURE "99,999,999.99" COLOR W+/BG
      exit
    endif
 enddo 
return




PROCEDURE CADRE
clear
datefact ={  /  /  }
date_cmde ={  /  /  }
no_cmde  = space(5)
delai_paie= space(3)
terme_paie = space(28)
@0,0 to 7,41 
@0,44 to 7,79
@ 9,0 TO 23,79 
@ 9,9 TO 23,9 
@ 9,9 SAY "Â" 
@ 9,35 TO 23,35 
@ 9,35 SAY "Â" 
@ 9,41 TO 23,41 
@ 9,41 SAY "Â" 
@ 9,62 TO 23,62 
@ 9,62 SAY "Â" 
@ 10,2 SAY "Article" 
@ 10,11 SAY "D‚signation" 
@ 10,36 SAY "Qt‚e" 
@ 10,45 SAY "Prix unitaire" 
@ 10,67 SAY "Montant" 
@ 11,0 TO 11,79 
@ 11,0 SAY "Ã" 
@ 11,9 SAY "Å" 
@ 11,35 SAY "Å" 
@ 11,41 SAY "Å" 
@ 11,62 SAY "Å" 
@ 11,79 SAY "´" 
@ 23,9 SAY "Á" 
@ 23,35 SAY "Á" 
@ 23,41 SAY "Á" 
@ 23,62 SAY "Á" 
@1,1 say "NøFact "
@2,1 say "Date  "  
@3,11 say "  (jours)"
@3,1 say "D‚lai " 
@4,1 say "Terme "  
if nom_menu = "GEST_VEN"
  @5,1 say "Nøcmde" 
  @6,1 say "Date  "  
endif
@6,31 say "Page  1"  COLOR GR+/B
@1,45 say "NøCmpte"   
@2,45 say "Nom    " 
@3,45 say "Adresse"
@4,45 say "Ville  " 
@5,45 say "C.P    "
@6,45 say "T‚l.   "
@24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
return    


PROCEDURE MESSAGE
  @24,0 clear to 24,78
  @24,0 say  "<Ctrl-Q>-Quitter                                               <Ctrl-I>-Imprimer" COLOR GR+/B
return

PROCEDURE Erreur
  on key label ctrl-q 
  imprimer = .T.
  fin_imp = .F.
  C= col()
  L=row()
  define MENU Err_imp
  define pad pad1 of err_imp prompt "Abandon" at 12,32
  define pad pad2 of err_imp prompt "Reprise" at 12,45
  on selection pad pad1 of err_imp do Abandon
  on selection pad pad2 of err_imp do Reprise
  save screen to ecran 
  do while .not. printstatus() 
    DO MENU_COL
    do beep
    DO FENETRE WITH 8,22,13,58,"ERREUR", opt_erreur
    @10,24  say "     IMPRIMANTE NON PRETE !      " COLOR W+/r 
    activate menu Err_imp
    if fin_imp
       exit
    endif
  enddo
  do couleur
  release menu Err_imp
  restore screen from ecran
  @l,c say ""
  on key label ctrl-q do echaper
return 


PROCEDURE Reprise
  set cursor on
  deactivate menu
return 


PROCEDURE Abandon
  fin_imp = .T.
  Imprimer = .F.
  do couleur
  deactivate menu
return

PROCEDURE ENVIRON
  DO COULEUR
  set separator to "'"
  set point to "."
  SET CONFIRM ON
  SET DEFAULT TO C
  SET DELETED ON
  SET ESCAPE  ON
  SET EXACT   ON
  SET HEADINGS OFF
  SET BELL OFF
  SET HELP  OFF
  SET INSTRUCT OFF
  SET LOCK OFF
  SET ECHO OFF
  SET PATH TO c:\PMSV3
  SET SAFETY OFF
  SET SCOREBOARD  OFF
  SET STATUS OFF
  SET TALK  OFF
  set message to 
  on key label ctrl-i
RETURN


PROCEDURE COULEUR
  if iscolor()
    SET COLOR OF MESSAGE TO N/BG
    SET COLOR OF NORMAL TO W+/B
    SET COLOR OF HIGHLIGHT TO W+/N
    SET COLOR OF TITLES TO W+/B
    SET COLOR OF BOX TO W+/BG
    SET COLOR OF FIELDS TO N/W
  else
    SET COLOR OF HIGHLIGHT TO W+/N
    SET COLOR OF NORMAL TO W/N
    SET COLOR OF MESSAGE TO N/W
    SET COLOR OF TITLES TO W+/N
    SET COLOR OF BOX TO N/W+
    SET COLOR OF FIELDS TO N/W
  endif
RETURN


PROCEDURE BEEP
  set bell on 
  set bell to 500,7 
  @0,0 say chr(7)
  set bell off
return

PROCEDURE Fenetre
PARAMETERS Y1, X1, Y2, X2, Titre , coul
*XG = X1 + INT((X2-X1)/2)
*YH = Y1 + INT((Y2-Y1)/2)
*XD = XG
*YB = YH
  XG = X1
  XD = X2
  YH = Y1
  YB = Y2
 
do while  XD <= X2 .OR. XG >= X1 .or. YB <= Y2 .OR. YH >= Y1
  IF XG <= XD .AND. YH<=YB 
    if (xd = x2-1)
      xd= x2
    endif
    if (xg = x1 +1)
      xg = x1
    endif
    @YH,XG clear to YB,XD
    @YH+1,XG+2 fill to YB+1,XD+2  color w/n
    do case
      case coul = "W+/BG"
        @YH,XG fill to YB,XD COLOR W+/BG
        @YH,XG to YB,XD COLOR W+/BG
      case coul = "W+/R"
        @YH,XG fill to YB,XD COLOR W+/R
        @YH,XG to YB,XD COLOR W+/R
      case coul = "GR+/B"
        @YH,XG fill to YB,XD COLOR GR+/B
        @YH,XG to YB,XD COLOR GR+/B
      case coul = "W+/G"
        @YH,XG fill to YB,XD COLOR W+/G
        @YH,XG to YB,XD COLOR W+/G
   endcase      
    IF (xd = X2) .AND. (XG=X1) .AND. (YH=Y1) .AND. (YB=Y2)
      EXIT
    ENDIF
  ENDIF

  
*  IF (XG > X1 ) 
*    XG = XG - 2
*  endif
*  IF (XD < X2)
*    XD = XD + 2
*  ENDIF
*  IF (YH > Y1) 
*    YH = YH - 1 
*  ENDIF
*  IF (YB < Y2 )
*    YB = YB + 1
*  ENDIF
ENDDO
 @Y1, X1+5 say TITRE color &coul
RETURN

PROCEDURE MENU_COL
  SET COLOR OF MESSAGE TO W+/R
  SET COLOR OF NORMAL TO W+/B
  SET COLOR OF HIGHLIGHT TO W+/N
  SET COLOR OF TITLES TO GR+/B
  SET COLOR OF BOX TO W+/R
  SET COLOR OF FIELDS TO N/W
RETURN


PROCEDURE Date_inv
  Do beep
  @24,17 say "Date invalide jj/mm/aa (appuyer sur une touche)" color N/BG
  read
RETURN  
   
FUNCTION trouve
PARAMETERS cle, type

Ok = .F.

do case
  case type = "C"
    do case
      case nom_menu="GEST_ACHAT" 
         select e
         set order to ind_four
         Ok = seek(cle)
      case  nom_menu = "GEST_STO"
         select e
         set order to ind_four
         if cle = 0
           return .F.
         endif  
         if .not. seek (cle)
           do crea_four
         endif
         ok = .T.
    otherwise  
         select a
         set order to ind_compt
         Ok = seek(cle)
    endcase
  case type = "F" .or. type = "V"
    if nom_menu="GEST_ACHAT"
      select zach
      set order to ind_ach
    else
      select b
      set order to ind_fact
    endif
    Ok = seek(cle)
  case type = "P"
    if nom_menu="GEST_ACHAT"
      select zach
      set order to ind_ach
    else
      select b
      set order to ind_fact
    endif
    seek (cle)
    if found() .and. proforma 
      Ok = .T.
    endif
  case type = "A"
    select D
    set order to code_art
    seek (cle)
    if nom_menu = "GEST_STO"
      return seek(cle)
    endif      
    if (found() .and. nom_menu="GEST_ACHAT" .and.  no_compte <> compte)
      return .F.     
    endif
    if found() .or. cle = space(8) 
      Ok = .T.
      if nom_menu = "GEST_ACHAT"
        element[indice,4] = prix_achat
      else
        element[indice,4] = prix_vente
      endif
      element[indice,2] = design
      element[indice,5] = service

***--- rajouter element[indice,6] = nomen pour les nomenclatures
      
      @ ligne,0   say element[indice,1]  color N/W
      @ ligne,9   say element[indice,2]
      @ ligne,47  say element[indice,4]  picture "9,999,999.99" COLOR N/W
    endif
    if .not. found()
      Ok = .F.
      do beep
      activate screen
      @24,13 say "Code d'article inexistant (appuyer sur une touche)" COLOR N/BG
      read
      @24,10 clear to 24,79
      activate window descrip 
      do Article
    endif
  case type = "T"
    select D
    set order to code_art
    Ok = .not. seek (cle)
  
  case type = "N"
  *** Nomenclatures
    select h
    set order to code_nomen
    do crea_nomen
    Ok = .T.  
endcase

return (Ok)  


PROCEDURE cle_inv
PARAMETERS type
on key label ctrl-q
*on key label F2
do beep
do case
  case type = "C"
    if nom_menu="GEST_ACHAT"
     @24,11 say "Nø de compte fournisseur inexistant (appuyer sur une touche)" COLOR N/BG
    else
     if nom_menu = "GEST_STO"
       @24,13 say "Nø de compte:  0  invalide  (appuyer sur une touche)" COLOR N/BG
     else
       @24,13 say "Nø de compte client inexistant (appuyer sur une touche)" COLOR N/BG
     endif
    endif
  case type = "A"
    if nom_menu = "GEST_STO"
      @24,13 say "Code d'article inexistant (appuyer sur une touche)" COLOR N/BG
      read
      @24,10 clear to 24,79
    else
      activate screen
      @24,13 say "Code d'article inexistant (appuyer sur une touche)" COLOR N/BG
      read
      @24,10 clear to 24,79
      activate window descrip 
 *     on key label F2 do Article
    endif
    on key label ctrl-q do echaper
    return
  case type = "T"
    @24,14 say "Code d'article existant (appuyer sur une touche)" COLOR N/BG
    read
    @24,10 clear to 24,79
    on key label ctrl-q do echaper
    return
  case type = "F" .or. type = "V"
    @24,16 say "Nø de facture inexistante (appuyer sur une touche)" COLOR N/BG
  case type = "P"
    if .not. found()
      @24,16 say "Nø de facture inexistante (appuyer sur une touche)" COLOR N/BG
    else 
      if nom_menu="GEST_ACHAT"
        @24,17 say "Ce n'est pas une commande (appuyer sur une touche)" COLOR N/BG   
      else
        @24,17 say "Ce n'est pas un proforma (appuyer sur une touche)" COLOR N/BG   
      endif
    endif
endcase
read
@24,10 clear to 24,79
on key label ctrl-q do echaper
return 


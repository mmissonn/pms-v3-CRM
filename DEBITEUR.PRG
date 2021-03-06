PROCEDURE debiteur
  do while .T.
    clear
    if nom_menu = "GEST_VEN"
      select a
      set order to ind_compt
      Select zfact
      nom_index = "IND_FACT"
      zone="a"
      Code_ = "Code_client"
    else
      select e
      set order to ind_four
      Select zach
      zone="e"
      nom_index = "IND_ACH"
      Code_ = "Code_four"
    endif
    Quitter = 'N'
    rep ='O'
    set filter to &zone->solde <> 0  .and. .not. proforma
    ON KEY LABEL CTRL-I Do imp with "Debiteur"
    do affic_db
    set filter to
    set cursor on
    @24,20 say "Autre rel�v� de compte ? (O/N) " get Quitter PICTURE "Y" ;
    COLOR N/BG
    read
    @24,29 clear to 24,col()
    if Quitter = 'N'
      set order to &nom_index
      ON KEY label ctrl-I
      restore screen from ecran_menu
      return
    endif 
  enddo
return


PROCEDURE Affic_db
  periode = 0
  Xlig = 8
  ** set order to ind_code
  set order to ind_date
  go top
  do Pres_db
  @24,0 say "<Ctrl-Q>-Quitter                                               <Ctrl-I>-Imprimer" COLOR GR+/B
  tot1 = 0
  tot2 = 0
  tot3 = 0
  do while  .not. eof() 
    cum1 = 0
    cum2 = 0
    cum3 = 0
    NC = &Code_
    @xlig,2 say &Code_ PICTURE "@L 99999" 
    @xlig,11 say &zone->Nom PICTURE "XXXXXXXXXXXXXXXXXXXXXXXXX" 
    do while &Code_ = NC .and. .not. eof()
      periode = date_fact+delai - date()
      do case
        case periode <= 30
          cum1 = cum1 + total_ttc - mont_paye
        case periode <= 60 .and. periode > 30
          cum2 = cum2 + total_ttc - mont_paye
        case periode > 60
          cum3 = cum3 + total_ttc - mont_paye
       endcase
      skip
    enddo
    tot1= tot1 + cum1
    tot2= tot2 + cum2
    tot3= tot3 + cum3
    @xlig,38 say cum1 PICTURE "9,999,999.99" 
    @xlig,51 say cum2 PICTURE "9,999,999.99" 
    @xlig,65 say cum3 PICTURE "9,999,999.99" 
    xlig = xlig +1
    rep = ' '
    if eof()
      @23,22 say "FIN DU RELEVE DE COMPTE  (Appuyez sur une touche)";
      COLOR N/BG 
      read
      @23,22 clear to 23,col()
      do fenetre with 7,17,15,60,"TOTAL",opt_quitter
      @9,21 say "Solde  -30 j      : "  color  W+/bg        
      @9,col() say Tot1 picture "99,999,999.99" color W+/BG
      @11,21 say "Solde 30-60 j     : "  color W+/bg        
      @11,col() say Tot2 picture "99,999,999.99" color W+/BG
      @13,21 say "Solde 60j et plus : "  color W+/bg        
      @13,col() say Tot3 picture "99,999,999.99" color W+/BG
      return
    endif
    if xlig = 22
      @23,17 say  "Appuyez sur une touche pour VOIR LA SUITE  ";
      COLOR N/BG 
      read
      @23,17 clear to 23,col()
      xlig = 8
      do Pres_db
    endif
  enddo
return


PROCEDURE Pres_db
PRIVATE lc_talk, lc_cursor, lc_display, lc_status, lc_carry, lc_proc,;
        ln_typeahd, gc_cut

IF SET("TALK") = "ON"
   SET TALK OFF
   lc_talk = "ON"
ELSE
   lc_talk = "OFF"
ENDIF
lc_cursor = SET("CURSOR")
SET CURSOR ON

lc_status = SET("STATUS")
*-- SET STATUS �tait OFF lors de l'entr�e dans l'�cran de cr�ation de format
IF lc_status = "ON"
   SET STATUS OFF
ENDIF


*-- Gestion des @ SAY... GETS -------------------------------------------------

*--  Page  1
@ 0,29 TO 2,50 DOUBLE 
@ 1,0 TO 22,79 DOUBLE 
if nom_menu= "GEST_VEN"
  @ 1,29 SAY "� COMPTES RECEVABLES �" 
else
  @ 1,29 SAY "�  COMPTES PAYABLES  �" 
endif

@ 4,0 SAY "������������������������������������������������������������������������������Ķ" 
@ 5,2 SAY "N�Cpte" 
@ 5,9 SAY "�" 
@ 5,11 SAY "Nom" 
@ 5,37 SAY "�" 
@ 5,41 SAY "Solde" 
@ 5,50 SAY "�" 
@ 5,54 SAY "Solde" 
@ 5,63 SAY "�" 
@ 5,68 SAY "Solde" 
@ 6,9 SAY "�" 
@ 6,37 SAY "�" 
@ 6,41 SAY "courant" 
@ 6,50 SAY "�" 
@ 6,54 SAY "30-60j" 
@ 6,63 SAY "�" 
@ 6,66 SAY "60j et plus" 
@ 7,0 SAY "������������������������������������������������������������������������������Ķ" 
@ 8,9 SAY "�" 
@ 8,37 SAY "�" 
@ 8,50 SAY "�" 
@ 8,63 SAY "�" 
@ 9,9 SAY "�" 
@ 9,37 SAY "�" 
@ 9,50 SAY "�" 
@ 9,63 SAY "�" 
@ 10,9 SAY "�" 
@ 10,37 SAY "�" 
@ 10,50 SAY "�" 
@ 10,63 SAY "�" 
@ 11,9 SAY "�" 
@ 11,37 SAY "�" 
@ 11,50 SAY "�" 
@ 11,63 SAY "�" 
@ 12,9 SAY "�" 
@ 12,37 SAY "�" 
@ 12,50 SAY "�" 
@ 12,63 SAY "�" 
@ 13,9 SAY "�" 
@ 13,37 SAY "�" 
@ 13,50 SAY "�" 
@ 13,63 SAY "�" 
@ 14,9 SAY "�" 
@ 14,37 SAY "�" 
@ 14,50 SAY "�" 
@ 14,63 SAY "�" 
@ 15,9 SAY "�" 
@ 15,37 SAY "�" 
@ 15,50 SAY "�" 
@ 15,63 SAY "�" 
@ 16,9 SAY "�" 
@ 16,37 SAY "�" 
@ 16,50 SAY "�" 
@ 16,63 SAY "�" 
@ 17,9 SAY "�" 
@ 17,37 SAY "�" 
@ 17,50 SAY "�" 
@ 17,63 SAY "�" 
@ 18,9 SAY "�" 
@ 18,37 SAY "�" 
@ 18,50 SAY "�" 
@ 18,63 SAY "�" 
@ 19,9 SAY "�" 
@ 19,37 SAY "�" 
@ 19,50 SAY "�" 
@ 19,63 SAY "�" 
@ 20,9 SAY "�" 
@ 20,37 SAY "�" 
@ 20,50 SAY "�" 
@ 20,63 SAY "�" 
@ 21,9 SAY "�" 
@ 21,37 SAY "�" 
@ 21,50 SAY "�" 
@ 21,63 SAY "�" 
@ 22,9 SAY "�" 
@ 22,37 SAY "�" 
@ 22,50 SAY "�" 
@ 22,63 SAY "�" 
*-- Sortie du fichier Format --------------------------------------------------

*-- SET STATUS �tait OFF lors de l'entr�e dans l'�cran de cr�ation de format
IF lc_status = "ON"  && Si STATUS �tait ON au d�part,
   SET STATUS ON     && restaurer cette valeur
ENDIF
SET CURSOR &lc_cursor.
SET TALK &lc_talk.

RELEASE lc_talk,lc_fields,lc_status
*-- Fin de la proc�dure : DB.FMT
return


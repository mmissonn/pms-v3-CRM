PROCEDURE Releve
  fn = "Releve"
  do while .T. 
    restore screen from fond
    Num_compte = space(5)
    do fenetre with 7,20,14,61, "RELEVE DE COMPTE", opt_menu
    do message
    Quitter = 'N'
    rep ='O'
    ON READERROR DO cle_inv with "C"
    @10,25 say "N�Compte  : " get Num_compte PICTURE "99999";
       VALID Trouve(val(Num_compte),"C");
       color GR+/B
    read
    Nb =0
    if val(Num_compte) = 0
      loop
    endif
    ON READERROR
    @24,30 say "Patientez S-V-P ..."
    @24,30 CLEAR TO 24,COL()
    if nom_menu = "GEST_VEN"
      select zfact
      ZONE = "a"
    else
      select zach
      ZONE = "e"
    endif

    count to nb for &ZONE->no_compte = val(num_compte) .and. .not. proforma 

    if Nb = 0
      @24,16 say "Le compte  N� "+trim(num_compte)+ " n'a aucune facture. (Appuyez sur une touche)";
        COLOR N/BG 
      read
      do message
    else
      on key label CTRL-I do imp with "Releve"
      set filter to &ZONE->No_compte  = val(Num_compte) .and. .not. proforma
      do affic_releve 
    endif
    Quitter = 'O'
    @24,24 say "Autre rel�v� de compte ? (O/N) " get Quitter PICTURE "Y" ;
       COLOR N/BG
    read
    set filter to
    on key label CTRL-I 
    @24,29 clear to 24,col()
    if Quitter = 'N'
      restore screen from ecran_menu
      return
    else 
      Num_compte =space(5)
    endif 
  enddo 
return

  
PROCEDURE Affic_releve
  Xlig = 10
  set order to ind_date
  go top
  do Pres_releve
  do message
  cumulatif = 0
  do while  .not. eof() 
    if (total_ttc - mont_paye) <> 0
      @xlig,1  say date_fact
      @xlig,12 say no_fact 
      @xlig,24 say Total_ttc PICTURE "9,999,999.99"
      @xlig,37 say Total_ttc - Mont_paye PICTURE "9,999,999.99"
      @xlig,52 say ltrim(str(date() - date_fact))
      @xlig,61 say delai
      cumulatif = cumulatif + (Total_ttc - mont_paye)
      @xlig,67 say cumulatif PICTURE "9,999,999.99"
      xlig = xlig +1
    endif 
      rep = ' '
    skip
    if eof()
      Do message
      @23,13 say "FIN DU RELEVE DE COMPTE  (Appuyez sur une touche)";
      COLOR N/BG 
      read
      set cursor on
      @23,13 clear to 23,col()
      return
    endif
    if xlig = 22
      rc = recno()
      @23,17 say  "Appuyez sur une touche pour VOIR LA SUITE  ";
      COLOR N/BG 
      read
      go rc
      set cursor on
      @23,17 clear to 23,col()
      xlig = 10
      do while xlig <= 21
        @xlig,1 clear to xlig,9
        @xlig,11 clear to xlig,22
        @xlig,24 clear to xlig,35
        @xlig,37 clear to xlig,48
        @xlig,52 clear to xlig,56
        @xlig,61 clear to xlig,64
        @xlig,67 clear to xlig,78
        xlig = xlig+1
      enddo
      xlig = 10
    endif
  enddo
return

PROCEDURE Pres_releve 
  clear
  @ 1,0 TO 22,79 
  @ 0,29 TO 2,46 DOUBLE 
  @ 1,30 SAY "RELEVE DE COMPTE" 
  @ 3,1 SAY "N� compte: "  
  @ 3,12 SAY ltrim(str(&ZONE->no_compte))  
  @ 3,61 SAY "Date : " 
  @ 3,68 SAY date()  
  @ 4,1 SAY "Nom      : " 
  @ 4,12 SAY ltrim(&ZONE->nom) 
  @ 6,1 SAY "������������������������������������������������������������������������������" 
  @ 6,0 say  chr(195)
  @ 6,79 say chr(180)
  @ 7,1 SAY "  Date" 
  @ 7,10 SAY "�" 
  @ 7,12 SAY "N� facture" 
  @ 7,23 SAY "�" 
  @ 7,25 SAY "Montant de" 
  @ 7,36 SAY "�" 
  @ 7,40 SAY "Solde" 
  @ 7,49 SAY "�" 
  @ 7,51 SAY "Jours" 
  @ 7,57 SAY "�" 
  @ 7,59 SAY "D�lai"   
  @ 7,65 SAY "�" 
  @ 7,69 SAY "Montant" 
  @ 8,10 SAY "�" 
  @ 8,23 SAY "�" 
  @ 8,25 SAY "la facture" 
  @ 8,36 SAY "�" 
  @ 8,49 SAY "�" 
  @ 8,51 SAY "�chus" 
  @ 8,57 SAY "�" 
  @ 8,65 SAY "�" 
  @ 8,68 SAY "cumulatif" 
  @ 9,1  SAY "������������������������������������������������������������������������������" 
  @ 9,0  SAY chr(195)
  @ 9,79 SAY chr(180)
  @ 10,10 SAY "�" 
  @ 10,23 SAY "�" 
  @ 10,36 SAY "�" 
  @ 10,49 SAY "�" 
  @ 10,57 SAY "�" 
  @ 10,65 SAY "�" 
  @ 11,10 SAY "�" 
  @ 11,23 SAY "�" 
  @ 11,36 SAY "�" 
  @ 11,49 SAY "�" 
  @ 11,57 SAY "�" 
  @ 11,65 SAY "�" 
  @ 12,10 SAY "�" 
  @ 12,23 SAY "�" 
  @ 12,36 SAY "�" 
  @ 12,49 SAY "�" 
  @ 12,57 SAY "�" 
  @ 12,65 SAY "�" 
  @ 13,10 SAY "�" 
  @ 13,23 SAY "�" 
  @ 13,36 SAY "�" 
  @ 13,49 SAY "�" 
  @ 13,57 SAY "�" 
  @ 13,65 SAY "�" 
  @ 14,10 SAY "�" 
  @ 14,23 SAY "�" 
  @ 14,36 SAY "�" 
  @ 14,49 SAY "�" 
  @ 14,57 SAY "�" 
  @ 14,65 SAY "�" 
  @ 15,10 SAY "�" 
  @ 15,23 SAY "�" 
  @ 15,36 SAY "�" 
  @ 15,49 SAY "�" 
  @ 15,57 SAY "�" 
  @ 15,65 SAY "�" 
  @ 16,10 SAY "�" 
  @ 16,23 SAY "�" 
  @ 16,36 SAY "�" 
  @ 16,49 SAY "�" 
  @ 16,57 SAY "�" 
  @ 16,65 SAY "�" 
  @ 17,10 SAY "�" 
  @ 17,23 SAY "�" 
  @ 17,36 SAY "�" 
  @ 17,49 SAY "�" 
  @ 17,57 SAY "�" 
  @ 17,65 SAY "�" 
  @ 18,10 SAY "�" 
  @ 18,23 SAY "�" 
  @ 18,36 SAY "�" 
  @ 18,49 SAY "�" 
  @ 18,57 SAY "�" 
  @ 18,65 SAY "�" 
  @ 19,10 SAY "�" 
  @ 19,23 SAY "�" 
  @ 19,36 SAY "�" 
  @ 19,49 SAY "�" 
  @ 19,57 SAY "�" 
  @ 19,65 SAY "�" 
  @ 20,10 SAY "�" 
  @ 20,23 SAY "�" 
  @ 20,36 SAY "�" 
  @ 20,49 SAY "�" 
  @ 20,57 SAY "�" 
  @ 20,65 SAY "�" 
  @ 21,10 SAY "�" 
  @ 21,23 SAY "�" 
  @ 21,36 SAY "�" 
  @ 21,49 SAY "�" 
  @ 21,57 SAY "�" 
  @ 21,65 SAY "�" 
  @ 22,10 SAY "�" 
  @ 22,23 SAY "�" 
  @ 22,36 SAY "�" 
  @ 22,49 SAY "�" 
  @ 22,57 SAY "�" 
  @ 22,65 SAY "�" 
  @24,0 say "<Ctrl-Q>-Quitter                                                  <Ctrl-I>-Imprimer" COLOR GR+/B
return


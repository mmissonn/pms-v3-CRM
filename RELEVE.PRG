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
    @10,25 say "NøCompte  : " get Num_compte PICTURE "99999";
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
      @24,16 say "Le compte  Nø "+trim(num_compte)+ " n'a aucune facture. (Appuyez sur une touche)";
        COLOR N/BG 
      read
      do message
    else
      on key label CTRL-I do imp with "Releve"
      set filter to &ZONE->No_compte  = val(Num_compte) .and. .not. proforma
      do affic_releve 
    endif
    Quitter = 'O'
    @24,24 say "Autre rel‚v‚ de compte ? (O/N) " get Quitter PICTURE "Y" ;
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
  @ 3,1 SAY "Nø compte: "  
  @ 3,12 SAY ltrim(str(&ZONE->no_compte))  
  @ 3,61 SAY "Date : " 
  @ 3,68 SAY date()  
  @ 4,1 SAY "Nom      : " 
  @ 4,12 SAY ltrim(&ZONE->nom) 
  @ 6,1 SAY "ÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ" 
  @ 6,0 say  chr(195)
  @ 6,79 say chr(180)
  @ 7,1 SAY "  Date" 
  @ 7,10 SAY "³" 
  @ 7,12 SAY "Nø facture" 
  @ 7,23 SAY "³" 
  @ 7,25 SAY "Montant de" 
  @ 7,36 SAY "³" 
  @ 7,40 SAY "Solde" 
  @ 7,49 SAY "³" 
  @ 7,51 SAY "Jours" 
  @ 7,57 SAY "³" 
  @ 7,59 SAY "D‚lai"   
  @ 7,65 SAY "³" 
  @ 7,69 SAY "Montant" 
  @ 8,10 SAY "³" 
  @ 8,23 SAY "³" 
  @ 8,25 SAY "la facture" 
  @ 8,36 SAY "³" 
  @ 8,49 SAY "³" 
  @ 8,51 SAY "‚chus" 
  @ 8,57 SAY "³" 
  @ 8,65 SAY "³" 
  @ 8,68 SAY "cumulatif" 
  @ 9,1  SAY "ÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ" 
  @ 9,0  SAY chr(195)
  @ 9,79 SAY chr(180)
  @ 10,10 SAY "³" 
  @ 10,23 SAY "³" 
  @ 10,36 SAY "³" 
  @ 10,49 SAY "³" 
  @ 10,57 SAY "³" 
  @ 10,65 SAY "³" 
  @ 11,10 SAY "³" 
  @ 11,23 SAY "³" 
  @ 11,36 SAY "³" 
  @ 11,49 SAY "³" 
  @ 11,57 SAY "³" 
  @ 11,65 SAY "³" 
  @ 12,10 SAY "³" 
  @ 12,23 SAY "³" 
  @ 12,36 SAY "³" 
  @ 12,49 SAY "³" 
  @ 12,57 SAY "³" 
  @ 12,65 SAY "³" 
  @ 13,10 SAY "³" 
  @ 13,23 SAY "³" 
  @ 13,36 SAY "³" 
  @ 13,49 SAY "³" 
  @ 13,57 SAY "³" 
  @ 13,65 SAY "³" 
  @ 14,10 SAY "³" 
  @ 14,23 SAY "³" 
  @ 14,36 SAY "³" 
  @ 14,49 SAY "³" 
  @ 14,57 SAY "³" 
  @ 14,65 SAY "³" 
  @ 15,10 SAY "³" 
  @ 15,23 SAY "³" 
  @ 15,36 SAY "³" 
  @ 15,49 SAY "³" 
  @ 15,57 SAY "³" 
  @ 15,65 SAY "³" 
  @ 16,10 SAY "³" 
  @ 16,23 SAY "³" 
  @ 16,36 SAY "³" 
  @ 16,49 SAY "³" 
  @ 16,57 SAY "³" 
  @ 16,65 SAY "³" 
  @ 17,10 SAY "³" 
  @ 17,23 SAY "³" 
  @ 17,36 SAY "³" 
  @ 17,49 SAY "³" 
  @ 17,57 SAY "³" 
  @ 17,65 SAY "³" 
  @ 18,10 SAY "³" 
  @ 18,23 SAY "³" 
  @ 18,36 SAY "³" 
  @ 18,49 SAY "³" 
  @ 18,57 SAY "³" 
  @ 18,65 SAY "³" 
  @ 19,10 SAY "³" 
  @ 19,23 SAY "³" 
  @ 19,36 SAY "³" 
  @ 19,49 SAY "³" 
  @ 19,57 SAY "³" 
  @ 19,65 SAY "³" 
  @ 20,10 SAY "³" 
  @ 20,23 SAY "³" 
  @ 20,36 SAY "³" 
  @ 20,49 SAY "³" 
  @ 20,57 SAY "³" 
  @ 20,65 SAY "³" 
  @ 21,10 SAY "³" 
  @ 21,23 SAY "³" 
  @ 21,36 SAY "³" 
  @ 21,49 SAY "³" 
  @ 21,57 SAY "³" 
  @ 21,65 SAY "³" 
  @ 22,10 SAY "Á" 
  @ 22,23 SAY "Á" 
  @ 22,36 SAY "Á" 
  @ 22,49 SAY "Á" 
  @ 22,57 SAY "Á" 
  @ 22,65 SAY "Á" 
  @24,0 say "<Ctrl-Q>-Quitter                                                  <Ctrl-I>-Imprimer" COLOR GR+/B
return


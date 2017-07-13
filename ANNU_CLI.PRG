PROCEDURE annu_client
   do while .T. 
      restore screen from fond
      LeCompte = .T.
      do fenetre with 7,20,14,61, "ANNULATION",opt_menu
      @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
      Num_compte = space(5)

      Confirme = ' '
      Quitter = ' '
      rep ='O'
      ON READERROR DO cle_inv with "C"
      @10,22 say "NøCompte  : " get Num_compte PICTURE "99999";
         VALID Trouve(val(Num_compte),"C");
         color &opt_menu
      read

      if val(Num_compte) = 0
        loop
      endif
      ON READERROR
      @24,30 say "Patientez S-V-P ..."
      confirme =' '
      if nom_menu = "GEST_VEN"
        select b
        ZONE = "a"
      else
        select f
        ZONE = "e"
      endif
      set filter to &ZONE->no_compte = val(Num_compte)

      clear
      do affic_releve
      set filter to
      @24,19 clear to 24,77
      @24,18 say "Voulez-vous VRAIMENT ANNULER ce compte ? (O/N) ";
      get Confirme PICTURE "Y";
      COLOR N/BG 
      read
      @24,18 CLEAR to 24,col()
      if confirme = 'O'
        select &ZONE
        do fenetre with 9,20,15,61,"TRAITEMENT",opt_attent
        @11,29 say "Annulation en cours ..." color &opt_attent
        @13,29 say "Soyez patient S-V-P ! " color &opt_attent
        delete all for No_compte = val(Num_compte)
        if nom_menu = "GEST_VEN"
          select ZDET_V
          delete all for zfact->code_clien = val(Num_compte)
          select b
          delete all for code_clien = val(Num_compte)
        else
          select ZDET_A
          delete all for zach->code_four = val(Num_compte)
          select f
          delete all for code_four = val(Num_compte)
        endif
        
        @13,29 fill to 13,col() color &opt_attent
        @11,29 say "...Annulation termin‚ !" Color &opt_attent
      endif            
      Num_compte = space(5)
    Quitter = 'O'
    @24,20 say "Annulation d'un  autre compte  ? (O/N) " get Quitter PICTURE "Y";
    COLOR N/BG 
    read
    @24,20 clear to 24,col()
    if Quitter = 'N'
       restore screen from ecran_menu
       return
    endif
  enddo 
return

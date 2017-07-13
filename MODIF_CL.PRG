PROCEDURE Modif_client
  do while .T.
    restore screen from fond
    do fenetre with 7,20,14,61,"MODIFICATON",opt_menu
    do message
    Num_compte = space(5)
    do while .T. 
      Confirme = ' '
      Quitter = ' '
      rep ='O'
      ON READERROR DO cle_inv with "C"
      @10,22 say "NøCompte  : " get Num_compte PICTURE "99999" ;
         VALID trouve(val(Num_compte),"C");
         COLOR GR+/B
      read
      if val(Num_compte) = 0
        loop
      endif
      ON READERROR
      @24,30 say "Patientez S-V-P ..."
      if nom_menu = "GEST_ACHAT"
        select e
      else
        select a
      endif
      set filter to No_compte = val(Num_compte)
      on key label ctrl-Q
      set MESSAGE to;
      "<Ctrl-Fin>-Sauver              <Tab>-D‚placer                     <Esc>-Abandonner" 
      BROWSE NOAPPEND FIELDS Nom, Adresse, Ville, Code_post, Telephone, Status
      on key label ctrl-q do echaper
      set MESSAGE to
      set filter to
      Num_compte = space(5)
      exit
    enddo
    Quitter = 'O'
    @24,20 say "Modification d'un  autre compte  ? (O/N) " get Quitter PICTURE "Y";
    COLOR N/BG 
    read
    @24,20 clear to 24,col()
    if Quitter = 'N'
      restore screen from ecran_menu
       return
    endif
  enddo 
return

 

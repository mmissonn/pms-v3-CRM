PROCEDURE rapp_ven
  date_sup = {  /  /  }
  date_inf = {  /  /  }
  vendeur_ = space(13)
  save screen to ecr_actuel
  restore screen from fond
  do fenetre with 7,20,19,61,"ANALYSE DES VENTES" ,opt_menu
  @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
  do while .T. 
    rep ='O'
    ON READERROR DO Date_inv
    @10,27 say "Du        " get date_inf MESSAGE "Entrer la date (jj/mm/aa)" COLOR GR+/B
    @12,27 say "Jusqu'au  " get date_sup MESSAGE "Entrer la date (jj/mm/aa)" COLOR GR+/B
    @14,27 say "Vendeur   " get vendeur_ PICTURE "@!" MESSAGE "Entrer le nom du vendeur"  COLOR GR+/B
    read
    if date_inf = {  /  /  } .or. date_sup = {  /  /  }
      loop
    endif
    ON READERROR 
    exit
  enddo 
  do imp with "VENDEUR"
  restore screen from ecr_actuel
return



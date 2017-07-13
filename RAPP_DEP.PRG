PROCEDURE rapp_dep
  date_sup = {  /  /  }
  date_inf = {  /  /  }
  save screen to ecr_actuel
  restore screen from fond
  do fenetre with 7,20,16,61,"JOURNAL DES DEPENSES" ,opt_menu
  @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
  do while .T. 
    rep ='O'
    ON READERROR DO Date_inv
    @10,27 say "Du        " get date_inf MESSAGE "Entrer la date (jj/mm/aa)" COLOR GR+/B
    @12,27 say "Jusqu'au  " get date_sup MESSAGE "Entrer la date (jj/mm/aa)" COLOR GR+/B
    read
    if date_inf = {  /  /  } .or. date_sup = {  /  /  }
      loop
    endif
    ON READERROR 
    exit
  enddo 
  do imp with "DEPENSE"
  restore screen from ecr_actuel
return




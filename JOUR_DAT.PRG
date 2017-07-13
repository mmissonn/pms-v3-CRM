PROCEDURE jour_date
  date_sup = {  /  /  }
  date_inf = {  /  /  }
  restore screen from fond
  do fenetre with 7,20,17,61,"JOURNAL DES VENTES" ,opt_menu
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
    do jour_ven with date_inf,date_sup
    exit
  enddo    
return


PROCEDURE Quotidien
  date_sup = {  /  /  }
  date_inf = {  /  /  }
  restore screen from fond

  if nom_menu = "GEST_VEN"
    do fenetre with 7,20,17,61,"JOURNAL DES VENTES" ,opt_menu
  else
    do fenetre with 7,20,17,61,"JOURNAL DES ACHATS" ,opt_menu
  endif

  @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
  do while .T. 
    rep ='O'
    ON READERROR DO Date_inv
    @11,29 say "Le  " get date_inf MESSAGE "Entrer la date (jj/mm/aa)" COLOR GR+/B
    read
    if date_inf = {  /  /  } 
      date_inf = date()
    endif
    ON READERROR 
    date_sup = date_inf
    do jour_ven with date_inf,date_sup
    exit
  enddo    
return


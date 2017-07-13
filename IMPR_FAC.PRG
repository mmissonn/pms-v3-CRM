PROCEDURE impr_fact
restore screen from fond
do fenetre with 8,20,15,61, "IMPRESSION" , opt_menu
do while .T. 
    out = .F.
    do message
    Num_fact = space(8)
    Quitter = 'O'
    rep ='O'
    ON READERROR DO cle_inv with "V"
    @11,25 say "NøFacture :" get Num_fact PICTURE "99999999" VALID trouve(val(Num_fact),"V");
          color GR+/B
    read
    if val(Num_fact) = 0
      loop
    endif
    ON READERROR
    Num =0
    ind = val(num_fact)
    do imp WITH "Facture"
    @24,25 say "Impression d'une autre facture ? (O/N) " get Quitter PICTURE "Y" ;
      COLOR N/BG
    read
    @24,29 clear to 24,col()
    if Quitter = 'N'
      restore screen from ecran_menu
      return 
    else 
      Num_fact = space(8)
    endif 
  enddo 
return
  


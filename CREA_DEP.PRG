PROCEDURE crea_dep
  restore screen from fond
  do fenetre with 2,17,18,60,"DEPENSE",opt_menu
  save screen to ecr_actuel
    do while .T.   
      date_ = {  /  /  }
      libelle_ = space(7)
      depense_ = space(11)
      fact_ = 0
      tps_ = 0
      tvq_ = 0
      tot_ = 0      
      @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
      Confirme = ' '
      Quitter = ' '
      rep ='O'
      on readerror do Date_inv
      do while libelle_ = space(7)
      @4,20  say "Date         " get date_ ;
         MESSAGE "Entrer la date de la d‚pense";
         COLOR GR+/B
      @6,20  say "No facture   " get fact_ PICTURE "99999999" ;
         MESSAGE "Entrer le num‚ro de facture";
         COLOR GR+/B
      @8,20  say "Libell‚      " get libelle_ PICTURE "@!";
         MESSAGE "Entrer le libell‚";
         COLOR GR+/B
      @10,20  say "D‚pense      " get depense_ FUNCTION "M D‚placement,Publicit‚,Loc/Bureau,Divers,Achat";
         MESSAGE "Entrer le type de d‚pense(appuyer sur la barre d'espace)" ;
         COLOR GR+/B
      @12,20 say "Total ht     " get tot_ PICTURE "99,999.99";
         MESSAGE "Entrer le total hors taxes";
         COLOR GR+/B
      @14,20 say "T.P.S        " get tps_ PICTURE "9,999.99";
         MESSAGE "Entrer la taxe f‚d‚rale";
         COLOR GR+/B
      @16,20 say "T.V.Q        " get tvq_ PICTURE "9,999.99";
         MESSAGE "Entrer la taxe provinciale";
         COLOR GR+/B
      read
      enddo
      confirme ='O'
      @24,22 say "Voulez-vous conserver cette d‚pense ? (O/N) ";
      get Confirme PICTURE "Y"  COLOR N/BG
      read
      @24,22 CLEAR to 24,col()
      if confirme = 'O'
        select i
        set order to date
        append blank 
	
	if depense_ = "D‚placement"
	  depense_ = "D"
	else
	  if depense_ = "Publicit‚"
	    depense_ = "P"
	  else
	    if depense_ = "Loc/Bureau"
	      depense_ = "L"
	    else
	      if depense_ = "Divers"
	        depense_ = "I"
	      else
	        if depense_ = "Achat"
	          depense_ = "A"
	        endif
	      endif
	    endif
	  endif
	endif
        replace date with date_, libelle with libelle_, depense with depense_,;
                tps with tps_, tvq with tvq_, tot_ht with tot_, fact with fact_
      endif            
    Quitter = 'O'
    @24,29 say "Autre d‚pense ? (O/N) " get Quitter PICTURE "Y";
    COLOR N/BG 
    read
    @24,21 clear to 24,col()
    if Quitter = 'N'
       release ecr_actuel
       restore screen from ecran_menu
       return
    endif
    restore screen from ecr_actuel
  enddo 
return


    


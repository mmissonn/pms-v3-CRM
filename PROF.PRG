PROCEDURE proforma
  set cursor on
  do while .T.
     clear
     select zfact
     NoFact = 0
     fin_pro = .F.
     Compte=0
     date_cmde ={  /  /  }
     no_cmde = space(5)
     delai_paie = space(3)
     terme_paie = space(28)
     do cadre
     if reccount() = 0
       nofact = 1000
     else
       do attrib_fact
     endif
     do while .T.
       Rep ='O'
       @24,20 clear to 24,79
       @1,1  say "NøProf "+ltrim(str(NoFact)) 
       @2,8  say date() 
       @3,11 say "  (jours)"
       @3,8  get delai_paie PICTURE "999" FUNCTION "M 30,60,90,120";
             MESSAGE "Entrer le d‚lai de livraison en appuyant sur la barre d'espace"
       @4,8  get terme_paie;
             MESSAGE "Entrer les conditions de paiement" 
       @5,8  get No_cmde PICTURE "99999";
             MESSAGE "Entrer le Nø de la commande"
       ON READERROR Do Date_inv
       @6,8  get Date_cmde;  
             MESSAGE "Entrer la date de la commande"
       @6,31 say "Page  1"  COLOR GR+/B
       @1,45 say "NøCpte " get Compte PICTURE "99999";
             MESSAGE "Entrer le Nø de compte du client"
       read
       if Compte = 0
         do Beep
         loop
       endif
       ON READERROR 
       @24,0 clear to 24,79
       do Recherche
       if .not. fin_pro 
         do Descrip with Nofact
       endif 
       exit
     enddo
     @24,20 say "Edition d'une autre facture ? (O/N) " get rep picture "Y";
         color N/BG
     read 
     on key label Ctrl-I 
     DEACTIVATE WINDOW ALL
     release windows
     release element
     @24,20 clear to 24,col() 
     do deplace
     if rep= 'N'
        restore screen from ecran_menu
        return
     endif
  enddo

PROCEDURE Recherche
  @3,8 clear to 3,30
  @3,8 say ltrim(delai_paie)+ "jours" 
  @3,col() clear to 3,40
  @4,8 say ltrim(terme_paie)
  @4,col() clear to 4,40
  @5,8 say trim(No_cmde)
  @5,col() clear to 5,30
  @6,8 say Date_cmde
  @1,53 say ltrim(str(Compte))+"     "
  select zclient
  set order to ind_compt
  seek Compte
  if found()
    @2,53 say Nom
    @3,53 say Adresse
    @4,53 say Ville
    @5,53 say Code_post
    @6,53 SAY Telephone
  else
    goto bottom
    append blank
    replace No_compte with Compte
    replace Date_Entre with date()
    do while .T.
      @2,53 get Nom PICTURE "@!"
      @3,53 get Adresse PICTURE "@!"
      @4,53 get Ville   PICTURE "@!"
      @5,53 get Code_post PICTURE "@!XXX-XXX"
      @6,53 get Telephone PICTURE "(999)999-9999"
      read
      @2,53 say ltrim(Nom)  
      @2,col() clear to 2,78
      @3,53 say ltrim(Adresse)  
      @3,col() clear to 3,78
      @4,53 say ltrim(Ville)  
      @4,col() clear to 4,78
      @5,53 say ltrim(Code_post)
      @5,col() clear to 5,78
      @6,53 say Telephone
      @6,col() clear to 6,78
      Exit
    enddo
  endif
  @1,8 say ltrim(str(nofact))+ "        "
return     

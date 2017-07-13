*** MODIF LE 30-06-93 TAXE VENTE ONTARIO
*** MODIF LE 14-05-94 TVQ A 6.5% ET TAXE SERVICE A 6.5%
*** MODIF LE 04-01-98 TVQ A 7.5% ET TAXE SERVICE A 7.5%

PROCEDURE proforma
  option = prompt()
  set cursor on
  clear
  do cadre
  save screen to ecr_prof
  do while .T.
     if nom_menu = "GEST_ACHAT"
       select zach
       set order to ind_ach
     else
       select zfact
***       set order to ind_fact
		  set order to ind_date
     endif
     NoFact = 0
     vendeur_ = space(13)
     reduc = 0
     fin_pro = .F.
     Compte=0
     date_cmde ={  /  /  }
     date_ = date()
     no_cmde = space(5)
     delai_paie = space(3)
     terme_paie = space(28)
     do attrib_fact
     do while .T.
       Rep ='O'
       @24,20 clear to 24,79
       if nom_menu = "GEST_ACHAT"
         @1,1  say "NøComm "+ltrim(str(NoFact)) 
       else     
         @1,1  say "NøFact "+ltrim(str(NoFact)) 
         @1,20 say "Vendeur" get vendeur_ PICTURE "@!";
	     MESSAGE "Entrer le nom du vendeur"
       endif

       ON READERROR Do Date_inv

       @3,11 say "  (jours)"
       @2,8 get date_ ;
             MESSAGE "Entrer la date de la facture"          
       @3,8  get delai_paie PICTURE "999" FUNCTION "M 0,30,60,90,120";
             MESSAGE "Entrer le d‚lai de livraison en appuyant sur la barre d'espace"
       @4,8 get terme_paie FUNCTION "M CASH,CHEQUE";
             MESSAGE "Entrer les conditions de paiement" 
       if nom_menu = "GEST_VEN"
         @5,8  get No_cmde PICTURE "99999";
             MESSAGE "Entrer le Nø de la commande"
         @6,8  get Date_cmde;  
             MESSAGE "Entrer la date de la commande"
       endif
       @6,31 say "Page  1"  COLOR GR+/B
       if nom_menu = "GEST_ACHAT"
         @1,45 say "NøCpte " get Compte PICTURE "99999";
             MESSAGE "Entrer le Nø de compte du fournisseur"
       else
         @1,45 say "NøCpte " get Compte PICTURE "99999";
             MESSAGE "Entrer le Nø de compte du client"
       endif
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
     @24,20 say "Edition d'une autre "+lower(option)+" ? (O/N) " get rep picture "Y";
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
     restore screen from ecr_prof
  enddo

PROCEDURE Recherche
  @2,8 say date_
  @3,8 clear to 3,30
  @3,8 say ltrim(delai_paie)+ "jours" 
  @3,col() clear to 3,40
  @4,8 say ltrim(terme_paie)
  @4,col() clear to 4,40
  @1,53 say ltrim(str(Compte))+"     "
  if nom_menu = "GEST_ACHAT"
    select zfour
    set order to ind_four
  else
    select zclient
    set order to ind_compt
    @1,20 SAY "Vendeur " + ltrim(vendeur_)
    @5,8 say trim(No_cmde)
    @5,col() clear to 5,30
    @6,8 say Date_cmde
  endif
  seek Compte
  if found()
   do case
      case Status = "R"
         @1,66 say "Revente" 
         t1=.07
         t2=0   
	 t3=0
      case Status = "I"
         @1,66 say "Importation"   
         t1=.07
         t2=0
	 t3=0
      case Status = "E"
         @1,66 say "Exportation"   
         t1=0  
         t2=0
	 t3=0
      case Status = "C"
         @1,66 say "Consommateur"   
         t1=.07
         t2 =.075
	 t3 =.075
       case Status = "O"
	  @1,66 say "ONT_CONS"
	  t1=.07
	  t2=.08
	  t3=1000
    endcase

    @2,53 say Nom
    @3,53 say Adresse
    @4,53 say Ville
    @5,53 say Code_post
    @6,53 SAY Telephone
  else
    VNom = space(25)  
    stat = space(12)
    VAdresse=space(25)
    VVille=space(25)
    VCode_post=space(7)
    VTelephone=space(13)
    do while .T.
      if nom_menu = "GEST_ACHAT"
        @1,66 get stat  function "M Revente,Importation,Consommation";
           message "Entrer le status en appuyant sur la bar d'espace"
      else
        @1,66 get stat  function "M Revente,Exportation,Consommation, ONT_CONS";
           message "Entrer le status en appuyant sur la bar d'espace"
      endif       

      @2,53 get VNom PICTURE "@!"
      @3,53 get VAdresse PICTURE "@!"
      @4,53 get VVille   PICTURE "@!"
      @5,53 get VCode_post function "!" PICTURE "XXX-XXX"
      @6,53 get VTelephone PICTURE "(999)999-9999"
      read
      goto bottom
      append blank
      replace No_compte with Compte
      replace Date_Entre with date()
      replace status with substr(stat,1,1)          
      replace Nom with ltrim(Vnom)
      replace Adresse with ltrim(VAdresse)
      replace Ville with vville
      replace Code_post with Vcode_post          
      replace Telephone with Vtelephone          
      @1,66 say stat
      do case
        case Status = "R"
          @1,66 say "Revente" 
          t1=.07
          t2=0
          t3=0   
       case Status = "I"
          @1,66 say "Importation"   
          t1=.07
          t2=0
          t3=0
       case Status = "E"
          @1,66 say "Exportation"   
          t1=0  
          t2=0
          t3=0
       case Status = "O"
	  t1=.07
	  t2=.08
	  t3=1000
       case Status = "C"
          @1,66 say "Consommateur"   
          t1 = .07
          t2 = .075
          t3 = .075
     endcase
      @2,53 say ltrim(Nom)  
      @2,col() clear to 2,78
      @3,53 say ltrim(Adresse)  
      @3,col() clear to 3,78
      @4,53 say ltrim(Ville)  
      @4,col() clear to 4,78
      @5,53 say ltrim(Code_post) picture "XXX-XXX"
      @5,col() clear to 5,78
      @6,53 say Telephone PICTURE "(999)999-9999"
      @6,col() clear to 6,78
      Exit
    enddo
  endif
  @1,8 say ltrim(str(nofact))+ "        "
return     

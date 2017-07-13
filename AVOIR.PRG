*** MODIF LE 08-01-95 POUR TVQ A 6.5% ET SERVICE A 6.5%
*** MODIF LE 04-01-98 POUR TVQ A 7.5% ET SERVICE A 7.5%

PROCEDURE Avoir
  option = prompt()
  do while .T.
     clear
     if nom_menu = "GEST_ACHAT"
       select zach
       set order to ind_ach
       ZONE = "e"
     else
       select zfact
       ** set order to ind_fact
       set order to ind_date
       ZONE = "a"
     endif
     reduc = 0
     NoFact = 0
     vendeur_ = space(13)
     terme_paie = space(28)
     date_ = date()
     fin_pro = .F.
     Compte=0
     do cadre
     @3,1  clear to 3,40 
     @4,1  clear to 4,40 
     @5,1  clear to 5,30
     @6,1  clear to 6,30 
     SET CURSOR ON
     do attrib_fact
     do while .T.
       Rep ='O'
       @24,20 clear to 24,79
       @1,1  say "Note de cr‚dit Nø "+ltrim(str(Nofact))
       ON READERROR do Date_inv
       @2,8 get date_ ;
             MESSAGE "Entrer la date de l'avoir"          
       ON READERROR Do cle_inv with "C"
       if nom_menu = "GEST_ACHAT"
         @4,8 get terme_paie FUNCTION "M CASH,CHEQUE";
             MESSAGE "Entrer les conditions de paiement" 
         @1,45 say "NøCpte " get Compte PICTURE "99999";
             VALID trouve(Compte,"C"); 
             MESSAGE "Entrer le Nø de compte du fournisseur"
       else
         @2,20 say "Vendeur" get vendeur_ PICTURE "@!";
	     MESSAGE "Entrer le nom du vendeur"
         @4,8 get terme_paie FUNCTION "M CASH,CHEQUE";
             MESSAGE "Entrer les conditions de paiement" 
	 @1,45 say "NøCpte " get Compte PICTURE "99999";
             VALID trouve(Compte,"C"); 
             MESSAGE "Entrer le Nø de compte du client"
       endif
       read
       if Compte = 0
         loop
       endif
       do message
       ON READERROR
       do Rech_cr
       if .not. fin_pro 
         do Descrip with Nofact
       endif
       do message
       exit
     enddo
     rep = 'O'
     @24,16 say "Edition d'une autre Note de cr‚dit ? (O/N) " get rep picture "Y" COLOR N/BG 
     read 
     on key label ctrl-i
     deactivate window all
     release element
     @24,20 clear to 24,col() 
     do deplace
     if rep= 'N'
        restore screen from ecran_menu
        return
     endif
  enddo

PROCEDURE Rech_cr
  @3,8 clear to 3,30
  @1,53 say ltrim(str(Compte))+"     "
  @2,8 SAY DATE_
  @2,20 SAY "Vendeur " + ltrim(vendeur_)
  do case
     case &zone->Status = "R"
        @1,66 say "Revente" 
        t1=.07
        t2=0   
        t3=0
     case &zone->Status = "I"
        @1,66 say "Importation"   
        t1=.07
        t2=0
	t3=0
     case &zone->Status = "E"
        @1,66 say "Exportation"   
        t1=0  
        t2=0
	t3=0
	
     case &zone->Status = "C"
	*** MODIF LE 04-01-98 TAXE PROV A 7.5%
        @1,66 say "Consommateur"   
        t1 =.07
        t2 =.075
	t3 =.075
	
	*** MODIF LE 18-07-93 TAXE TVO ONTARIO
	case Status = "O"
	  @1,66 say "ONT_CONS"
	  t1=.07
	  t2=.08
	  t3=1000
	
	
  endcase

    @2,53 say &ZONE->Nom
    @3,53 say &ZONE->Adresse
    @4,53 say &ZONE->Ville
    @5,53 say &ZONE->Code_post
    @6,53 say &ZONE->Telephone
  @1,19 say ltrim(str(nofact))+ "        "
return     

PROCEDURE FACTURE
 clear
 option = prompt()
 date_cmde = {  /  /  }
 date_ = date()
 terme_paie = space(28)
 delai_paie = space(3)
 vendeur_ = space(13)
 no_cmde = space(5)
 do cadre
 Out = .F.
 do while .T.
   clear 
   reduc = 0
   do cadre
   fact_prof = space(8)
   if nom_menu = "GEST_ACHAT"
     select f
     set order to ind_ach
     ZONE = "e"
   else
     select b
     set order to ind_fact
     ZONE = "a"
   endif
   do while .T.
     ON READERROR Do cle_inv with "P"
     if nom_menu = "GEST_ACHAT"
       @1,1 say "Nøcomm" get  fact_prof PICTURE "999999999";
          VALID Trouve(val(fact_prof), "P");
          MESSAGE "Entrer le Nø de la commande"
     else
       @1,20 say "Vendeur" get vendeur_ PICTURE "@!";
	MESSAGE "Entrer le nom du vendeur"
       @1,1 say "Nøprof" get  fact_prof PICTURE "999999999";
          VALID Trouve(val(fact_prof), "P");
          MESSAGE "Entrer le Nø de la facture proforma"
     endif
     read
     if val(fact_prof) = 0
       loop
     endif
     ON READERROR
     @24,0 clear to 24,79
       seek val(fact_prof)
       reduc = reduction
       Quitter = ' '
       @24,30 say "Patientez S-V-P ..."
       @24,30 clear to 24,col()
       @1,8 say fact_prof
       @1,col() clear to 1,30
       @1,53 say ltrim(str(&ZONE->No_compte))
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
           @1,66 say "Consommateur"   
           t1 =.07 
           t2 =.08
           t3 =.04
       endcase
       @2,53 say &ZONE->Nom
       @3,53 say &ZONE->Adresse
       @4,53 say &ZONE->Ville
       @5,53 say &ZONE->Code_post
       @6,53 SAY &ZONE->Telephone
       date_fact = date()
 ****
       delai_paie = ltrim(str(delai)) + " "
       terme_paie = (terme)
       IF NOM_MENU = "GEST_VEN"
         no_cmde = ltrim(str(no_command))
         date_cmde = date_comm
       ENDIF
       Rep = 'O'
       do while .T.
         @3,11 say "  (jours)"
         @2,8 get date_ ;
                  MESSAGE "Entrer la date de la facture"          
         @3,8 get delai_paie FUNCTION "M 0,30,60,90,120";
                  MESSAGE "Entrer le d‚lai de paiement (appuyer sur la barre d'espace)"
         @4,8 get terme_paie FUNCTION "M CASH,MASTER,CHEQUE";
                  MESSAGE "Entrer les conditions de paiement"
         if nom_menu = "GEST_VEN"
           @5,8 get No_cmde PICTURE "99999";
                   MESSAGE "Entrer le Nø de commande"
           ON READERROR Do date_inv
           @6,8 get Date_cmde;
                   MESSAGE "Entrer la date de la commande"
         endif
         read
         ON READERROR
         @24,0 clear to 24,79
           @1,1 say "Nøfact " + ltrim(fact_prof) +space(4)
           @2,8 say date_
           @3,8 say ltrim(delai_paie) + " jours     " 
           @4,8 say ltrim(terme_paie )+space(33-len(ltrim(terme_paie)))
           norec = recno()
           if nom_menu = "GEST_VEN"
             @5,8 say ltrim(No_cmde) + space(5)
             @6,8 say Date_cmde 
             @1,20 SAY "Vendeur " + ltrim(vendeur_)
           endif
             do  Descrip with val(fact_prof)
           exit
       enddo  
       fact_prof = space(8)
       exit 
   enddo
   Quitter = 'O'
   @24,20 say "Edition d'une autre facture ? (O/N) " get Quitter PICTURE "Y" COLOR N/BG 
   read
   on key label ctrl-i 
   DEACTIVATE WINDOW ALL
   release windows
   release element
   @24,20 clear to 24,col()
   do deplace
   if Quitter = 'N'
     restore screen from ecran_menu
     return
   endif
 enddo 
return


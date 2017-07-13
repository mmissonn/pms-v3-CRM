PROCEDURE modif_art
  restore screen from fond
  do fenetre with 7,20,20,61,"MODIFICATION",opt_menu
  save screen to ecr_actuel
  do while .T.
      @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
      Num_art= space(8)
      Confirme = ' '
      Quitter = ' '
      rep ='O'
      ON READERROR Do cle_inv with "A"
      @10,22 say "Code article : " get Num_art FUNCTION "!";
         VALID Trouve(Num_art,"A");
         COLOR GR+/B
      read
      if Num_art = space(8)
        loop
      endif
      ON READERROR
      select h
      set order to code_nomen
      seek num_art          
      art1 = article1
      art2 = article2
      art3 = article3
      art4 = article4
      art5 = article5
      art6 = article6
      art7 = article7
      art8 = article8
      art9 = article9
      art10 = article10
      art11 = article11
      art12 = article12
      art13 = article13
      art14 = article14
      art15 = article15
      art16 = article16
      art17 = article17
      art18 = article18
      art19 = article19
      art20 = article20

      qte1_ = qte1
      qte2_ = qte2
      qte3_ = qte3
      qte4_ = qte4
      qte5_ = qte5
      qte6_ = qte6
      qte7_ = qte7
      qte8_ = qte8
      qte9_ = qte9
      qte10_ = qte10
      qte11_ = qte11
      qte12_ = qte12
      qte13_ = qte13
      qte14_ = qte14
      qte15_ = qte15
      qte16_ = qte16
      qte17_ = qte17
      qte18_ = qte18
      qte19_ = qte19
      qte20_ = qte20



      select d 
      set order to code_art
      set relation to no_compte into zfour
      seek num_art
      do fenetre with 3,17,19,60,"MODIFICATION",opt_menu
      code = CODE_ART
      descrip = DESIGN
      Sauve = .F.
      Sauve_ = .F.

      service_ = SERVICE
      nomen_ = NOMEN


      Stat = space(12)
      q_p = Qte_phys
      q_c = Qte_comm
      q_v = Qte_vendue
      p_v = PRIX_VENTE
      p_a = PRIX_ACHAT
      q_a = QTE_ALERTE
      four = NO_COMPTE
      
      Nom_     = space(25)
      Adr_     = space(25)
      Ville_   = space(25)
      CP_      = space(7)
      tel_     = space(13)
      @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
      Confirme = ' '
      Quitter = ' '
      rep ='O'
       
      @4,20  say "Code article " + code ;
         COLOR GR+/B
 
      @6,20  say "D‚signation  " get descrip;
         MESSAGE "Entrer la d‚signation";
         COLOR GR+/B
      @8,20 say "Prix de vente" get p_v PICTURE  "9,999,999.99";
         MESSAGE "Entrer le prix de vente" ;
         COLOR GR+/B
      @9,20 say "Prix d'achat " get p_a PICTURE "9,999,999.99";
         MESSAGE "Entrer le prix d'achat";
         COLOR GR+/B
      @11,20 say "Quantit‚e alerte    " get q_a PICTURE "9999";
         MESSAGE "Entrer la quantit‚e critique";
         COLOR GR+/B
      @12,20 say "Quantit‚e physique  " get q_p PICTURE "9999";
         MESSAGE "Entrer la quantit‚e physique";
         COLOR GR+/B
      @13,20 say "Quantit‚e command‚e " get q_c PICTURE "9999";
         MESSAGE "Entrer la quantit‚e en commande";
         COLOR GR+/B
      @14,20 say "Quantit‚e vendue    " get q_v PICTURE "9999";
         MESSAGE "Entrer la quantit‚e vendue";
         COLOR GR+/B
      
      @15,20 say "Nomenclature    " get nomen_ PICTURE "Y";
         valid trouve(code, "N");
         MESSAGE "Article avec plusieurs composantes(O/N)";
         COLOR GR+/B

      @16,20 say "Service    " get service_ PICTURE "Y";
         MESSAGE "Service taxable T.V.Q 4% (O/N)";
         COLOR GR+/B

      @18,20 say "Code du fournisseur " get four PICTURE "99999";
         valid trouve(four,"C") error chr(7)+"Nø de compte invalide !" ;
         MESSAGE "Entrer le code du fournisseur";
         COLOR GR+/B

      read
      confirme ='O'
      @24,19 say "Voulez-vous conserver les modifications ? (O/N) ";
      get Confirme PICTURE "Y"  COLOR N/BG
      read
      @24,19 CLEAR to 24,col()
      if confirme = 'O'

        replace  code_art with ltrim(code), design with descrip, prix_vente with p_v,;
        prix_achat with p_a, qte_alerte with q_a, no_compte with four,;
        Qte_phys with q_p, qte_vendue with q_v, qte_comm with q_c, service with service_,;
        nomen with nomen_

        if Sauve
          select e 
          set order to ind_four
          append blank 
          replace no_compte with four, nom with nom_, adresse with adr_, ville with ;
             ville_, code_post with cp_, telephone with tel_, solde with 0,;
             date_entre with date(), status with stat
        endif 

	if Sauve_
          select h
	  set order to code_nomen
	  append blank
	  replace code_nomen with code,;
	  article1 with art1, article2 with art2,;
	  article3 with art3, article4 with art4,;
	  article5 with art5, article6 with art6,;
	  article7 with art7, article8 with art8,;
	  article9 with art9, article10 with art10,;
	  article11 with art11, article12 with art12,;
	  article13 with art13, article14 with art14,;
	  article15 with art15, article16 with art16,;
	  article17 with art17, article18 with art18,;
	  article19 with art19, article20 with art20,;
	  qte1 with qte1_, qte2 with qte2_,;
	  qte3 with qte3_, qte4 with qte4_,;
	  qte5 with qte5_, qte6 with qte6_,;
	  qte7 with qte7_, qte8 with qte8_,;
	  qte9 with qte9_, qte10 with qte10_,;
	  qte11 with qte11_, qte12 with qte12_,;
	  qte13 with qte13_, qte14 with qte14_,;
	  qte15 with qte15_, qte16 with qte16_,;
	  qte17 with qte17_, qte18 with qte18_,;
	  qte19 with qte19_, qte20 with qte20_
        endif 


      endif            
    Quitter = 'O'
    @24,0 clear to 24,78
    @24,21 say "Modification d'un autre article ? (O/N) " get Quitter PICTURE "Y";
    COLOR N/BG 
    read
    @24,20 clear to 24,col()
    if Quitter = 'N'
       release ecr_actuel
       restore screen from ecran_menu
       return
    endif
    restore screen from ecr_actuel
  enddo 
return


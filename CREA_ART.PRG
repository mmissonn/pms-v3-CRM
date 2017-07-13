PROCEDURE crea_art
  restore screen from fond
  do fenetre with 2,17,22,60,"CREATION",opt_menu
  save screen to ecr_actuel
    do while .T.   
      code = SPACE (8)
      descrip = space(25)
      Sauve = .F.
      Sauve_ = .F.
      service_ = "N" 
      nomen_ = "N"
      art1 = space(8)
      art2 = space(8)
      art3 = space(8)
      art4 = space(8)
      art5 = space(8)
      art6 = space(8)
      art7 = space(8)
      art8 = space(8)
      art9 = space(8)
      art10 = space(8)
      art11 = space(8)
      art12 = space(8)
      art13 = space(8)
      art14 = space(8)
      art15 = space(8)
      art16 = space(8)
      art17 = space(8)
      art18 = space(8)
      art19 = space(8)
      art20 = space(8)

      qte1_ = 0
      qte2_ = 0
      qte3_ = 0
      qte4_ = 0
      qte5_ = 0
      qte6_ = 0
      qte7_ = 0
      qte8_ = 0
      qte9_ = 0
      qte10_ = 0
      qte11_ = 0
      qte12_ = 0
      qte13_ = 0
      qte14_ = 0
      qte15_ = 0
      qte16_ = 0
      qte17_ = 0
      qte18_ = 0
      qte19_ = 0
      qte20_ = 0

      p_v = 0
      p_a = 0
      q_a = 0
      q_p = 0
      four = 0
      stat = space(12)
      Nom_     = space(25)
      Adr_     = space(25)
      Ville_   = space(25)
      CP_      = space(7)
      tel_     = space(13)
      @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
      Confirme = ' '
      Quitter = ' '
      rep ='O'
      on readerror
    do while code = space(8) .or. four = 0      
      @4,20  say "Code article " get code FUNCTION "!";
         VALID Trouve(ltrim(code),"T") error chr(7)+"Code article existant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B
      @6,20  say "D‚signation  " get descrip;
         MESSAGE "Entrer la d‚signation";
         COLOR GR+/B
      @8,20 say "Prix de vente" get p_v PICTURE  "9,999,999.99";
         MESSAGE "Entrer le prix de vente" ;
         COLOR GR+/B
      @10,20 say "Prix d'achat " get p_a PICTURE "9,999,999.99";
         MESSAGE "Entrer le prix d'achat";
         COLOR GR+/B
      @12,20 say "Quantit‚e alerte    " get q_a PICTURE "9999";
         MESSAGE "Entrer la quantit‚e critique";
         COLOR GR+/B
      
      @14,20 say "Nomenclature    " get nomen_ PICTURE "Y";
         MESSAGE "Article avec plusieurs composantes(O/N)";
         COLOR GR+/B
         *valid trouve(code, "N");

      @16,20 say "Service    " get service_ PICTURE "Y";
         MESSAGE "Service taxable T.V.Q 4% (O/N)";
         COLOR GR+/B

      @18,20 say "Code du fournisseur " get four PICTURE "99999";
         valid trouve(four,"C") error chr(7)+"Nø de compte invalide !" ;
         MESSAGE "Entrer le code du fournisseur";
         COLOR GR+/B

      @20,20 say "Quantit‚e physique  " get q_p PICTURE "9999";
         MESSAGE "Entrer la quantit‚e physique";
         COLOR GR+/B

      read
    enddo  
      if nomen_ = 'O'
       do crea_nomen
      endif
      confirme ='O'
      @24,22 say "Voulez-vous conserver cet article ? (O/N) ";
      get Confirme PICTURE "Y"  COLOR N/BG
      read
      @24,22 CLEAR to 24,col()
      if confirme = 'O'
        select d
        set order to code_art
        append blank 

        replace  code_art with ltrim(code), design with descrip, prix_vente with p_v,;
        prix_achat with p_a, qte_alerte with q_a, no_compte with four,;
        Qte_phys with q_p, qte_vendue with 0, qte_comm with 0, service with service_,;
        nomen with nomen_

        if Sauve
          select e 
          set order to ind_four
          append blank 
          replace no_compte with four, nom with nom_, adresse with adr_, ville with ;
             ville_, code_post with cp_, telephone with tel_, solde with 0,;
             date_entre with date(),status with substr(stat,1,1)
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
    @24,21 say "Cr‚ation d'un autre article ? (O/N) " get Quitter PICTURE "Y";
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
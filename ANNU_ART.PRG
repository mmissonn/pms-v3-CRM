PROCEDURE annu_art

  **** Modification le 01/11/92
  SELECT ZART
  SET ORDER TO CODE_ART
  
  restore screen from fond
  do fenetre with 7,20,14,61,"ANNULATION",opt_menu
  save screen to ecr_actuel
  do while .T.
      QT = 0
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
      seek num_art
      do affi_art 
      confirme ='N'
      @24,18 say "Voulez-vous VRAIMENT ANNULER cet article ? (O/N) ";
      get Confirme PICTURE "Y"  COLOR N/BG
      read
      @24,14 CLEAR to 24,col()
      if confirme = 'O'
        delete 
        if nomen = 'O'
          select h
          set order to code_nomen
          seek num_art
          delete 
        endif
      endif            
    Quitter = 'O'
    @24,21 say "Annulation d'un autre article ? (O/N) " get Quitter PICTURE "Y";
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

PROCEDURE affi_art
      do fenetre with 3,17,19,62,"ANNULATION",opt_menu
      @4,20  say "Code article : " + code_art ;
         COLOR GR+/B
      @6,20  say "D‚signation  : " + design;
         COLOR GR+/B
      @8,20 say  "Prix de vente: " color GR+/B
      @8,col() say Prix_vente picture "9,999,999.99";
         COLOR GR+/B
      @10,20 say "Prix d'achat : " color gr+/b
      @10,col() say Prix_achat PICTURE "9,999,999.99";
         COLOR GR+/B
      @12,20 say "Quantit‚e alerte    :"+ str(Qte_alerte) color gr+/b
      @13,20 say "Quantit‚e physique  :"+ str(qte_phys) COLOR GR+/B

      @15,20 say "Nomenclature        :" + NOMEN  COLOR GR+/B
      @16,20 say "Service             :" + SERVICE COLOR GR+/B
      @17,20 say "Code du fournisseur :"+ str(no_compte) COLOR GR+/B

return




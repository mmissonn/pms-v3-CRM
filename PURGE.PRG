**** MODIF le 07-08-94 POUR FACTURATION CLIENT

PROCEDURE Purge
  MENU = "PAD4"
  save screen to Ecran_menu
  restore screen from fond
  @0,0 fill to 24,79 color W/R+
  DO FENETRE WITH 8,18,15,66,"PURGE",opt_erreur
  @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
  Confirme = ' '
  Quitter = ' '
  rep ='N'
  @10,20 say "ATTENTION!!!! la facturation va ˆtre d‚truite" COLOR W+/R
  @11,20 say "Elle sera inaccessible … l'avenir!!" COLOR W+/R
  @12,20 say "Appuyer sur une touche.." COLOR W+/R    
  read
  @24,18 say "Voulez-vous VRAIMENT PURGER la facturation ? (O/N) ";
  get rep PICTURE "Y" COLOR N/BG
  read
  @24,18 CLEAR to 24,col()
  if upper(Rep) = 'O'
    confirme ='N'
    @24,24 say "En ˆtes-vous s–r ? (O/N) " get Confirme PICTURE "Y" COLOR N/BG
    read
    @24,24 clear to 24,col()
    if confirme = 'O'
      do fenetre with 9,25,15,55,"TRAITEMENT",opt_attent
      @11,29 say "Purge en cours ..."  COLOR W+/G
      @13,29 say "Soyez patient S-V-P ! " COLOR W+/G

      select b
      delete all
      pack
   
      select c
      delete all
      pack

      @13,29 say "Appuyer sur une touche." color W+/G
      @11,29 say "...Purge termin‚e." COLOR W+/G
      read
    endif            
  endif
  restore screen from ecran_menu
return


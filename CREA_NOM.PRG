PROCEDURE crea_nomen
  Sauve_ = .T.
  release screen cr_nomen
  save screen to cr_nomen

  do fenetre with 1,2,17,77,"NOMENCLATURE",opt_menu
  @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B

  @3,5  say " Article     Qt‚e           ----------             Article       Qt‚e" color GR+/B 
                                                  
  @4,5  say "" get art1 FUNCTION "!";                                    
         VALID Trouve(ltrim(art1),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @4,17 say "" get qte1_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read

  
  @5,5  say "" get art3 FUNCTION "!";                                    
         VALID Trouve(ltrim(art3),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @5,17 say "" get qte3_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read


  @6,5  say "" get art5 FUNCTION "!";                                    
         VALID Trouve(ltrim(art5),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @6,17 say "" get qte5_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read


  @7,5  say "" get art7 FUNCTION "!";                                    
         VALID Trouve(ltrim(art7),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @7,17 say "" get qte7_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read

  @8,5  say "" get art9 FUNCTION "!";                                    
         VALID Trouve(ltrim(art9),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @8,17 say "" get qte9_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read


  @9,5  say "" get art11 FUNCTION "!";                                    
         VALID Trouve(ltrim(art11),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B
  
 
  @9,17 say "" get qte11_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read

  @10,5  say "" get art13 FUNCTION "!";                                    
         VALID Trouve(ltrim(art13),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @10,17 say "" get qte13_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read


  @11,5  say "" get art15 FUNCTION "!";                                    
         VALID Trouve(ltrim(art15),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @11,17 say "" get qte15_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read



  @12,5  say "" get art17 FUNCTION "!";                                    
         VALID Trouve(ltrim(art17),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @12,17 say "" get qte17_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read



  @13,5  say "" get art19 FUNCTION "!";                                    
         VALID Trouve(ltrim(art19),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @13,17 say "" get qte19_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read

    
  @9,5  say "" get art11 FUNCTION "!";                                    
         VALID Trouve(ltrim(art11),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B
  
 
  @9,17 say "" get qte11_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read


  @10,5  say "" get art13 FUNCTION "!";                                    
         VALID Trouve(ltrim(art13),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @10,17 say "" get qte13_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read


  @11,5  say "" get art15 FUNCTION "!";                                    
         VALID Trouve(ltrim(art15),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @11,17 say "" get qte15_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read


  @12,5  say "" get art17 FUNCTION "!";                                    
         VALID Trouve(ltrim(art17),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @12,17 say "" get qte17_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B


  read


  @13,5  say "" get art19 FUNCTION "!";                                    
         VALID Trouve(ltrim(art19),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @13,17 say "" get qte19_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B


  read
  
  @4,55  say "" get art2 FUNCTION "!";                                    
         VALID Trouve(ltrim(art2),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @4,69 say "" get qte2_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read

  @5,55  say "" get art4 FUNCTION "!";                                    
         VALID Trouve(ltrim(art4),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @5,69 say "" get qte4_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read


  @6,55  say "" get art6 FUNCTION "!";                                    
         VALID Trouve(ltrim(art6),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @6,69 say "" get qte6_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read


  @7,55  say "" get art8 FUNCTION "!";                                    
         VALID Trouve(ltrim(art8),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @7,69 say "" get qte8_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read


  @8,55  say "" get art10 FUNCTION "!";                                    
         VALID Trouve(ltrim(art10),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @8,69 say "" get qte10_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read


  @9,55  say "" get art12 FUNCTION "!";                                    
         VALID Trouve(ltrim(art12),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @9,69 say "" get qte12_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read


  @10,55  say "" get art14 FUNCTION "!";                                    
         VALID Trouve(ltrim(art14),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @10,69 say "" get qte14_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read


  @11,55  say "" get art16 FUNCTION "!";                                    
         VALID Trouve(ltrim(art16),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @11,69 say "" get qte16_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B

  read


  @12,55  say "" get art18 FUNCTION "!";                                    
         VALID Trouve(ltrim(art18),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @12,69 say "" get qte18_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B


  read


  @13,55  say "" get art20 FUNCTION "!";                                    
         VALID Trouve(ltrim(art20),"A") error chr(7)+"Code article inexistant !";
         MESSAGE "Entrer le code d'article";
         COLOR GR+/B

  @13,69 say "" get qte20_ PICTURE "9999" MESSAGE "Entrer la quantit‚e" COLOR GR+/B


   read



  restore screen from cr_nomen
 return

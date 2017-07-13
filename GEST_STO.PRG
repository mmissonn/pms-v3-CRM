PROCEDURE gest_sto
* GEST_STO_MENU.PRG

nom_menu = "GEST_STO"
out =.F.            
rep =' '
nom_proced = ""
Menu = ""
Menu_vert = ""
Ind = 0  
on key label ctrl-q do echaper

Define MENU Gest_sto
  Opt1 = "Articles"
  Opt2 = "Etat du stock"
  Opt3 = "Mouvement du stock"
  Opt4 = "Quitter"
  Room = 6  
  Row = 0

  Define pad pad1 OF gest_sto prompt opt1 at row, 0 MESSAGE ;
"                   Cr‚ation / modification / annulation article               "

  define pad pad2 OF gest_sto prompt opt2 at row, Len(opt1)+Room MESSAGE ;
"                                 Etat du stock                                "

  Define pad pad3 OF gest_sto prompt opt3 at row, Len(opt1+opt2)+Room*2 MESSAGE ;
"                               Mouvement du stock                             "

  Define pad pad4 OF gest_sto prompt opt4 at row, Len(opt1+opt2+opt3)+Room*3 MESSAGE ;
"                                 Retour au menu                               "

  on pad pad1 OF gest_sto activate popup Article
  on pad pad2 OF gest_sto activate popup etat
  on pad pad3 OF gest_sto activate popup mvt
  on selection pad pad4 OF gest_sto deactivate menu

  Define popup Article From row+1,0

  Define BAR 1 OF Article Prompt "Cr‚ation" 
  Define BAR 2 OF Article Prompt "Annulation" 
  Define BAR 3 OF Article Prompt "Modification"
  on selection popup Article Do Article_proc

  Define popup Etat From row+1,Len(opt1)+room
  Define BAR 1 OF Etat Prompt "ÄÄÄRecherche parÄÄÄ" skip
  Define BAR 2 OF Etat Prompt "Article" 
  Define BAR 3 OF Etat Prompt "Groupe" 
  Define BAR 4 OF Etat Prompt "Fournisseur" 
  Define BAR 5 OF Etat Prompt "Articles manquants" 
  Define BAR 6 OF Etat Prompt "Tous les articles"
  on selection popup Etat Do Etat_proc

  Define popup Mvt From row+1,Len(opt1+opt2)+room*2
  Define BAR 1 OF Mvt Prompt "ÄÄÄRecherche parÄÄÄ" skip    
  Define BAR 2 OF Mvt Prompt "Article"        
  Define BAR 3 OF Mvt Prompt "Groupe"   
  Define BAR 4 OF Mvt Prompt "Fournisseur"   
  Define BAR 5 OF Mvt Prompt "Back ordered"  
  Define BAR 6 OF Mvt Prompt "Articles manquants"  
  Define BAR 7 OF Mvt Prompt "Tous les articles"  
  on selection popup Mvt Do mvt_proc

save screen to menu_
do while .t.
  menu = ""
  restore screen from fond
  on key label ctrl-i
  Activate MENU gest_sto
  if pad() = "PAD4" .or. menu=""
    restore screen from menu_
    release screen menu_
    exit
  endif
enddo
return

PROCEDURE Article_proc
  save screen to Ecran_menu
  MENU = "PAD1S"
  do case
    case bar() = 1
      do crea_art
    case bar() = 2
      do annu_art
    case bar() = 3
      do Modif_ar
   endcase   
  restore screen from ecran_menu
  menu = ""
return


PROCEDURE Mvt_proc
  save screen to Ecran_menu
  menu = "PAD3S"
  menu_vert = bar()
  do case
    case bar() = 2
      Do rec_art
    case bar() = 3
      Do rec_gro
    case bar() = 4
      Do rec_fn
    case bar() = 5
      Do rec_rot
    case bar() = 6
      Do mvt with "M",0,0
    case bar() = 7
      Do mvt with "T",0,0
  endcase
  on key label ctrl-i
  restore screen from ecran_menu
  menu = ""
return


PROCEDURE Etat_proc
  save screen to Ecran_menu
  menu = "PAD2S"
  menu_vert = bar()
  do case
    case bar() = 2
      Do rec_art
    case bar() = 3
      Do rec_gro
    case bar() = 4
      Do rec_fn
    case bar() = 5
      Do etat with "M",0
    case bar() = 6
      Do ETAT with "T",0
  endcase
  menu = ""
  on key label ctrl-i
  restore screen from ecran_menu
return


PROCEDURE etat
PARAMETERS Type, cle
select d
set order to code_art
set relation to no_compte into zfour
do case
   case Type = "A"
     set filter to code_art = cle
   case Type = "G"
     set filter to substr(code_art,1,len(cle)) = cle 
   case Type = "F"
     set filter to no_compte = cle
   case Type = "M"
     set filter to Qte_phys +  Qte_comm <= Qte_alerte
endcase
go top 
ligne = 7
val_sto = 0
do pres_eta
do message
on key label ctrl-i do imp with "ETAT"
save screen to ecr_etat
do while .not. eof() 
  @ ligne,1 SAY Code_art PICTURE "XXXXXXXX" 
  @ ligne,10 SAY Design PICTURE "XXXXXXXXXXXXXXXXXXXXXXXXX" 
  @ ligne,36 SAY Qte_alerte PICTURE "999" 
  @ ligne,40 SAY Prix_achat PICTURE "9,999,999.99" 
  IF QTE_PHYS > 0
    @ ligne,53 SAY Qte_phys PICTURE "9999" 
    val_sto = val_sto + qte_phys * prix_achat
  ELSE
    @ligne, 53 SAY "   0"
  ENDIF
  @ ligne,58 SAY Qte_comm PICTURE "9999" 
  @ ligne,63 SAY e->No_compte PICTURE "99999" 
  @ ligne,69 SAY e->Nom PICTURE "XXXXXXXXXX"
  ligne = ligne + 1
  skip
  if eof()
      Do message
      @23,15 say "FIN DE L'ETAT DU STOCK  (Appuyez sur une touche)";
      COLOR N/BG 
      read
      do etat_stat
      set cursor on
      @23,15 clear to 23,col()
      release screen ecr_etat
      set filter to
      return
  endif
  if ligne = 21
      rc = recno()
      @23,17 say  "Appuyez sur une touche pour VOIR LA SUITE  ";
      COLOR N/BG 
      read
      go rc
      set cursor on
      @23,17 clear to 23,col()
      ligne = 7
      restore screen from ecr_etat
  endif
enddo
release screen ecr_etat
set filter to
return


PROCEDURE etat_stat
  DO FENETRE WITH 9,23,13,55,"STATISTIQUES", opt_QUITTER
  @11,25 say "Valeur du stock : " COLOR W+/BG
  @11,col() say val_sto  PICTURE "9,999,999.99" COLOR W+/BG
  @23,0 clear to 23,79                     
  @23,29 say  "Appuyez sur une touche" ;
  COLOR N/BG 
  read
return


PROCEDURE rec_art
  restore screen from fond
  if menu = "PAD2S"
    do fenetre with 7,20,14,61,"ETAT DU STOCK",opt_menu
  else
    do fenetre with 7,20,14,61,"MVT DU STOCK",opt_menu
  endif
  save screen to ecr_actuel
  do while .T.
      on key label ctrl-I
      @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
      Num_art= space(8)
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
      Quitter = 'O'
      if menu = "PAD2S"
        do etat with "A", ltrim(Num_art)
        @24,26 say "Autre ‚tat de stock ? (O/N) " get Quitter PICTURE "Y";
        COLOR N/BG 
      else
        do mvt with "A", ltrim(Num_art),0
        @24,26 say "Autre MVT de stock ? (O/N) " get Quitter PICTURE "Y";
        COLOR N/BG 
      endif
      set filter to
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

PROCEDURE rec_gro
  restore screen from fond
  if menu = "PAD2S"
    do fenetre with 7,20,14,61,"ETAT DU STOCK",opt_menu
  else
    do fenetre with 7,20,14,61,"MVT DU STOCK",opt_menu
  endif
  save screen to ecr_actuel
  do while .T.
      on key label ctrl-I
      @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
      Num_art= space(8)
      Quitter = ' '
      rep ='O'
      @10,22 say "Groupe d'article : " get Num_art FUNCTION "!";
         COLOR GR+/B
      read
      if Num_art = space(8)
        loop
      endif
      Quitter = 'O'
      if menu = "PAD2S"
        do etat with "G", Trim(Num_art)
        @24,26 say "Autre ‚tat de stock ? (O/N) " get Quitter PICTURE "Y";
        COLOR N/BG 
      else
        do mvt with "G", Trim(Num_art),0
        @24,26 say "Autre MVT de stock ? (O/N) " get Quitter PICTURE "Y";
        COLOR N/BG 
      endif
      set filter to
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

PROCEDURE rec_fn
  restore screen from fond
  if menu = "PAD2S"
    do fenetre with 7,20,14,61,"ETAT DU STOCK",opt_menu
  else
    do fenetre with 7,20,14,61,"MVT DU STOCK",opt_menu
  endif
  save screen to ecr_actuel
  do while .T.
      on key label ctrl-I
      @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
      Num_art= 0
      Quitter = ' '
      rep ='O'
      ON READERROR Do cle_inv with "C"
      @10,22 say "Nø de compte : " get Num_art picture "99999";
         VALID Trouve(Num_art,"C");
         COLOR GR+/B
      read
      if Num_art = 0
        loop
      endif
      ON READERROR
      Quitter = 'O'
      if menu = "PAD2S"
        do etat with "F", Num_art
        @24,26 say "Autre ‚tat de stock ? (O/N) " get Quitter PICTURE "Y";
        COLOR N/BG 
      else
        do mvt with "F", Num_art,0
        @24,26 say "Autre MVT de stock ? (O/N) " get Quitter PICTURE "Y";
        COLOR N/BG 
      endif
      set filter to
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


PROCEDURE mvt
PARAMETERS Type, cle , cle2
select d
set order to code_art
set relation to no_compte into zfour
do case
   case Type = "A"
     set filter to code_art = cle
   case Type = "G"
     set filter to substr(code_art,1,len(cle)) = cle 
   case Type = "F"
     set filter to no_compte = cle
   case Type = "M"
     set filter to Qte_phys + Qte_comm <= Qte_alerte
   case Type = "R"
     set filter to qte_phys < 0
endcase
go top 
ligne = 7
tot_ven  = 0
tot_phys = 0
TOT_BO = 0
B_O = 0

do pres_mvt
do message
save screen to ecr_etat
on key label ctrl-i do imp with "MVT"
do while .not. eof() 
  manque = Qte_alerte - (Qte_phys + Qte_comm)
  if manque < 0
    manque = 0
  endif
   
  @ ligne,1 SAY Code_art PICTURE "XXXXXXXX" 
  @ ligne,10 SAY Design PICTURE "XXXXXXXXXXXXXXXXXXXXXXXX" 
  @ ligne,35 SAY manque PICTURE "9999" 
  @ ligne,42 SAY Qte_vendue PICTURE "9999" 
  IF QTE_PHYS < 0
    B_O = -QTE_PHYS
    @ ligne,47 SAY "   0" 
  ELSE
    B_O = 0
    @ ligne,47 SAY Qte_phys PICTURE "9999" 
    tot_phys = tot_phys + qte_phys
  ENDIF
  @ ligne,52 SAY Qte_comm PICTURE "9999" 
  @ ligne,59 SAY B_O PICTURE "9999"
  @ ligne,67 SAY Prix_vente PICTURE "9,999,999.99" 
  tot_ven = tot_ven + qte_vendue
  TOT_BO = TOT_BO + B_O
  ligne = ligne + 1
  skip
  if eof()
      Do message
      @23,15 say "FIN DU MVT DE STOCK  (Appuyez sur une touche)";
      COLOR N/BG 
      read
      do MVT_stat
      set cursor on
      @23,15 clear to 23,col()
      release screen ecr_etat
      set filter to
      return
  endif
  if ligne = 21
      rc = recno()
      @23,17 say  "Appuyez sur une touche pour VOIR LA SUITE  ";
      COLOR N/BG 
      read
      go rc
      set cursor on
      @23,17 clear to 23,col()
      ligne = 7
      restore screen from ecr_etat
  endif
enddo
release screen ecr_etat
set filter to
return


PROCEDURE MVT_STAT
  DO FENETRE WITH 7,22,15,55,"STATISTIQUES", opt_QUITTER
  @9,24 say "Qt‚e totale vendue   : " COLOR W+/BG
  @9,col() say tot_ven  PICTURE "9999999" COLOR W+/BG
  @11,24 say "Qt‚e totale physique : " color W+/BG
  @11,col() say tot_phys picture "9999999" color W+/BG
  @13,24 say "Qt‚e totale en B/O   : " color W+/BG
  @13,col() say tot_bo picture "9999999" color W+/BG
  @23,0 clear to 23,78
  @23,29 say  "Appuyez sur une touche" ;
  COLOR N/BG 
  read
RETURN

PROCEDURE REC_ROT
  DO MVT WITH "R",0,0
RETURN

PROCEDURE rec_OLD
  restore screen from fond
  do fenetre with 7,20,13,61,"MVT DU STOCK",opt_menu
  save screen to ecr_actuel
  do while .T.
      on key label ctrl-I
      @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
      rot_inf= 0
      rot_sup= 0
      Quitter = ' '
      rep ='O'
      @9,24 say "Rotation inf‚rieure : " get rot_inf PICTURE "999%"  range 0,100 COLOR GR+/B
      @11,24 say "Rotation sup‚rieure : " get rot_sup PICTURE "999%" range 0,100 COLOR GR+/B
      read
      Quitter = 'O'
      do mvt with "R", (rot_inf /100), (rot_sup /100) 
      @24,26 say "Autre MVT de stock ? (O/N) " get Quitter PICTURE "Y";
      COLOR N/BG 
      set filter to
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
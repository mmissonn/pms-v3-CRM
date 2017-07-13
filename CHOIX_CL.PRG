PROCEDURE Choix_client
  fn = "Client"
  do case
    case bar() = 1
      do Tous
    case bar() = 2
      do Intervalle_client
    case bar() = 3
      deactivate popup
  endcase 
  set filter to
  set order to
  restore screen from ecran_menu
  @8,32 fill to 12,49 color W/N
return


PROCEDURE Tous
  do case
    case Ordre = 'V'
      do view_client
    case Ordre = 'I'
      do imp with "Client"
    case Ordre = 'E'
      do Etiquet
  endcase
return


PROCEDURE Intervalle_client
  fn = "Client"
  nom_sup = " "
  nom_inf = " "
  restore screen from fond
  if nom_menu = "GEST_VEN"
    do fenetre with 7,20,17,61,"LISTE CLIENTS" ,opt_menu
  else
    do fenetre with 7,20,17,61,"LISTE FOURNISSEURS" ,opt_menu
  endif
  @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
  do while .T. 
    rep ='O'
    @10,26 say "De la lettre    " get nom_inf Function "!" COLOR GR+/B
    @12,26 say "Jusqu'…         " get nom_sup Function  "!" COLOR GR+/B
    read
    @24,30 say "Patientez S-V-P ..."
    do case
      case Ordre = 'V'
        do view_client
      case Ordre = 'I'
        do imp with "Client"
      case Ordre = 'E'
        do etiquet
    endcase
    exit
  enddo    
return


PROCEDURE Etiquet
  restore screen from fond
  do fenetre with 5,15 ,15,65,"ETIQUETAGE",opt_menu
  DEFINE POPUP pop_mail FROM 8,23
  DEFINE BAR 1 OF pop_mail PROMPT "1 ‚tiquette  3.5'' x 15/16''"
  DEFINE BAR 2 OF pop_mail PROMPT "3 ‚tiquettes 2.5'' x 15/16''"
  DEFINE BAR 3 OF pop_mail PROMPT "Quitter"
  ON SELECTION POPUP pop_mail Do Imp with "Etiquette"
  @9,25 fill to 13,54 color W/N
  activate popup pop_mail
  @9,25 fill to 13,54 color W+/B
  SET FILTER TO
  SET ORDER TO
  restore screen from ecran_menu
return


PROCEDURE view_client
  clear
  if nom_menu = "GEST_VEN"
    select zclient
    set order to ind_nom
  else
    select zfour
    set order to nom
  endif
  
  go top
  Xlig = 7
  do message
  if eof()
    if nom_menu = "GEST_VEN"
      @12,20 say " Il n'existe aucun client (Appuyez sur une touche)"; 
        COLOR N/BG 
    else
      @12,17 say " Il n'existe aucun fournisseur (Appuyez sur une touche)"; 
        COLOR N/BG 
    endif
    read
    @24,20 clear to 24,col()
    set order to
    SET FILTER TO
    deactivate MENU
    return to Master
  endif
  on key label ctrl-i do imp with "Client"
  do Present_client  
  do while  .not. eof() 
    if nom_inf <= substr(Nom,1,1) .and. nom_sup >= substr(Nom,1,1)
      @xlig,3 say No_compte
      @xlig,11 say ltrim(Nom)
      @xlig,38 say ltrim(Adresse)
      @xlig+1,38 say ltrim(Ville)
      @xlig+2,38 say ltrim(code_post)
      @xlig,65 say ltrim(Telephone)
      xlig = xlig + 4
    endif
    rep = ' '
    skip
    if eof()
      if nom_menu = "GEST_VEN"
        @24,20 say "FIN DE LA LISTE DES CLIENTS   (Appuyez sur une touche)";
             COLOR N/BG 
      else
        @24,18 say "FIN DE LA LISTE DES FOURNISSEURS (Appuyez sur une touche)";
             COLOR N/BG 
      endif
      read
      @24,18 clear to 24,col()
      on key label ctrl-i
      set order to      
      SET FILTER TO
      return 
    endif
    if xlig = 23
      @24,17 say "Appuyez sur une touche pour VOIR LA SUITE "; 
      COLOR N/BG 
      read
      @24,17 clear to 24,col()
      do message
      xlig = 7
      do while xlig <= 21
        @xlig,3 clear to xlig,8
        @xlig,11 clear to xlig,35
        @xlig,38 clear to xlig,62
        @xlig,38 clear to xlig,62
        @xlig,38 clear to xlig,62
        @xlig,65 clear to xlig,77
        xlig = xlig+1
      enddo
      xlig = 7
    endif
  enddo
  on key label ctrl-i
return


PROCEDURE Present_client
  @ 1,1 TO 22,78 DOUBLE 
  if nom_menu = "GEST_VEN"
    @ 1,31 SAY " LISTE DES CLIENTS " COLOR W+/B
  else
    @ 1,31 SAY " LISTE FOURNISSEUR " COLOR W+/B
  endif
  @ 0,30 to 2,50
  X = 2
  do while X <=78
    @ 4,X SAY "Ä" 
    @ 6,X Say "Ä"
    X = X + 1
  enddo
  @ 4,1 say chr(199)
  @ 5,2 SAY "NøCpte" 
  @ 5,22 SAY "Nom" 
  @ 5,47 SAY "Adresse" 
  @ 5,68 say "T‚l."
 
  @ 6,1 say chr(199)
  @ 6,78 say chr(182)
  @ 4,78 say chr(182)
  lig = 5
  do while lig <= 21
    @ lig,9 SAY "³" 
    @ lig,36 SAY "³" 
    @ lig,63 SAY "³"
    lig =lig + 1
  enddo 
  X = 4 
  Char = 194
  N = 0
  do while N < 3
    @X,9 say chr(char)
    @X,36 say chr(char)
    @X,63 say chr(char)
    if N = 0 
      char = 197
      X = X + 2
    else
      char = 207
      X = 22
    endif
    N = N + 1
  enddo
  @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/b
return


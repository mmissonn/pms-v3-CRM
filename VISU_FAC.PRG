PROCEDURE visu_fact
   do while .T.
     clear
     if nom_menu = "GEST_VEN" 
       select zfact
       set order to ind_fact
       secteur = "B"       
     else
       select zach
       set order to ind_ach
       secteur = "F"
     endif
     NoFact = 0
     datefact = {  /  /  }
     delai_paie = space(3)
     terme_paie = Space(28)
     vendeur_ = space(13)
     Compte=0
     do cadre
     do while .T.
       ON READERROR DO cle_inv with "V"
       @1,1 say "NøFact"  get NoFact PICTURE "99999999" VALID trouve(Nofact,"V");
            MESSAGE "Entrer le Nø de facture"  
       read
       if Nofact = 0
         loop
       endif 
       ON READERROR
       do cherche_fact
       do affiche_fact
       exit
     enddo
     choix = 'O'
     @24,20 say "Visualisation d'une autre facture ? (O/N) " get choix picture "Y";
     COLOR N/BG 
     read
     on key label ctrl-i
     DEACTIVATE WINDOW ALL
     release windows
     @24,20 clear to 24,col() 
     if choix = 'N'
       restore screen from ecran_menu
       return
     endif
  enddo

PROCEDURE cherche_fact
  do while  .T.
        do message
        ind = nofact
        @1,18 say "Vendeur " + ltrim(code_ven)
        @2,8  say date_fact
        @3,8  say ltrim(str(delai))+" jours      "
        @4,8  say ltrim(terme)
        if nom_menu = "GEST_VEN"    
          @5,8  say ltrim(str(No_command))
          @6,8  say date_comm
          @1,53 say ltrim(str(Code_clien))+"     "
          ZONE = "a"
        else
          @1,53 say ltrim(str(Code_four))+"     "
          ZONE = "e"
        endif
        do case
          case &zone->status = "R"
            @1,66 say "Revente"  
          case &zone->status = "C"
            @1,66 say "Consommation"  
          case &zone->status = "I"
            @1,66 say "Importation"  
          case &zone->status = "E"
            @1,66 say "Exportation"  
        endcase
        @2,53 say ltrim(&ZONE->Nom)  
        @3,53 say ltrim(&ZONE->Adresse)  
        @4,53 say ltrim(&ZONE->Ville)  
        @5,53 say ltrim(&ZONE->Code_post)
        @6,53 say ltrim(&ZONE->Telephone)
        @8,2 clear to 8,79
        do case
          case Proforma
            if nom_menu = "GEST_VEN"
              @8,2 say "FACTURE PROFORMA Nø "+ltrim(str(Nofact)) COLOR GR+/B
            else
              @8,2 say "COMMANDE Nø "+ltrim(str(Nofact)) COLOR GR+/B
            endif
          case note_cr
            @8,2 say "NOTE DE CREDIT Nø "+ltrim(str(Nofact)) COLOR GR+/B
          otherwise
            @8,2 say "FACTURE Nø "+LTRIM(str(Nofact)) COLOR GR+/B
        endcase
        save screen to ecran_fact
        return
   enddo
return  


PROCEDURE Affiche_fact
  on key label ctrl-i do imp with "Facture"

  if nom_menu = "GEST_ACHAT"
    select zdet_a
  else
    select zdet_v
  endif
  set filter to no_fact = nofact
  set order to ind_fact
  seek(nofact)
  set relation to code_art into d
  norec = recno()
  do while .T.
    ligne = 12
    do while ligne <= 22 .and. reccount() >= recno();
             .and. .not. eof() .and. .not. delete() 
      @ ligne,1 say CODE_ART   
      @ ligne,10 say D->DESIGN
      @ ligne, 36 say QTE picture "99999" 
      @ ligne, 47 say P_U picture "9,999,999.99" 
      @ ligne, 64 say QTE*P_U picture "9,999,999.99"
      ligne = ligne + 1
      if .not. eof()
        skip
      else
        exit
      endif
    enddo
    @24,20 say "Appuyez sur une touche pour continuer" COLOR N/BG
    read
    @24,20 clear to 24,col()
    do message
    if eof()
      exit
    endif
    restore screen from ecran_fact
  enddo 
  go norec

  tot_ht = &secteur->TOTAL_HT /(1-(&SECTEUR->REDUCTION/100))
  deduc = tot_ht * &SECTEUR->reduction /100

  DO FENETRE WITH 8,24,21,57,"TOTAL", opt_QUITTER
  @10,28 say "Total ht    : " COLOR W+/BG
  @10,COL() SAY tot_ht PICTURE "99,999,999.99" COLOR W+/BG
  @11,28 say "% r‚duction : "  COLOR W+/BG
  @12,28 say "D‚duction   : " COLOR W+/BG
  @13,28 say "              --------------" color W+/bg
  @14,28 say "Total ht    : " COLOR W+/BG
  @16,28 say "TPS 7%      : " COLOR W+/BG
  @17,28 say "TVQ         : " COLOR W+/BG
  @18,28 say "Total ttc   : " COLOR W+/BG
  @12,41 say -deduc PICTURE "999,999,999.99" COLOR W+/BG
  @14,42 SAY &SECTEUR->TOTAL_HT  PICTURE "99,999,999.99" COLOR W+/BG
  @18,42 SAY &SECTEUR->TOTAL_TTC  PICTURE "99,999,999.99" COLOR W+/BG
  @16,42 say &SECTEUR->TPS PICTURE "99,999,999.99" COLOR W+/BG
  @17,42 say &SECTEUR->TVQ PICTURE "99,999,999.99" COLOR W+/BG
  @11,48 say &SECTEUR->REDUCTION picture "999.99%" COLOR W+/BG
  set filter to
  release screen ecran_fact
return



PROCEDURE init_crediter
  option = prompt()
  restore screen from fond
  if nom_menu = "GEST_VEN"
    do fenetre with 7,20,16,61, "CREDITER",opt_menu
  else
    do fenetre with 7,20,16,61, "DEBITER",opt_menu
  endif
  @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
  Num_fact = space(8)
  Cmpte = space(5)
  Montant_paye = 0
  do Crediter
return


PROCEDURE Crediter
  do while .T.
    do while .T. 
      Sortie = .F.
      Confirme = ' '
      Encore = ' '
      rep ='O'
      @9,22  say  "NøCompte           :  " get Cmpte  PICTURE "99999" color GR+/B
      @10,22 say  "NøFacture          :  " get Num_fact PICTURE "99999999" color GR+/B
      @11,22 say  "Montant            :  " get Montant_paye PICTURE "9,999,999.99" Color GR+/B
      @12,22 say  "Ancien Solde       :              " Color GR+/B
      @13,22 say  "Nouveau Solde      :              " Color GR+/B
      read
      if val(cmpte) = 0
        loop
      endif
      @24,30 say "Patientez S-V-P ..."
  ****
      set order to
      if nom_menu = "GEST_VEN"
        select b
        ZONE = "a"
        set order to ind_fact        
      else
        select f
        ZONE = "e"
        set order to ind_ach       
      endif

      seek val(Num_fact)
      do Effacer_message
      if found()
        if .not. Proforma
          if &ZONE->No_compte <> val(Cmpte)
            @24,10 say "Facture Nø "+TRIM(Num_fact)+" n'appartient pas au compte Nø ";
            +trim(Cmpte)+". (appuyez une touche) " COLOR N/BG
            read
            @24,10 clear to 24,79
            @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
            sortie = .F.
          else
            if total_ttc - mont_paye >= Montant_paye
              @9,42 clear to 9,57
              @9,43 say Cmpte  color GR+/B
              @10,42 clear to 11,57 
              @10,43 say Num_fact  color GR+/B
              @11,42 clear to 12,57 
              @11,43 say Montant_paye picture "9,999,999.99" color GR+/B
              @12,43 say &ZONE->Solde PICTURE "9,999,999.99" color GR+/B
              @13,42 clear to 14,57
              @13,43 say (&ZONE->Solde - Montant_paye) picture "9,999,999.99" color GR+/B
              @24,25 say "ETES-VOUS CERTAIN ? (O/N) " COLOR N/BG
              @row(),col() get Confirme PICTURE "Y"
              read
              do Effacer_message 
              if confirme = 'O'
                @24,30 say "...Patientez S-V-P ! " COLOR N/BG
                replace Mont_paye with Mont_paye + Montant_paye
                replace &ZONE->Solde with &ZONE->Solde - Montant_paye
                do Effacer_message
                @24,16 say "AFFECTATION DU COMPTE TERMINEE. (Appuyez sur une touche)" COLOR N/BG
                read
                do Effacer_message
                Sortie = .T.
              endif
            else
              save screen to tempo
              @15,22 say  "Solde de la facture:   " color GR+/B
              @15,col() say total_ttc - mont_paye  PICTURE "9,999,999.99" COLOR GR+/B
              @23,15 say "Montant … payer sup‚rieur au montant de la facture " color n/bg
              @24,30 say "Appuyez sur une touche " COLOR N/BG
              read
              restore screen from tempo
            endif  
          endif
        else
          Sortie = .F.
          @24,20 say "Facture Nø "+TRIM(Num_fact)+ " est un PROFORMA (appuyez sur une touche)";
                      COLOR N/BG
          read
          do Effacer_message
          exit
        endif
      else
        @24,20 say "Facture Nø "+TRIM(Num_fact)+ " n'existe pas. (appuyez sur une touche)" COLOR N/BG
        read
        do Effacer_message
      endif
      if Sortie
         Cmpte = space(5)
         Num_fact  = space(8)
         Montant_paye = 0
         exit
      endif
    enddo
    Encore = 'O'
    @24,20 say option+" un autre compte ? (O/N) " get Encore PICTURE "Y";
    COLOR N/BG 
    read
    @24,20 clear to 24,col()
    release tempo
    if Encore = 'N'
       restore screen from ecran_menu
       return
    endif
  enddo
return



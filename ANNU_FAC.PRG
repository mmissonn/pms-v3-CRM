PROCEDURE annu_fact
  restore screen from fond
  do fenetre with 7,20,14,61,"ANNULATION",opt_menu
  save screen to ecr_actuel
  do while .T.
      QT = 0
      @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
      Num_fact=space(8)
      IF nom_menu = "GEST_ACHAT"
        select zach      
        set order to ind_ach
        ZONE= "E"
      else
        select zfact
        set order to ind_fact
        ZONE= "A"
      endif
      Confirme = ' '
      Quitter = ' '
      rep ='O'
      ON READERROR Do cle_inv with "V"
      @10,22 say "NøFacture : " get Num_fact PICTURE "99999999";
         VALID Trouve(val(Num_fact),"V");
         COLOR GR+/B
      read
      if val(Num_fact) = 0
        loop
      endif
      ON READERROR
      seek val(num_fact)
      @24,30 say "Patientez S-V-P ..."
      confirme ='N'
      @24,18 say "Voulez-vous VRAIMENT ANNULER cette facture ? (O/N) ";
      get Confirme PICTURE "Y"  COLOR N/BG
      read
      @24,14 CLEAR to 24,col()
      if confirme = 'O'
        do fenetre with 9,25,15,55,"TRAITEMENT",opt_attent
        @11,29 say "Annulation en cours ..." COLOR W+/G
        @13,29 say "Soyez patient S-V-P ! " COLOR W+/G
        type_fact = ""
        if  note_cr
           Replace &ZONE->Solde with &ZONE->Solde + Total_ttc
           type_fact = "N"
        else 
           if proforma
             type_fact = "P"
           else
             Replace &ZONE->Solde with &ZONE->Solde - Total_ttc
             type_fact = "F"
           endif
        endif
        delete 
        if nom_menu= "GEST_ACHAT"
          select zdet_a
        else 
          select zdet_v
        endif 
        seek val(num_fact)
        set relation to code_art into zart
        do while no_fact = val(num_fact) .and. .not. eof()
           do case
             case type_fact = "P" .and. alias() = "ZDET_A" 
               replace d->qte_comm with d->qte_comm - qte 
             case  (type_fact = "F" .and. alias() = "ZDET_V") .or. (type_fact = "N" .and. alias()="ZDET_V") 
               replace d->qte_phys with d->qte_phys + qte 
               replace d->qte_vendue with d->qte_vendue - qte 
             case (type_fact = "N" .and. alias()="ZDET_A") .or. (type_fact = "F" .and. alias() = "ZDET_A" )
               replace d->qte_phys with d->qte_phys - qte 
           endcase
           skip  
        enddo
        delete all for no_fact = val(num_fact)
        @11,29 fill to 13,col() color W+/G
        @11,29 say "...Annulation termin‚ !" COLOR W+/G
        @13,29 say "                      " COLOR W+/G

      endif            
    Quitter = 'O'
    @24,20 say "Annulation d'une autre facture ? (O/N) " get Quitter PICTURE "Y";
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
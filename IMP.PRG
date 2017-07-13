PROCEDURE imp
  PARAMETER fn
  PRIVATE Position
  imprimer = .F.
  Cx=col()
  Lx=row()
  if prompt() = "Quitter"
    restore screen from ecran_menu
    deactivate popup
  endif
  save screen to xecran
  do erreur
  if imprimer 
    on error do erreur
    do fenetre with 9,25,12,50,"TRAITEMENT", opt_attent
    @10,27 say " Op‚ration en cours ..."  COLOR &opt_attent
    @11,27 say " Soyez patient S-V-P   " COLOR  &opt_attent
    set console off
        _peject = "NONE"
    do case
      case fn = "Etiquette"
        if nom_menu = "GEST_VEN"
          select a
        else
          select e
        endif
        set order to ind_nom
        set filter to substr(Nom,1,1) >=nom_inf .and. substr(Nom,1,1)<=Nom_sup 
        if bar() = 1
          label form etiquet1 to print
        endif
        if bar() = 2
          label form etiquet3 to print
        endif 
        set filter to
      case fn = "Facture"
        if nom_menu = "GEST_VEN"
          select zdet_v
          ZONE = "a"
        else
          select zdet_a
          ZONE = "e"
        endif
        set order to ind_fact
        set filter to no_fact = ind
        go top
        position = recno()
        report form prn_fact to print
        SET FILTER TO
      case fn = "Client"
        if nom_menu = "GEST_VEN"
          select a
        else
          select e
        endif
        set order to ind_nom
        set filter to substr(Nom,1,1) >= Nom_inf .and. substr(Nom,1,1) <= Nom_sup 
        position = recno()
        report form list_client to print
        go position
        set filter to
      case fn = "Releve"
        report form releve to print
      case fn = "Debiteur"
        position = recno()
        report form prn_db to print          
        go position
      case fn = "ETAT"
        position = recno()
        report form etat to print          
        go position
      case fn = "MVT"
        position = recno()
        report form mvt to print          
        go position
      case fn = "Journal"
        position = recno()
        IF NOM_MENU = "GEST_VEN"
          report form jour_ven to print
        ELSE
          select i
	  set order to date
          set filter to date >= date_inf .and. date <= date_sup
          report form rapp_dep to print
          set filter to   
  	ENDIF
        go position
      case fn = "VENDEUR"
        select zfact
        set filter to code_ven = vendeur_ .and. date_fact >= date_inf .and. date_fact <= date_sup;
           .and. .not. proforma
        report form rapp_ven to print
        set filter to   
    endcase 
    on error
    set console on
    @10,27 say " ...Op‚ration termin‚e " COLOR &opt_attent
    @11,27 say "                       " COLOR &opt_attent
    restore screen from xecran
    @lx,cx say ""
    set cursor on
  endif
  fn = ""
return



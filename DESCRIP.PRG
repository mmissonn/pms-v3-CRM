***** MODIF LE 30-06-93 POUR TVO ONTARIO


PROCEDURE Descrip
PARAMETERS fact_prof
 clear gets
 rec = 0
 set cursor off
 do deplace
 nom_proced = "description"
 define window descrip from 12,1 to 22,78 none color W+/B
 activate window descrip
 @ 0,8 TO 10,8 
 @ 0,34 TO 10,34 
 @ 0,40 TO 10,40
 @ 0,61 TO 10,61 
 declare element[110,5]
 indice = 1
 pos_indice = 1
 indice_max = 0
 ligne = 0
 @ ligne, 0 fill to ligne,7 color N/W
 @ ligne, 35 fill to ligne,39 color N/W
 @ ligne, 47 fill to ligne,59 color N/W
 Xpos = 1
 saut_page =.F.
 do init
 if option = "Note de cr‚dit"
   sym1 = "9999-"
   sym2 = "9,999,999.99-"
 else
   sym1 = "9999"
   sym2 = "9,999,999.99"
 endif
 if option = "Facture" .and. nom_menu = "GEST_ACHAT"
   saut_page = .T.
   do mem_prof
 endif
 do while .t.
   if indice <= 0
     indice = 1
   endif
   activate screen
   @6,37 say ltrim(str((int(indice/31) + 1 )))+ " " COLOR GR+/B
   activate window descrip
   if indice_max >= pos_indice - 1 
     do init
   endif
   compteur=0
   if element[indice,1] = space(8) 
     element[indice,2]  = space(25)
     element[indice,3]  = 0
     element[indice,4]  = 0
     element[indice,5]  = "N"
   endif
   if saut_Page
     clear
     @ 0,8 TO 10,8 
     @ 0,34 TO 10,34 
     @ 0,40 TO 10,40
     @ 0,61 TO 10,61 
     ligne = 0
     do while ligne <= 10 .and. saut_page .and. indice <= indice_max
       if element[indice,1] <> space(8)
         @ ligne,0 say element[indice,1]   
         @ ligne, 9 say element[indice,2]  
         @ ligne, 35 say element[indice,3] picture sym1
         @ ligne, 47 say element[indice,4] picture "9,999,999.99" 
         @ ligne, 65 say element[indice,3]*element[indice,4] picture sym2 
       endif
       compteur = compteur + 1
       ligne = ligne + 1
       indice = indice + 1
     enddo
     indice = indice - compteur 
     ligne = 0
     @ ligne,9 fill to ligne,62 color W+/B
     saut_page = .F.
   endif
   @ ligne, 0 fill to ligne,7 color N/W
   @ ligne, 35 fill to ligne,39 color N/W
   @ ligne, 47 fill to ligne,59 color N/W
   set cursor on
   do case
     case xpos = 1
    *** a modifier : problemes avec les appels a F2 incontrol‚s
	       
*       ON KEY LABEL F2 DO Article
       ON READERROR Do cle_inv with "A"
       @ ligne, 0 get element[indice,1] function "!" VALID Trouve(element[indice,1], "A");
          MESSAGE "Entrer le code d'article"
    ***
     case xpos = 3
       @ ligne, 35 get element[indice,3] picture sym1 range 0,9999 ;
          MESSAGE "Entrer la quantit‚"
     case xpos = 4
       @ ligne, 47 get element[indice,4] PICTURE "9,999,999.99" ;
          MESSAGE "Entrer le prix unitaire"

   endcase
   read
 *  ON KEY LABEL F2
   ON READERROR
   set cursor off
   do case
      case readkey()=270
       if indice > indice_max
         indice_max = indice
       endif
       exit
      case readkey() = 6 .or. readkey() = 262
        if indice > 11
          indice  = indice - 11
        else 
          indice = 1
        endif
        ligne = 0
        saut_page = .T.
        *PgUp
      case readkey() = 7 .or. readkey() = 263           
        if indice <= 94
          if (indice_max + 11 - mod(indice_max,11)) >= pos_indice - 1
            do init
          endif 
          indice = indice + 1 + (11-mod(indice,11))
        else
          indice  = 99
        endif
        ligne = 0
        saut_page = .T.
        *PgDn
      case (readkey() = 1 .or. readkey() = 257 .or. readkey() = 15 .or. readkey() = 271 .or. lastkey() = 9 )
        do case
          case xpos = 1
            xpos = 3
          case xpos = 3
            xpos = 4
          case xpos = 4
            xpos = 1

            do down
        endcase
        *Enter
      case  (readkey() = 0 .or. readkey() = 256 .or. lastkey() = -400)
         do case
           case xpos = 1
             do Up
           case xpos = 3
             xpos = 1
          case xpos = 4
            xpos = 3

         endcase
        *Shift Tab + Fleche gauche
      case (readkey() = 5 .or. readkey() = 261)
        do down
      case (readkey() = 4 .or. readkey() = 260)  
        do up
    endcase
    if indice > indice_max
      indice_max = indice
    endif
  enddo
  nom_proced = " "
  activate screen
  tot_ht = 0
  taxe1 = 0
  taxe2 = 0
  tot_ttc = 0
  prod = 0
  serv = 0
  if indice_max > 110
    indice_max = 110
  endif
  do afficher_montant
  choix = 'O'
  set cursor on
  @24,0 clear to 24,79
  if readkey() = 270 
    @24,20 clear to 24,col() 
    ind = fact_prof
    do message
    if nom_menu= "GEST_ACHAT"
      select zdet_a
    else
      select zdet_v
    endif 
    on key label ctrl-i do imp with "Facture"
    @24,30 say "SOYEZ PATIENT S-V-P !"
    pos = 1
    nb = 0
    if option = "Facture" .and. nom_menu = "GEST_ACHAT"
      go rec
    endif
    set deleted on
    if nom_menu = "GEST_ACHAT"
      do save_ach
    else
      do save_ven
    endif
    return
   else
     return
   endif
return   


PROCEDURE mem_prof
  if nom_menu = "GEST_ACHAT"
    select zdet_a
  else
    select zdet_v
  endif
  set order to ind_fact
  seek fact_prof
  set relation to code_art into zart
  rec = recno()
  indice_max = 0
    
  do while .not. eof()  .and. no_fact = fact_prof
    indice_max = indice_max + 1
    element[indice_max,1] = code_art 
    element[indice_max,2] = d->design
    element[indice_max,3] = qte
    element[indice_max,5] = d->service
    element[indice_max,4] = p_u
    skip 
  enddo
return

PROCEDURE  init
  pos_indice = indice_max + 1
  nb = 1
  store space(8) to element[pos_indice,1],element[pos_indice+1,1],;
       element[pos_indice+2,1],element[pos_indice+3,1],;
       element[pos_indice+4,1],element[pos_indice+5,1],;
       element[pos_indice+6,1],element[pos_indice+7,1],;
       element[pos_indice+8,1],element[pos_indice+9,1],;
       element[pos_indice+10,1],element[pos_indice+11,1],;
       element[pos_indice+12,1],element[pos_indice+13,1]
  store  0 to  element[pos_indice,3],element[pos_indice+1,3],;
       element[pos_indice+2,3],element[pos_indice+3,3],;
       element[pos_indice+4,3],element[pos_indice+5,3],;
       element[pos_indice+6,3],element[pos_indice+7,3],;
       element[pos_indice+8,3],element[pos_indice+9,3],;
       element[pos_indice+10,3],element[pos_indice+11,3],;
       element[pos_indice+12,3],element[pos_indice+13,3]

return

    
PROCEDURE up
  if indice > 1
    if ligne > 0
      @ ligne,0 fill to ligne,62 color  W+/B
      if element[indice,1] <>  space(8)
        @ ligne,65 say element[indice,3]*element[indice,4] picture sym2
      else
        @ ligne,9   say space(25) 
        @ ligne,35  say space(5) 
        @ ligne,47  say space(12) 
        @ ligne,65 say space(12)

      endif
      indice = indice - 1
      ligne = ligne-1
    else
      clear
      @ 0,8 TO 10,8 
      @ 0,34 TO 10,34 
      @ 0,40 TO 10,40
      @ 0,61 TO 10,61 

      indice = indice - 1
      temp = indice
      do while ligne <= 10 
        if element[indice,1] <> space(8)
          @ ligne,0 say element[indice,1]   
          @ ligne, 9 say element[indice,2]  
          @ ligne, 35 say element[indice,3] picture sym1 
          @ ligne, 47 say element[indice,4] picture "9,999,999.99" 
          @ ligne,65 say element[indice,3]*element[indice,4] picture sym2 
        endif
        ligne =ligne + 1
        indice = indice + 1
      enddo
      ligne = 0
      indice = temp
      if element[indice,1] <> space(8)
         @ ligne,0 say element[indice,1]   color N/W
         @ ligne, 9 say element[indice,2]  
         @ ligne, 35 say element[indice,3] picture sym1 color N/w
         @ ligne, 47 say element[indice,4] picture "9,999,999.99" color N/W
         @ ligne,65 say element[indice,3]*element[indice,4] picture sym2 
      endif
    endif
  endif
return



PROCEDURE Down
  if indice < 110
      @ ligne,0 fill to ligne,71 color  W+/B
      if element[indice,1] <> space(8)
        @ ligne,65 say element[indice,3]*element[indice,4] picture sym2
      else
        @ ligne,9   say space(25) 
        @ ligne,35  say space(5) 
        @ ligne,47  say space(12) 
        @ ligne,65 say space(12)
      endif
    if ligne < 10
      indice = indice + 1
      ligne = ligne + 1
    else  
      indice = indice + 1
      ligne = 10
      @ ligne,77 say "  "
      @ 0,8 TO 10,8 
      @ 0,34 TO 10,34 
      @ 0,40 TO 10,40
      @ 0,61 TO 10,61 
      if element[indice,1] <> space(8)
         @ ligne,0 say element[indice,1]   color N/W
         @ ligne, 9 say element[indice,2] 
         @ ligne, 35 say element[indice,3] picture sym1 color N/w
         @ ligne, 47 say element[indice,4] picture "9,999,999.99" COLOR N/W
         @ ligne,65 say element[indice,3]*element[indice,4] picture sym2 
      else
         @ ligne, 35 say space(5)
      endif
    endif
  endif
return


PROCEDURE save_ach
    do while pos <= indice_max             
      if option = "Facture"
        if (element[pos,1] = Space(8)) .and. no_fact = fact_prof
          delete
        else 
          if element[pos,1] <> space(8)
            if no_fact <> fact_prof .or. eof()
              append blank
              replace No_fact with fact_prof
            endif            
            replace code_art with element[pos,1]
            replace Qte with element[pos,3]
            replace p_u with element[pos,4]
            set relation to code_art into zart 
            replace d->qte_comm with (d->qte_comm - element[pos,3])
            replace d->qte_phys with (d->qte_phys + element[pos,3])

*** a modifier pour nomenclatures            

            nb = nb + 1
          endif
        endif
        if .not. eof() .and. no_fact = fact_prof
          skip
        endif
      else
        if element[pos,1] <> space(8)
          append blank
          replace No_fact with fact_prof
          replace code_art with element[pos,1]
          replace Qte with element[pos,3]
          replace p_u with element[pos,4]
          set relation to code_art into zart 
          if option = "Commande"
            replace d->qte_comm with (d->qte_comm + element[pos,3])
          else
            replace d->qte_phys with (d->qte_phys + element[pos,3])
	  endif
          nb = nb + 1
        endif
      endif
      pos = pos + 1
    enddo
    set filter to
    if nb <> 0 
      select zach
      do case
        case option = "Commande"
          append blank
          replace zach->code_four with Compte
          replace zach->no_fact with fact_prof
          replace zach->proforma with .T.
          replace zach->note_cr with .F.
          replace zach->terme with ltrim(terme_paie)
          replace zach->delai with val(delai_paie)
        case option = "Note de cr‚dit"
          append blank
          replace zach->code_four with Compte
          replace zach->no_fact with fact_prof
          replace zach->proforma with .F.
          replace zach->note_cr with .T.
          replace zach->terme with ltrim(terme_paie)
          set relation to code_four into zfour
          replace e->solde with e->solde + tot_ht+taxe1+taxe2
        otherwise
          goto Norec
          replace zach->terme with ltrim(terme_paie)
          replace zach->delai with val(delai_paie)
          replace zach->proforma with .F.
          replace zach->note_cr with .F.

          if val(delai_paie) <> 0 
            replace e->solde with e->solde + tot_ht+taxe1+taxe2
          else
            replace zach->Mont_paye with tot_ht+taxe1+taxe2
          endif
      endcase

      replace zach->code_ven with ltrim(vendeur_)
      replace zach->date_fact with date_
      replace zach->total_ht with tot_ht
      replace zach->reduction with reduc
      replace zach->tps with taxe1
      replace zach->tvq with taxe2
      replace zach->total_ttc with tot_ht+taxe1+taxe2
    endif
return

***** MODIF LE 30-06-93 POUR TVO ONTARIO
PROCEDURE save_ven
    do while pos <= indice_max             
*      if option = "Facture"
*        if (element[pos,1] = Space(8)) .and. no_fact = fact_prof
*          delete
*        else 
*          if element[pos,1] <> space(8)
*            if no_fact <> fact_prof .or. eof()
*              append blank
*              replace No_fact with fact_prof
*            endif            
*            replace code_art with element[pos,1]
*            replace Qte with element[pos,3]
*            replace p_u with element[pos,4]
*            set relation to code_art into zart 
*            replace d->qte_phys with (d->qte_phys - element[pos,3])
*            replace d->qte_vendue with (d->qte_vendue + element[pos,3])
*            nb = nb + 1
*          endif
*        endif
*        if .not. eof() .and. no_fact = fact_prof
*          skip
*        endif
*      else
        if element[pos,1] <> space(8)
          append blank
          replace No_fact with fact_prof
          replace code_art with element[pos,1]
          replace Qte with element[pos,3]
          replace p_u with element[pos,4]
          set relation to code_art into zart 
*          if option = "Note de cr‚dit" 
            replace d->qte_phys with (d->qte_phys - element[pos,3])
            replace d->qte_vendue with (d->qte_vendue + element[pos,3])
*         endif
          nb = nb + 1
        endif
*      endif
      pos = pos + 1
    enddo
    set filter to
    if nb <> 0 
      select zfact
      do case
        case option = "Facture"
          append blank
          replace zfact->code_clien with Compte
          replace zfact->no_fact with fact_prof
          replace zfact->proforma with .F.
          replace zfact->note_cr with .F.
          replace zfact->terme with ltrim(terme_paie)
          replace zfact->delai with val(delai_paie)
          replace zfact->date_comm with date_cmde
          replace zfact->no_command with val(no_cmde)
          if val(delai_paie) <> 0
            set relation to code_clien into zclient
            replace a->solde with a->solde + tot_ht+taxe1+taxe2
          else
            replace zfact->Mont_paye with tot_ht+taxe1+taxe2
          endif
        case option = "Note de cr‚dit"
          append blank
          replace zfact->code_clien with Compte
          replace zfact->no_fact with fact_prof
          replace zfact->proforma with .F.
          replace zfact->note_cr with .T.
          replace zfact->terme with ltrim(terme_paie)
          set relation to code_clien into zclient
          replace a->solde with a->solde + tot_ht+taxe1+taxe2
*        otherwise
*          goto Norec
*          replace zfact->terme with ltrim(terme_paie)
*          replace zfact->delai with val(delai_paie)
*          replace zfact->proforma with .F.
*          replace zfact->note_cr with .F.
*          replace zfact->date_comm with date_cmde
*          replace zfact->no_command with val(no_cmde)
*          replace a->solde with a->solde + tot_ht+taxe1+taxe2
      endcase

***** MODIF LE 30-06-93 POUR TVO ONTARIO
      replace zfact->code_ven with ltrim(vendeur_)
      replace zfact->date_fact with date_
      replace zfact->total_ht with tot_ht
      replace zfact->reduction with reduc
      replace zfact->tps with taxe1

*** Si l'indice t3 vaut 1000 c'est la taxe de vente ONTARIO
      if t3 = 1000 
         replace zfact->tvo with taxe2
         replace zfact->tvq with 0
      else
         replace zfact->tvo with 0
         replace zfact->tvq with taxe2
      endif
      replace zfact->total_ttc with tot_ht+taxe1+taxe2
    endif
return

  

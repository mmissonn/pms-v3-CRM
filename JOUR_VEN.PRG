PROCEDURE Jour_ven
PARAMETERS date_inf, date_sup

if nom_menu = "GEST_VEN"
  select b
  ** set order to ind_jour
  set order to ind_date
  ZONE = "a"
  set filter to date_fact >=date_inf .and. date_fact <= date_sup .and. .not. proforma
else
  DO JOUR_DEP
  RETURN
endif

go top
if eof()
  do beep
  do fenetre with 8,20,13,59,"",opt_quitter
  @10,22 say "Aucune facture pour cette p‚riode !" color W+/BG
  @11,22 say "    Appuyer sur une touche" color W+/BG
  read
  set filter to
  restore screen from ecran_menu
  return
endif
ON KEY LABEL Ctrl-I do imp with "Journal"
do pres_jour
do message
save screen to ecr_jour
debut = 9
tot_master=0
tot_check=0
tot_cash=0
tot_tps=0
tot_tvq=0
tot_tvo=0
tot_gal=0
master=0
cheque=0
cash=0

do while .T.
  ligne = debut
  
  do while .not. eof() .and. ligne <= 21

    @LIGNE,0 SAY LTRIM(STR(No_fact)) PICTURE "9999999"
    @LIGNE,8 SAY  Date_fact

*** MODIF LE 26/06/93 POUR TVO ONTARIO

**    if Terme = "MASTER"
**      master=TOTAL_HT
**      cheque=0
**      cash=0
**      @LIGNE,17 SAY master PICTURE "9,999.99" 
**    else

      if Terme = "CHEQUE"
        master=0
        cheque=TOTAL_HT
        cash=0
        @LIGNE,27 SAY cheque PICTURE "99,999.99" 
      else
        if Terme = "CASH"
          master=0
          cheque=0
          cash=TOTAL_HT
          @LIGNE,17 SAY cash PICTURE "9,999.99" 
        endif
      endif

**    endif

    @LIGNE,39 SAY  Tps PICTURE "9,999.99" 
    @LIGNE,49 SAY  Tvo PICTURE "9,999.99" 
    @LIGNE,59 SAY  Tvq PICTURE "9,999.99" 
    @LIGNE,69 SAY  Total_ttc PICTURE "999,999.99" 

    tot_master=tot_master+MASTER
    tot_check=tot_check+CHEQUE
    tot_cash=tot_cash+CASH
    tot_tps=tot_tps+TPS
    tot_tvq=tot_tvq+TVQ
    tot_tvo=tot_tvo+TVO
    tot_gal=tot_gal+TOTAL_TTC

    ligne = ligne + 1
    skip
  enddo

  if eof()
    do Attente
    do stat
    
    @24,27 say "FIN DU JOURNAL DES VENTES" COLOR N/BG 
    read
    @24,27 clear to 24,col()
    exit
  else
    do Attente
    restore screen from ecr_jour
  endif  
enddo
ON KEY LABEL Ctrl-i 
release screen ecr_jour
set filter to
restore screen from ecran_menu
return


PROCEDURE Attente
  @24,0 say "<Ctrl-Q>-Quitter" color gr+/B
  @24,29 SAY "Appuyer sur une touche" COLOR N/BG
  read
  @24,0 clear to 24,79
  @24,0 say "<Ctrl-Q>-Quitter" color gr+/B
return


PROCEDURE Stat

@22,15 SAY tot_cash PICTURE "999,999.99" 
@22,26 SAY tot_check PICTURE "999,999.99" 
@22,37 SAY tot_tps  PICTURE "999,999.99" 
@22,48 SAY tot_tvo PICTURE "99,999.99" 
@22,58 SAY tot_tvq PICTURE "99,999.99"
@22,69 SAY tot_gal PICTURE "999,999.99"

return


PROCEDURE Pres_jour
clear
@ 0,29 TO 2,50 
@ 1,0 TO 6,79 
@ 1,29 SAY "´ JOURNAL DES VENTES Ã" 

if date_inf <> date() .and. date_sup <> date()
   @ 3,3 SAY "le " 
   @ 3,6 SAY date() 
endif
if date_inf <> date_sup
  @ 4,25 SAY "Du " 
  @ 4,37 SAY "jusqu'au " 
  @ 4,28 SAY date_inf
  @ 4,46 SAY date_sup 
else
  @ 4,33 SAY "Du " 
  @ 4,36 SAY date_inf
endif
  

@7,0 SAY "Fact" 
@7,10 SAY "Date" 
@7,18 SAY "Cash  " 
@7,28 SAY "ChŠque" 
@7,42 SAY "T.P.S"
@7,51 SAY "T.V.O" 
@7,61 SAY "T.V.Q" 
@7,71 SAY "TOT_TTC" 

return


PROCEDURE JOUR_DEP
select i
set order to DATE
set filter to date >=date_inf .and. date <= date_sup
go top
if eof()
  do beep
  do fenetre with 8,20,13,59,"",opt_quitter
  @10,22 say "Aucune facture pour cette p‚riode !" color W+/BG
  @11,22 say "    Appuyer sur une touche" color W+/BG
  read
  set filter to
  restore screen from ecran_menu
  return
endif
ON KEY LABEL Ctrl-I do imp with "Journal"
do pres_dep
do message
save screen to ecr_jour
debut = 9
tot_ht_ = 0
dep=0
pub=0
loc=0
div=0
ach=0
tf=0
tq=0
tot_ttc=0
TTC_ =0

do while .T.
  ligne = debut
  
  do while .not. eof() .and. ligne <= 21
    ttc_=tot_ht + tps + tvq
    tf=tf+TPS
    tq=tq+TVQ
    tot_ttc=tot_ttc+TTC_

    @LIGNE,0 SAY Date
    @LIGNE,9 SAY Libelle FUNCTION "T" PICTURE "XXXXXXX" 
    if depense = "D"
      @LIGNE,17 SAY Tot_ht PICTURE "9999.99" 
      dep=dep+TOT_HT
    endif
    if depense = "P"
      @LIGNE,24 SAY Tot_ht PICTURE "9999.99" 
      pub=pub+TOT_HT
    endif
    if depense = "L"
      @LIGNE,32 SAY Tot_ht PICTURE "9999.99"
      loc=loc+TOT_HT
    endif
    if depense = "I"
      @LIGNE,39 SAY  Tot_ht PICTURE "9999.99" 
      div=div+TOT_HT
    endif
    if depense = "A"
      @LIGNE,47 SAY Tot_ht PICTURE "99999.99"
      ach=ach+TOT_HT
    endif

    @LIGNE,56 SAY Tps PICTURE "9999.99" 
    @LIGNE,64 SAY Tvq PICTURE "9999.99" 
    @LIGNE,72 SAY ttc_ PICTURE "99999.99"

    ligne = ligne + 1
    skip
  enddo

  if eof()
    do Attente
    do stat_dep
    @24,27 say "FIN DU JOURNAL DES ACHATS" COLOR N/BG 
    read
    @24,27 clear to 24,col()
    exit
  else
    do Attente
    restore screen from ecr_jour
  endif  
enddo
ON KEY LABEL Ctrl-i 
release screen ecr_jour
set filter to
restore screen from ecran_menu
return

PROCEDURE PRES_DEP
CLEAR
@ 0,29 TO 2,50 
@ 1,0 TO 6,79 
@ 1,29 SAY "´ JOURNAL DES ACHATS Ã" 

if date_inf <> date() .and. date_sup <> date()
   @ 3,3 SAY "le " 
   @ 3,6 SAY date() 
endif
if date_inf <> date_sup
  @ 4,25 SAY "Du " 
  @ 4,37 SAY "jusqu'au " 
  @ 4,28 SAY date_inf
  @ 4,46 SAY date_sup 
else
  @ 4,33 SAY "Du " 
  @ 4,36 SAY date_inf
endif
  

@7,0 SAY  "Date" 
@7,9 SAY "Libell‚" 
@7,18 SAY "D‚pla"
@7,26 SAY "Pub" 
@7,32 SAY "Loc/Bur" 
@7,40 SAY "Divers"
@7,48 SAY "Achat"
@7,58 SAY "TPS" 
@7,66 SAY "TVQ" 
@7,73 SAY "TOT_TTC"


RETURN

PROCEDURE STAT_DEP

@22,17 SAY dep PICTURE "9999.99" 
@22,24 SAY pub PICTURE "9999.99" 
@22,32 SAY loc PICTURE "9999.99" 
@22,39 SAY div PICTURE "9999.99"
@22,47 SAY ach PICTURE "99999.99" 
@22,56 SAY tf PICTURE "9999.99"
@22,64 SAY tq PICTURE "9999.99" 
@22,72 SAY tot_ttc PICTURE "99999.99"

RETURN

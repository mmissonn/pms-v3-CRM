* Programme..........: C:\PMSV3\JOUR_VEN.FRG
* Date...............: 7-14-92
* Versions...........: dBASE IV - Rapport 1.1
*
* Notes :
* -------
* Avant de lancer la proc‚dure avec un DO, il est
* n‚cessaire d'utiliser la fonction LOCATE. En effet,
* la commande CONTINUE se trouve dans la boucle principale.
*
*-- ParamŠtres
PARAMETERS gl_noeject, gl_plain, gl_summary, gc_heading, gc_extra
** Les trois premiers paramŠtres sont de type Logique.
** Le quatriŠme est de type CaractŠre. Le cinquiŠme est un "extra".
PRIVATE _peject, _wrap

*-- Test si fin de fichier ou fichier vide
IF EOF() .OR. .NOT. FOUND()
   RETURN
ENDIF

*-- D‚sactive la fonction _wrap
_wrap=.F.

IF _plength < (_pspacing * 5 + 1) + (_pspacing + 1) + 2
   SET DEVICE TO SCREEN
   DEFINE WINDOW gw_report FROM 7,17 TO 11,62 DOUBLE
   ACTIVATE WINDOW gw_report
   @ 0,1 SAY "Augmentez la longueur de page du rapport"
   @ 2,1 SAY "Pressez une touche..."
   x=INKEY(0)
   DEACTIVATE WINDOW gw_report
   RELEASE WINDOW gw_report
   RETURN
ENDIF

_plineno=0          && Initialisation du num‚ro de ligne … z‚ro
*-- ParamŠtre NOEJECT
IF gl_noeject
   IF _peject="BEFORE"
      _peject="NONE"
   ENDIF
   IF _peject="BOTH"
      _peject="AFTER"
   ENDIF
ENDIF

*-- Initialisation de l'environnement
ON ESCAPE DO Prnabort
IF SET("TALK")="ON"
   SET TALK OFF
   gc_talk="ON"
ELSE
   gc_talk="OFF"
ENDIF
gc_space=SET("SPACE")
SET SPACE OFF
gc_time=TIME()      && Heure systŠme pour les champs pr‚-d‚finis
gd_date=DATE()      && Date systŠme pour les champs pr‚-d‚finis
gl_fandl=.F.        && Indicateur de premiŠre et derniŠre page
gl_prntflg=.T.      && Indicateur d'impression
gl_widow=.T.        && Indicateur de groupes vides
gn_length=LEN(gc_heading)  && Longueur de HEADING (en-tˆte)
gn_level=2          && Section en cours
gn_page=_pageno     && Num‚ro de page en cours
gn_pspace=_pspacing && Interligne pour l'impression

*-- Initialisation des variables calcul‚es
master=0
cheque=0
cash=0

*-- Initialisation des variables utilis‚es pour le saut de page
gn_atline=_plength - (_pspacing + 1)
ON PAGE AT LINE gn_atline EJECT PAGE

*-- Impression du rapport

PRINTJOB

*-- Initialisation des variables statistiques
tot_master=0
tot_check=0
tot_cash=0
tot_tps=0
tot_tvq=0
tot_tvo=0
tot_gal=0

*-- Initialisation des variables calcul‚es
master=0
cheque=0
cash=0

IF gl_plain
   ON PAGE AT LINE gn_atline DO Pgplain
ELSE
   ON PAGE AT LINE gn_atline DO Pgfoot
ENDIF

DO Pghead

gl_fandl=.T.        && D‚but de la premiŠre page physique

DO Rintro

*-- Boucle sur le fichier
DO WHILE FOUND() .AND. .NOT. EOF() .AND. gl_prntflg
   gn_level=0
   *-- Lignes de la section D‚tail
   IF gl_summary
      DO Upd_Vars
   ELSE
      DO __Detail
   ENDIF
   gl_widow=.T.         && Autorisation de recherche de groupes vides
   CONTINUE
ENDDO

IF gl_prntflg
   DO Rsumm
   IF _plineno <= gn_atline
      EJECT PAGE
   ENDIF
ELSE
   DO Rsumm
   DO Reset
   RETURN
ENDIF

ON PAGE

ENDPRINTJOB

DO Reset
RETURN
* Fin de la proc‚dure : C:\PMSV3\JOUR_VEN.FRG

*-- Mise … jour des champs statistiques et/ou calcul‚s dans la section D‚tail
PROCEDURE Upd_Vars

*if Terme = "MASTER"
*  master=TOTAL_HT
*  cheque=0
*  cash=0
*else

  if Terme = "CHEQUE"
    master=0
    cheque=TOTAL_HT
    cash=0
  else
    if Terme = "CASH"
      master=0
      cheque=0
      cash=TOTAL_HT
    endif
  endif

*endif
*-- Somme
tot_master=tot_master+MASTER
*-- Somme
tot_check=tot_check+CHEQUE
*-- Somme
tot_cash=tot_cash+CASH
*-- Somme
tot_tps=tot_tps+TPS
*-- Somme
tot_tvq=tot_tvq+TVQ
tot_tvo=tot_tvo+TVO
*-- Somme
tot_gal=tot_gal+TOTAL_TTC
RETURN
* Fin de la proc‚dure : Upd_Vars

*-- Init. de l'indicateur pour sortir de la boucle DO WHILE avec la touche Esc
PROCEDURE Prnabort
gl_prntflg=.F.
RETURN
* Fin de la proc‚dure : Prnabort

PROCEDURE Pghead
?
?? "J O U R N A L  D E S  V E N T E S" STYLE "B" AT 23,;
 IIF(gl_plain,'',_pageno) PICTURE "999" AT 76
?

*-- Impression de HEADING (exemple : REPORT FORM <nom> HEADING <expC>)
IF .NOT. gl_plain .AND. gn_length > 0
   ?? gc_heading FUNCTION "I;V"+LTRIM(STR(_rmargin-_lmargin))
   ?
ENDIF
?? "Du "  AT 28,
?? DATE_INF,
?? " au ",  
?? DATE_SUP

?
?
RETURN
* Fin de la proc‚dure : Pghead

PROCEDURE Rintro
?? "Fact" AT 0,;
 "Date" AT 10,;
 "Cash  " AT 18,;
 "ChŠque" AT 28,;
 "T.P.S" AT 42,;
 "T.V.O" AT 51,;
 "T.V.Q" AT 61,;
 "TOT_TTC" AT 71
?
?
RETURN
* Fin de la proc‚dure : Rintro

PROCEDURE __Detail
IF gn_pspace < gn_atline - (_pspacing * 5 + 1)
   IF gl_widow .AND. _plineno+gn_pspace > gn_atline + 1
      EJECT PAGE
   ENDIF
ENDIF
DO Upd_Vars
?? LTRIM(STR(No_fact)) PICTURE "9999999" AT 0,;
 Date_fact AT 8,

*if Terme = "MASTER"
*  ?? master PICTURE "9,999.99" AT 17,
*else

  if Terme = "CHEQUE"
    ?? cheque PICTURE "99,999.99" AT 27,
  else
    if Terme = "CASH"
      ?? cash PICTURE "9,999.99" AT 17,
    endif
  endif

*endif

?? Tps PICTURE "9,999.99" AT 39,;
 Tvo PICTURE "9,999.99" AT 49,;
 Tvq PICTURE "9,999.99" AT 59,;
 Total_ttc PICTURE "999,999.99" AT 69
?
RETURN
* Fin de la proc‚dure : __Detail

PROCEDURE Rsumm
?? ;
"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ";
+ "ÄÄÄÄÄÄÄÄÄ";
AT 0
?
?? tot_cash PICTURE "999,999.99" AT 15,;
 tot_check PICTURE "999,999.99" AT 26,;
 tot_tps  PICTURE "999,999.99" AT 37,;
 tot_tvo PICTURE "99,999.99" AT 48,;
 tot_tvq PICTURE "99,999.99" AT 58,;
 tot_gal PICTURE "999,999.99" AT 69
gl_fandl=.F.        && DerniŠre page imprim‚e
?
RETURN
* Fin de la proc‚dure : Rsumm

PROCEDURE Pgfoot
PRIVATE _box, _pspacing
gl_widow=.F.         && Interdit la recherche de sections vides
_pspacing=1
?
IF .NOT. gl_plain
ENDIF
EJECT PAGE
*-- Test si le num‚ro de page actuelle est sup‚rieur au num‚ro de page finale
IF _pageno > _pepage
   GOTO BOTTOM
   SKIP
   gn_level=0
ENDIF
IF .NOT. gl_plain .AND. gl_fandl
   _pspacing=gn_pspace
   DO Pghead
ENDIF
RETURN
* Fin de la proc‚dure : Pgfoot

*-- Saut de page si l'option PLAIN est utilis‚e
PROCEDURE Pgplain
PRIVATE _box
EJECT PAGE
RETURN
* Fin de la proc‚dure : Pgplain

*-- Initialisation de l'environnement avant l'accŠs au rapport
PROCEDURE Reset
SET SPACE &gc_space.
SET TALK &gc_talk.
ON ESCAPE
ON PAGE
RETURN
* Fin de la proc‚dure : Reset


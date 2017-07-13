* Programme..........: C:\PMS\RELEVE.FRG
* Date...............: 5-28-91
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

IF _plength < (_pspacing * 7 + 1) + (_pspacing + 1) + 2
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
solde_fact=0
jour_echu=FLOAT(0)

*-- Initialisation des variables utilis‚es pour le saut de page
gn_atline=_plength - (_pspacing + 1)
ON PAGE AT LINE gn_atline EJECT PAGE

*-- Impression du rapport

PRINTJOB

*-- Initialisation des variables statistiques
cumulatif=0

*-- Initialisation des variables calcul‚es
solde_fact=total_ttc - Mont_paye
jour_echu=date() - date_fact

DO Rintro

*-- Initialisation du num‚ro de page si l'introduction du rapport
*-- est r‚partie sur deux pages.
_pageno=gn_page

IF gl_plain
   ON PAGE AT LINE gn_atline DO Pgplain
ELSE
   ON PAGE AT LINE gn_atline DO Pgfoot
ENDIF

DO Pghead

gl_fandl=.T.        && D‚but de la premiŠre page physique

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
* Fin de la proc‚dure : C:\PMS\RELEVE.FRG

*-- Mise … jour des champs statistiques et/ou calcul‚s dans la section D‚tail
PROCEDURE Upd_Vars
solde_fact=total_ttc - Mont_paye
jour_echu=date() - date_fact
*-- Somme
cumulatif=cumulatif+SOLDE_FACT
RETURN
* Fin de la proc‚dure : Upd_Vars

*-- Init. de l'indicateur pour sortir de la boucle DO WHILE avec la touche Esc
PROCEDURE Prnabort
gl_prntflg=.F.
RETURN
* Fin de la proc‚dure : Prnabort

PROCEDURE Rintro
?
?
?? "   " AT 0,;
 &ZONE->Nom FUNCTION "T" ,;
 "     RELEVE DE COMPTE" STYLE "B" AT 46
?
?? "  " AT 1,;
 &ZONE->Adresse FUNCTION "T" 
?
?? &ZONE->Ville FUNCTION "T" AT 3
?
?? &ZONE->Code_post FUNCTION "T" AT 3
?
?
?
RETURN
* Fin de la proc‚dure : Rintro

PROCEDURE Pghead
?
?? IIF(gl_plain,'',gd_date) AT 51,;
 " " ,;
 IIF(gl_plain,'',_pageno) PICTURE "999" AT 77
?

*-- Impression de HEADING (exemple : REPORT FORM <nom> HEADING <expC>)
IF .NOT. gl_plain .AND. gn_length > 0
   ?? gc_heading FUNCTION "I;V"+LTRIM(STR(_rmargin-_lmargin))
   ?
ENDIF
?? "Nø de compte "+ltrim(str(&ZONE->No_compte)) AT 51
?
?? &ZONE->Nom FUNCTION "T" AT 51
?
?
?? "Date" AT 1,;
 " Nøfact. " AT 13,;
 " Montant" AT 27,;
 "  Solde" AT 43,;
 "Jours  D‚lai" AT 54,;
 " Cumulatif" AT 70
?
?? "Echus" AT 54
?
?
RETURN
* Fin de la proc‚dure : Pghead

PROCEDURE __Detail
IF gn_pspace < gn_atline - (_pspacing * 7 + 1)
   IF gl_widow .AND. _plineno+gn_pspace > gn_atline + 1
      EJECT PAGE
   ENDIF
ENDIF
DO Upd_Vars
?? Date_fact AT 1,;
 No_fact PICTURE "99999999" AT 12,;
 Total_ttc PICTURE "9,999,999.99" AT 24,;
 solde_fact PICTURE "9,9999,999.99" AT 39,;
 jour_echu FUNCTION "T" PICTURE "999" AT 54,;
 " " AT 61,;
 Delai PICTURE "999" ,;
 "  " AT 66,;
 cumulatif PICTURE "9,999,999.99" 
?
RETURN
* Fin de la proc‚dure : __Detail

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

PROCEDURE Rsumm
gl_fandl=.F.
?
RETURN
* Fin de la proc‚dure : Rsumm

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
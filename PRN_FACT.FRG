
*** MODIF LE 08-01-95 QTE REQUISE = QTE EXPEDIEE

* Programme..........: C:\PMSV3\PRN_FACT.FRG
* Date...............: 7-09-92
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

IF _plength < (_pspacing * 26 + 1) + 1 + 2
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

*-- Initialisation des variables utilis‚es en bas de page
r_foot1=.F.
r_foot2=.F.
r_foot3=.F.
r_foot4=.F.

*-- Initialisation des variables calcul‚es
sub_tot=0
rabais=0

*-- Initialisation des variables utilis‚es pour le saut de page

*gn_atline=_plength - 1
gn_atline=_plength - (_pspacing * 2 + 1) - 2

ON PAGE AT LINE gn_atline EJECT PAGE

*-- Impression du rapport

PRINTJOB

*-- Initialisation des variables statistiques
tot_brut=0

*-- Initialisation des variables calcul‚es

rabais = 0
sub_tot = 0

IF gl_plain
   ON PAGE AT LINE gn_atline DO Pgplain
ELSE
   ON PAGE AT LINE gn_atline DO Pgfoot
ENDIF

DO Pghead

gl_fandl=.T.        && D‚but de la premiŠre page physique

*-- Boucle sur le fichier
DO WHILE .NOT. EOF() .AND. gl_prntflg
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
ELSE
   DO Rsumm
   DO Reset
   RETURN
ENDIF

ON PAGE

ENDPRINTJOB

DO Reset
RETURN
* Fin de la proc‚dure : C:\PMSV3\PRN_FACT.FRG

*-- Mise … jour des champs statistiques et/ou calcul‚s dans la section D‚tail
PROCEDURE Upd_Vars

sub_tot=QTE*P_U
IF NOM_MENU = "GEST_VEN"
  SELECT ZFACT
ELSE
  SELECT ZACH
ENDIF

*-- Somme
tot_brut=tot_brut+SUB_TOT
rabais=TOT_BRUT*REDUCTION/100
r_foot1=Total_ht
r_foot2=Tps
r_foot3=Tvq
r_foot4=Total_ttc
IF NOM_MENU = "GEST_VEN"
  SELECT ZDET_V
ELSE
  SELECT ZDET_A
ENDIF
RETURN
* Fin de la proc‚dure : Upd_Vars

*-- Init. de l'indicateur pour sortir de la boucle DO WHILE avec la touche Esc
PROCEDURE Prnabort
gl_prntflg=.F.
RETURN
* Fin de la proc‚dure : Prnabort


PROCEDURE Pghead
IF NOM_MENU = "GEST_VEN"
  SELECT ZFACT
ELSE
  SELECT ZACH
ENDIF

?
?
?
*-- Impression de HEADING (exemple : REPORT FORM <nom> HEADING <expC>)
IF .NOT. gl_plain .AND. gn_length > 0
   ?? gc_heading FUNCTION "I;V"+LTRIM(STR(_rmargin-_lmargin))
   ?
ENDIF
?? No_fact PICTURE "99999999" STYLE "B" AT 65
?
?? "" 
?
?? Code_clien PICTURE "99999" STYLE "B" AT 68
?
?? 
?
?? IIF(gl_plain,'' , "Page" ) STYLE "B" AT 65,;
 IIF(gl_plain,'',_pageno) PICTURE "999" STYLE "B" AT 70
?
?? 
?
?? 
?
?
?
?
?
?? &ZONE->Nom FUNCTION "T" STYLE "B" AT 9
?
?? &ZONE->Adresse FUNCTION "T" STYLE "B" AT 9
?
?? &ZONE->Ville FUNCTION "T" STYLE "B" AT 9
?
?? &ZONE->Code_post FUNCTION "T" PICTURE "XXXXXXX" STYLE "B" AT 9
?
?
?
?
?
?
?? Date_fact STYLE "B" AT 1,;
 Terme FUNCTION "T" PICTURE "XXXXXXXXXXXXXXXXXXXXXX" STYLE "B" AT 48
if delai <> 0
  ?? Delai PICTURE "999" STYLE "B" AT 68,;
 " jours" STYLE "B"
endif
?
?
?? No_command PICTURE "99999" STYLE "B" AT 3,;
 Date_comm STYLE "B" AT 20,;
 Code_ven FUNCTION "T" STYLE "B" AT 41
?
?
?
IF NOM_MENU = "GEST_VEN"
  SELECT ZDET_V
ELSE
  SELECT ZDET_A
ENDIF
RETURN
* Fin de la proc‚dure : Pghead

PROCEDURE __Detail
IF 2 * gn_pspace < gn_atline - (_pspacing * 26 + 1)
   IF gl_widow .AND. _plineno+2 * gn_pspace > gn_atline + 1
      EJECT PAGE
   ENDIF
ENDIF
DO Upd_Vars
?? Qte PICTURE "99999" STYLE "B" AT 0,;
 Qte PICTURE "99999" STYLE "B" AT 6,;
 Code_art FUNCTION "T" STYLE "B" AT 19,;
 D->Design FUNCTION "T" STYLE "B" AT 31,;
 P_u PICTURE "9,999,999.99" STYLE "B" AT 56,;
 sub_tot PICTURE "9,999,999.99" STYLE "B" AT 67
?

RETURN
* Fin de la proc‚dure : __Detail

PROCEDURE Pgfoot
PRIVATE _box
gl_widow=.F.         && Interdit la recherche de sections vides
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
?
?
?
?? "Total brut" STYLE "B" AT 31,;
 tot_brut PICTURE "9,999,999.99" STYLE "B" AT 67
?
if rabais <> 0
  ?? "Escompte " AT 31,;
   "-" AT 66,;
 rabais PICTURE "9,999,999.99" 
endif
?
?
?? "Total hors taxes" STYLE "B" AT 31,;
 r_foot1 PICTURE "9,999,999.99" STYLE "B" AT 67
?
?? "T.P.S" STYLE "B" AT 31,;
 r_foot2 PICTURE "9,999,999.99" STYLE "B" AT 67
?
?? "T.V.Q" STYLE "B" AT 31,;
 r_foot3 PICTURE "9,999,999.99" STYLE "B" AT 67
?
?
?? "Montant total factur‚" STYLE "B" AT 31,;
 r_foot4 PICTURE "9,999,999.99" STYLE "B" AT 67
?
?
?? "MERCI POUR VOTRE COMMANDE" STYLE "B" AT 31
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
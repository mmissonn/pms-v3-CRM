* Programme..........: C:\PMSV3\ETAT.FRG
* Date...............: 7-12-91
* Versions...........: dBASE IV - Rapport 1.1
*
* Notes :
* -------
* Avant de lancer la proc�dure avec un DO, il est
* n�cessaire d'utiliser la fonction LOCATE. En effet,
* la commande CONTINUE se trouve dans la boucle principale.
*
*-- Param�tres
PARAMETERS gl_noeject, gl_plain, gl_summary, gc_heading, gc_extra
** Les trois premiers param�tres sont de type Logique.
** Le quatri�me est de type Caract�re. Le cinqui�me est un "extra".
PRIVATE _peject, _wrap

*-- Test si fin de fichier ou fichier vide
IF EOF() .OR. .NOT. FOUND()
   RETURN
ENDIF

*-- D�sactive la fonction _wrap
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

_plineno=0          && Initialisation du num�ro de ligne � z�ro
*-- Param�tre NOEJECT
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
gc_time=TIME()      && Heure syst�me pour les champs pr�-d�finis
gd_date=DATE()      && Date syst�me pour les champs pr�-d�finis
gl_fandl=.F.        && Indicateur de premi�re et derni�re page
gl_prntflg=.T.      && Indicateur d'impression
gl_widow=.T.        && Indicateur de groupes vides
gn_length=LEN(gc_heading)  && Longueur de HEADING (en-t�te)
gn_level=2          && Section en cours
gn_page=_pageno     && Num�ro de page en cours
gn_pspace=_pspacing && Interligne pour l'impression


*-- Initialisation des variables utilis�es pour le saut de page
gn_atline=_plength - (_pspacing + 1)
ON PAGE AT LINE gn_atline EJECT PAGE

*-- Impression du rapport

PRINTJOB

*-- Initialisation des variables statistiques
r_msum1=0

IF gl_plain
   ON PAGE AT LINE gn_atline DO Pgplain
ELSE
   ON PAGE AT LINE gn_atline DO Pgfoot
ENDIF

DO Pghead

gl_fandl=.T.        && D�but de la premi�re page physique

*-- Boucle sur le fichier
DO WHILE FOUND() .AND. .NOT. EOF() .AND. gl_prntflg
   gn_level=0
   *-- Lignes de la section D�tail
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
* Fin de la proc�dure : C:\PMSV3\ETAT.FRG

*-- Mise � jour des champs statistiques et/ou calcul�s dans la section D�tail
PROCEDURE Upd_Vars
*-- Somme
IF QTE_PHYS >0
  r_msum1=r_msum1+qte_phys*prix_achat
ENDIF
RETURN
* Fin de la proc�dure : Upd_Vars

*-- Init. de l'indicateur pour sortir de la boucle DO WHILE avec la touche Esc
PROCEDURE Prnabort
gl_prntflg=.F.
RETURN
* Fin de la proc�dure : Prnabort

PROCEDURE Pghead
?
IF .NOT. gl_plain
   ?? "Page" AT 72,;
    _pageno PICTURE "999" AT 77
ENDIF
?
?? "E T A T  D U  S T O C K" STYLE "B" AT 28
?
?

*-- Impression de HEADING (exemple : REPORT FORM <nom> HEADING <expC>)
IF .NOT. gl_plain .AND. gn_length > 0
   ?? gc_heading FUNCTION "I;V"+LTRIM(STR(_rmargin-_lmargin))
   ?
ENDIF
?? "Du" AT 34,;
 IIF(gl_plain,'',gd_date) AT 37
?
?
?? "Article" AT 0,;
 "D�signation" AT 9,;
 "Alrt" AT 35,;
 "      Co�t" AT 41,;
 "Phys" AT 52,;
 "Comd" AT 59,;
 "Code four. " AT 64
?
?
RETURN
* Fin de la proc�dure : Pghead


PROCEDURE __Detail
IF gn_pspace < gn_atline - (_pspacing * 7 + 1)
   IF gl_widow .AND. _plineno+gn_pspace > gn_atline + 1
      EJECT PAGE
   ENDIF
ENDIF
DO Upd_Vars
?? Code_art FUNCTION "T" AT 0,;
 Design FUNCTION "T" AT 9,;
 Qte_alerte PICTURE "9999" AT 35,;
 Prix_achat PICTURE "9,999,999.99" AT 39,
IF QTE_PHYS > 0
  ?? Qte_phys PICTURE "9999" AT 52,
ELSE
  ?? "   0" AT 52,
ENDIF
?? Qte_comm PICTURE "9999" AT 57,;
 e->No_compte PICTURE "99999" AT 62,;
 e->Nom FUNCTION "T" PICTURE "XXXXXXXXXXX" AT 68
?
RETURN
* Fin de la proc�dure : __Detail

PROCEDURE Rsumm
?
?
?? "VALEUR DU STOCK  :  " AT 0,;
 r_msum1 STYLE "B" PICTURE "99,999,999.99" 
?
gl_fandl=.F.        && Derni�re page imprim�e
?
RETURN
* Fin de la proc�dure : Rsumm

PROCEDURE Pgfoot
PRIVATE _box, _pspacing
gl_widow=.F.         && Interdit la recherche de sections vides
_pspacing=1
?
IF .NOT. gl_plain
ENDIF
EJECT PAGE
*-- Test si le num�ro de page actuelle est sup�rieur au num�ro de page finale
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
* Fin de la proc�dure : Pgfoot

*-- Saut de page si l'option PLAIN est utilis�e
PROCEDURE Pgplain
PRIVATE _box
EJECT PAGE
RETURN
* Fin de la proc�dure : Pgplain

*-- Initialisation de l'environnement avant l'acc�s au rapport
PROCEDURE Reset
SET SPACE &gc_space.
SET TALK &gc_talk.
ON ESCAPE
ON PAGE
RETURN
* Fin de la proc�dure : Reset


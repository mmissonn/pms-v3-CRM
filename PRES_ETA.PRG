PROCEDURE PRES_ETAT
clear
*--  Page  1
@ 1,0 TO 22,79 
@ 0,31 TO 2,47 
@ 1,32 SAY " ETAT DU STOCK " 
@ 2,2 SAY "le" 
*-- Champ calcul‚ :  - 
@ 2,5 SAY date() 
@ 4,0 TO 4,79 
@ 4,0 SAY "Ã" 
@ 4,9 TO 21,9 
@ 4,9 SAY "Â" 
@ 4,35 TO 21,35 
@ 4,35 SAY "Â" 
@ 4,39 TO 21,39 
@ 4,39 SAY "Â" 
@ 4,52 TO 21,52 
@ 4,52 SAY "Â" 
@ 4,57 TO 21,57 
@ 4,57 SAY "Â" 
@ 4,62 TO 21,62 
@ 4,62 SAY "Â" 
@ 4,79 SAY "´" 
@ 5,2 SAY "Article" 
@ 5,11 SAY "Description" 
@ 5,36 SAY "Alt"
@ 5,42 SAY "Prix achat" 
@ 5,53 SAY "Phys" 
@ 5,58 SAY "Comd" 
@ 5,65 SAY "Code four.  " 
@ 6,0 TO 6,79 
@ 6,0 SAY "Ã" 
@ 6,9 SAY "Å" 
@ 6,35 SAY "Å" 
@ 6,39 SAY "Å" 
@ 6,52 SAY "Å" 
@ 6,57 SAY "Å" 
@ 6,62 SAY "Å" 
@ 6,79 SAY "´" 
@ 22,9 SAY "Á" 
@ 22,35 SAY "Á" 
@ 22,39 SAY "Á" 
@ 22,52 SAY "Á" 
@ 22,57 SAY "Á" 
@ 22,62 SAY "Á" 

return

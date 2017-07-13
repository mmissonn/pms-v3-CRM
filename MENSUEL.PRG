PROCEDURE Mensuel
  define popup mensuel from 5,23
  DEFINE BAR 1 OF mensuel PROMPT "Janvier" SKIP for month(date()) < 1 
  DEFINE BAR 2 OF mensuel PROMPT "F‚vrier" SKIP for month(date()) < 2
  DEFINE BAR 3 OF mensuel PROMPT "Mars" SKIP for month(date()) < 3
  DEFINE BAR 4 OF mensuel PROMPT "Avril" SKIP for month(date()) < 4
  DEFINE BAR 5 OF mensuel PROMPT "Mai" SKIP for month(date()) < 5
  DEFINE BAR 6 OF mensuel PROMPT "Juin" SKIP for month(date()) < 6 
  DEFINE BAR 7 OF mensuel PROMPT "Juillet" SKIP for month(date()) < 7
  DEFINE BAR 8 OF mensuel PROMPT "Ao–t" SKIP for month(date()) < 8 
  DEFINE BAR 9 OF mensuel PROMPT "Septembre" SKIP for month(date()) < 9
  DEFINE BAR 10 OF mensuel PROMPT "Octobre" SKIP for month(date()) < 10
  DEFINE BAR 11 OF mensuel PROMPT "Novembre" SKIP for month(date()) < 11
  DEFINE BAR 12 OF mensuel PROMPT "D‚cembre" SKIP for month(date()) < 12

  ON SELECTION POPUP mensuel Do param_jour
  @6,25 fill to 19,35 color W/N
  activate popup mensuel
  @6,25 fill to 19,35 color W+/B
return


PROCEDURE param_jour
  date_inf = ctod("01/"+str(bar())+"/"+str( year( date() ) ) )
  if bar() < 12
    date_sup = ctod("01/"+str(bar()+1)+"/"+str( year( date() ) ) ) - 1
  else
    date_sup = ctod("01/01/"+str( year( date() ) + 1) ) - 1
  endif
  do jour_ven with date_inf, date_sup
  @6,25 fill to 19,35 color W/N
return


PROCEDURE Hebdomadaire
    if dow(date()) = 7
      date_inf = date() - 5
    else
      date_inf = date() - (5+dow(date()))
    endif
    date_sup = date_inf + 5
    do jour_ven with date_inf,date_sup
return

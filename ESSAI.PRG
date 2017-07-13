sele d
define popup champs from 5,10 to 15,35 prompt field e->nom
on selection popup champs do Rec
activate  popup champs

procedure rec
  ? prompt()
  ?
*  set order to nom
*  seek prompt()
  @21,20 say  e->no_compte 
  read
return

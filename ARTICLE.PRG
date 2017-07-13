PROCEDURE Article
*****---- Il faut penser au cas ou il y a set filter to code_four=....
*****   ->Gestion achats

  activate screen
  DEFINE POPUP article FROM 2,23 TO 9,33 PROMPT FIELD d->code_art

  ON SELECTION POPUP article DEACTIVATE POPUP
  @3,25 fill to 10,35 color W/N

  activate popup article
  @3,25 fill to 10,35 color W+/B
  element[indice,1] = prompt()
  activate window descrip

  val = Trouve(element[indice,1], "A")

return


PROCEDURE Crea_four
  Stat = space(12)
  Sauve = .T.
  release screen cr_four
  save screen to cr_four
  do fenetre with 1,2,17,51,"FOURNISSEUR",opt_menu
  @24,0 say "<Ctrl-Q>-Quitter" COLOR GR+/B
  @3,5  say "Nø de compte       " + ltrim(str(four)) color GR+/B 
  @5,5 say  "Status            " get stat function "M Revente,Importation,Consommation";
      MESSAGE "Entrer le type de transaction" color Gr+/B
  @7,5  say "Nom du fournisseur" get nom_ FUNCTION "!";
      MESSAGE "Entrer le nom du fournisseur" COLOR GR+/B
  @9,5 say  "Adresse           " get Adr_  ;
      MESSAGE "Entrer l'adresse " COLOR GR+/B
  @11,5 say "Ville             " get Ville_ ;
      MESSAGE "Entrer la ville   "  COLOR GR+/B
  @13,5 say "Code postal       " get CP_ PICTURE "XXX-XXX" Function "!";
     MESSAGE "Entrer le code postal" COLOR GR+/B
  @15,5 say "T‚l‚phone         " get tel_ PICTURE "(999)999-9999";
     MESSAGE "Entrer le num‚ro de t‚l‚phone" COLOR GR+/B
  read
  restore screen from cr_four
 return

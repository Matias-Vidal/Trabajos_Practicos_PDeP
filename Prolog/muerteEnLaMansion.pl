viveEnLaMansionDreadbury(agatha).
viveEnLaMansionDreadbury(mayordomo).
viveEnLaMansionDreadbury(charles).

odiaA(agatha,Odiado):-
    viveEnLaMansionDreadbury(Odiado),
    Odiado \= mayordomo.

odiaA(charles,Odiado):-
    viveEnLaMansionDreadbury(Odiado),
    not(odiaA(agatha,Odiado)).

odiaA(mayordomo,Odiado):-
    odiaA(agatha,Odiado).


esMasRico(Alguien,agatha):-
    viveEnLaMansionDreadbury(Alguien),
    not(odiaA(mayordomo,Alguien)).

mata(Asesino,Victima):-
    viveEnLaMansionDreadbury(Asesino),
    odiaA(Asesino,Victima),
    not(esMasRico(Asesino,Victima)).

/* 
------------------------------Punto 2---------------------------------
a. Se puede hacer la consulta, si alguien odia a milhouse:

consola > odiaA(_,milhouse).

responde False, ya que nadie odia a milhouse.

b. consola > odiaA(charles,Alguien).

respuesta > Alguien = mayordomo.

c. consola > odiaA(Alguien,agatha).

respuesta > Alguien = agatha.
          > Alguien = mayordomo.

d. consola > odiaA(Odiador,Odiado).

respuesta > Odiador = Odiado,
            Odiado = agatha ;
          > Odiador = agatha,
            Odiado = charles ;
          > Odiador = charles,
            Odiado = mayordomo ;
          > Odiador = mayordomo,
            Odiado = agatha ;
          > Odiador = mayordomo,
            Odiado = charles.

e. consola > odiaA(mayordomo,_).

respuesta > true.

*/

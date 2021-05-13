module Lib where

import Data.List()
import Text.Show.Functions() 


type Accion = (Jugador->Jugador)

type Propiedad = (String, Int)

data Jugador = Jugador {
nombre :: String,
dinero :: Int,
tacticaEnElJuego :: String, 
propiedadesActuales :: [Propiedad],
acciones :: [Accion]
}deriving (Show)

carolina :: Jugador
carolina = Jugador "Carolina" 500 "Accionista" [] [pasarPorElBanco,pagarAAccionistas]

manuel :: Jugador
manuel = Jugador "Manuel" 500 "Oferente Singular" [] [enojarse,pasarPorElBanco]

tipoDeTactica :: String -> Jugador -> Bool
tipoDeTactica tactica  = ((==tactica).tacticaEnElJuego) 

esAccionista :: Jugador->Bool
esAccionista  = tipoDeTactica "Accionista" 

esOferenteSingular :: Jugador->Bool
esOferenteSingular = tipoDeTactica "Oferente Singular" 

cambiarTacticaDeJuego :: String -> Accion
cambiarTacticaDeJuego tacticaNueva jugador = jugador {tacticaEnElJuego = tacticaNueva} 

aplicarTransaccionDeDinero :: Int->Accion
aplicarTransaccionDeDinero valorDeTransaccion jugador = jugador {dinero = dinero jugador + valorDeTransaccion}

agregarPropiedad :: Propiedad->Accion
agregarPropiedad propiedad jugador = jugador {propiedadesActuales = propiedad : propiedadesActuales jugador }

añadirAccion :: Accion -> Jugador -> Jugador
añadirAccion accion jugador = jugador {acciones = accion : acciones jugador}

pasarPorElBanco :: Accion
pasarPorElBanco jugador = (cambiarTacticaDeJuego "Comprador Compulsivo").(aplicarTransaccionDeDinero 40) $ jugador 

enojarse :: Accion
enojarse jugador = (añadirAccion gritar).(aplicarTransaccionDeDinero 50) $ jugador

gritar :: Accion
gritar jugador = jugador {nombre = "AHHHH " ++ nombre jugador}

subastar :: Propiedad -> Accion
subastar propiedad jugador   
   | (esAccionista jugador) || (esOferenteSingular jugador) = adquirirPropiedad propiedad jugador
   | otherwise = jugador

alquiler :: Int -> Int
alquiler unValor | unValor < 150 = 10
                 | otherwise = 20

valorDeUnaPropiedad :: Propiedad -> Int
valorDeUnaPropiedad propiedad = snd propiedad

adquirirPropiedad :: Propiedad -> Jugador -> Jugador
adquirirPropiedad propiedad jugador = 
   (agregarPropiedad propiedad).(aplicarTransaccionDeDinero (-(valorDeUnaPropiedad propiedad))) $ jugador

costoDeAlquiler :: Jugador -> Int
costoDeAlquiler jugador = sum.(map alquiler).(map valorDeUnaPropiedad) $ propiedadesActuales jugador

cobrarAlquileres :: Accion
cobrarAlquileres jugador = aplicarTransaccionDeDinero (costoDeAlquiler jugador) jugador

pagarAAccionistas :: Accion
pagarAAccionistas jugador | esAccionista jugador = aplicarTransaccionDeDinero 200 jugador
                          | otherwise = aplicarTransaccionDeDinero (-100) jugador

puedeComprar :: Propiedad->Jugador->Bool
puedeComprar propiedad jugador = valorDeUnaPropiedad propiedad <= dinero jugador

hacerBerrinchePor :: Propiedad->Accion
hacerBerrinchePor propiedad jugador 
      | puedeComprar propiedad jugador = adquirirPropiedad propiedad jugador
      | otherwise = (hacerBerrinchePor propiedad).(aplicarTransaccionDeDinero 10).gritar $ jugador 

ejecutarLasAcciones :: [Accion]->Accion
ejecutarLasAcciones unasAcciones = foldl1 (.) unasAcciones

ultimaRonda :: Accion
ultimaRonda jugador = ejecutarLasAcciones (acciones jugador) jugador

compararDineroDeJugadores :: Jugador->Accion
compararDineroDeJugadores jugador otroJugador 
   | (dinero jugador) < (dinero otroJugador) = otroJugador
   | otherwise =  jugador

juegoFinal :: Jugador->Accion
juegoFinal jugador otroJugador = compararDineroDeJugadores (ultimaRonda jugador) (ultimaRonda otroJugador)
// JUGADORES

object julieta {
  var tickets = 25
  var cansancio = 0
  
  method punteria() = 20

  method fuerza() = 80 - cansancio 

  method tickets() = tickets
  method tickets(nuevoValor) {tickets = nuevoValor}

// Que tienen en comun todos los juegos?

  method jugar(juego){
    tickets = tickets + juego.ticketsGanados(self) // aca estoy delgando, noc que va a pasar, ni se la logica detras de ticketsGanados
    cansancio = cansancio + juego.cansancioQueProduce()
  }

  method puedeCanjear(premio) = tickets >= premio.costo()
}

object gerundio { //hijo del dueño, polimorfico con julieta
  method jugar(juego){}
  method puedeCanjear(premio) = true
}


// premio

object osoDePeluche {
  method costo() = 45
}

object taladro {
  var property costo = 200
}


// juegos

object tiroAlBlanco {


  method ticketsGanados(jugador) = (jugador.punetria()/10).roundUp()
  method cansancioQueProduce() = 3
}

object pruebaDeFuerza {

  method ticketsGanados(jugador) = if(jugador.fuerza() >75) 20 else 0
  method cansancioQueProduce() = 8
}

object ruedaDeLaFortuna {

  var aceitada = true

  method aceitada() = aceitada                        //getter
  method aceitada(nuevoValor) {aceitada = nuevoValor} //setter

  method ticketsGanados(jugador) = 0.randomUpTo(20).roundUp()  //dame un numero random entre 0 y 20 y redondeamelo
  method cansancioQueProduce() = if(aceitada) 0 else 1
}

object robarseUnTicket {
  method ticketsGanados(jugador) = 1
  method cansancioQueProduce() = 10 
}
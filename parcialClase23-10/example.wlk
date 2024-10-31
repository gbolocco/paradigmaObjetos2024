class Jugador{
  var property nivelSospecha = 40
  var property mochila = []

  method esSospechoso(){
    nivelSospecha > 50
  }

  method buscarItem(unItem) {
    mochila.add(unItem)
  }

  method aumentarSospecha(unaCantidad){
    nivelSospecha += unaCantidad
  }

  method disminuirSospecha(unaCantidad){
    nivelSospecha -= unaCantidad
  }



}
class Tripulante inherits Jugador{
  var property tareas = []

  method agregarTarea(unaTarea) = tareas.add(unaTarea)

  method completoSusTareas() {
    tareas.isEmpty()
  }

  method realizarTarea() = self.tareaPendienteHacible().realizarse()

  method tareaPendienteHacible() = tareas.find{tarea => tarea.puedeRealizar(self)}
}

//cuando uno tiene la relacio uno a n, la responsabilidad la tiene la n
//si yo tenfo 1 jugador y n tareas, la responsabilidad de saber si la puede realizar es la tarea

class Impostor inherits Jugador{
  
  method completoSusTareas() = true
}

class ArreglarTablero {
  
  method puedeRealizar(unJugador) = unJugador.tiene("llave iglesa")
  method realizatePor(unJugador) {
    unJugador.aumentarSospecha(10)
    unJugador.usar("llave inglesa")
  } 

}

class SacarBasuta {

  method puedeRealizar(unJugador) {

    unJugador.tiene("escoba") && unJugador.tiene("bolsa consorcio")
  }
    
  method realizatePor(unJugador){

    unJugador.disminuirSospecha(5)  
    unJugador.usar("escoba")
    unJugador.usar("bolsa consorcio")
  } 

}

class VentilarNave {
  method puedeRealizar(unJugador) = true
  method realizatePor(unJugador) {
 //   nave.aumentarOxigeno(5)
  }
}


/*

if(self.seCompletaronTodasLasTareas)
throw new DomainExeption(message = "ganaron los tripulantes")
*/
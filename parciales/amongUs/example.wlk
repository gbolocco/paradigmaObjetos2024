object nave{

  var tripulantes = []

  var oxigeno = 100

  var cantidadTripulantes = 4

  var cantidadImpostores = 2

  method expulsarTripulante() {cantidadTripulantes -= 1}
  method expulsarImpostor() {cantidadImpostores -= 1}


  method afectarOxigeno(valor){
   oxigeno += valor
   if(oxigeno <= 0) throw new DomainException(message = "ganaron los imposores")
  }

  method alguienTiene(item) = tripulantes.any{unTripulante => unTripulante.tieneItem(item)}

  method sabotearOxigeno() {
    if(!self.alguienTiene("tubo de oxigeno")) self.afectarOxigeno(-10)
  }

  method cualquieraQueNoSeaSospechoso() = tripulantes.filter{unTripulante => !unTripulante.esSospechoso()}.anyOne()

  method jugadorMasSospechoso() = tripulantes.max{unTripulante => unTripulante.nivelSospecha()}

  method cualquieraQueTengaLaMochilaVacia() = tripulantes.filter{unTripulante => unTripulante.tieneMochilaVacia()}.anyOne()

  method reunionEmergencia() {
    var votos = []
    tripulantes.forEach{unTripulante => votos.add(unTripulante.votar())}

    const candidato =  votos.max{unVoto => votos.occurrencesOf(unVoto)}

    self.expulsar(candidato)

    candidato.muerto()

    self.verificarJuego()

  }

  method expulsar(candidato) {
    if(candidato != votoEnBlanco){
      tripulantes.remove(candidato)
      candidato.morir()
    }
  }

  method verificarJuego(){
    if(cantidadImpostores == 0) throw new DomainException(message = "ganaron los tripulantes")
    else if(cantidadTripulantes == 0) throw new DomainException(message = "ganaron los imposores")
  }
}

class Jugador{

  const color

  const personalidad

  var property nivelSospecha = 40

  var property tareas = []

  var property impugnado = false

  var mochila = []

  method tieneItem(item) = mochila.contains(item)

  method usarItem(item) = mochila.remove(item)

  method buscarItem(item) = mochila.add(item)

  method afectarSospecha(valor) {nivelSospecha += valor}

  method esSospechoso() = nivelSospecha > 50

  method realizarTarea(unaTarea){
    if(unaTarea.cumpleCondicion(self)) {
      
      unaTarea.serRealizadaPor(self)
      tareas.remove(unaTarea)

    }
  }

  method tieneMochilaVacia() = mochila.isEmpty()

  method completoSusTareas() = tareas.isEmpty()

  method llamarReunion() {nave.reunionEmergencia()}

  method votar() {

    if(impugnado) return votoEnBlanco
    else return personalidad.votarSegun()
  }

  method morir(){
    nave.expulsarTripulante()
  }

}

class Impostor inherits Jugador{

  override method realizarTarea(unaTarea) {}

  override method completoSusTareas() = true

  method realizarSabotaje(unSabotaje) {
    unSabotaje.serRealizado()
    self.afectarSospecha(5)
  }

  override method morir(){
    nave.expulsarImpostor()
  }
}

// votoEnBlanco

object votoEnBlanco{}

// Personalidad

object troll{
  method votarSegun() = nave.cualquieraQueNoSeaSospechoso()
}

object detective{
  method votarSegun() = nave.jugadorMasSospechoso()
} 

object materialista{
  method votarSegun() = nave.cualquieraQueTengaLaMochilaVacia()
}


// Tareas
object arreglarTableroElectrico{
  
  method cumpleCondicion(jugador) = jugador.tieneItem("llave inglesa")

  method serRealizadaPor(jugador) = jugador.afectarSospecha(10)

}

object sacarLaBasura{
  
  method cumpleCondicion(jugador) = jugador.tieneItem("escoba") and jugador.tieneItem("bolsa de consorcio")
  method serRealizadaPor(jugador) = jugador.afectarSospecha(-5)

}

object ventilarLaNave {
  
  method cumpleCondicion(jugador) = true
  
  method serRealizadaPor(jugador) {nave.afectarOxigeno(5)}

}

// Sabotajes

object reducirOxigeno{

  method serRealizado() {nave.sabotearOxigeno()}
}

class Impugnar{
  const jugadorImpugnado

  method serRealizado() = jugadorImpugnado.impugnado(true)

}
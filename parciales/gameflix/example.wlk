// Parcial: Gameflix and Chill

class Juego {
  const property titulo
  const property precio
  const property categoria

  method esBarato() = precio < 30

  method serJugado(unaPersona,horas)

}

class JuegoViolento inherits Juego (categoria = "violento"){

  override method serJugado(unaPersona,horas){
    unaPersona.afectarHumor(-10*horas)
  }
}

class MOBA inherits Juego (categoria = "moba"){

  override method serJugado(unaPersona,horas){
    unaPersona.gastarSaldo(30)
  }
}

class JuegoTerror inherits Juego (categoria = "terror"){

  override method serJugado(unaPersona,horas){
    unaPersona.tirarTodoAlCarajo()
  }
}

class JuegoEstrategico inherits Juego (categoria = "estrategico"){

  override method serJugado(unaPersona,horas){
    unaPersona.afectarHumor(5*horas)
  }
}

class Usuario{

  const nombre
  var property suscripcion
  var humor
  var property saldo

  method buscar(juego) = gameflix.buscarEnLibreria(juego)

  method filtrar(unaCategoria) = gameflix.filtrarPorCategoria(unaCategoria)

  method recomendar() = gameflix.recomendarJuegoAlAzar()

  method puedeJugar(juego) = suscripcion.permiteJugarSuscripcion(juego) && self.buscar(juego)

  method actualizarSuscripcion(nuevaSuscripcion) { suscripcion = nuevaSuscripcion}

  method pagarMensualidad(){
    if(suscripcion.precio() > saldo) self.actualizarSuscripcion(prueba)
    
    else saldo -= suscripcion.precio()
    
  }

  method jugar(juego,horas) {

    if(self.puedeJugar(juego)) juego.serJugado(self,horas)

    throw new DomainException(message = "No lo puede Jugar")

  }

  method afectarHumor(cantidad) { humor += cantidad }

  method tirarTodoAlCarajo() { self.actualizarSuscripcion(infantil) }

  method gastarSaldo(cantidad){
    if(cantidad > saldo) throw new DomainException(message="no te alcanza para la skin")

    saldo -= cantidad
  }
}

object gameflix{

  const property usuariosRegistrados = []
  const property juegosDisponibles = []

  method buscarEnLibreria(juego){
    if(!juegosDisponibles.contains(juego)) throw new DomainException(message="no se encontro el juego")

    return juego
  }

  method filtrarPorCategoria(unaCategoria){
     return juegosDisponibles.filter{juego => juego.categoria() == unaCategoria}
  }

  method recomendarJuegoAlAzar() = juegosDisponibles.anyOne()

  method cobrarMensualidad(){
    usuariosRegistrados.forEach{unUsuario => unUsuario.pagarMensualidad()}
  }

}

// suscripciones:

object premium{
  const property precio = 50

  method permiteJugarSuscripcion(juego) = true

}

object base{
  const property precio = 25

  method permiteJugarSuscripcion(juego) {
    juego.esBarato()
  }

}


object infantil{
  const property precio = 10

  method permiteJugarSuscripcion(juego) {
    juego.categoria() == "infantil"
  }
}

object prueba{
  const property precio = 0

  method permiteJugarSuscripcion(juego) {
    juego.categoria() == "demo"
  }
  
}
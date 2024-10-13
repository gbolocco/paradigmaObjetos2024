class Tanque {
  const armas = []
  const tripulantes = 2
  var salud = 1000
  var property prendidoFuego = false

  method emiteCalor() = prendidoFuego || tripulantes > 3

  method sufrirDanio(danio) {
    salud -= danio
  }

  method atacar(objetivo) {
    armas.anyOne().dispararA(objetivo)
  }
}

class TanqueBlindado inherits Tanque{
  const blindaje = 10
  override method emiteCalor() = false

  override method sufrirDanio(danio){
    if(blindaje < danio)
     super(danio-blindaje)
  }
}

// Armas
class Misil { // las clases nos permite no crear repeticiones
  const potencia
  var agotada = false
  method agotada() = agotada
  method dispararA(objetivo){
    agotada = true
    objetivo.sufrirDanio(potencia)
  }
}

class Recargable {
  var cargador = 100

  method agotada() = cargador <= 0
}

class Rociador inherits Recargable{
  method dispararA(objetivo){
    cargador -= 20
    self.causarEfecto(objetivo)
  }
  method causarEfecto(objetivo)
}

class LanzaLlamas inherits Rociador{
  override method causarEfecto(objetivo){ // En el ejemplo no lo escribe con override, pero me salta un warning
    objetivo.prendidoFuego(true)
  }
}
class Matafuego inherits Rociador{
  override method causarEfecto(objetivo){
    objetivo.prendidoFuego(false)
  }
}

class Metralla inherits Recargable {
  const calibre

  method dispararA(objetivo){
    cargador -= 10
    if(calibre >= 50)
      objetivo.sufrirDanio(calibre/4)
  }
}


class Pajaro{
  var property ira

  method fuerza() = ira * 2

  method enojarse(valor) { ira *= 2 * valor}

  method esFuerte() = self.fuerza() > 50

  method tranquilizarse() { ira -= 5 }

  method serLanzadoA(islaCerdito) = islaCerdito.recibirImpacto(self)

}

class PajaroRencoroso inherits Pajaro{
    
  var cantidadDeVecesQueSeEnojo = 0

  override method enojarse(valor) {
    cantidadDeVecesQueSeEnojo += 1
    super(valor)
  }

}

class Red inherits PajaroRencoroso{

  override method fuerza() = ira * 10 * cantidadDeVecesQueSeEnojo

}

class Bomb inherits Pajaro{

  var property topeMaximoFuerza = 9000

  override method fuerza() = super().min(topeMaximoFuerza)

}

class Chuck inherits Pajaro{
  var property velocidadActual

  override method fuerza() {
    if(velocidadActual <= 80) return 150
    
    return (velocidadActual - 80) * 5 // a partir de los 80 kilometros por hora
  }

  override method tranquilizarse() {}
}

class Terence inherits PajaroRencoroso{

  var property multiplicador

  override method fuerza() = ira * cantidadDeVecesQueSeEnojo * multiplicador

}

class Matilda inherits Pajaro{

  var huevos = 0

  var property pesoDeCadaHuevo = 2

  override method fuerza() = ira * 2 + self.fuerzaDeSusHuevos()

  method fuerzaDeSusHuevos() = huevos * pesoDeCadaHuevo

  override method enojarse(valor) {
    huevos += 1
    super(valor)
  }
}


// EVENTOS

object sesionDeManejoDeLaIraConMatilda{

  method serRealizadaPor(pajaros){
    pajaros.forEach{unPajaro => unPajaro.tranquilizarse()}
  }
}

class InvasionDeCerditos {
  const cantidadDeCerditos

  method serRealizadaPor(pajaros){
    pajaros.forEach{unPajaro => unPajaro.enojarse(cantidadDeCerditos/100)}
  }
}

class FiestaSorpresa{
  const homenajeados = []

  method serRealizadaPor(pajaros) = homenajeados.forEach{unPajaro => unPajaro.enojarse(1)}
}

// ISLA

class IslaPajaro{

  var pajaros = []

  method pajarosFuertes() = pajaros.filter{unPajaro => unPajaro.esFuerte()}

  method fuerzaDeLaIsla() = self.pajarosFuertes().sum{unPajaro => unPajaro.fuerza()}

  method realizar(evento) = evento.serRealizadaPor(pajaros)

  method realizarSerieDeEventos(serieDeEventos) = serieDeEventos.forEach{evento => self.realizar(evento)}

  method aracarIslaCerdito(islaCerdito) {
    pajaros.forEach{unPajaro => unPajaro.serLanzadoA(islaCerdito)}
  }
}

// Obstaculos

class Material{
  const ancho
  const multiplicador

  method resistencia()
}

class Vidrio inherits Material{
  override method resistencia() = 10 * ancho
}

class Madera inherits Material{
  override method resistencia() = 25 * ancho
}

class Piedra inherits Material{
  override method resistencia() = 50 * ancho
}

object cerditoObrero{
  method resistencia() = 50
}

class CerditoArmado{

  const defensa

  method resistencia() = 10 * defensa
}

// Isla Cerdito

class IslaCerdito{

  const obstaculos = []

  method seRecuperaronLosHuevos() = obstaculos.isEmpty()

  method recibirImpacto(unPajaro){
    const unObstaculo = obstaculos.first()
    if(unPajaro.fuerza() >= unObstaculo.resistencia()){ obstaculos.remove(unObstaculo) }
    if(self.seRecuperaronLosHuevos()) return "Se recuperaron los huevos"
    return "se lanzo exitosamente el pajaro"
  }
}

/*
Si quisiéramos incorporar nuevos pájaros a la isla, ¿qué cambios habría que hacer en la solución
planteada? ¿Qué conceptos nos ayudan?

habria que heredarlo de la clase pajaro y definir los criterios de fuerza y enojo, la solucion planteada es polimorfica
*/
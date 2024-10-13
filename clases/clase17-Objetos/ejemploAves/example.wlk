object pepita {
  var energy = 100

  method energy() = energy

  method volar(distancia) {
    energy = energy - distancia * 2
  }

  method comer(gramos){
    energy = energy + gramos*3
  }
}

object ramiro {
  var horasDormidas = 0

  method horasDormidas() = horasDormidas

  method horasDormidas(horas){
    horasDormidas = horas
  }

  method estaDeBuenHumor() = horasDormidas >= 8

  method entrenar(ave){
    const distancia = if(self.estaDeBuenHumor()) 15 else 30

    ave.volar(distancia)
  }
}
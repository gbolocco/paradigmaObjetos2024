class BarcoPirata{

  var property tripulacion

  const capacidad

  var property mision

  method esTemible() = mision.puedeSerRealizadaPor(self)

  method tieneSuficienteTripulacion() = tripulacion.size() >= capacidad * 0.9

  method alMenosUnoTenga(item){
    tripulacion.any{unPirata => unPirata.posee(item)}
  }

  method cantidadDeTripulantes() = tripulacion.size()

  method tripulacionBorrachaCon(num) = tripulacion.all{pirata => pirata.estaBorrachoCon(num)}

  method hayLugar() = self.cantidadDeTripulantes() < capacidad

  method cambiarMision(nuevaMision) {
    mision = nuevaMision
    tripulacion = tripulacion.filter{unPirata => mision.esUtil(unPirata)}
  }

  method pirataMasEbrio(){}

  method piratasDeLaCorona(){}

  method cuantosEstanPasadosDeGrog() = tripulacion.filter{unPirata => unPirata.estaBorrachoCon(90)}.size()

  method cantidadDeTiposDistintosDeItemDeTripulantesPasadosDeGrog(){}

  method tripulantePasadoDeGrofConMasDinero(){}

}

// PIRATA

class Pirata{

  var property dinero
  var property items = []
  var property nivelDeEbriedad

  method posee(item) = items.contains(item)

  method cantidadDeItems() = items.size()

  method estaBorrachoCon(num) = nivelDeEbriedad >= num

  method puedeSerParteDeLaTripulacion(unBarco){
    unBarco.mision().esUtil(self)
    unBarco.hayLugar()
  }

}

// Misiones

class Mision{

  method puedeSerRealizadaPor(unBarco) {
    unBarco.tieneSuficienteTripulacion()
  }

  method esUtil(unPirata)
}

object busquedaDelTesoro inherits Mision{

  override method puedeSerRealizadaPor(unBarco){
    unBarco.alMenosUnoTenga("llaveCofre")
    super(unBarco)
  }


  override method esUtil(unPirata) = (unPirata.posee("brujula") || unPirata.posee("mapa") || unPirata.posee("botella")) && (unPirata.dinero() <= 5)
  
}

class ConvertirseEnLeyenda inherits Mision{

  const itemObligatorio

  override method esUtil(unPirata) = (unPirata.cantidadItems() >= 10) && unPirata.posee(itemObligatorio)
  
}

class Saqueo inherits Mision{

  var property cantidadMonedas

  const victima 

  override method puedeSerRealizadaPor(unBarco){
    victima.esVulnerableA(unBarco)
    super(unBarco)
  }


  override method esUtil(unPirata) = (unPirata.dinero() <= cantidadMonedas) && victima.seAnima(unPirata)

}

class VictimaBarcoPirata{

  const barcoVictima

  method seAnima(unPirata) = unPirata.estaBorrachoCon(90)

  method esVulnerableA(unBarco) = barcoVictima.cantidadDeTripulantes() <= (unBarco.cantidadDeTripulantes() / 2)

}

class VictimaCiudadCostera{

  const cantidadHabitantes

  method seAnima(unPirata) = unPirata.estaBorrachoCon(50)

  method esVulnerableA(unBarco) =  (unBarco.cantidadDeTripulantes() >= (cantidadHabitantes * 0.4)) || unBarco.tripulacionBorrachaCon(90)

}
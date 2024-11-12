class Ninio{
  var property elementos = []

  var property caramelos

  var estaEnCama = false

  var empachado = false

  var actitud

  method capacidadSusto() = elementos.sum{unElemento => unElemento.sustoQueGenera()} * actitud 

  method asustar(unAdulto) {
    
    if(!estaEnCama) unAdulto.serAsustado(self)
    else throw new DomainException(message = "no puede asustar porque esta en cama")
  
  }
  method tieneMasDeNCaramelos(cantidadCaramelos) = (caramelos >= cantidadCaramelos)

  method recibirCaramelos(cantidadCaramelos) { caramelos += cantidadCaramelos }

  method comerCaramelos(cantidad){
    if(caramelos >= cantidad){
      self.consecuenciasDeComerCaramelos(cantidad)
      caramelos -= cantidad
    }
    throw new DomainException(message = "no tiene suficientes caramelos")
  }

  method consecuenciasDeComerCaramelos(cantidad){
    if(cantidad >= 10 and empachado and !estaEnCama) estaEnCama = true
    if(cantidad >= 10 and !empachado){
      actitud /= 2
      empachado = true
    }
  }
}

class Maquillaje{

  method sustoQueGenera() = 3

}

class Traje{

  const tipoDeTraje

  method sustoQueGenera() = tipoDeTraje.sustoSegunTraje()

}

object trajeTierno{
  method sustoSegunTraje() = 2
}

object trajeTerrorifico{
  method sustoSegunTraje() = 5
}

// Adulto

class Adulto{

  var property tolerancia

  var niniosQueIntentaronAsustarlo = []

  method niniosConMasDeNCaramelos(cantidadCaramelos) = niniosQueIntentaronAsustarlo.filter{unNinio => unNinio.tieneMasDeNCaramelos(cantidadCaramelos)}.size()

  method serAsustado(unNinio){

    const cantidadDeNinios = self.niniosConMasDeNCaramelos(15)
    const cantidadCaramelos = cantidadDeNinios * 10

    if(unNinio.capacidadSusto() > tolerancia){
      self.darCaramelos(unNinio,cantidadCaramelos)
    }
    niniosQueIntentaronAsustarlo.add(unNinio)
  }

  method darCaramelos(unNinio,cantidadCaramelos){
    unNinio.recibirCaramelos(cantidadCaramelos)
  }

}

class Abuelo inherits Adulto{
  

  override method serAsustado(unNinio){ // siempre se asustan

    const cantidadDeNinios = self.niniosConMasDeNCaramelos(15)
    const cantidadCaramelos = (cantidadDeNinios * 10) / 2
    self.darCaramelos(unNinio,cantidadCaramelos)
    niniosQueIntentaronAsustarlo.add(unNinio)
  }

}

class Necio inherits Adulto{

  override method serAsustado(unNinio){
    niniosQueIntentaronAsustarlo.add(unNinio)
  }

}

// Legiones

class Legion{

  var property grupo = []

  override method initialize() {
    if(grupo.size() < 2) throw new DomainException(message = "Toda Legion debe estar minimo por dos ninios")
  }

  method capacidadSusto() = grupo.sum{unNinio => unNinio.capacidadSusto()}

  method caramelos() = grupo.sum{unNinio => unNinio.caramelos()}

  method lider() = grupo.max{unNinio => unNinio.capacidadSusto()}

  method asustar(unAdulto) = grupo.forEach{unNinio => unNinio.asustar(unAdulto)}

}

// Barrios

class Barrios{

  var property grupo = []

  method tresNiniosConMasCaramelos() = grupo.sortedBy{uno, otro => uno.caramelos() > otro.caramelos()}.take(3)

  method elementosUsadosPorLosNiniosConMasDe10Caramelos() {

    const todosLosItems = grupo.filter{unNinio => unNinio.caramelos() > 10}.map{unNinio => unNinio.elementos()}.flatten()

    return self.obtenerElementosSinRepetir(todosLosItems)

  }

  method obtenerElementosSinRepetir(lista) = lista.filter{elemento => !self.estaRepetido(elemento,lista)}

  method estaRepetido(elemento,lista) = lista.filter{otroElemento => otroElemento == elemento}.size() > 1

}
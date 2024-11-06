

class Equipo{

  var property modo = standard

  var property quemado = false

  method consumo() = modo.consumoDe(self)
  method capacidadComputo() = modo.capacidadDeComputoDe(self)

  method estaActivo() = !quemado && (self.capacidadComputo() > 0)

  method consumoBase()
  method capacidadComputoBase()
  method computoExtraOverclock()

  method computar(problema)
  method quemar() {quemado = true}

}
class A105 inherits Equipo{

  override method consumoBase() = 300
  override method capacidadComputoBase() = 600

  override method computoExtraOverclock() = self.capacidadComputoBase() * 0.3

  override method computar(problema){
    if(problema.complejidad() > self.capacidadComputo()) throw new DomainException(message = "A105 trato de computar algo complejo y exploto")
    if(problema.complejidad() < 5) throw new DomainException(message = "A105 trato de computar algo boludo y exploto")

    modo.realizarComputo(self)
  }

}

class B2 inherits Equipo{
  var property microchips

  override method consumoBase() = 10 + 50 * microchips
  override method capacidadComputoBase() = 800.min(microchips*100)

  override method computoExtraOverclock() = 20 * microchips 

  override method computar(problema){
    if(problema.complejidad() > self.capacidadComputo()) throw new DomainException(message = "B2 trato de computar algo complejo y exploto")

    modo.realizarComputo(self)
  }


}


//SuperComputadora
class SuperComputadora{

  var property equipos = []

  var totalDeComplejidadComputada = 0

  method equiposActivos() = equipos.filter{cpu => cpu.estaActivo()}

  method capacidadComputo() = self.equiposActivos().sum{cpu => cpu.capacidadComputo()}

  method consumo() = self.equiposActivos().sum{cpu => cpu.consumo()}

  method equipoQueMasConsume() = self.equiposActivos().max{cpu => cpu.consumo()}
  method equipoQueMasComputa() = self.equiposActivos().max{cpu => cpu.capacidadComputo()}

  method malConfigurada() = !(self.equipoQueMasComputa() == self.equipoQueMasConsume())

  method computar(problema){

    self.equiposActivos().forEach{cpu => cpu.computar(new Problema(complejidad = problema.complejidad() / self.equiposActivos().size()))}
    totalDeComplejidadComputada += problema.complejidad()
  }
}

//Modos
object standard{

  method consumoDe(equipo) = equipo.consumoBase()
  method capacidadDeComputoDe(equipo) = equipo.capacidadComputoBase()
  
  method realizarComputo(equipo) {}

}

class overclock{

  var usosAntesDeQuemarse

  method consumoDe(equipo) = equipo.comsumoBase() * 2
  method capacidadDeComputoDe(equipo) = equipo.capacidadComputoBase() + equipo.computoExtraOverclock()

  method realizarComputo(equipo) {
    if(usosAntesDeQuemarse == 0){
      
      equipo.quemar()
      throw new DomainException(message="se quemo el equipo")
    }

    usosAntesDeQuemarse -= 1
  }
}

const diecisieteNumeros = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

class Ahorro{

  method consumoDe(equipo) = 200
  method capacidadDeComputoDe(equipo) = self.consumoDe(equipo) / equipo.consumoBase() * equipo.capacidadComputoBase()

  method realizarComputo(equipo) {

    const numeroRandom = diecisieteNumeros.anyOne()

    if(numeroRandom == 1){
      throw new DomainException(message="exploto todo al demonio")//digo 1 porq puede ser cualquier numero, todos tienen 1/17 probabilidad de ser elegidos
    }
  }
}

class ApruebaDeFallo inherits Ahorro{
  var contador = 0

  override method capacidadDeComputoDe(equipo) = super(equipo) / 2

  override method realizarComputo(equipo){
    if((contador % 100) == 0) throw new DomainException(message="exploto todo al demonio")

    contador += 1
  }
}

// Problema

class Problema{
  const property complejidad
}
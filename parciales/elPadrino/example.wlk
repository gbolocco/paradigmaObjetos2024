//Familia

class Familia{

  var property integrantes = []

  var property don

  method soldados() = integrantes.filter{unIntegrante => unIntegrante.esSoldado()}


  method duermenConLosPeces() = integrantes.filter{unIntegrante => unIntegrante.duermeConLosPeces()}

  method peligroso() = integrantes.max{unIntegrante => unIntegrante.cantidadDeArmas()}

  method elQueQuieraEstarArmadoQueAndeArmado() = integrantes.forEach{unIntegrante => unIntegrante.agregarUnArma(new Revolver(capacidad = 6, balas = 6))}

  method integrantesVivos(){
    return integrantes.filter({ unIntegrante => unIntegrante.estaVivo() })
  }

  method ataqueSorpresa(otraFamilia) = self.integrantesVivos().forEach{unIntegrante => unIntegrante.tomarVictima(otraFamilia)}

  method renombrarSubJefes(){
    const posiblesSubJefes = self.soldados()

    posiblesSubJefes.forEach{unIntegrante => unIntegrante.condicionSubjefe()}
  }

  method nuevoDon(){
    don = don.nuevoDon()
  }

  method aumentarLeatadFamilia(cantidad) = integrantes.forEach{unIntegrante => unIntegrante.aumentarLeatad(cantidad)}

  method luto(){
    self.renombrarSubjefes()
    self.nuevoDon()
    self.aumentarLeatadFamilia(0.1)
  }
}

//Rangos

class Miembro{
  const nombre

  var property herido = false

  var property muerto = false 

  var property rango

  var property armas = []

  var property lealtad

  method morir(){
    self.muerto(true)
  }

  method serHerido(){
    if(herido) self.morir()
    else self.herido(true)
  }

  method estaVivo() = !muerto

  method cualquierArma() = armas.anyOne()

  method primerArma() = armas.head()

  method atacar(unaPersona) = rango.atacarSegunRango(self,unaPersona)

  method esSoldado() = rango.esSoldado()

  method subirRango(nuevoRango) {
    rango = nuevoRango
  }

  method aumentarLeatad(cantidad){
    lealtad += lealtad * cantidad
  }

  //ACCION

  method duermeConLosPeces() = muerto

  method cantidadDeArmas() = armas.size()

  method agregarUnArma(unArma) = armas.add(unArma)

  method sabeDespacharElegantemente() = rango.sabeDespacharElegantementeSegunRango(self)

  method tieneArmaSutil() = armas.any{unArma => unArma.esSutil()}

  method tomarVictima(unaFamilia) {
    
    const masPeligroso = unaFamilia.peligroso()
    if(masPeligroso.estaVivo()) self.atacar(masPeligroso)
  }

  method condicionSubjefe(){
    if(self.cantidadDeArmas() >= 5) self.subirRango(new Subjefe(subordinados = []))
  }

  method nuevoDon() = rango.nuevoDon()
}


class Don{

  const subordinados = []

  method delegarASubordinado(enemigo) {
    subordinados.anyOne().atacar(enemigo)
  }
  
  method atacarSegunRango(miembro,enemigo) {
   
    self.delegarASubordinado(enemigo)
  }

  method sabeDespacharElegantementeSegunRango(miembro) = true

  method nuevoDon = subordinados.max{unSubordinado => unSubordinado.lealtad()}

}

class Subjefe{

  const subordinados = []

  method atacarSegunRango(miembro,enemigo) {
    miembro.cualquierArma().usarContra(enemigo)
  }

  method sabeDespacharElegantementeSegunRango(miembro) = subordinados.any{unIntegrante => unIntegrante.tieneArmaSutil()}

  method esSoldado() = false
}

class Soldado {

  method atacarSegunRango(miembro,enemigo) {
    miembro.primerArma().usarContra(enemigo)
  }

  method sabeDespacharElegantementeSegunRango(miembro) = miembro.tieneArmaSutil()

  method esSoldado() = true

}

// Armas
class Arma{

  const capacidad

  var balas

  method esSutil()

  method usarContra(persona)

  method recargar(){
    balas = capacidad
  }

}

class Revolver inherits Arma{

  override method esSutil() = (balas == 1)

  override method usarContra(persona){
    if(balas > 0){
      balas -= 1
      persona.morir()
    }else self.recargar()
  }
}

class Escopeta inherits Arma{

  override method esSutil() = false

  override method usarContra(persona){
    if(balas > 0){
      balas -= 1
      persona.serHerido()
    }else self.recargar()
  }
}

class CuerdaDePiano{

  const buenaCalidad

  method esSutil() = true

  method usarContra(persona){
    if(buenaCalidad) persona.morir()
  }
}
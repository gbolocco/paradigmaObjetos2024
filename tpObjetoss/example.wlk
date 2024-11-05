class Guerrero {
  var property vida
  const armas = []
  const property items = []
  
  method vida() = vida
  
  method armas() = armas
  
  method modificarVida(valor) {
    vida += valor
  }
  
  method cantidadDeItem(itemBuscado) = items.filter(
    { item => item == itemBuscado }
  ).size()
  
  method perderItem(item) = items.remove(item)
  
  method ganarItem(item) = items.add(item) //method puedePasar(){}
  
  method pasar(unaZona) {
    unaZona.afectar(self)
  }
  
  method poderArmas() = armas.sum({ arma => arma.poder() })
  
  method tieneArmas() = armas.size() >= 1
  
  method poder()
  
  method fueraDeCombate() = self.vida() <= 0
}

class Hobbit inherits Guerrero {
  
  override method poder() = (vida + self.poderArmas()) + items.size()
}

class Enano inherits Guerrero {
  const factorDePoder
  
  override method poder() = vida + (factorDePoder * self.poderArmas())
}

class Elfo inherits Guerrero {
  var property destrezaBase = 2
  const destrezaPropia
  
  override method poder() = vida + (self.poderArmas() * (destrezaBase + destrezaPropia))
}

class Humano inherits Guerrero {
  const limitadorDePoder
  
  override method poder() = (vida * self.poderArmas()) / limitadorDePoder
}

class Maiar inherits Guerrero {
  var property multiplicadorNormal = 15
  var property multiplicadorPeligro = 300
  
  override method poder() {
    if (vida >= 10) {
      return self.calcularPoder(multiplicadorNormal)
    } else {
      return self.calcularPoder(multiplicadorPeligro)
    }
  }
  
  method calcularPoder(
    multiplicador
  ) = (vida * multiplicador) + (self.poderArmas() * 2)
}

class Gollum inherits Guerrero {
  override method poder() {
    
  }
}

object baculo {
  method poder(origen) = 400
}

class Origen {
  const valorOrigen
  
  method poderOriginario() = valorOrigen
}

const elfico = new Origen(valorOrigen = 30)

const enano = new Origen(valorOrigen = 20)

const humano = new Origen(valorOrigen = 15)

//                                               Tom Bombadil
object tomBombadil inherits Guerrero (vida = 100) {

  override method poder() = 10000000
  
  method puedePasar(unaZona) = true
  
  override method pasar(unaZona) {
  }
}
//=============================================================================
//                                 PARTE 2
//=============================================================================
class Espada {
  const multiplicador
  const origen
  
  method poder() = origen.poderOriginario() * multiplicador
}

class Daga inherits Espada {
  // La daga reutiliza el cálculo del poder de la espada
  override method poder() = super() / 2
}

class Baculo {
  const nivelDePoder
  
  method poder() = nivelDePoder
}

class Arco {
  var property tension = 40
  const largo
  
  method poder() = (tension * largo) * 0.1
}

class Hacha {
  const pesoDeLahoja
  const largoDelMango
  
  method poder() = largoDelMango * pesoDeLahoja
}

//=============================================================================
//                       Los Caminos de la Tierra Media
//=============================================================================
class Zona {
  const region

  method region() = region

  const property zonasLimitrofes = []
  
  method afectar(guerrero) {}

  
  method efectoVida(guerrero, valor) = guerrero.modificarVida(valor)
  
  method efectoPerderItem(guerrero, cantidadADescontar, item) {
    if (cantidadADescontar > 0) {
      guerrero.perderItem(item)
      self.efectoPerderItem(guerrero, cantidadADescontar - 1, item)
    }
  }
  
  method efectoGanarItem(guerrero, cantidadAAgregar, item) {
    if (cantidadAAgregar > 0) {
      guerrero.ganarItem(item)
      self.efectoGanarItem(guerrero, cantidadAAgregar - 1, item)
    }
  }
  
  method requiereGuerrero(unGrupo) {}
  
  method requiereItem(unGrupo) {}
  
  method permitirPasarGuerreros(unGrupo)

  method esLimitrofe(unaZona) = zonasLimitrofes.contains(unaZona) //&& unaZona.esLimitrofe(self)?
}



// ==========[Region de gondor]==========

object pradosDeParthGalen inherits Zona (region = "gondor") {

  override method afectar(guerrero) {
    self.efectoVida(guerrero, -25)
  }

  override method permitirPasarGuerreros(unGrupo) = true
} 

object belfalas inherits Zona (region = "gondor", zonasLimitrofes = [lebennin, lamedon]) {
  override method afectar(guerrero) {
    self.efectoGanarItem(guerrero, 1, "pan de lembas")
  }
  
  override method permitirPasarGuerreros(unGrupo) = true
}

object lebennin inherits Zona (region = "gondor", zonasLimitrofes = [belfalas, minasTirith]) {
  override method afectar(guerrero) {
    
  }
  
  override method requiereGuerrero(unGrupo) = unGrupo.tieneAlgunoConPoder(1500)
  
  override method permitirPasarGuerreros(unGrupo) = self.requiereGuerrero(
    unGrupo
  )
}

object minasTirith inherits Zona (region = "gondor", zonasLimitrofes = [lebennin]) {

  override method afectar(guerrero) {
    self.efectoVida(guerrero, -15)
  }
  
  override method requiereItem(unGrupo) = unGrupo.tiene("lembas", 10)
  
  override method permitirPasarGuerreros(unGrupo) = self.requiereItem(unGrupo)
}

object lamedon inherits Zona (region = "gondor", zonasLimitrofes = [edoras, belfalas]) {
  // en la parte 2 no aparece esta zona en la region gondor, aqui si
  override method afectar(guerrero) {
    const unTercioDeVida = guerrero.vida() * 0.3
    self.efectoVida(guerrero, unTercioDeVida)
  }
  
  override method permitirPasarGuerreros(unGrupo) = true
  // el enunciado no dice ninguna condicion
} // ==========[Region de Rohan]==========

object bosqueDeFangorn inherits Zona (region = "rohan", zonasLimitrofes = [estemnet, edoras]) {
  override method afectar(guerrero) {
    self.efectoPerderItem(guerrero, 1, "capa elfica")
  }
  
  override method requiereGuerrero(unGrupo) = unGrupo.tieneAlgunoConArmas()
  
  override method permitirPasarGuerreros(unGrupo) = self.requiereGuerrero(
    unGrupo
  )
}

object edoras inherits Zona (region = "rohan", zonasLimitrofes = [estemnet , lamedon, bosqueDeFangorn]){
  override method afectar(guerrero) {
    self.efectoGanarItem(guerrero, 1, "vino caliente")
  }
  
  override method permitirPasarGuerreros(unGrupo) = true
}

object estemnet inherits Zona (region = "rohan", zonasLimitrofes = [bosqueDeFangorn, edoras]) {
  override method afectar(guerrero) {
    self.efectoVida(guerrero, guerrero.vida())
  }
  
  override method requiereItem(unGrupo) = unGrupo.tiene("capa elfica", 3)
  
  override method permitirPasarGuerreros(unGrupo) = self.requiereItem(unGrupo)
}
//=============================================================================

//                                 PARTE 3
//=============================================================================
// Efecto de vida: Podría causar un aumento o disminución de vida. Por ejemplo, pasar por Moria va a reducir la vida claramente, mientras que pasar por Rivendel produce un obvio aumento.
// Efecto de Ítem: En este caso todos los integrantes del grupo pierden o ganan, unidades de algún ítem determinado. En el caso de pérdida, si algún integrante del grupo no tiene el item, no sucede nada.
// -------------- MAS SOBRE CAMINOS --------------
/*
Los caminos están representados por una sucesión de zonas. Vamos a tener que considerar realizar alguna validación a la hora de ser recorrido,
teniendo en cuenta que las zonas que lo componen deben ser limítrofes entre ellas. 
Esto quiere decir que un camino que pasa por las zonas A, B y C, debe pasar que A limite con B y ésta última con C. Para resolver este inconveniente,
cada zona conoce con quien/es limita.

!! cada zona conoce con quien es limitrofe

[-] Cuando un camino es valido todo ok
[-] Cuando un camino es invalido lanzamos un error (exepcion)
*/
class GrupoGuerreros {
  var property guerreros = []
  
  method puedenPasarCamino(unCamino) = unCamino.permitirPasarCamino(self)

  method pasarCamino(unCamino) {
    if (self.puedenPasarCamino(unCamino)){
      unCamino.recorrerCamino(self)
    }
  }

  method puedenPasar(unaZona) = unaZona.permitirPasarGuerreros(self)

  
  method pasarPorZona(unaZona) {
    if (self.puedenPasar(unaZona)) {
      guerreros.forEach({ guerrero => guerrero.pasar(unaZona) })
      
      guerreros = guerreros.filter({ guerrero => !guerrero.fueraDeCombate() })
    } else {
      throw new DomainException(
        message = "Los guerreros no pueden pasar por la zona"
      )
    }
  }
  
  // para que un grupo de guerreros atraviese un camino debemos verificar que el mismo sea valido
  method tiene(unItem, cantidadRequerida) = cantidadRequerida <= guerreros.sum(
    { guerrero => guerrero.cantidadDeItem(unItem) }
  )
  
  method tieneAlgunoConPoder(poder) = guerreros.any(
    { guerrero => guerrero.poder() >= 1500 }
  )
  
  method tieneAlgunoConArmas() = guerreros.any(
    { guerrero => guerrero.tieneArmas() }
  )
}

class Camino { // la accion de recorrer caminos debe hacerse en grupo//   var property lugares = []//   method puedenRecorrerCamino(guerreros) = lugares.all({lugar => lugar.permitirPasarGuerreros(guerreros)})
  
  const property lugares = []
  var property recorrido = lugares
  
  method caminoValido() {
    

    if(recorrido.size() <= 1){
        recorrido = lugares
        return true
    }
    if(recorrido.size() > 1 && recorrido.get(0).esLimitrofe(recorrido.get(1))){

        recorrido = recorrido.drop(1)
        return self.caminoValido()
    }
    recorrido = lugares
    return false
  }


  method regionesQuePasa() = lugares.map{zona => zona.region()}.asSet()


  method permitirPasarCamino(unGrupo) {
    
    if(self.caminoValido()) {
      return true
    }
      throw new DomainException(message = "Los guerreros no pueden pasar por el camino, el mismo es invalido")
  }
  
  method recorrerCamino(unGrupo) {  
    if(self.permitirPasarCamino(unGrupo)){
      
      lugares.forEach({
        lugar => unGrupo.pasarPorZona(lugar)

      })
    }
  }
}

object caminoPrueba inherits Camino(lugares=[bosqueDeFangorn, edoras, lamedon, belfalas, lebennin, minasTirith]){}
object caminoPrueba2 inherits Camino(lugares=[lamedon,belfalas,lebennin]){}

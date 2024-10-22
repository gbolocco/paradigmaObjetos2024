class Personaje{
  const property inteligencia
  const property fuerza
  var property rol //guerrero, cazador, brujo. Los personajes tienen un unico rol, pero si se aburren pueden cambiarlo

  method potencialOfensivo() = 10 * fuerza + rol.potencialOfensivoExtra() //10 veces su fuerza + extra que depende del rol

  method esGroso() = self.esInteligente() || self.esGrosoParaSuRol()
  method esInteligente()
  method esGrosoParaSuRol() = rol.esGroso(self)

}
class Orco inherits Personaje{

  override method potencialOfensivo() = super() * 1.1 //Tiene un 10% mas
  override method esInteligente() = false
}

class Humano inherits Personaje{

  override method esInteligente() = inteligencia > 50
}


// === MASCOTAS ===
class Mascota{
  const fuerza
  const edad
  const tieneGarras //booleano

  method potencialOfensivoMascota() {
    if(tieneGarras) fuerza * 2
    else fuerza
  }

  method esLongeva() = edad > 10
}

// === ROLES ===
object guerrero{

  method potencialOfensivoExtra() = 100
  method esGroso(personaje) = personaje.fuerza() > 50
}

//cazadores pueden tener una mascota (fuerza, edad y si tiene o no garras)
class Cazador{
  var property mascota

  method potencialOfensivoExtra() = mascota.potencialOfensivoMascota()
  method esGroso(personaje) = mascota.esLongeva() // la mascota es longeva

}

object brujo{

  method potencialOfensivoExtra() = 0
  method esGroso(personaje) = true

}

// === ZONAS ===

class Ejercito{
  const property miembros = []
  
  method potencialOfensivoEjercito() = miembros.sum{personaje => personaje.potencialOfensivo()}

  method invadir(zona) {
    if(zona.potencialDefensivo() < self.potencialOfensivoEjercito()) zona.seOcupaPor(self)
  }
}

class Zona {
  var habitantes
  method potencialDefensivo() = habitantes.poderOfensivoEjercito()

  method seOcupaPor(ejercito) {habitantes = ejercito}
}

class Ciudad inherits Zona {
  override method potencialDefensivo() = super() + 300
}

class Aldea inherits Zona {
  const maxHabitantes = 50

  override method seOcupaPor(ejercito) {
    if(ejercito.miembros().size() > maxHabitantes) {

      const nuevosHabitantes = ejercito.miembros().sortedBy{uno, otro => uno.potencialOfensivo() > otro.potencialOfensivo()}.take(10)

      super(new Ejercito(miembros = nuevosHabitantes))

      ejercito.miemrbos().remove(nuevosHabitantes)

    }else super(ejercito)
  }
}
class Filosofo{
  
  const nombre

  var property edad
  var dias  

  var property actividades = []
  var honorificos = []
  var nivelDeIluminacion

  method presentate() = nombre + self.honorificosString()

  method honorificosString() = honorificos.join(",")

  method estaEnLoCorrecto() = nivelDeIluminacion > 100

  // ============
  method nivelDeIluminacion() = nivelDeIluminacion
  method afectarNivelDeIluminacion(cantidad) {nivelDeIluminacion += cantidad}

  method agregarActividad(unaActividad) {actividades.add(unaActividad)}

  method agregarHonorifico(unHonorifico) {
    
    if(!honorificos.contains(unHonorifico)) honorificos.add(unHonorifico)
  }

  method rejuvenecer(cantidadDias) {dias = 0.max(dias - cantidadDias)}


  // realizar actividad

  method realizarActividad(actividad) = actividad.serRealizadaPor(self)

  // hacer que pase un dia

  method vivirDia(){
    actividades.forEach{actividad => self.realizarActividad(actividad)}

    dias += 1
    if(dias == 365) self.cumplirUnAnio()
  }

  method cumplirUnAnio(){
    edad += 1
    self.afectarNivelDeIluminacion(10)
    if(edad > 60){
      self.agregarHonorifico("el sabio")
    }
  }

}

class Actividad{

  method serRealizadaPor(unFilosofo)
}

object tomarVino inherits Actividad {
  
  override method serRealizadaPor(unFilosofo){
    unFilosofo.afectarNivelDeIluminacion(-10)
    unFilosofo.agregarHonorifico("el borracho")
  }
  
}

class JuntarseEnElAgora inherits Actividad{
  
  const otroFilosofo

  override method serRealizadaPor(unFilosofo) {
    unFilosofo.afectarNivelDeIluminacion(otroFilosofo.nivelDeIluminacion() / 10)
  }
}

object admirarElPaisaje inherits Actividad {
  override method serRealizadaPor(unFilosofo) {}
}

class MeditarBajoUnaCascada inherits Actividad{

  const alturaCascada
  
  override method serRealizadaPor(unFilosofo){
    unFilosofo.afectarNivelDeIluminacion(10 * alturaCascada)
  }
}

class JugarUnDeporte inherits Actividad{

  const dias
  
  override method serRealizadaPor(unFilosofo){
    unFilosofo.rejuvenecer(dias)
  }
}

const jugarAlFutbol = new JugarUnDeporte(dias=1)
const jugarAlPolo = new JugarUnDeporte(dias=2)
const jugarAlWaterPolo = new JugarUnDeporte(dias=4)


// ==============================================


class Argumento{
  const descripcion
  const naturalezas

  method esEnrriquesedor() = naturalezas.all{unaNaturaleza => unaNaturaleza.esEnrriquesedoraCon(self)}

  method cantidadPalabras() = descripcion.words()

  method esPregunta() = descripcion.endsWith("?")
}

// naturalezas

object estoica{
  
  method esEnrriquesedoraCon(unArgumento) = true
}

object moralista{

  method esEnrriquesedoraCon(unArgumento) = unArgumento.cantidadPalabras() > 10
}

object esceptica{

  method esEnrriquesedoraCon(unArgumento) = unArgumento.esPregunta()
}

object cinica{
  
  method esEnrriquesedoraCon(unArgumento) =  1.randomUpTo(30).truncate(0) == 1
}

// ========


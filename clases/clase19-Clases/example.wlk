// [-] La monetizacion es independiente al tipo del contenido (polimorfismo)
// [-] Initialize se ejecuta cada vez que se instancia una clase, podemos usarlo para que los objetos siempre esten en estado consistente



class Contenido{
  const property titulo
  var property ofensivo = false
  var property cantidadVisitas = 0
  var property estrategiaMonetizacion

  method recaudacion() = estrategiaMonetizacion.recaudacionDe(self)
  method esPopular()
  method recaudacionMaximaParaPublicidad()

  method estrategiaMonetizacion(nuevaMonetizacion) {
    if(!nuevaMonetizacion.puedeAplicarse(self)) throw new DomainException(message = "El contenido no soporta la forma de monetizacion")
    
    estrategiaMonetizacion = nuevaMonetizacion
  }

  override method initialize(){
    if(!estrategiaMonetizacion.puedeAplicarse(self)) throw new DomainException(message = "El contenido no soporta la forma de monetizacion")
  }

  method puedeAlquilarse()
}


class Video inherits Contenido{

  override method esPopular() = cantidadVisitas > 10000

  override method recaudacionMaximaParaPublicidad() = 10000

  override method puedeAlquilarse() = true

}

const tagsDeModa = ["campera", "baggy"]
class Imagen inherits Contenido{
  var property tags = []
  
  override method esPopular() = tagsDeModa.all{tag => tags.contains(tag)}

  override method recaudacionMaximaParaPublicidad() = 4000

  override method puedeAlquilarse() = false

}

// MONETIZACION

object publicidad {
  method recaudacionDe(contenido) = (
    0.05  * contenido.cantidadVisitas() + 
    if(contenido.esPopular()) 2000 else 0
    ).min(contenido.recaudacionMaximaParaPublicidad()) // delegamos esPopular y recaudacionMaxima para poder lograr polimorfismo

  method puedeAplicarse(contenido) = !contenido.ofensivo()
}

class Donacion {
  
var property donaciones = 0

  method recaudacionDe(contenido) = donaciones

  method puedeAplicarse(contenido) = true
}

class Descarga {

  const property precio = 5

  method recaudacionDe(contenido){
    if(contenido.esPopular() && precio >= 5) return contenido.cantidadVisitas() * precio else return 0
  }

  method puedeAplicarse(contenido) = contenido.esPopular()

}

class Alquiler inherits Descarga {
  override method precio() = 1.max(super())
  method puedeAplicarse(contenido) = super(contenido) && contenido.puedeAlquilarse()
}

// USUARIOS

object usuarios{ // punto 2

  const todosLosUsuarios = []

  method emailDeUsuariosRicos() = todosLosUsuarios.filter{usuario => usuario.verificado()}.sortedBy{uno,otro => uno.saldo() >= otro.saldo()}.take(100).map{usuario => usuario.email()}

  method cantidadDeSuperUsuarios() = todosLosUsuarios.filter{usuario => usuario.esSuperUsuario()}.size()
}

class Usuario{
  const property nombre
  const property email

  var property verificado = false

  const contenidos = []

  method saldoTotal() = contenidos.sum{contenido => contenido.recaudacion()}

  method esSuperUsuario() = contenidos.size() >= 10

  method publicarContenido(contenido) {

    contenidos.add(contenido)
  }
}

/*
¿En qué parte de tu solución se está aprovechando más el uso de
polimorfismo? ¿Por qué?

- Estrategias de monetizacion y saldo total, no distingue que monetizacion tiene y que tipo de contenido es
*/


class Impresora{
  const property cabezal
  const property cabezalAux
  var property ocupada = false

  method trazar(recorrido){}

  method mostrarEnPantalla(mensaje){}

  method imprimir(documento){
    if(ocupada) throw new NoPuedeImprimirException()

    ocupada = true

    try{
      cabezal.eyectar(documento.tinta())
      self.trazar(documento.recorrido())
    }catch error: SinCargaException {
      cabezalAux.eyectar(documento.tinta())
    }then always{
      ocupada = false
    }
  }
}

class NoPuedeImprimirException inherits DomainException {}

class Cabezal{
  const property eficiencia
  const property cartucho

  method liberar(){}

  method eyectar(cantidad){
    cartucho.extraer(1 / eficiencia * cantidad)
    self.liberar()
  }
}

class Cartucho{
  var property carga

  method extraer(cantidad){

    if(carga > cantidad){
      carga -= cantidad
    }else{
      throw new SinCargaException (carga = carga)
    }
  } 
}

class SinCargaException inherits DomainException {
  const property carga
}

/*
> const documento = ...
> const impresoras = [...]

¿Como hago para imprimir el documento con alguna de esas impresoras?

> impresoras.anyOne().imprimir(documento)

Si la lista de impresoras esta vacia wollok me tira un error

> if(!impresoras.isEmpty()) impresoras.anyOne().imprimir(documento)

Si la lista no esta vacia y ninguna puede imprimir podemos lanzar una excepcion

"Todo método debe hacer lo que promete, o no hacer nada y explotar"

*/


/*
Practica:
- Una impresora "ocupada" no puede imprimir
- Una impresora permanece "ocupada" mientras imprime
- Si algo saliera mal durante una impresion, se desocupa
*/



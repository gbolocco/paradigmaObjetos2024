class Vaca {

  var litrosDeLeche = 100
  method estaContenta() = true

  method ordeniar(){
    //logica para ordeñar
  }
}

// const vacas = [new Vaca(), new Vaca()] --> lista de vacas
// vacas.add(new Vaca()) --> agrego un elemento a la lista
// vacas.size() --> 3

// vacas.filter({vaca => vaca.estaContenta()})


/*
Practica:
  [1] Consultar cuantos litros de leche podemos ordeñar de vacas contentas.
  [2] saber si todas las vacas estan contentas.
  [3] Ordeñar todas las vacas contentas.
  [4] ¿Podemos agregar cabras?
*/

class Corral{
  const vacas = []

  method lecheDisponible() = vacas.filter({vaca => vaca.estaContenta()}).sum({vaca => vaca.litrosDeLeche()})

  method estanTodasContentas() = vacas.all({vaca => vaca.estaContenta()})

  method ordeniarTodasLasVacasContentas() { 
    vacas.forEach{ vaca => 
      if(vaca.estaContenta())
        vaca.ordeniar()
    }  
  }

  // Si que se puede, el corral admite cualquier cosa que cumpla con la interfaz, cualquier cosa que pueda estar contenta y que pueda ser ordeniable.
}
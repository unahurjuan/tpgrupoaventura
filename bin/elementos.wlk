import wollok.game.*
import utilidades.*
import personajes.*


class Elementos {
	var property position = utilidadesParaJuego.posicionArbitraria()
	const property image = 0
	method reposicionarse() {
		if (!game.getObjectsIn(self.position()).contains(personajeSimple) && game.getObjectsIn(self.position()).size() > 1) {
			position = utilidadesParaJuego.posicionArbitraria()
		}
	}
	method efectoPacMan()
    {
        if (position.y() > game.height() - 1)
        {
            position = position.down(game.height())
        }
        
        if (position.y() < game.height() - game.height())
        {
            position = position.up(game.height())
        }
        
        if (position.x() > game.width() - 1)
        {
            position = position.left(game.width())
        }
        
        if (position.x() < game.width() - game.width())
        {
            position = position.right(game.width())
        }
    }
    method moverArriba() {
		position = position.up(1)
		self.efectoPacMan()
	}
	method moverAbajo() {
		position = position.down(1)
		self.efectoPacMan()
	}
	method moverIzquierda() {
		position = position.left(1)	
		self.efectoPacMan()	
	}
	method moverDerecha() {
		position = position.right(1)
		self.efectoPacMan()
	}
	method pisarX()
	
}

object mercado {
	var property position = utilidadesParaJuego.posicionArbitraria()
	var property deposito = []	
	method image() =	"market.png"
	method colision(personaje) {
		if (self.cajasEnLugar().size() > 0) {
			self.deposito().add(1)
			game.removeVisual(self.cajasEnLugar())
		}
	}
	method dejarLlaves(personaje) {
		if (personaje.bolsillo().size() > 0) {
			self.deposito().add(1)
			personaje.bolsillo().clear()
		}
		else {
			game.say(personajeSimple, "No tengo llave")
		}
	}
	method cajasEnLugar() {
		return game.getObjectsIn(self.position()).filter{o => o.image() == "caja.png"}
	}	
	method pisarX(){}
}

class Caja inherits Elementos {
	override method image() = "caja.png"
	method eliminarse(){
        game.removeVisual(self)
    }
    override method pisarX(){}			
}

class Llave inherits Elementos{
	override method image() = "key.png"
	method colision(personaje) {
		if (personaje.bolsillo().size() == 0) {
			personaje.bolsillo().add(1)
			game.removeVisual(self)
		}
	}
	override method pisarX(){}
}

class Energia inherits Elementos {
    override method image() = "energia.png"
     method colision(personaje) {
        personaje.ganarEnergia(10)
    }
}

class CeldaSorpresa inherits Elementos {
	override method image() = "piso.png"
     method pisar(personaje) {
        const random = 0.randomUpTo(4).truncate(0)
        
        game.say(personaje, random.toString())
        
        if (random == 0)
            personaje.ganarEnergia(30)
        else if (random == 1)
            personaje.perderEnergia(15)
        else if (random == 2)
            personaje.teletransportar()
        else
            personaje.crearObjeto()
        game.removeVisual(self)    
    }
    override method pisarX(){}
    
 }
 class Fondo {
    const property position = game.at(0, 0)
    var property image
    method pisarX() {}
}
class CosaIngerible{
    const property image = 0
    var property position = utilidadesParaJuego.posicionArbitraria()
    method cosaQueTeDa()
    method agarrar()
    method pisarX()
    method reposicionarse() {
        if (!game.getObjectsIn(self.position()).contains(personajeSimple) && game.getObjectsIn(self.position()).size() > 1) {
            position = utilidadesParaJuego.posicionArbitraria()
        	}
        	
        }
}


 class Corazon inherits CosaIngerible {
    override method image() =  "corazon.png"
    override method cosaQueTeDa()=20
    override method agarrar(){
        game.removeVisual(self)
        personajeSimple.ganarVida(self.cosaQueTeDa())
    }	
    override method pisarX(){self.agarrar()}
 }
 
  class Pastilla inherits CosaIngerible {
    override method image() =  "pills.png"
    override method cosaQueTeDa()=5
    override method agarrar(){
        game.removeVisual(self)
        personajeSimple.ganarVida(self.cosaQueTeDa())
    }	
    override method pisarX(){self.agarrar()}
 }

class Manzana inherits CosaIngerible {
    override method image() =  "fruta.png"
    override method cosaQueTeDa()=30
    override method agarrar(){
        game.removeVisual(self)
        personajeSimple.ganarEnergia(self.cosaQueTeDa())
    }
    override method pisarX(){}
}

class Caramelo inherits CosaIngerible {
    override method image() =  "candy.png"
    override method cosaQueTeDa()=10
    override method agarrar(){
        game.removeVisual(self)
        personajeSimple.ganarEnergia(self.cosaQueTeDa())
    }
    override method pisarX(){}
}

class ObjetosAExplotar{
	const property image =0
    var property position = utilidadesParaJuego.posicionArbitraria()
    method cosaQueTeDa()
    method dinero()
    method tocar(){
		personajeSimple.perderVida(self.cosaQueTeDa())
		game.say(personajeSimple, "auch!")
		personajeSimple.ganarDinero(self.dinero())
		self.eliminar()
        }
    method reposicionarse() {
        if (!game.getObjectsIn(self.position()).contains(personajeSimple) && game.getObjectsIn(self.position()).size() > 1) {
            position = utilidadesParaJuego.posicionArbitraria()
            
            }
        }
    method eliminar(){
    	game.removeVisual(self)
    }
    method pisarX(){
    	self.tocar()
    }
}

class Explosivo inherits ObjetosAExplotar{
	override method image() =  "explosivo.png"
    override method cosaQueTeDa()=20
	override method dinero()=20
}

class Cactus inherits ObjetosAExplotar{
	override method image() =  "cactus.png"
    override method cosaQueTeDa()=5
	override method dinero()=10

}

class Dinero inherits ObjetosAExplotar{
	override method cosaQueTeDa()=5
	override method image() = "dinero.png"	
	override method dinero()=1

}


object puerta{
	var image =	"door.png"
	const property position = utilidadesParaJuego.posicionArbitraria()	
	
	method image()=image
    method pisarX(){
    	game.removeVisual(personajeSimple)
    	image="doorOpen.png"
    	game.say(self, "Si!! Ganamos!")
    }
    
    method estaAbierta(){
    	return self.image()=="doorOpen.png"
    }
}









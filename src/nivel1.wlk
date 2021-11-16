import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import nivel2.*



object nivelBloques {

	method configurate() {
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image="fondoCompleto.png"))
				 
		// otros visuals, p.ej. bloques o llaves
		game.addVisual(mercado)
		game.addVisual(new Caja())
		game.addVisual(new Caja())
		game.addVisual(new Caja())
		game.addVisual(new Llave())
		game.addVisual(new Llave())
		game.addVisual(new Llave())

		game.addVisual(new CeldaSorpresa())
		game.addVisual(new CeldaSorpresa())
		game.addVisual(new CeldaSorpresa())
		game.addVisual(new CeldaSorpresa())
		game.addVisual(new Manzana())

		game.addVisual(new Manzana())
		game.addVisual(new Caramelo())
		game.addVisual(new Caramelo())
			
		// personaje, es importante que sea el último visual que se agregue
		game.addVisual(personajeSimple)
		game.schedule(1, {self.elementos().forEach{o => o.reposicionarse()}})
		
		// teclado
		// este es para probar, no es necesario dejarlo
		keyboard.t().onPressDo({ self.terminar() })
		
		personajeSimple.configurate1()
		self.gameOver()
		game.onTick(500,"ganoNivel1?",{self.ganar()})
		
	}
	
	method gameOver(){
		game.onTick(500,"perdioN1?",{personajeSimple.perdio()})
	}
	
	method ganar() {
		if (personajeSimple.gano1()) {
			game.removeTickEvent("ganoNivel1?")
			self.terminar()
		}
	}
	method terminar() {
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
		// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image="fondoCompleto.png"))
		game.addVisual(personajeSimple)
		// después de un ratito ...
		game.schedule(2500, {
			game.clear()
			// cambio de fondo
			game.addVisual(new Fondo(image="finNivel1.png"))
			// después de un ratito ...
			game.schedule(3000, {
				// ... limpio todo de nuevo
				game.clear()
				// y arranco el siguiente nivel
				nivelLlaves.configurate()
			})
		})
	}
	method elementos() {
		return self.caramelos()+self.frutas()+self.cajas()+self.llaves()+self.celdas()
	}
	method caramelos() {
		return game.allVisuals().filter{o => o.image() == "candy.png"}
	}
	method frutas() {
		return game.allVisuals().filter{o => o.image() == "fruta.png"}
	}
	method cajas() {
		return game.allVisuals().filter{o => o.image() == "caja.png"}
	}
	method llaves() {
		return game.allVisuals().filter{o => o.image() == "key.png"}
	}
	method celdas() {
		return game.allVisuals().filter{o => o.image() == "piso.png"}
	}	
}




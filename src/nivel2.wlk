import wollok.game.*
import fondo.*
import personajes.*
import elementos.*

object nivelLlaves {

	method configurate() {
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image="fondoCompleto.png"))
				 
		// otros visuals, p.ej. bloques o llaves
		game.addVisual(new Corazon())
		game.addVisual(new Corazon())
		game.addVisual(new Corazon())
		game.addVisual(new Pastilla())
		game.addVisual(new Pastilla())
		game.addVisual(new Pastilla())
		game.addVisual(new Manzana())
		game.addVisual(new Manzana())
		game.addVisual(new Caramelo())
		game.addVisual(new Caramelo())
		game.addVisual(new Manzana())
		game.addVisual(new Manzana())
		game.addVisual(new Caramelo())
		game.addVisual(new Caramelo())
		game.addVisual(new Dinero())
		game.addVisual(new Dinero())
		game.addVisual(new Dinero())
		game.addVisual(new Dinero())
		game.addVisual(new Dinero())
		game.addVisual(new Dinero())
		game.addVisual(new Cactus())
		game.addVisual(new Cactus())
		game.addVisual(new Explosivo())
		game.addVisual(new Explosivo())
		game.addVisual(new Explosivo())
			
		// personaje, es importante que sea el último visual que se agregue
		game.addVisual(personajeSimple)
		game.schedule(1, {self.elementos().forEach{o => o.reposicionarse()}})
		personajeSimple.configurate2()
		// este es para probar, no es necesario dejarlo
		keyboard.g().onPressDo({ self.ganar() })
		game.onCollideDo(personajeSimple,{cosa=>cosa.pisarX()})
		self.gameOver()
		self.abrirPuerta()
		game.onTick(1000,"logroObjetivos?",{self.abrirPuerta()})
		//game.onTick(1000,"ganoNivel2?",{self.terminar()})
		
	}
	
	method abrirPuerta(){
		if (personajeSimple.logroLosObjetivos()){
			game.addVisual(puerta)
			game.removeTickEvent("logroObjetivos?")
			self.ganoElJuego()
		}
	}
	
	method ganoElJuego(){
		game.onTick(100,"llegoALaPuerta?",{self.terminar()})
	}
	
	method terminar() {
		if (personajeSimple.gano2()) {
			game.removeTickEvent("llegoALaPuerta?")
			self.ganar()
		}
	}
	method gameOver() {
		game.onTick(100,"perdio2?",{personajeSimple.perdio2()})
	}
	method ganar() {
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
		// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image="fondoCompleto.png"))
		// después de un ratito ...
		game.schedule(2500, {
			game.clear()
			// cambio de fondo
			game.addVisual(new Fondo(image="ganaste.png"))
			// después de un ratito ...
			game.schedule(3000, {
				// fin del juego
				game.stop()
			})
		})
	}
	method elementos() {
		return self.caramelos()+self.frutas()+self.cajas()+self.llaves()+self.celdas()+self.dineros()+self.cactus()+self.explosivos()+self.pastillas()+self.corazones()
	}
	method explosivos() {
		return game.allVisuals().filter{o => o.image() == "explosivos.png"}
	}	
	
	method cactus() {
		return game.allVisuals().filter{o => o.image() == "cactus.png"}
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
	method dineros() {
		return game.allVisuals().filter{o => o.image() == "dinero.png"}
	}
	method pastillas() {
		return game.allVisuals().filter{o => o.image() == "pills.png"}
	}
	method corazones() {
		return game.allVisuals().filter{o => o.image() == "corazon.png"}
	}
	
}

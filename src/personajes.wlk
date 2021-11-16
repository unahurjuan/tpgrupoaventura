import wollok.game.*
import elementos.*
import utilidades.*
import nivel1.*
import nivel2.*

// en la implementación real, conviene tener un personaje por nivel
// los personajes probablemente tengan un comportamiendo más complejo que solamente
// imagen y posición

object personajeSimple {
	var property position = game.at(0,0)
	const property image = "player.png"	
	var property salud    = 100
    var property energia  = 30
    var property bolsillo = []
    var property cajasEnMercado = 0
    var property dinero = 0
    
    method configurate1()
    {
        game.addVisual(personajeEnergia)      
        keyboard.up().onPressDo    ({ self.moverArriba()})
        keyboard.down().onPressDo  ({ self.moverAbajo()})
        keyboard.left().onPressDo  ({ self.moverIzquierda()})
        keyboard.right().onPressDo ({ self.moverDerecha()})
        keyboard.m().onPressDo       ({ self.siHayManzanaAgarrar()self.siHayCarameloAgarrar()})
        keyboard.n().onPressDo		({self.agarrarLlave()})
        keyboard.b().onPressDo ({self.dejarLlaveEnDeposito()})
    }
    method configurate2() {
    	game.addVisual(personajeDinero)
    	game.addVisual(personajeSalud)
        game.addVisual(personajeEnergia)        
        keyboard.up().onPressDo    ({ self.moverArriba() })
        keyboard.down().onPressDo  ({ self.moverAbajo()})
        keyboard.left().onPressDo  ({ self.moverIzquierda()})
        keyboard.right().onPressDo ({ self.moverDerecha()})
        keyboard.m().onPressDo       ({ self.siHayManzanaAgarrar()self.siHayCarameloAgarrar()})
    	
    }
    
    
    method gano1(){ 
    	return cajasEnMercado==3 && mercado.deposito().size() == 3
    }
    	
    method logroLosObjetivos() {
    	return dinero == 86 && energia > 0 && salud>0 
    }
    	
    method gano2() {
    	return puerta.estaAbierta() 
    }
    
    method perdio(){
        if (self.energia() < 1){
        	game.clear()
            game.addVisual(new Fondo(image="game-over.png"))
        }
    }
    
    method perdio2() {
    	if( salud < 0 || energia < 0){
        	game.clear()
            game.addVisual(new Fondo(image="game-over.png"))   		
    	}
    }
    
    method perderEnergia(energiaNueva) {
    	energia -= energiaNueva
    }
    
    
    method ganarEnergia(num) {
    	energia += num
    }
    method ganarVida(num) {
    	salud += num
    }
    method perderVida(num) {
    	salud -= num
    }

    method ganarDinero(num) {
    	dinero += num
    }
    
//////////////////MANZANA/////////////////// 
    
    method siHayManzanaAgarrar(){
        self.hayManzanaDerecha()
        self.hayManzanaIzquierda()
        self.hayManzanaAbajo()
        self.hayManzanaArriba()
        }

    method hayManzanaDerecha(){
        game.getObjectsIn(self.position().right(1)).filter{o => o.image()=="fruta.png"}.forEach{m => m.agarrar()}
        }

    method hayManzanaIzquierda(){
        game.getObjectsIn(self.position().left(1)).filter{o => o.image()=="fruta.png"}.forEach{m => m.agarrar()}
        }

    method hayManzanaArriba(){
        game.getObjectsIn(self.position().up(1)).filter{o => o.image()=="fruta.png"}.forEach{m => m.agarrar()}
        }

    method hayManzanaAbajo(){
        game.getObjectsIn(self.position().down(1)).filter{o => o.image()=="fruta.png"}.forEach{m => m.agarrar()}
        }
        
        
/////////////////MOVIENTO/////////
   method moverArriba() {
        var mover = 0
        
        if (self.cajasEnLugarArriba(1).size() == 1 and self.cajasEnLugarArriba(2).size() == 1)
            mover = 0
        else
            mover = 1
        
        if (mover == 1)
        {
            position = position.up(1)
            self.cajasEnLugar().forEach{p => p.moverArriba()}
            self.efectoPacMan()
            self.meterCajaEnMercadoArriba()
            self.perderEnergia(1)
            self.activarCeldaSorpresa()
        }
    }
    method moverAbajo() {
        var mover = 0
        
        if (self.cajasEnLugarAbajo(1).size() == 1 and self.cajasEnLugarAbajo(2).size() == 1)
            mover = 0
        else
            mover = 1
        
        if (mover == 1)
        {
            position = position.down(1)
            self.cajasEnLugar().forEach{p => p.moverAbajo()}
            self.efectoPacMan()
            self.meterCajaEnMercadoAbajo()
            self.perderEnergia(1)
            self.activarCeldaSorpresa()
        }
    }
       method moverIzquierda() {
        var mover = 0
        
        if (self.cajasEnLugarIzquierda(1).size() == 1 and self.cajasEnLugarIzquierda(2).size() == 1)
            mover = 0
        else
            mover = 1
        
        if (mover == 1)
        {
               position = position.left(1)
            self.cajasEnLugar().forEach{p => p.moverIzquierda()}
            self.efectoPacMan()
            self.meterCajaEnMercadoIzq()
            self.perderEnergia(1)
            self.activarCeldaSorpresa()
        }
       }
       method moverDerecha() {
        var mover = 0
        
        if (self.cajasEnLugarDerecha(1).size() == 1 and self.cajasEnLugarDerecha(2).size() == 1)
            mover = 0
        else
            mover = 1
        
        if (mover == 1)
        {
               position = position.right(1)
            self.cajasEnLugar().forEach{p => p.moverDerecha()}
            self.efectoPacMan()
            self.meterCajaEnMercadoDer()
            self.perderEnergia(1)
            self.activarCeldaSorpresa()
        }
       }
    method cajasEnLugar() {
       	return game.getObjectsIn(self.position()).filter{o => o.image() == "caja.png"}
       }
       

   	 method cajasEnLugarArriba(numero) {
           return game.getObjectsIn(self.position().up(numero)).filter{o => o.image() == "caja.png"}
       }
       method cajasEnLugarAbajo(numero) {
           return game.getObjectsIn(self.position().down(numero)).filter{o => o.image() == "caja.png"}
       }
       method cajasEnLugarIzquierda(numero) {
           return game.getObjectsIn(self.position().left(numero)).filter{o => o.image() == "caja.png"}
       }
       method cajasEnLugarDerecha(numero) {
           return game.getObjectsIn(self.position().right(numero)).filter{o => o.image() == "caja.png"}
       }
	method meterCajaEnMercadoArriba(){
        if (self.hayCajaEnMercado(position.up(1))){
                game.getObjectsIn(position.up(1)).filter{o => o.image() == "caja.png"}.forEach({o=>o.eliminarse()})
                cajasEnMercado+=1
            }
    }

    method meterCajaEnMercadoAbajo(){
        if (self.hayCajaEnMercado(position.down(1))){
            game.getObjectsIn(position.down(1)).filter{o => o.image() == "caja.png"}.forEach({o=>o.eliminarse()})
            cajasEnMercado+=1
            }
    }

    method meterCajaEnMercadoIzq(){
        if (self.hayCajaEnMercado(position.left(1))){
            game.getObjectsIn(position.left(1)).filter{o => o.image() == "caja.png"}.forEach({o=>o.eliminarse()})
            cajasEnMercado+=1
            }
    }

    method meterCajaEnMercadoDer(){
        if (self.hayCajaEnMercado(position.right(1))){
            game.getObjectsIn(position.right(1)).filter{o => o.image() == "caja.png"}.forEach({o=>o.eliminarse()})
            cajasEnMercado+=1
            }
    }     
    
    method hayCajaEnMercado(posicion){
        return game.getObjectsIn(posicion).any{o => o.image()=="market.png"} and 
        game.getObjectsIn(posicion).any{o => o.image()=="caja.png"}
    }  
    
    method efectoPacMan()
    {
        if (position.y() > game.height() - 1)
        {
            position = position.down(game.height())
            self.cajasEnLugar().forEach{o => o.moverArriba()}
        }
        
        if (position.y() < game.height() - game.height())
        {
            position = position.up(game.height())
            self.cajasEnLugar().forEach{o => o.moverAbajo()}
        }
        
        if (position.x() > game.width() - 1)
        {
            position = position.left(game.width())
            self.cajasEnLugar().forEach{o => o.moverDerecha()}
        }
        
        if (position.x() < game.width() - game.width())
        {
            position = position.right(game.width())
            self.cajasEnLugar().forEach{o => o.moverIzquierda()}
        }
    }
    
    //////////////CARAMELOS///////       
       
   	method siHayCarameloAgarrar(){
        self.hayCarameloDerecha()
        self.hayCarameloIzquierda()
        self.hayCarameloAbajo()
        self.hayCarameloArriba()
        }

    method hayCarameloDerecha(){
        game.getObjectsIn(self.position().right(1)).filter{o => o.image()=="candy.png"}.forEach{m => m.agarrar()}
        }

    method hayCarameloIzquierda(){
        game.getObjectsIn(self.position().left(1)).filter{o => o.image()=="candy.png"}.forEach{m => m.agarrar()}
        }

    method hayCarameloArriba(){
        game.getObjectsIn(self.position().up(1)).filter{o => o.image()=="candy.png"}.forEach{m => m.agarrar()}
        }

    method hayCarameloAbajo(){
        game.getObjectsIn(self.position().down(1)).filter{o => o.image()=="candy.png"}.forEach{m => m.agarrar()}
        }
    

//////////CELDAS/////////

    method activarCeldaSorpresa() {
    	if (self.hayCeldaSorpresa()) {
    		self.celdasEnLugar().forEach{o => o.pisar(self)}
    	}
    }
    method hayCeldaSorpresa() {
    	return self.celdasEnLugar().size() > 0
    }
    method celdasEnLugar() {
    	return game.getObjectsIn(self.position()).filter{o => o.image() == "piso.png"}
    }


    method crearObjeto() {
    	const random = 0.randomUpTo(1).truncate(0)
    	
    	if (random == 0) {
    		game.addVisual(new Manzana())
    	}
    	else {
    		game.addVisual(new Caramelo())
    	}
    }
    
    method agarrarLlave() {
    	if (self.hayLlave()) {
    		self.llavesEnLugar().forEach{o => o.colision(self)}
    	}
    }
    
    method llavesEnLugar() {
    	return game.getObjectsIn(self.position()).filter{o => o.image() == "key.png"}
    }
    method hayLlave() {
    	return self.llavesEnLugar().size() > 0
    }
    

	method dejarLlaveEnDeposito() {
		if (self.mercadoEnLugar().size() > 0) {
			self.mercadoEnLugar().forEach{o => o.dejarLlaves(self)}
		}
		else {
			game.say(self, "No hay deposito")
		}
	}
	method mercadoEnLugar() {
		return game.getObjectsIn(self.position()).filter{o => o.image() == "market.png"}
	}
	method teletransportar() {
		position = utilidadesParaJuego.posicionArbitraria()
	}
	
}



/////////////////BLOQUE SALUD Y ENERGIA////////////////////////////////////    
    
object personajeSalud {
    method position() = game.at(1, game.height() - 2)
    method text()     = "Salud: "   + personajeSimple.salud()
    method image()    = "nada.png"
    method colision(personaje){}
    method pisarX(){}
}

object personajeEnergia {
    method position() = game.at(1, game.height() - 1)
    method text()     = "Energia: " + personajeSimple.energia()
    method image()    = "nada.png"
    method colision(personaje){}
    method pisarX(){}
}

object personajeDinero {
    method position() = game.at(1, game.height() - 3)
    method text()     = "Dinero: " + personajeSimple.dinero()
    method image()    = "nada.png"
    method colision(personaje){}
    method pisarX(){}
}




// Nota 8 (ocho): Buen parcial salvo por el uso inadecuado de atributos para datos temporales.
// 1) MB
// 2) R+. Usa un atributo para guardar un valor temporal, debería ser local a un método. 
// 3) MB-. 
// 4) MB-.
// 5) MB.
// 6) MB.
// 7) MB-
// 8) MB.

// Tests no andan!

class Familia {

	var property hijos = #{}

	method puedeSalirDePaseo() {
		return hijos.all({ hijo => hijo.puedeSalirDePaseo() })
	}

	method prendasInfaltables() {
		return hijos.sum({ hijo => hijo.prendaDeMaximaCalidad() })
	}

	method niniosMenores() {
		hijos.filter({ hijo => hijo.esMenorDe4()})
	}

	method pasear() {
		self.validarPaseo()
		hijos.forEach({ hijo => hijo.usarPrendas()})
	}

	method validarPaseo() {
		if (!self.puedeSalirDePaseo()) {
			self.error("aun no estan preparados para salir de paseo")
		}
	}

}

class Ninio {

	var property edad = 0
	var property talle = "talle"
	var prendas = #{}
	var property juguete = "unJuguete"

	method agregarPrenda(unaPrenda) {
		prendas.add{ unaPrenda}
	}

	method puedeSalirDePaseo() {
		return self.tieneLasPrendasNecesarias() and self.tieneAbrigoNecesario() and self.prendasDeCalidad()
	}

	method tieneLasPrendasNecesarias() {
		return prendas.size() >= 5
	}

	method tieneAbrigoNecesario() {
		return prendas.any({ prenda => prenda.nivelDeAbrigo() >= 3 })
	}

	method prendasDeCalidad() {
		return self.promedioCalidadDeSusPrendas() > 8
	}

	method promedioCalidadDeSusPrendas() {
		return (prendas.sum({ prenda => prenda.calidad(self) })) / (prendas.size())
	}

	method prendaDeMaximaCalidad() {
		prendas.max({ prenda => prenda.calidad(self)}).map(prenda)
	}

	// Sería mejor que se llame esPequenio
	method esMenorDe4() = edad < 4

	method usarPrendas() {
		prendas.forEach({ prenda => prenda.usar()})
	}

}

class NinioProblematico inherits Ninio {

	override method tieneLasPrendasNecesarias() {
		return prendas.size() >= 4
	}

	override method puedeSalirDePaseo() {
		return super() and self.tieneElJugueteApropiado()
	}

	method tieneElJugueteApropiado() {
		// between recibe dos números, no un rango.
		// Y sería mejor delegar en el juguete
		return self.edad().between(self.juguete().min() .. self.juguete().max())
	}

}

class Juguete {

	var property min = 0
	var property max = 0

}

class Prenda {

	var property nivelDeDesgaste = 0
	var property talle = "talle"

	method nivelDeComodidad(ninio) {
		return if (talle.coincide(ninio)) {
			8 - self.restaPorDesgaste(ninio)
		} else {
			0 - self.restaPorDesgaste(ninio)
		}
		// Mejor
		// return (if (talle.coincide(ninio)) 8 else 0) - self.restaPorDesgaste(ninio)
		// es más organizado
		// o incluso separar la comodidadPorTalle en un método
	}

	method restaPorDesgaste(ninio) {
		// Más fácil nivelDeDesgaste.min(3)
		return if (nivelDeDesgaste < 4) {
			nivelDeDesgaste
		} else {
			3
		}
	}

	method nivelDeAbrigo()

	method calidad(ninio) {
		return self.nivelDeAbrigo() + self.nivelDeComodidad(ninio)
	}

	method usar() {
		nivelDeDesgaste += 1
	}

}

class PrendasPares inherits Prenda {

	// Los strings no son buenos defaults aquí, es propenso a errores.
	var property derecho = "elementoDerecho"
	var property izquierdo = "elementoIzquierdo"

	var guardarValor = 0

	override method restaPorDesgaste(ninio) {
		return self.promedioDeDesgaste() - self.ninioMenorDe4(ninio) // Esto no debería estar acá, no tiene que ver con el desgaste.
	}

	method promedioDeDesgaste() {
		return (self.derecho().desgaste() + self.izquierdo().desgaste()) / 2
	}

	method ninioMenorDe4(ninio) {
		return if (ninio.esMenorDe4()) {
			1
		} else {
			0
		}
	}

	method intercambiar(otraPrenda) {
		self.validarIntercambio(otraPrenda)
		self.realizarIntercambio(otraPrenda)
	}

	method validarIntercambio(otraPrenda) {
		if (self.talle() != otraPrenda.talle()) {
			self.error("las prendas son de distinto talle no se pueden intercambiar")
		}
	}

	method realizarIntercambio(otraPrenda) {
		// Debería ser una variable local
		guardarValor = otraPrenda.derecho()
		otraPrenda.derecho(self.derecho())
		self.derecho(guardarValor)
		guardarValor = 0 
	}

	override method nivelDeAbrigo() {
		return self.izquierdo().abrigo() + self.derecho().abrigo()
	}

	override method usar() {
		self.derecho().usar()
		self.izquierdo().usar()
	}

}

class ElementoIzq inherits PrendasPares {

	var property desgaste = 0
	var property abrigo = 1

	override method usar() {
		desgaste += 0.80
	}

}

class ElementoDer inherits PrendasPares {

	var property desgaste = 0
	var property abrigo = 1

	override method usar() {
		desgaste += 1.20
	}

}

class RopaLiviana inherits Prenda {

	var puntosPorSerRopaLiviana = 2 // ¿Por qué variable?

	override method nivelDeComodidad(ninio) {
		return super(ninio) + puntosPorSerRopaLiviana
	}

	override method nivelDeAbrigo() = abrigoRopaLiviana.valor()

}

class RopaPesada inherits Prenda {

	var abrigo = 3 // Debería poder modificarse

	override method nivelDeAbrigo() = abrigo

}

object abrigoRopaLiviana {

	var valor = 1

	method valor(unValor) {
		valor = unValor
	}

	method valor() = valor

}

//Objetos usados para los talles
object xs {

	method coincide(ninio) {
		return ninio.talle() == self
	}

}

object s {

	method coincide(ninio) {
		return ninio.talle() == self
	}

}

object m {

	method coincide(ninio) {
		return ninio.talle() == self
	}

}

object l {

	method coincide(ninio) {
		return ninio.talle() == self
	}

}

object xl {

	method coincide(ninio) {
		return ninio.talle() == self
	}

}




//Esta clase no debe existir, 
//está para que el test compile al inicio del examen
//al finalizar el examen hay que borrar esta clase
//class XXX {
//	var talle= null
//	var desgaste= null
//	var min= null
//	var max= null
//	var prendas= null
//	var ninios= null
//	var edad= null
//	var juguete = null
//	var abrigo = null
//}

class Familia{
	var property hijos = #{}
	
	method puedeSalirDePaseo(){
		return hijos.all({hijo => hijo.puedeSalirDePaseo()})
	}
	
	method prendasInfaltables(){
		return hijos.sum({hijo=> hijo.prendaDeMaximaCalidad()})
	}
	
	method niniosMenores(){
		hijos.filter({hijo => hijo.esMenorDe4()})
	}
	
	method pasear(){
		self.validarPaseo()
		hijos.forEach({hijo => hijo.usarPrendas()})
	}
	
	method validarPaseo(){
		if (!self.puedeSalirDePaseo()){
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
		prendas.add{unaPrenda}
	}
	
	method puedeSalirDePaseo(){
	return 	self.tieneLasPrendasNecesarias() and self.tieneAbrigoNecesario() and self.prendasDeCalidad()
	}
	
	method tieneLasPrendasNecesarias() {
		return prendas.size() >= 5
	}
	
	method tieneAbrigoNecesario() {
		return prendas.any({prenda => prenda.nivelDeAbrigo() >= 3})
	}
	
	method prendasDeCalidad() {
		return self.promedioCalidadDeSusPrendas() > 8
	}
	
	method promedioCalidadDeSusPrendas(){
		return (prendas.sum({prenda => prenda.calidad(self)}))/(prendas.size())
	}
	
	method prendaDeMaximaCalidad(){
		prendas.max({prenda => prenda.calidad(self)}).map(prenda)
	}
	
	method esMenorDe4() = edad < 4
	
	method usarPrendas(){
		prendas.forEach({prenda => prenda.usar()})
	}
}

class NinioProblematico inherits Ninio {
	
	
	override method tieneLasPrendasNecesarias() {
		return prendas.size() >= 4
	}
	
	override method puedeSalirDePaseo(){
		return super() and self.tieneElJugueteApropiado()
	}
	
	method tieneElJugueteApropiado(){
		return self.edad().between(self.juguete().min()..self.juguete().max())
	}
}

class Juguete {
	var property min = 0
	var property max = 0
}

class Prenda {
	var property nivelDeDesgaste = 0
	var property talle = "talle"
	
	method nivelDeComodidad(ninio){
		return if (talle.coincide(ninio))
				{8 - self.restaPorDesgaste(ninio)}
				else 
				{0 - self.restaPorDesgaste(ninio)}
	}
	
	method restaPorDesgaste(ninio) {
		return if (nivelDeDesgaste < 4) {
			nivelDeDesgaste
		} else {3}
	}
	
	method nivelDeAbrigo()
	
	method calidad(ninio){
		return self.nivelDeAbrigo() + self.nivelDeComodidad(ninio)
	}
	
	
	 method usar(){
		nivelDeDesgaste += 1
	}
}

class PrendasPares inherits Prenda {
	
	var property derecho = "elementoDerecho"
	var property izquierdo = "elementoIzquierdo"

	var guardarValor = 0
	
	override method restaPorDesgaste(ninio){
		return self.promedioDeDesgaste() - self.ninioMenorDe4(ninio)
	}
	
	method promedioDeDesgaste() {
		return (self.derecho().desgaste() + self.izquierdo().desgaste())/2
	}
	
	method ninioMenorDe4(ninio) {
		return if (ninio.esMenorDe4())	
			   {1} 
			   else	{0}
	}
	
	method intercambiar(otraPrenda){
		self.validarIntercambio(otraPrenda)
		self.realizarIntercambio(otraPrenda)
	}
	
	method validarIntercambio(otraPrenda){
		if (self.talle() != otraPrenda.talle()){
			self.error("las prendas son de distinto talle no se pueden intercambiar")
		}
	}
	
	method realizarIntercambio(otraPrenda){
		guardarValor = otraPrenda.derecho()
		otraPrenda.derecho(self.derecho())
		self.derecho(guardarValor)
		guardarValor = 0
	}
	
	override method nivelDeAbrigo() {
		return self.izquierdo().abrigo() 
		       + 
		       self.derecho().abrigo() 
	}
	
	override method usar(){
		self.derecho().usar()
		self.izquierdo().usar()
	}
}

class ElementoIzq inherits PrendasPares {
	var property desgaste = 0
	var property abrigo = 1
	
	
	override method usar(){
		desgaste += 0.80
	}
	
}

class ElementoDer inherits PrendasPares {
	var property desgaste = 0
	var property abrigo = 1
	
	override method usar(){
		desgaste += 1.20
	}
}

class RopaLiviana inherits Prenda {
	
	var puntosPorSerRopaLiviana = 2
	
	override method nivelDeComodidad(ninio){
		return super(ninio) + puntosPorSerRopaLiviana
	}
	
	override method nivelDeAbrigo() = abrigoRopaLiviana.valor()
	
}

class RopaPesada inherits Prenda {
	var abrigo = 3
	

override method nivelDeAbrigo() = abrigo
}

object abrigoRopaLiviana{
	var valor = 1
	
	method valor(unValor){
		valor = unValor
		}
		
	method valor() = valor
	
}

//Objetos usados para los talles

object xs {
	method coincide(ninio){
		return ninio.talle() == self
	}
}

object s {
	method coincide(ninio){
		return ninio.talle() == self
	}
}

object m {
	method coincide(ninio){
		return ninio.talle() == self
	}
	
}

object l{
	method coincide(ninio){
		return ninio.talle() == self
	}
	
}
object xl{
	method coincide(ninio){
		return ninio.talle() == self
	}
	
}
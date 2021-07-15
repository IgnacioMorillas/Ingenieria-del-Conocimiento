;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;Datos de habitaciones;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts Habitaciones
    (Habitacion Entrada)
    (Habitacion Salon)
    (Habitacion Comedor)
    (Habitacion Pasillo1)
    (Habitacion Cocina)
    (Habitacion Pasillo2)
    (Habitacion Dormitorio1)
    (Habitacion Dormitorio2)
    (Habitacion Banio)
    (Habitacion Lavadero)       
)

(deffacts Puertas
    (Puerta Entrada Salon)
    (Puerta Entrada Comedor)
    (Puerta Entrada Pasillo2)
    (Puerta Comedor Pasillo1)
    (Puerta Pasillo1 Cocina)
    (Puerta Pasillo2 Dormitorio1)
    (Puerta Pasillo2 Dormitorio2)
    (Puerta Pasillo2 Banio)
    (Puerta Pasillo2 Lavadero)
)

(deffacts Ventanas
    (Ventana Salon)
    (Ventana Comedor)
    (Ventana Pasillo1)
    (Ventana Cocina)
    (Ventana Dormitorio1)
    (Ventana Dormitorio2)
    (Ventana Banio)
    (Ventana Lavadero)
)

(deffacts PuertasExterior
    (PuertaExterior Entrada)
    (PuertaExterior Comedor)
    (PuertaExterior Cocina)
)
(deffacts tipo_luminosidad
    (tipo Entrada 200 400)
    (tipo Salon 300 600)
    (tipo Dormitorio1 150 300)
    (tipo Dormitorio2 150 300)
    (tipo Comedor 300 600)
    (tipo Pasillo1 200 400)
    (tipo Pasillo2 200 400)
    (tipo Cocina 200 400)
    (tipo Banio 200 400)
    (tipo Lavadero 200 400)
)

(deffacts luminosidad_bombillas
    (bombilla Entrada 220)
    (bombilla Salon 320)
    (bombilla Comedor 200)
    (bombilla Pasillo1 220)
    (bombilla Cocina 220)
    (bombilla Pasillo2 220)
    (bombilla Dormitorio1 200)
    (bombilla  Dormitorio2 200)
    (bombilla Banio 220)
    (bombilla Lavadero 220)
)

(deffacts Luminosidad_de_habitacion
    (luminosidad Entrada 100)
    (luminosidad Salon 100)
    (luminosidad Comedor 100)
    (luminosidad Pasillo1 201)
    (luminosidad Cocina 100)
    (luminosidad Pasillo2 100)
    (luminosidad Dormitorio1 100)
    (luminosidad Dormitorio2 100)
    (luminosidad Banio 100)
    (luminosidad Lavadero 100)
)

(deffacts Manejo_automatico_de_luces
    (manejoluces Entrada)
    (manejoluces Salon)
    (manejoluces Comedor)
    (manejoluces Pasillo1)
    (manejoluces Cocina)
    (manejoluces Pasillo2)
    (manejoluces Dormitorio2)
    (manejoluces Lavadero) 
)

(deffacts Estado_inicial_habitaciones
    (ultima_desactivacion movimiento Entrada 0)
    (ultima_desactivacion movimiento Salon 0)
    (ultima_desactivacion movimiento Comedor 0)
    (ultima_desactivacion movimiento Pasillo1 0)
    (ultima_desactivacion movimiento Cocina 0)
    (ultima_desactivacion movimiento Pasillo2 0)
    (ultima_desactivacion movimiento Dormitorio1 0)
    (ultima_desactivacion movimiento Dormitorio2 0)
    (ultima_desactivacion movimiento Banio 0)
    (ultima_desactivacion movimiento Lavadero 0)
)

(deffacts Habitaciones_inicialmente_Inactivas
    (inactiva Entrada)
    (inactiva Salon)
    (inactiva Comedor)
    (inactiva Pasillo1)
    (inactiva Cocina)
    (inactiva Pasillo2)
    (inactiva Dormitorio1)
    (inactiva Dormitorio2)
    (inactiva Banio)
    (inactiva Lavadero)
)

;Si se puede pasar directamente (por una puerta o por un paso) de una habitación a otra, 
;añadiendo a la base de hechos  (posible_pasar habitacion1 habitacion2) 
(defrule posible_pasar 
    (Puerta ?h1 ?h2)
    =>
    (assert(posible_pasar ?h1 ?h2))
    (assert(posible_pasar ?h2 ?h1))
)

;Si para acceder a una habitación solo se puede pasar desde otra, añadiendo en su caso el hecho (necesario_pasar  habitacion1 habitacion2). 
(defrule varias_entradas
    (posible_pasar ?h1 ?h2)
    (posible_pasar ?h1 ?h3)
    (test(neq ?h2 ?h3 ))
    =>
    (assert(varias_entradas ?h1))
)

(defrule necesario_pasar
    (declare (salience -1))
    (posible_pasar ?h1 ?h2)
    (test(neq ?h1 ?h2 ))
    (not( varias_entradas ?h1))
    =>
    (assert(necesario_pasar ?h1 ?h2 ))
)

;Si una habitación es interior, añadiendo el hecho (habitacion_interior  habitacion) 

(defrule habitacion_interior
    (Habitacion ?h1)
    (not (Ventana ?h1))
    =>
    (assert(habitacion_interior  ?h1))
)


;;;SEGUNDA PARTE

;a1)  llevar un registro de  las señales recibidas de estos sensores con una marca de tiempo, 
;haciendo que el sistema añada los hechos (valor_registrado ?t ?tipo ?habitacion ?v)  → en el instante t el sensor  
;de tipo ?tipo situado en ?habitacion envió que  el resultado detectado era ?v. 
(defrule nuevo_registros
    (declare (salience 1))
    (hora_actual ?h)
    (minutos_actual ?m)
    (segundos_actual ?s)
    ?f<-(valor ?tipo ?ha ?v)
    =>
    (bind ?now (totalsegundos ?h ?m ?s))
    (assert (valor_registrado ?now ?tipo ?ha ?v))
    (assert(ultimo_registro ?tipo ?ha ?now))
    (retract ?f)
)

;a2) También cuando se produjo el último registro del sensor, mediante el hecho  
;(ultimo_registro ?tipo ?habitacion ?t) → el último registro del sensor  de tipo ?tipo 
;situado en ?habitacion tuvo lugar en el instante t , 

(defrule ultimo_registro
    (declare (salience 1000))
    ?f<-(ultimo_registro ?tipo ?h ?t)
    (ultimo_registro ?tipo ?h ?t1)
    (test (< ?t ?t1))
    =>
    (retract ?f)
)

;a3) y cuando fue la última vez que el sensor de movimiento de una  habitación pasó OFF a ON,
;y la última vez que paso de ON a OFF, mediante los hechos (ultima_activacion  movimiento ?habitacion ?t) 
;y (ultima_desactivacion  movimiento ?habitacion ?t) respectivamente.

(defrule ultima_activacion
    (ultimo_registro movimiento ?h ?t)
    (valor_registrado ?t movimiento ?h on)
    (inactiva ?h)
    =>
    (assert(ultima_activacion movimiento ?h ?t))
)

(defrule ultimo_desactivacion2
    (declare (salience 1000))
    ?f<-(ultima_desactivacion movimiento ?h ?t)
    (ultima_desactivacion movimiento ?h ?t1)
    (test (< ?t ?t1))
    =>
    (retract ?f)
)

(defrule ultima_desactivacion
    ?f<-(ultimo_registro movimiento ?h ?t)
    (not (ultima_desactivacion movimiento ?h ?t))
    (valor_registrado ?t movimiento ?h off)
    (activa ?h)
    =>
    (assert(ultima_desactivacion movimiento ?h ?t))
)
(defrule ultimo_activacion2
    (declare (salience 1000))
    ?f<-(ultima_activacion movimiento ?h ?t)
    (ultima_activacion movimiento ?h ?t1)
    (test (< ?t ?t1))
    =>
    (retract ?f)
)

;/////////////////////////////////////////////////////////////////
;///////     CREACION DE INFORME      //////////////////////////////////
;/////////////////////////////////////////////////////////////////
(defrule informe
    ?f<-(informe ?h)
    (valor_registrado ?t ?tipo ?h ?v)
    =>
    (printout t "informe -> valor_registrado " ?t " " ?h " " ?tipo " " ?v crlf)
    ;(retract ?f)

)

;/////////////////////////////////////////////////////////////////
;///////REGLAS PARA ACTIVACION INACTIVACION DE HABITACIONES///////
;/////////////////////////////////////////////////////////////////

;Pasa a activa despues de estar 3s como recientemente_activa
(defrule activa
    (hora_actual ?h)
    (minutos_actual ?m)
    (segundos_actual ?s)
    ?f<-(recientemente_activa ?ha)
    (ultima_activacion movimiento ?ha ?t )
    (test (<= 3 (- (totalsegundos ?h ?m ?s ) ?t ) ) )
    =>
    (retract ?f)
    (assert (activa ?ha))
)

;finaliza el recientemente_activa de lahabitacion(3s)
(defrule recientemente_activa
    ?f<-(inactiva ?h)
    ;?g<-(parece_inactivo ?h2) 
    (ultima_desactivacion movimiento ?h ?t)
    (ultima_activacion movimiento ?h ?t2)
    ;(ultima_desactivacion movimiento ?h2 ?t3)
    ;(ultima_activacion movimiento ?h2 ?t4)
    ;(test (or (> ?t2 ?t) (> ?t4 ?t3)))
    (test (> ?t2 ?t))
    =>
    ;(assert(activa ?h))
    (assert(recientemente_activa ?h))
    (retract ?f)
    ;(retract ?g)
)

;Parece inactivo pero pasa a activo por que llega de 
;nuevo una señal de activacion de la habitacion
(defrule no_inactivo
    ?f<-(parece_inactivo ?h)
    (ultima_desactivacion movimiento ?h ?t)
    (ultima_activacion movimiento ?h ?t2)
    (test (> ?t2 ?t))
    =>
    (assert(activa ?h))
    (retract ?f)

)
;El sensor de lahabitacion devuelve un Off en movimiento, por lo que
;pasa a parece inactivo durante 10s
(defrule parece_inactivo
    ?f<-(activa ?h)
    (ultima_desactivacion movimiento ?h ?t)
    (ultima_activacion movimiento ?h ?t2)
    (test (< ?t2 ?t))
    =>
    (assert(parece_inactivo ?h))
    (retract ?f)
)

;Si se tira 10s como parece inactivo, pasara a inactiva la habitacion
(defrule Comprobacion_inactividad
    (hora_actual ?h)
    (minutos_actual ?m)
    (segundos_actual ?s)
    ?f<-(parece_inactivo ?ha)
    (ultima_desactivacion movimiento ?ha ?t)
    (ultima_activacion movimiento ?ha ?t2)
    ;(bind ?comprobacion =(+ ?t 10))
    ;(test (and (= ?comprobacion (totalsegundos ?h ?m ?s)) (< ?t2 ?t)))
    (test (and (= 10 (- (totalsegundos ?h ?m ?s ) ?t ) ) (< ?t2 ?t) ))
    =>
    (assert(inactiva ?ha))
    (retract ?f)
)
;/////////////////////////////////////////////////////////////////
;///////REGLAS PARA EL PASO DE UNA HABITTACION A OTRA ////////////
;/////////////////////////////////////////////////////////////////

;Sensor On en A y puede pasar B->A y B esta recientemente activa->(Posible_PASO B A)
;Si se dispara el sensor de una habitaci´on y hay varias habitaciones posibles, se ha podido producir
desde todas las recientemente activas (define ’reciente’ como un plazo de 3 segundos).
(defrule Posible_Paso
    (activa ?h1)
    (recientemente_activa ?h2)
    (posible_pasar ?h1 ?h2)
    (not (necesario_pasar ?h2 ?h1))
    =>
    (assert(Posible_PASO ?h1 ?h2))
)


;Sensor ON en A y solo 1 Posible_paso a A: Paso a A
;Cuando se dispara el sensor de una habitaci´on y solo hay una desde la que se puede pasar a ella,
;y est´a activa, deduce que se ha pasado de una a otra.
(defrule Producido_Paso
    (activa ?h1)
    (recientemente_activa ?h2)
    (necesario_pasar ?h2 ?h1)
    =>
    (assert (Producido_Paso ?h1 ?h2))
)



;Si en vez de haber 2 hay solo una, en vez considerar se ha podido producir el caso, diremos que se ha porucido el paso
;Si hay solo una posible explicaci´on donde se podr´ıa haber hecho el paso, entonces se afirma que se
;dio ese paso.
(defrule un_posible_paso
    ?f<-(Posible_PASO ?h1 ?h3)
    (not(Posible_PASO ?h2&~?h1 ?h3))
    =>
    (assert (Producido_Paso ?h1 ?h3))
    (retract ?f)
)

;parece_inactiva y pasodesdeA-> inactiva A
;AQUI PODEMOS METER UN ASSERT PARA LLEVAR UN REGISTRO DE MOVIMIENTO
;Si ha habido un paso reciente desde una habitaci´on que parec´ıa activa, deduce que esa habitaci´on
;ahora pasa a inactiva.
(defrule inactiva_habitacion_paso
    ?f<-(parece_inactivo ?h)
    ?g<-(Producido_Paso ?h ?h1)
    =>
    (assert(inactiva ?h))
    (retract ?f)
    (retract ?g)
)

;parece_inactiva A y ningun posible_paso desde A-> activa A

(defrule ningun_posible_paso
    (hora_actual ?h)
    (minutos_actual ?m)
    (segundos_actual ?s)
    ?f<-(parece_inactivo ?h1)
    (not (Posible_PASO ?h1 ?h2))
    =>
    (assert(activa ?h1))
    (assert (ultima_activacion movimiento ?h1 (totalsegundos ?h ?m ?s)))
    (retract ?f)
)

;eliminar posible paso si la habitacion a la que podia moverse pasa a inactiva
(defrule elimenarPosiblePaso
    ?f<-(Posible_PASO ?h1 ?h2)
    (inactiva ?h2)
    =>
    (retract ?f)

)


;/////////////////////////////////////////////////////////////////
;///////REGLAS PARA LAS LUCES /////////////////////// ////////////
;/////////////////////////////////////////////////////////////////

;Si una habitacion está no vacia y hay poca luz, enciendo la luz

(defrule encender_LUZ
    (Manejo_inteligente_luces ?h)
    (activa ?h)
    (luminosidad ?h ?l)
    (tipo ?h ?estandar ?maximo)
    (valor_registrado ?t luminosidad ?h ?v)
    (ultimo_registro luminosidad ?h ?t)
    (test (and (< ?v ?estandar) (= ?v ?l)))
    =>
    (assert (accion pulsador_luz ?h encender))
)

;Siuna habitacion está vacia y la luz esta encendida, se apaga
(defrule apagar_LUZ
    (Manejo_inteligente_luces ?h)
    (inactiva ?h)
    (tipo ?h ?estandar ?maximo)
    (luminosidad ?h ?l)
    (valor_registrado ?t luminosidad ?h ?v)
    (ultimo_registro luminosidad ?h ?t)
    (test (neq ?v ?l))
    =>
    (assert (accion pulsador_luz ?h apagar))
)

;Si la luz está encendida y hay mucha luminosidad, la apagamos
(defrule demasiada_luz
    (Manejo_inteligente_luces ?h)
    (activa ?h)
    (luminosidad ?h ?l)
    (tipo ?h ?estandar ?maximo)
    (valor_registrado ?t luminosidad ?h ?v)
    (ultimo_registro luminosidad ?h ?t)
    (test (and (< ?maximo ?v) (neq ?v ?l)))
    =>
    (assert (accion pulsador_luz ?h apagar))
)

;///////////////////////////////////////
;/////// REGLAS PROPIAS /////////////////
;//////////////////////////////////////////

;Si una habitación no tiene ventanas y está no vacia, se enciende la luz siempre
(defrule Habitacion_sin_ventanas
    (Manejo_inteligente_luces ?h)
    (activa ?h)
    (tipo ?h ?estandar ?maximo)
    (luminosidad ?h ?l)
    (valor_registrado ?t luminosidad ?h ?v)
    (ultimo_registro luminosidad ?h ?t)
    (habitacion_interior ?h)
    (test (= ?v ?l))
    =>
    (assert(assert (accion pulsador_luz ?h encender)))
)

; SI ESTAMOS ENTRE LAS 12 y las 14h, todas las luces estarán apagadas durene ese periodo
;(defrule 2h_sin_luces
;    (tipo ?ha ?estandar ?maximo)
;    (luminosidad ?ha ?l)
;    (valor_registrado ?t luminosidad ?ha ?v)
;    (ultimo_registro luminosidad ?ha ?t)
;    (hora_actual ?h)
;    (minutos_actual ?m)
;    (segundos_actual ?s)
;    (activa ?ha)
;    (test (and (> (totalsegundos ?h ?m ?s ) 36000 ) (< (totalsegundos ?h ?m ?s ) 39600 ) (neq ?v ?l))
;    =>
;    (assert (accion pulsador_luz ?h apagar))
;)
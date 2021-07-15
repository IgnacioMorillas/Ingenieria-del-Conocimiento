;Vamos a comenzar por declarar los tiestos y los distintos grados de humedad de cada uno

(deffacts Tiesto
    (Tiesto Tomate)
    (Tiesto Pimiento)
    (Tiesto Berenjena)
)

;*********************************************************
;=============================================
;APARTADO SOBRE LAS HUMEDAD
;=============================================
(deffacts Humedad_Optima
    (Humedad_Optima Tomate 60 80) ;Medida en %
    (Humedad_Optima Pimienti 50 70)
    (Humedad_Optima Berenjena 50 65)
)

(deffacts Humedad_Alta_Critica
    (Humedad_Alta_Critica Tomate 85) ;Medida en %
    (Humedad_Alta_Critica Pimienti 75)
    (Humedad_Alta_Critica Berenjena 70)
)

(deffacts Humedad_Baja_Critica
    (Humedad_Baja_Critica Tomate 55) ;Medida en %
    (Humedad_Baja_Critica Pimienti 45)
    (Humedad_Baja_Critica Berenjena 45)
)

;*********************************************************

;Los distintos grados de humedad actuales serán incluidos mediante el simulador
;Los distintos tipos de temperatura actuales, tambien serán incluidos por el simulador
;*********************************************************
;=============================================
;APARTADO SOBRE LAS TEMPERATURAS
;Tengo encuenta las temperaturas en periodo de Crecimiento vegetativo
;=============================================
(deffacts Temperatura_Optima
    (Temperatura_Optima_dia Tomate 20 30)
    (Temperatura_Optima_dia Pimiento 20 25)
    (Temperatura_Optima_dia Berenjena 20 27)
)

;Podemos considerar que cuando alcanza la temperatura maxima, de un periodo de actuacion sumandole 5 grados al limite real
;o dejarlo así y que jugar con las temperaturas fueras de las optimas.
(deffacts Altas_Temperaturas_Critica
    (Altas_Temperaturas_Critica Tomate 33)
    (Altas_Temperaturas_Critica Pimiento 32)
    (Altas_Temperaturas_Critica Berenjena 42)
)

;Esto en verdad nos da igual, ya que el sistema de regadio no puede hacer nada
;a no ser que le pongamos un sistema que lo tape pero que deje entrar la luz solar
(deffacts Baja_Temperaturas_Critica
    (Baja_Temperaturas_Critica Tomate 12)
    (Baja_Temperaturas_Critica Pimiento 15)
    (Baja_Temperaturas_Critica Berenjena 13)
)

;*********************************************************

;*********************************************************
;=============================================
;APARTADO SOBRE LA Intensidad de la lluvia
;Se encargará de decirnos en que grado cuanta cantidad de agua 
;=============================================
(deffacts Intensidad_lluvia     ;(mm/h)
    (Intensidad_lluvia 1 Muy_debil 0.2 1.0)
    (Intensidad_lluvia 2 Debil 1.1 2.5)
    (Intensidad_lluvia 3 Ligera 2.6 6.5)
    (Intensidad_lluvia 4 Moderada 6.6 15.0)
    (Intensidad_lluvia 5 Fuerte 16.0 40.0)
    (Intensidad_lluvia 6 Muy_Fuerte 41.0 100.0)
    (Intensidad_lluvia 7 Torrencial 101.0 10000.0)
)
;*********************************************************


;EXTRAS!!!!!
;Radiacion directa o externa
;estado de la planta(germinacion, crecimiento vegetativo, floracion y fructacion)


;////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////
;REGLAS
;////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////
(defrule Horas
    (declare (salience 7))
    ?f<-(hora ?t)
    (not(hora_actual ?t2))
    =>
    (assert (hora_actual ?t))
    (retract ?f)
)

(defrule Horas_actualizar
    (declare (salience 7))
    ?f<-(hora ?t)
    ?g<-(hora_actual ?t2)
    =>
    (assert (hora_actual ?t))
    (retract ?f ?g)
)

(defrule minutos
    (declare (salience 7))
    ?f<-(minutos ?t)
    (not(minutos_actual ?t2))
    =>
    (assert (minutos_actual ?t))
    (retract ?f)
)

(defrule minutos_actualizar
    (declare (salience 7))
    ?f<-(minutos ?t ?v)
    ?g<-(minutos_actual ?t2)
    =>
    (assert (minutos_actual ?t))
    (retract ?f ?g)
)

(defrule segundos
    (declare (salience 7))
    ?f<-(segundos ?t)
    (not(segundos_actual ?t2))
    =>
    (assert (segundos_actual ?t))
    (retract ?f)
)

(defrule segundos_actualizar
    (declare (salience 7))
    ?f<-(segundos ?t)
    ?g<-(segundos_actual ?t2)
    =>
    (assert (segundos_actual ?t))
    (retract ?f ?g)
)


;=============================================
;=============  SENSORES   ===================
;=============================================

;SENSORES HUMEDAD
(defrule Inicializar_Humedad
    (declare (salience 7))
    ?f<-(Sensor_Humedad ?t ?v)
    (not(Humedad_actual ?t ?v2))
    =>
    (assert (Humedad_actual ?t ?v))
    (retract ?f)
)

(defrule Actualizar_Humedad
    (declare (salience 7))
    ?f<-(Sensor_Humedad ?t ?v)
    ?g<-(Humedad_actual ?t ?v2)
    =>
    (assert (Humedad_actual ?t ?v))
    (retract ?f ?g)
)

;SENTSORES TEMPERATURA
(defrule Inicializar_Temperatura
    (declare (salience 7))
    ?f<-(Sensor_Temperatura ?t ?v)
    (not(Temperatura_actual ?t ?v2))
    =>
    (assert (Temperatura_actual ?t ?v))
    (retract ?f)
)

(defrule Actualizar_Temperatura
    (declare (salience 7))
    ?f<-(Sensor_Temperatura ?t ?v)
    ?g<-(Temperatura_actual ?t ?v2)
    =>
    (assert (Temperatura_actual ?t ?v))
    (retract ?f ?g)
)
;PRECIPITACIONES
(defrule Inicializar_Precipitaciones
    (declare (salience 7))
    ?f<-(Senial_Precipitaciones ?t)
    (not(Precipitacion_actual ?t2))
    =>
    (assert (Precipitacion_actual ?t))
    (retract ?f)
)

(defrule Actualizar_Precipitacones
    (declare (salience 7))
    ?f<-(Senial_Precipitaciones ?t)
    ?g<-(Precipitacion_actual ?t2)
    =>
    (assert (Precipitacion_actual ?t))
    (retract ?f ?g)
)
;============================================================================================================

;=============================================
;=============  REGLAS   =====================
;=============================================

;============================================================================================================
;1.Activar riego siempre que la humedad esté por debajo del optimo

;si el 
(defrule posible_activacion_riego
    (declare (salience 6))
    (Humedad_actual ?t ?v)
    (not(riego_activo ?t))
    (not(Activar_riego ?t))
    (not(Precipitacion_actual 6))
    (not(Precipitacion_actual 7))
    (Temperatura_actual ?t ?temp)
    (Humedad_Optima ?t ?hmin ?hmax)
    (test(< ?v ?hmin))
    =>
    (assert(Posible_Activar_riego ?t))
)

;============================================================================================================
;============================================================================================================
;2.Activar el riego automático de cada tiesto independientemente cuando dicho cultivo lo necesite.

;Funcionamiento:
;Si se le ordena activar el riego y no esta activo se activa
(defrule Activar_riego
    ?f<-(Posible_Activar_riego ?t)
    (not(caudal_actual ?t ?h))
    (not(riego_activo ?t))
    =>
    (assert (riego_activo ?t))
    ;(assert (cambiar_caudal ?t alto))
    (retract ?f)
)

;Por si ya se está regando y le llega la orden de que se active eliminarlo del facts
;(defrule Ya_regando
;    (Posible_Activar_riego ?t)
;    ?f<-(Posible_Activar_riego ?t)
;    =>
;    (retract ?f)
;)
;============================================================================================================

;============================================================================================================
;3.Desactivar el riego de cada tiesto cuando se llegue a la humedad deseada.
;Funcionamiento:
;Si el riego esta activo y el sensor dice que está ya en el optimo, borraremos 
;riego activo que es lo que hace que esté regando

(defrule Apagar_riego
    ?r<-(riego_activo ?t)
    ?h<-(caudal_actual ?t ?j)
    ?s<-(Humedad_actual ?t ?v)
    (Humedad_Optima ?t ?hmin ?hmax)
    (test(< ?hmin ?v))
    =>
    ;(retract ?r ?s ?h)
    (retract ?r ?h)
)
;============================================================================================================

;============================================================================================================
;4.Realizar un riego más inteligente en función del momento del día, considerando la posible evaporación.

;medio dia(12-4) evitaremos los riegos, aunque esté por debajo la humedad optima ya que se produce un desaprovechamiento del agua

;hay que darle prioridad a estos condicionantes de activacion
(defrule riego_inteligente
    (declare (salience 2))
    ?f<-(Posible_Activar_riego ?t)
    (hora_actual ?h)
    (minutos_actual ?m)
    (segundos_actual ?s)
    (test(and (< 43200 (totalsegundos ?h ?m ?s)) (< (totalsegundos ?h ?m ?s) 57600 )))
    =>
    (retract ?f)
)
(defrule riego2_inteligente
    (declare (salience 2))
    ?f<-(riego_activo ?t)
    ?a<-(caudal_actual ?t ?j)
    (hora_actual ?h)
    (minutos_actual ?m)
    (segundos_actual ?s)
    (test(and (< 43200 (totalsegundos ?h ?m ?s)) (< (totalsegundos ?h ?m ?s) 57600 )))
    =>
    (retract ?f ?a)
)
;============================================================================================================

;============================================================================================================
;5.Evitar, siempre que se pueda, el riego en situaciones de altas temperaturas y sol. No se podrá posponer en presencia de valores de humedad críticamente bajos.
;Basicamente es lo mismo que la anterior, pero solo que si la temperatura es alta y está en estado critico activemos si o si

;dar mas prioridad a esta orden que a la anterior
(defrule Riego_Inteligente_altas_Temperaturas
    (declare (salience 3))
    ?f<-(Posible_Activar_riego ?t)
    (Temperatura_actual ?t ?temp)
    (Altas_Temperaturas_Critica ?t ?alta)
    (test (< ?alta ?temp))
    =>
    (retract ?f)
)

(defrule Riego2_Inteligente_altas_Temperaturas
    (declare (salience 3))
    ?r<-(riego_activo ?t)
    ?h<-(caudal_actual ?t ?j)
    (not(humedad 2))
    (Temperatura_actual ?t ?temp)
    (Altas_Temperaturas_Critica ?t ?alta)
    (test (< ?alta ?temp))
    =>
    (retract ?r ?h)
)

;dar prioridad muy alta
(defrule Humedad_critica
    (declare (salience 5))
    ?f<-(Posible_Activar_riego ?t)
    (Humedad_actual ?t ?v)
    (Humedad_Baja_Critica ?t ?min)
    (test (< ?v ?min ))
    =>
    (retract ?f)
    (assert(riego_activo ?t))
    (assert (humedad 2))
    ;(assert (cambiar_caudal ?t alto))
)
(defrule Humedad_critica2
    (declare (salience 10))
    ?r<-(humedad 2)
    (Humedad_actual ?t ?v)
    (Humedad_Baja_Critica ?t ?min)
    (test (> ?v ?min ))
    =>
    (retract ?r)
    ;(assert (cambiar_caudal ?t alto))
)
;============================================================================================================

;============================================================================================================
;6.Activar vaporizadores para refrescar el ambiente de cada tiesto y reducir altas temperaturas.
(defrule Activar_vaporizadores
    (Temperatura_actual ?t ?temp)
    (Altas_Temperaturas_Critica ?t ?alta)
    (test (< ?alta ?temp))
    =>
    (assert (activar_vaporizadores ?t))
)

;Desactiva los vaporizadores si la temperatura ya está por debajo de la crítica
(defrule Desactivar_vaporizadores
    (Temperatura_actual ?t ?temp)
    (Altas_Temperaturas_Critica ?t ?alta)
    ?h<-(activar_vaporizadores ?t)
    (test (> ?alta ?temp))
    =>
    (retract ?h)
)
;IDEAD PARA HACER LAS MISMAS COSAS EN CASO DE HELADAS

;============================================================================================================

;============================================================================================================
;7.Posibilitar la combinación  del uso de vaporizadores con el riego en momentos de altas temperaturas, cuando sea estrictamente necesario. 
;Siempre que haga alta temperatura se va a activar, asi que si se tiene que activar los riegos ya funcionan igualmente


;Ya lo cumple, en el caso en el que la temperatura sea criticamente alta siempre va estar activo
;Ya que ambas decisiones se toman por separado, por lo que se puede dar el caso en que ambas se esten ejecutando.



;============================================================================================================
;============================================================================================================

;8.Utilizar la información meteorológica de la zona local para gestionar el riego de manera más eficiente, como posponer o regar con menor intensidad 
;en caso de lluvia, según su intensidad y la certeza de la predicción.

;Voy a considerar 3 tipos de caudales, ligermo, medio, alto
;Un riego alto sería el normal usado
;Si la lluvia va a ser ligera, debil, muy debil, no se tendrá en cuenta ya que no será suficiente cantidad de agua.

;Si es moderada, el caudal de riego(si se riega) será medio
;si es fuere sera un riego ligero
;Para los demas casos no se regaran ya que se dapor supuesto que hay agua de sobra y alta probabilidad de que ocurra
;Si la humedad es criticamente baja se regará igualmente(prioridades).

;//////////////////////////////
;caudal
;/////////////////////////////
(defrule Inicializar_Caudal
    (declare (salience 7))
    ?f<-(cambiar_caudal ?t ?tipo)
    (not(caudal_actual ?t2 ?tipo2))
    =>
    (assert (caudal_actual ?t ?tipo))
    (retract ?f)
)

(defrule Actualizar_Caudal
    (declare (salience 7))
    ?f<-(cambiar_caudal ?t ?tipo)
    ?g<-(caudal_actual ?t2 ?tipo2&~?tipo)
    =>
    (assert (caudal_actual ?t ?tipo))
    (retract ?f ?g)
)

(defrule Apagar_Caudal
    (declare (salience 8))
    ?f<-(cambiar_caudal ?t Nulo)
    ?g<-(caudal_actual ?t2 ?tipo2)
    =>
    (retract ?f ?g)
)

(defrule eliminar_cambiar_Caudal
    (declare (salience -10))
    ?f<-(cambiar_caudal ?t ?h)
    =>
    (retract ?f)
)
;/////////////////////////////////


(defrule Precipitaciones_Muydebil-Ligera
(declare (salience 6))
    (riego_activo ?t)
    (Precipitacion_actual ?tipo_numerico)
    (test (< ?tipo_numerico 4))
    =>
    (assert (cambiar_caudal ?t alto))
)

(defrule Precipitaciones_Moderada
(declare (salience 6))
    (riego_activo ?t)
    (Precipitacion_actual ?tipo_numerico)
    (test (= ?tipo_numerico 4))
    =>
    (assert (cambiar_caudal ?t medio))
)

(defrule Precipitaciones_Fuerte
(declare (salience 6))
    (riego_activo ?t)
    (Precipitacion_actual ?tipo_numerico)
    (test (= ?tipo_numerico 5))
    =>
    (assert (cambiar_caudal ?t ligero))
)

(defrule Precipitaciones_Muy_fuerte_torrencial
(declare (salience 6))
    ?f<-(riego_activo ?t)
    (Precipitacion_actual ?tipo_numerico)
    (test (> ?tipo_numerico 5))
    =>
    (retract ?f)
    (assert (cambiar_caudal ?t Nulo))
)
;Desde moderada para arriba los pulverizadores no se activaran

;Si la humedad es criticamente alta, no se activaran los pulverizadores de agua, ya que probocarian que la humedad subiese mas 


;============================================================================================================
;============================================================================================================

;tAMBIEN PODEMOS PONER SENSORES DE LUZ, Y SI ES BAJA Y DE DIA ABRIRLA, YA QUE PUEDE SIGNIDICAR QUE ESTÉ NUBLADO
;PERO ESTO  INTERFERIRA EN LA REGULACION DE TEMPERATURA POR TANTO HAY QUE PONER MAS REGLAS 
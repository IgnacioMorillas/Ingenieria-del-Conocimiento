;EJERCICIO 3
;APARTADO B

;(deffacts Empieza
;    (empieza 0)
;)

(defrule leer
    (declare (salience 10000))
    =>
    (load-facts DatosT.txt)    
    ;?f<-(empieza 0)
    ;=>
    ;(retract ?f)
    ;(open "DatosT.txt" temp "r")
    ;(bind ?rv (readline temp))
    ;(close temp)
    ;(assert (T ?rv))
    ;(assert (empieza 0))
)

;(defrule borrar
;    (declare (salience -1))
;    ?f<-(empieza 0)
;    =>
;    (close temp)
;    (retract ?f)
;)




;(defrule lectura
;    (open "DatosT.txt" datos "r") 
;    ?f<-(readline datos)
;    =>
;    (assert ?f)
;)
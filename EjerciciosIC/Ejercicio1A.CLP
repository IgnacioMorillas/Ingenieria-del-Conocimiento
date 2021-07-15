;EJERCICIO 1
;APARTADO A

;Declaración de echos
(deffacts XXX
    (XXX 1 2 3)
    (XXX 2 4 5)
    (XXX 3 6 7)
)

(defrule Contar_hechos
    ?f<-(Contar_hechos ?h)
    =>
    (assert ( numero_hechos 0 ))
    (assert ( FIN 0 ))
    (retract ?f)
)

(defrule incrementarhecho
    ?f<-(FIN ?h)
    (XXX $?)
    =>
    (assert (aniadirhecho contador))
    
)
;
(defrule borrar
    (declare (salience -1))
    ?f<-(FIN ?h)
    (numero_hechos ?n)
    (not (aniadirhecho contador))
    =>
    (retract ?f)
)


;
;Incrementa en uno
(defrule aniadirhecho
    (declare (salience 1))
    ?f<-(numero_hechos ?n)
    ?g<-(aniadirhecho contador)
    =>
    (retract ?f ?g)
    (assert (numero_hechos (+ ?n 1)))
)
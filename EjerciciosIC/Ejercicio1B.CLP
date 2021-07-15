;EJERCICIO 1
;APARTADO B

;Declaración de echos
(deffacts XXX
    (XXX 1)
    (XXX 2)
    (XXX 3)
)

;Inicialización de echos
(deffacts numero_hechos
    (numero_hechos 0)
)

;Regla que llama a inclementar el echo cuando introducimos un nuevo echo
(defrule incrementarhecho
(XXX $?)
=>
(assert (aniadirhecho contador))

)
;Incrementa en uno
(defrule aniadirhecho
    (declare (salience 1))
    ?f<-(numero_hechos ?n)
    ?g<-(aniadirhecho contador)
    =>
    (retract ?f ?g)
    (assert (numero_hechos (+ ?n 1)))
)


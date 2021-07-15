;EJERCICIO 2
;APARTADO B
;Vamos a coger el minimo de la columna 2
(deffacts T
    (T 1 3 2 4)
    (T 2 1 3 4)
    (T 1 2 3 4)
    (T 2 4 3 4)
)

(deffacts Inicio
    (inicio 0)
)

;Vamos a coger el minimo de la columna 2
(defrule Establecer_Minimo_actual
    ?f<-(inicio 0)
    (T ?h1 ?h2 ?h3 ?h4)
    =>
    (retract ?f)
    (assert( minimo_actual ?h1 ?h2 ?h3 ?h4))
)

(defrule Modificar_Minimo_actual
    ?g<-( minimo_actual ?c1 ?c2 ?c3 ?c4)
    (T ?h1 ?h2 ?h3 ?h4)
    (test (< ?h2 ?c2))
    =>
    (retract ?g)
    (assert( minimo_actual ?h1 ?h2 ?h3 ?h4))
    
)
    
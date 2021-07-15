;EJERCICIO 2
;APARTADO A
(deftemplate T
    (slot S)
)

(deftemplate inicializar
    (slot i)
)

(deffacts  otroHecho
    (inicializar (i -1000))
)


(deffacts  VariosHechos
    (T 
    (S 3)
    )

    (T 
        (S 1)
    )

    (T 
        (S 2)
    )

    (T 
        (S 2)
    )
)

(defrule establecer_minimo_actual
    ?f<-(inicializar (i ?i))
    (T (S ?s))
    =>
    (assert ( minimo_actual ?s ))
    (retract ?f)
)

(defrule minSdeT
    ?f<-(minimo_actual ?m)
    (T ( S ?x))
    (test ( < ?x ?m))
    =>
    (retract ?f)
    (assert ( minimo_actual ?x ))

)

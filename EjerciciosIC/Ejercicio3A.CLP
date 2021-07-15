;EJERCICIO 3
;APARTADO A

;Tomaremos como referencia la columna 2

(deffacts T
    
    (T 2 4 3 2)
    (T 3 5 6 7)
    (T 1 2 3 4)
    (T 4 7 2 3)
)

(deffacts Inicio
    (inicio 0)
)

(defrule Copiar 
   (declare (salience 1000))
   (T ?x1 ?x2 ?x3 ?x4)
   =>
   (assert (copia ?x1 ?x2 ?x3 ?x4))
)

(defrule Escribir
    (declare (salience 9))
    ?f<-(escribir ?x1 ?x2 ?x3 ?x4)
    =>
    (open "DatosT.txt" datos "a")
    ;(format datos " X" ?Xn)
    (printout datos "(T " ?x1 " " ?x2 " "?x3 " "?x4 ")" crlf) 
    (close datos) 
    (retract ?f)
)

;Vamos a coger el minimo de la columna 2
(defrule Establecer_Minimo_actual
    ?f<-(inicio 0)
    (copia ?x1 ?x2 ?x3 ?x4)
    =>
    (retract ?f)
    (assert( minimo_actual ?x1 ?x2 ?x3 ?x4))
)

(defrule Modificar_Minimo_actual
    (declare (salience 10))
    ?g<-( minimo_actual ?c1 ?c2 ?c3 ?c4)
    (copia ?x1 ?x2 ?x3 ?x4)
    (test (< ?x2 ?c2))
    =>
    (retract ?g)
    (assert( minimo_actual ?x1 ?x2 ?x3 ?x4))
)

(defrule Minimo_final
    ?f<-( minimo_actual ?c1 ?c2 ?c3 ?c4)
    ?g<-(copia ?c1 ?c2 ?c3 ?c4)
    =>
    (retract ?g)
    (assert( escribir ?c1 ?c2 ?c3 ?c4))
    (assert ( inicio 0))
    (retract ?f)
)

(defrule borrar_inicio
    (declare (salience -1))
    ?f<-( inicio 0)
    =>
    (retract ?f)
)
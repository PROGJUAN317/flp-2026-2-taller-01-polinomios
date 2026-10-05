#lang eopl
;Autores: Samuel Garcia Parra 2459476, Nombre2 Codigo2
 
;; Taller 1 — Polinomios dispersos.
;; Parte 4: la misma batería de pruebas sobre las tres representaciones.
 
(require rackunit)
(require (only-in racket/base exn:fail? exn?)) ;; 
(require (prefix-in listas: "polinomios-listas.rkt"))
(require (prefix-in procs:  "polinomios-procedimientos.rkt")) 
(require (prefix-in dt:     "polinomios-datatypes.rkt"))      
 
;; pruebas-interfaz : string x funciones -> void
;; Propósito: correr la misma batería de pruebas contra cualquier
;; representación que exponga las cuatro funciones de la interfaz,
;; evidenciando que el cliente (las pruebas) no distingue entre ellas.
(define (pruebas-interfaz nombre polinomio-cero insertar-termino coeficiente-de eliminar-termino)
  (test-case nombre
 
    ;; polinomio nulo como caso base
    (check-exn exn:fail? (lambda () (coeficiente-de (polinomio-cero 'x) 0)))
    (check-exn exn:fail? (lambda () (eliminar-termino (polinomio-cero 'x) 0)))
    (check-equal? (coeficiente-de (insertar-termino (polinomio-cero 'x) 5 3) 3) 5)
 
    ;; casos funcionales
    (let ((p (insertar-termino
              (insertar-termino
               (insertar-termino (polinomio-cero 'x) 7 0)
               -3/2 2)
              4 5)))
 
      (check-equal? (coeficiente-de p 5) 4)
      (check-equal? (coeficiente-de p 2) -3/2)
      (check-equal? (coeficiente-de p 0) 7)
 
      ;; eliminar-termino: el eliminado desaparece, los demás quedan
      (check-exn exn:fail? (lambda () (coeficiente-de (eliminar-termino p 2) 2)))
      (check-equal? (coeficiente-de (eliminar-termino p 2) 5) 4)
 
      ;; insertar-termino: suma que cancela el término (coeficiente -> 0)
      (check-exn exn:fail? (lambda () (coeficiente-de (insertar-termino p 3/2 2) 2)))
 
      ;; insertar-termino: coeficiente cero no altera el polinomio
      (check-equal? (coeficiente-de (insertar-termino p 0 10) 5) 4)
      (check-exn exn:fail? (lambda () (coeficiente-de (insertar-termino p 0 10) 10)))
 
      ;; errores
      (check-exn exn:fail? (lambda () (insertar-termino p 5 -1)))
      (check-exn exn:fail? (lambda () (insertar-termino p 1.5 2)))
      (check-exn exn:fail? (lambda () (coeficiente-de p 3)))
      (check-exn exn:fail? (lambda () (eliminar-termino p 3))))))

;;Pruebas datatypes

(define construir
  (lambda (cero ins var pares)
    (if (null? pares)
        (cero var)
        (ins (construir cero ins var (cdr pares))
             (car (car pares))
             (cadr (car pares))))))

;; pruebas-interfaz-extra : string x funciones -> void
;; Propósito: casos adicionales de la interfaz (orden de inserción, racionales,
;; persistencia, posiciones cabeza/medio/cola, nulo con coeficiente cero).
(define (pruebas-interfaz-extra nombre polinomio-cero insertar-termino coeficiente-de eliminar-termino)
  (test-case nombre

    ;;nulo: insertar coeficiente cero deja el polinomio nulo
    (let ((z (insertar-termino (polinomio-cero 'x) 0 3)))
      (check-exn exn:fail? (lambda () (coeficiente-de z 3)))
      (check-exn exn:fail? (lambda () (eliminar-termino z 3))))

    ;;el orden de inserción no importa
    (let ((p1 (construir polinomio-cero insertar-termino 'x '((4 5) (-3/2 2) (7 0))))
          (p2 (construir polinomio-cero insertar-termino 'x '((7 0) (-3/2 2) (4 5))))
          (p3 (construir polinomio-cero insertar-termino 'x '((-3/2 2) (4 5) (7 0)))))
      (for-each
       (lambda (p)
         (check-equal? (coeficiente-de p 5) 4)
         (check-equal? (coeficiente-de p 2) -3/2)
         (check-equal? (coeficiente-de p 0) 7)
         (check-exn exn:fail? (lambda () (coeficiente-de p 1)))
         (check-exn exn:fail? (lambda () (coeficiente-de p 3)))
         (check-exn exn:fail? (lambda () (coeficiente-de p 4))))
       (list p1 p2 p3)))

    ;;inserción en cabeza, medio y cola
    (let* ((p (construir polinomio-cero insertar-termino 'x '((4 5) (7 0))))
           (cabeza (insertar-termino p 2 7))
           (medio  (insertar-termino p 3 3))
           (cola   (insertar-termino p 9 0)))
      (check-equal? (coeficiente-de cabeza 7) 2)
      (check-equal? (coeficiente-de cabeza 5) 4)
      (check-equal? (coeficiente-de medio 3) 3)
      (check-equal? (coeficiente-de medio 5) 4)
      (check-equal? (coeficiente-de medio 0) 7)
      (check-equal? (coeficiente-de cola 0) 16)
      (check-equal? (coeficiente-de cola 5) 4))

    ;;racionales: se suman y se reducen
    (let ((p (insertar-termino (insertar-termino (polinomio-cero 'x) 1/3 4) 1/6 4)))
      (check-equal? (coeficiente-de p 4) 1/2))
    (let ((p (insertar-termino (insertar-termino (polinomio-cero 'x) 1/2 4) 1/2 4)))
      (check-equal? (coeficiente-de p 4) 1)
      (check-true (integer? (coeficiente-de p 4))))
    (let ((p (insertar-termino (insertar-termino (polinomio-cero 'x) 1/2 4) -1/2 4)))
      (check-exn exn:fail? (lambda () (coeficiente-de p 4))))

    ;;cancelar y volver a insertar el mismo exponente
    (let* ((p (construir polinomio-cero insertar-termino 'x '((4 5) (7 0))))
           (cancelado (insertar-termino p -4 5))
           (reinsertado (insertar-termino cancelado 9 5)))
      (check-exn exn:fail? (lambda () (coeficiente-de cancelado 5)))
      (check-equal? (coeficiente-de cancelado 0) 7)
      (check-equal? (coeficiente-de reinsertado 5) 9))

    ;;exponente grande (disperso)
    (let ((p (construir polinomio-cero insertar-termino 'x '((1 1000) (2 0)))))
      (check-equal? (coeficiente-de p 1000) 1)
      (check-equal? (coeficiente-de p 0) 2)
      (check-exn exn:fail? (lambda () (coeficiente-de p 999))))

    ;;eliminar: vaciar el polinomio y persistencia del original
    (let* ((p (construir polinomio-cero insertar-termino 'x '((4 5) (-3/2 2) (7 0))))
           (sin5 (eliminar-termino p 5))
           (sin52 (eliminar-termino sin5 2))
           (vacio (eliminar-termino sin52 0)))
      (check-equal? (coeficiente-de sin52 0) 7)
      (check-exn exn:fail? (lambda () (coeficiente-de vacio 0)))
      (check-exn exn:fail? (lambda () (eliminar-termino vacio 0)))
      ;; eliminar dos veces el mismo término: la segunda falla
      (check-exn exn:fail? (lambda () (eliminar-termino sin5 5)))
      ;; el polinomio original no cambió
      (check-equal? (coeficiente-de p 5) 4)
      (check-equal? (coeficiente-de p 2) -3/2)
      (check-equal? (coeficiente-de p 0) 7))

    ;;un término sobrevive a la eliminación de otro, en cualquier posición
    (let ((p (construir polinomio-cero insertar-termino 'x '((4 5) (-3/2 2) (7 0)))))
      (check-equal? (coeficiente-de (eliminar-termino p 0) 5) 4)
      (check-equal? (coeficiente-de (eliminar-termino p 0) 2) -3/2)
      (check-exn exn:fail? (lambda () (coeficiente-de (eliminar-termino p 0) 0)))
      (check-equal? (coeficiente-de (eliminar-termino p 5) 2) -3/2)
      (check-equal? (coeficiente-de (eliminar-termino p 5) 0) 7)
      (check-exn exn:fail? (lambda () (coeficiente-de (eliminar-termino p 5) 5))))

    (let ((p (insertar-termino (polinomio-cero 'x) 3 1)))
      (check-exn exn:fail? (lambda () (insertar-termino p 1 -5)))
      (check-exn exn:fail? (lambda () (insertar-termino p 1 1/2)))
      (check-exn exn:fail? (lambda () (insertar-termino p 0.5 1)))
      (check-exn exn:fail? (lambda () (coeficiente-de p -1)))
      (check-exn exn:fail? (lambda () (eliminar-termino p -1))))))

(pruebas-interfaz-extra "Extra: representación con listas"
                        listas:polinomio-cero listas:insertar-termino
                        listas:coeficiente-de listas:eliminar-termino)

;;Representación con datatypes: misma batería de la interfaz
(pruebas-interfaz "Representación con datatypes"
                  dt:polinomio-cero dt:insertar-termino
                  dt:coeficiente-de dt:eliminar-termino)

(pruebas-interfaz-extra "Extra: representación con datatypes"
                        dt:polinomio-cero dt:insertar-termino
                        dt:coeficiente-de dt:eliminar-termino)

;; Pruebas propias de datatypes sumar


(define (dt-construir var pares)
  (construir dt:polinomio-cero dt:insertar-termino var pares))

(test-case "datatypes: sumar — ejemplo del enunciado"
  ;; p = 4x^5 - (3/2)x^2 + 7 ; q = -4x^5 + (1/2)x^2 + 2x
  ;; p + q = -x^2 + 2x + 7
  (let* ((p (dt-construir 'x '((4 5) (-3/2 2) (7 0))))
         (q (dt-construir 'x '((-4 5) (1/2 2) (2 1))))
         (s (dt:sumar p q)))
    (check-equal? (dt:coeficiente-de s 2) -1)
    (check-equal? (dt:coeficiente-de s 1) 2)
    (check-equal? (dt:coeficiente-de s 0) 7)
    (check-exn exn:fail? (lambda () (dt:coeficiente-de s 5)))   ; x^5 se canceló
    (check-exn exn:fail? (lambda () (dt:coeficiente-de s 3)))
    ;; los operandos no se modifican
    (check-equal? (dt:coeficiente-de p 5) 4)
    (check-equal? (dt:coeficiente-de q 5) -4)))

(test-case "datatypes: sumar — cancelación total"
  (let* ((p (dt-construir 'x '((4 5) (-3/2 2) (7 0))))
         (menos-p (dt-construir 'x '((-4 5) (3/2 2) (-7 0))))
         (s (dt:sumar p menos-p)))
    (check-exn exn:fail? (lambda () (dt:coeficiente-de s 5)))
    (check-exn exn:fail? (lambda () (dt:coeficiente-de s 2)))
    (check-exn exn:fail? (lambda () (dt:coeficiente-de s 0)))
    ;; el resultado es el polinomio nulo: se comporta como tal
    (check-exn exn:fail? (lambda () (dt:eliminar-termino s 0)))
    (check-equal? (dt:coeficiente-de (dt:insertar-termino s 5 3) 3) 5)))

(test-case "datatypes: sumar — variables distintas"
  (let ((px (dt-construir 'x '((4 5) (7 0))))
        (qy (dt-construir 'y '((1 5) (2 0)))))
    (check-exn exn:fail? (lambda () (dt:sumar px qy)))
    (check-exn exn:fail? (lambda () (dt:sumar qy px)))
    ;; incluso con el polinomio nulo, la variable debe coincidir
    (check-exn exn:fail? (lambda () (dt:sumar px (dt:polinomio-cero 'y))))))

(test-case "datatypes: sumar — con el polinomio nulo (neutro)"
  (let* ((p (dt-construir 'x '((4 5) (-3/2 2) (7 0))))
         (cero (dt:polinomio-cero 'x))
         (s1 (dt:sumar p cero))
         (s2 (dt:sumar cero p))
         (s3 (dt:sumar cero cero)))
    (for-each
     (lambda (s)
       (check-equal? (dt:coeficiente-de s 5) 4)
       (check-equal? (dt:coeficiente-de s 2) -3/2)
       (check-equal? (dt:coeficiente-de s 0) 7))
     (list s1 s2))
    (check-exn exn:fail? (lambda () (dt:coeficiente-de s3 0)))))

(test-case "datatypes: sumar — exponentes disjuntos, intercalados y conmutatividad"
  (let* ((p (dt-construir 'x '((1 6) (1 4) (1 2))))
         (q (dt-construir 'x '((1 5) (1 3) (1 1))))
         (s (dt:sumar p q))
         (s-inv (dt:sumar q p)))
    (for-each
     (lambda (r)
       (for-each (lambda (e) (check-equal? (dt:coeficiente-de r e) 1))
                 '(1 2 3 4 5 6))
       (check-exn exn:fail? (lambda () (dt:coeficiente-de r 0))))
     (list s s-inv))))

(test-case "datatypes: sumar — racionales que se reducen y suman a entero"
  (let* ((p (dt-construir 'x '((1/3 2) (1/2 1))))
         (q (dt-construir 'x '((2/3 2) (-1/2 1) (5 0))))
         (s (dt:sumar p q)))
    (check-equal? (dt:coeficiente-de s 2) 1)
    (check-true (integer? (dt:coeficiente-de s 2)))
    (check-exn exn:fail? (lambda () (dt:coeficiente-de s 1)))   ; 1/2 - 1/2 = 0
    (check-equal? (dt:coeficiente-de s 0) 5)))

(test-case "datatypes: sumar — resultado sigue siendo operable por la interfaz"
  (let* ((p (dt-construir 'x '((4 5) (-3/2 2) (7 0))))
         (q (dt-construir 'x '((-4 5) (1/2 2) (2 1))))
         (s (dt:sumar p q))
         (s2 (dt:insertar-termino s 1 2)))     ; -x^2 + x^2 = 0 -> desaparece
    (check-exn exn:fail? (lambda () (dt:coeficiente-de s2 2)))
    (check-equal? (dt:coeficiente-de (dt:eliminar-termino s 1) 2) -1)
    (check-exn exn:fail? (lambda () (dt:eliminar-termino s 5)))))
 
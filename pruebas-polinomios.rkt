#lang eopl
;Autores: Samuel Garcia Parra 2459476, Nombre2 Codigo2
 
;; Taller 1 — Polinomios dispersos.
;; Parte 4: la misma batería de pruebas sobre las tres representaciones.
 
(require rackunit)
(require (only-in racket/base exn:fail? exn?)) ;; 
(require (prefix-in listas: "polinomios-listas.rkt"))
;; (require (prefix-in procs:  "polinomios-procedimientos.rkt")) ;; agregar cuando exista
;; (require (prefix-in dt:     "polinomios-datatypes.rkt"))      ;; agregar cuando exista
 
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
 
(pruebas-interfaz "Representación con listas"
                   listas:polinomio-cero listas:insertar-termino
                   listas:coeficiente-de listas:eliminar-termino)
 
;; Cuando existan los otros dos archivos, descomenta sus require arriba
;; y agrega:
;; (pruebas-interfaz "Representación con procedimientos"
;;                    procs:polinomio-cero procs:insertar-termino
;;                    procs:coeficiente-de procs:eliminar-termino)
;; (pruebas-interfaz "Representación con datatypes"
;;                    dt:polinomio-cero dt:insertar-termino
;;                    dt:coeficiente-de dt:eliminar-termino)
 
;; Pruebas propias de la representación con datatypes (Parte 3): sumar
;; dos polinomios que se cancelan por completo, y suma de polinomios en
;; variables distintas. Agregar junto con polinomios-datatypes.rkt:
;; (check-equal? (dt:coeficiente-de (dt:sumar p q) 5) ...)
;; (check-exn exn:fail? (lambda () (dt:sumar p-en-x q-en-y)))
 
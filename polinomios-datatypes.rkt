#lang eopl
;Autores: Juan Sebastian Navarrete 202459562, Samuel Garcia Parra 202459476

;; Taller 1 — Polinomios dispersos.
;; Parte 3: representación con datatypes.
;;
;; Gramática (BNF) del TAD y su correspondencia con define-datatype:
;;
;;   <polinomio>    ::= <variable> <terminos>       poli(var, terms)
;;   <variable>     ::= <symbol>                    nombre-var(s)
;;   <terminos>     ::= '()                         sin-terminos()
;;                  ::= <termino> <terminos>        mas-terminos(term, resto)
;;   <termino>      ::= <coeficiente> <exponente>   termino(coef, expo)
;;   <coeficiente>  ::= <int>                       coef-ent(n)
;;                  ::= <int> "/" <int>             coef-rac(num, den)
;;   <exponente>    ::= <int>                       expo-nat(k)
;;
;; Interfaz del TAD. Cada función va comentada con su nombre, su contrato
;; (entrada -> salida) y su propósito, y ninguna recorre la lista de términos
;; más de una vez ni la ordena al final.
;;
;;   polinomio-cero    : symbol -> polinomio
;;   insertar-termino  : polinomio x coeficiente x exponente -> polinomio
;;   coeficiente-de    : polinomio x exponente -> coeficiente
;;   eliminar-termino  : polinomio x exponente -> polinomio
;;   sumar             : polinomio x polinomio -> polinomio



(provide polinomio-cero insertar-termino coeficiente-de eliminar-termino sumar)

;;Define datatype

(define-datatype polinomio polinomio?
  (poli (var variable?) (terms terminos?)))

(define-datatype variable variable?
  (nombre-var (s symbol?)))
 
(define-datatype terminos terminos?
  (sin-terminos)
  (mas-terminos (term termino-tad?) (resto terminos?)))
 
(define-datatype termino-tad termino-tad?
  (termino (coef coeficiente?) (expo exponente?)))
 
(define-datatype coeficiente coeficiente?
  (coef-ent (n integer?))
  (coef-rac (num integer?) (den integer?)))
 
(define-datatype exponente exponente?
  (expo-nat (k integer?)))

;; interfaz

(define concreto->coef
  (lambda (n)
    (if (integer? n)
        (coef-ent n)
        (coef-rac (numerator n) (denominator n)))))

(define coef->concreto
  (lambda (c)
    (cases coeficiente c
      (coef-ent (n) n)
      (coef-rac (num den) (/ num den)))))

(define polinomio-cero
  (lambda (v)
    (if (symbol? v)
        (poli (nombre-var v) (sin-terminos))
        (eopl:error 'polinomio-cero "La variable debe ser un simbolo"))))

(define insertar-termino
  (lambda (polinomio coeficiente exponente)
    (eopl:error 'insertar-termino "Sin implementar")))

(define coeficiente-de
  (lambda (polinomio exponente)
    (eopl:error 'coeficiente-de "Sin implementar")))

(define eliminar-termino
  (lambda (polinomio exponente)
    (eopl:error 'eliminar-termino "Sin implementar")))

(define sumar
  (lambda (p q)
    (eopl:error 'sumar "Sin implementar")))

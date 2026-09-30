#lang eopl
;Autores: Samuel Garcia Parra 2459476, Nombre2 Codigo2

;; Taller 1 — Polinomios dispersos.
;; Parte 1: representación basada en listas.
;;
;; Interfaz del TAD. Cada función va comentada con su nombre, su contrato
;; (entrada -> salida) y su propósito, y ninguna recorre la lista de términos
;; más de una vez ni la ordena al final.
;;
;;   polinomio-cero    : symbol -> polinomio
;;   insertar-termino  : polinomio x coeficiente x exponente -> polinomio
;;   coeficiente-de    : polinomio x exponente -> coeficiente
;;   eliminar-termino  : polinomio x exponente -> polinomio

(provide polinomio-cero insertar-termino coeficiente-de eliminar-termino)

;; ============================================================
;; Capa de datos: constructores, predicados y extractores de la
;; gramática BNF del TAD (sección 3.3 del enunciado).
;; ============================================================

;; ---- <polinomio> ::= <variable> <terminos>      poli(var, terms) ----
(define poli
  (lambda (var terms)
    (list 'poli var terms)))
 
(define poli?
  (lambda (x)
    (and (pair? x) (equal? (car x) 'poli))))
 
(define poli->var
  (lambda (valor)
    (cadr valor)))
 
(define poli->terms
  (lambda (valor)
    (caddr valor)))
 
;; ---- <variable> ::= <symbol>      nombre-var(s) ----
(define nombre-var
  (lambda (s)
    (list 'nombre-var s)))
 
(define nombre-var?
  (lambda (x)
    (and (pair? x) (equal? (car x) 'nombre-var))))
 
(define nombre-var->s
  (lambda (valor)
    (cadr valor)))
 
;; ---- <terminos> ::= '()      sin-terminos() ----
(define sin-terminos
  (lambda ()
    (list 'sin-terminos)))
 
(define sin-terminos?
  (lambda (x)
    (and (pair? x) (equal? (car x) 'sin-terminos))))
 
;; ---- <terminos> ::= <termino> <terminos>      mas-terminos(term, resto) ----
(define mas-terminos
  (lambda (term resto)
    (list 'mas-terminos term resto)))
 
(define mas-terminos?
  (lambda (x)
    (and (pair? x) (equal? (car x) 'mas-terminos))))
 
(define mas-terminos->term
  (lambda (valor)
    (cadr valor)))
 
(define mas-terminos->resto
  (lambda (valor)
    (caddr valor)))
 
;; ---- <termino> ::= <coeficiente> <exponente>      termino(coef, expo) ----
(define termino
  (lambda (coef expo)
    (list 'termino coef expo)))
 
(define termino?
  (lambda (x)
    (and (pair? x) (equal? (car x) 'termino))))
 
(define termino->coef
  (lambda (valor)
    (cadr valor)))
 
(define termino->expo
  (lambda (valor)
    (caddr valor)))
 
;; ---- <coeficiente> ::= <int>      coef-ent(n) ----
(define coef-ent
  (lambda (n)
    (list 'coef-ent n)))
 
(define coef-ent?
  (lambda (n)
    (and (pair? n) (equal? (car n) 'coef-ent))))
 
(define coef-ent->n
  (lambda (valor)
    (cadr valor)))
 
;; ---- <coeficiente> ::= <int> "/" <int>      coef-rac(num, den) ----
(define coef-rac
  (lambda (num den)
    (list 'coef-rac num den)))
 
(define coef-rac?
  (lambda (x)
    (and (pair? x) (equal? (car x) 'coef-rac))))
 
(define coef-rac->num
  (lambda (valor)
    (cadr valor)))
 
(define coef-rac->den
  (lambda (valor)
    (caddr valor)))
 
;; ---- <exponente> ::= <int>      expo-nat(k) ----
(define expo-nat
  (lambda (k)
    (list 'expo-nat k)))
 
(define expo-nat?
  (lambda (x)
    (and (pair? x) (equal? (car x) 'expo-nat))))
 
(define expo-nat->k
  (lambda (valor)
    (cadr valor)))
 
;; ============================================================
;; Ayudantes de traducción entre coeficiente concreto (número de
;; Racket: 4, -3/2) y coeficiente abstracto (coef-ent / coef-rac).
;; ============================================================
 
(define coeficiente-concreto->abstracto
  (lambda (c)
    (if (integer? c)
        (coef-ent c)
        (coef-rac (numerator c) (denominator c)))))

(define polinomio-cero
  (lambda (variable)
    (eopl:error 'polinomio-cero "Sin implementar")))

(define insertar-termino
  (lambda (polinomio coeficiente exponente)
    (eopl:error 'insertar-termino "Sin implementar")))

(define coeficiente-de
  (lambda (polinomio exponente)
    (eopl:error 'coeficiente-de "Sin implementar")))

(define eliminar-termino
  (lambda (polinomio exponente)
    (eopl:error 'eliminar-termino "Sin implementar")))

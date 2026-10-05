#lang eopl
;Autores: Samuel Garcia Parra 2459476, Juan Sebastian Navarrete Rada Codigo2
 
(provide polinomio-cero insertar-termino coeficiente-de eliminar-termino)
 
;; ---- Capa de datos (gramática BNF) ----
 
(define poli (lambda (var terms) (list 'poli var terms)))
(define poli? (lambda (x) (and (pair? x) (equal? (car x) 'poli))))
(define poli->var (lambda (valor) (cadr valor)))
(define poli->terms (lambda (valor) (caddr valor)))
 
(define nombre-var (lambda (s) (list 'nombre-var s)))
(define nombre-var? (lambda (x) (and (pair? x) (equal? (car x) 'nombre-var))))
(define nombre-var->s (lambda (valor) (cadr valor)))
 
(define sin-terminos (lambda () (list 'sin-terminos)))
(define sin-terminos? (lambda (x) (and (pair? x) (equal? (car x) 'sin-terminos))))
 
(define mas-terminos (lambda (term resto) (list 'mas-terminos term resto)))
(define mas-terminos? (lambda (x) (and (pair? x) (equal? (car x) 'mas-terminos))))
(define mas-terminos->term (lambda (valor) (cadr valor)))
(define mas-terminos->resto (lambda (valor) (caddr valor)))
 
(define termino (lambda (coef expo) (list 'termino coef expo)))
(define termino? (lambda (x) (and (pair? x) (equal? (car x) 'termino))))
(define termino->coef (lambda (valor) (cadr valor)))
(define termino->expo (lambda (valor) (caddr valor)))
 
(define coef-ent (lambda (n) (list 'coef-ent n)))
(define coef-ent? (lambda (n) (and (pair? n) (equal? (car n) 'coef-ent))))
(define coef-ent->n (lambda (valor) (cadr valor)))
 
(define coef-rac (lambda (num den) (list 'coef-rac num den)))
(define coef-rac? (lambda (x) (and (pair? x) (equal? (car x) 'coef-rac))))
(define coef-rac->num (lambda (valor) (cadr valor)))
(define coef-rac->den (lambda (valor) (caddr valor)))
 
(define expo-nat (lambda (k) (list 'expo-nat k)))
(define expo-nat? (lambda (x) (and (pair? x) (equal? (car x) 'expo-nat))))
(define expo-nat->k (lambda (valor) (cadr valor)))
 
;; ---- Traducción concreto <-> abstracto ----
 
;; coeficiente-concreto->abstracto : number -> coeficiente
;; Propósito: construir coef-ent o coef-rac a partir de un número de Racket.
(define coeficiente-concreto->abstracto
  (lambda (c)
    (if (integer? c)
        (coef-ent c)
        (coef-rac (numerator c) (denominator c)))))
 
;; coeficiente-abstracto->concreto : coeficiente -> number
;; Propósito: devolver el número de Racket a partir de coef-ent o coef-rac.
(define coeficiente-abstracto->concreto
  (lambda (c)
    (if (coef-ent? c)
        (coef-ent->n c)
        (/ (coef-rac->num c) (coef-rac->den c)))))
 
;; ---- Interfaz del TAD ----
 
;; polinomio-cero : symbol -> polinomio
;; Propósito: construir el polinomio nulo en la variable dada.
(define polinomio-cero
  (lambda (variable)
    (poli (nombre-var variable) (sin-terminos))))
 
;; coeficiente-de : polinomio x exponente -> coeficiente
;; Propósito: devolver el coeficiente del término con ese exponente;
;; error si no existe.
(define coeficiente-de
  (lambda (polinomio exponente)
    (coeficiente-de-terminos (poli->terms polinomio) exponente)))
 
(define coeficiente-de-terminos
  (lambda (terms exponente)
    (if (sin-terminos? terms)
        (eopl:error 'coeficiente-de "El polinomio no tiene termino con ese exponente")
        (let* ((t (mas-terminos->term terms))
               (expo-t (expo-nat->k (termino->expo t))))
          (cond
            ((= expo-t exponente) (coeficiente-abstracto->concreto (termino->coef t)))
            ((< expo-t exponente) (eopl:error 'coeficiente-de "El polinomio no tiene termino con ese exponente"))
            (else (coeficiente-de-terminos (mas-terminos->resto terms) exponente)))))))
 
;; eliminar-termino : polinomio x exponente -> polinomio
;; Propósito: devolver el polinomio sin el término de ese exponente;
;; error si no existe.
(define eliminar-termino
  (lambda (polinomio exponente)
    (poli (poli->var polinomio)
          (eliminar-termino-terminos (poli->terms polinomio) exponente))))
 
(define eliminar-termino-terminos
  (lambda (terms exponente)
    (if (sin-terminos? terms)
        (eopl:error 'eliminar-termino "El polinomio no tiene termino con ese exponente")
        (let* ((t (mas-terminos->term terms))
               (resto (mas-terminos->resto terms))
               (expo-t (expo-nat->k (termino->expo t))))
          (cond
            ((= expo-t exponente) resto)
            ((< expo-t exponente) (eopl:error 'eliminar-termino "El polinomio no tiene termino con ese exponente"))
            (else (mas-terminos t (eliminar-termino-terminos resto exponente))))))))
 
;; insertar-termino : polinomio x coeficiente x exponente -> polinomio
;; Propósito: insertar un término sumando coeficientes si el exponente ya
;; existía (eliminándolo si la suma da cero); error si el exponente es
;; negativo o el coeficiente no es exacto.
(define insertar-termino
  (lambda (polinomio coeficiente exponente)
    (cond
      ((or (not (integer? exponente)) (< exponente 0))
       (eopl:error 'insertar-termino "El exponente debe ser un entero no negativo"))
      ((not (exact? coeficiente))
       (eopl:error 'insertar-termino "El coeficiente debe ser un numero exacto"))
      (else
       (poli (poli->var polinomio)
             (insertar-termino-terminos (poli->terms polinomio) coeficiente exponente))))))
 
(define insertar-termino-terminos
  (lambda (terms coeficiente exponente)
    (if (sin-terminos? terms)
        (if (= coeficiente 0)
            terms
            (mas-terminos (termino (coeficiente-concreto->abstracto coeficiente) (expo-nat exponente)) terms))
        (let* ((t (mas-terminos->term terms))
               (resto (mas-terminos->resto terms))
               (expo-t (expo-nat->k (termino->expo t))))
          (cond
            ((> exponente expo-t)
             (if (= coeficiente 0)
                 terms
                 (mas-terminos (termino (coeficiente-concreto->abstracto coeficiente) (expo-nat exponente)) terms)))
            ((= exponente expo-t)
             (let ((suma (+ coeficiente (coeficiente-abstracto->concreto (termino->coef t)))))
               (if (= suma 0)
                   resto
                   (mas-terminos (termino (coeficiente-concreto->abstracto suma) (expo-nat exponente)) resto))))
            (else
             (mas-terminos t (insertar-termino-terminos resto coeficiente exponente))))))))
 
;; ---- Ejemplos: construcción con constructores y observadores ----
 
(define ejemplo-var (nombre-var 'x))
(define ejemplo-coef-ent (coef-ent 4))
(define ejemplo-coef-rac (coef-rac -3 2))
(define ejemplo-termino (termino ejemplo-coef-ent (expo-nat 5)))
(define ejemplo-poli-vacio (poli ejemplo-var (sin-terminos)))
 
;; ---- Ejemplos: uso de la interfaz ----
 
(define p0 (polinomio-cero 'x))
 
(define p
  (insertar-termino
   (insertar-termino
    (insertar-termino (polinomio-cero 'x) 7 0)
    -3/2 2)
   4 5))
;; p representa 4x^5 - (3/2)x^2 + 7
 
;; (insertar-termino p 1 2)     ;; => 4x^5 - (1/2)x^2 + 7
;; (insertar-termino p 3/2 2)   ;; => 4x^5 + 7
;; (insertar-termino p 5 -1)    ;; Error: exponente negativo
;; (insertar-termino p 1.5 2)   ;; Error: coeficiente no exacto
 
;; (coeficiente-de p 2)   ;; => -3/2
;; (coeficiente-de p 5)   ;; => 4
;; (coeficiente-de p 0)   ;; => 7
;; (coeficiente-de p0 0)  ;; Error
;; (coeficiente-de p 3)   ;; Error
 
;; (eliminar-termino p 2)   ;; => 4x^5 + 7
;; (eliminar-termino p 5)   ;; => -(3/2)x^2 + 7
;; (eliminar-termino p 0)   ;; => 4x^5 - (3/2)x^2
;; (eliminar-termino p0 0)  ;; Error
;; (eliminar-termino p 3)   ;; Error
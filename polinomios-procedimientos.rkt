#lang eopl
;Autores: Samuel Garcia Parra 2459476, Nombre2 Codigo2

;; Taller 1 — Polinomios dispersos.
;; Parte 2: representación basada en procedimientos.
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

;; ---- Capa de datos: cada dato es un procedimiento que responde a
;; mensajes. 'tipo devuelve la etiqueta de la variante; los demás
;; mensajes son los nombres de los campos. ----

(define poli
  (lambda (var terms)
    (lambda (msg)
      (cond
        ((equal? msg 'tipo) 'poli)
        ((equal? msg 'var) var)
        ((equal? msg 'terms) terms)
        (else (eopl:error 'poli "Mensaje desconocido: ~a" msg))))))
(define poli? (lambda (dato) (and (procedure? dato) (equal? (dato 'tipo) 'poli))))
(define poli->var (lambda (valor) (valor 'var)))
(define poli->terms (lambda (valor) (valor 'terms)))

(define nombre-var
  (lambda (s)
    (lambda (msg)
      (cond
        ((equal? msg 'tipo) 'nombre-var)
        ((equal? msg 's) s)
        (else (eopl:error 'nombre-var "Mensaje desconocido: ~a" msg))))))
(define nombre-var? (lambda (dato) (and (procedure? dato) (equal? (dato 'tipo) 'nombre-var))))
(define nombre-var->s (lambda (valor) (valor 's)))

(define sin-terminos
  (lambda ()
    (lambda (msg)
      (cond
        ((equal? msg 'tipo) 'sin-terminos)
        (else (eopl:error 'sin-terminos "Mensaje desconocido: ~a" msg))))))
(define sin-terminos? (lambda (dato) (and (procedure? dato) (equal? (dato 'tipo) 'sin-terminos))))

(define mas-terminos
  (lambda (term resto)
    (lambda (msg)
      (cond
        ((equal? msg 'tipo) 'mas-terminos)
        ((equal? msg 'term) term)
        ((equal? msg 'resto) resto)
        (else (eopl:error 'mas-terminos "Mensaje desconocido: ~a" msg))))))
(define mas-terminos? (lambda (dato) (and (procedure? dato) (equal? (dato 'tipo) 'mas-terminos))))
(define mas-terminos->term (lambda (valor) (valor 'term)))
(define mas-terminos->resto (lambda (valor) (valor 'resto)))

(define termino
  (lambda (coef expo)
    (lambda (msg)
      (cond
        ((equal? msg 'tipo) 'termino)
        ((equal? msg 'coef) coef)
        ((equal? msg 'expo) expo)
        (else (eopl:error 'termino "Mensaje desconocido: ~a" msg))))))
(define termino? (lambda (dato) (and (procedure? dato) (equal? (dato 'tipo) 'termino))))
(define termino->coef (lambda (valor) (valor 'coef)))
(define termino->expo (lambda (valor) (valor 'expo)))

(define coef-ent
  (lambda (n)
    (lambda (msg)
      (cond
        ((equal? msg 'tipo) 'coef-ent)
        ((equal? msg 'n) n)
        (else (eopl:error 'coef-ent "Mensaje desconocido: ~a" msg))))))
(define coef-ent? (lambda (dato) (and (procedure? dato) (equal? (dato 'tipo) 'coef-ent))))
(define coef-ent->n (lambda (valor) (valor 'n)))

(define coef-rac
  (lambda (num den)
    (lambda (msg)
      (cond
        ((equal? msg 'tipo) 'coef-rac)
        ((equal? msg 'num) num)
        ((equal? msg 'den) den)
        (else (eopl:error 'coef-rac "Mensaje desconocido: ~a" msg))))))
(define coef-rac? (lambda (dato) (and (procedure? dato) (equal? (dato 'tipo) 'coef-rac))))
(define coef-rac->num (lambda (valor) (valor 'num)))
(define coef-rac->den (lambda (valor) (valor 'den)))

(define expo-nat
  (lambda (k)
    (lambda (msg)
      (cond
        ((equal? msg 'tipo) 'expo-nat)
        ((equal? msg 'k) k)
        (else (eopl:error 'expo-nat "Mensaje desconocido: ~a" msg))))))
(define expo-nat? (lambda (dato) (and (procedure? dato) (equal? (dato 'tipo) 'expo-nat))))
(define expo-nat->k (lambda (valor) (valor 'k)))

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

;; ---- Interfaz del TAD (idéntica a polinomios-listas.rkt) ----

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
#lang eopl
;Autores: Juan Sebastian Navarrete 202459562, Nombre2 Codigo2

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

;; funciones auxiliares

;; Paso de la representacion concreta a la abstracta

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

(define expo->concreto
  (lambda (exp)
    (cases exponente exp
      (expo-nat (k) k))))

(define concreto->expo
  (lambda (k)
    (expo-nat k)))



;; validacion de los valores concretos

(define expo-valido?
  (lambda (exp)
    (and (integer? exp) (exact? exp) (>= exp 0))))

(define coef-valido?
  (lambda (c)
    (and (rational? c) (exact? c))))

;;auxiliar de insertar-termino que se encarga de insertar coeficiente y exponente en la lista de terminos

(define insertar-en
  (lambda (ts c e)
    (cases terminos ts
      (sin-terminos ()
        (if (zero? c)
            ts
            (mas-terminos (termino (concreto->coef c) (concreto->expo e)) ts)))
      (mas-terminos (t resto)
        (cases termino-tad t
          (termino (coef expo)
            (let ((k (expo->concreto expo)))
              (cond
                ((> k e) (mas-terminos t (insertar-en resto c e)))
                ((= k e)
                 (let ((suma (+ (coef->concreto coef) c)))
                   (if (zero? suma)
                       resto
                       (mas-terminos (termino (concreto->coef suma) expo) resto))))
                (else
                 (if (zero? c)
                     ts
                     (mas-terminos (termino (concreto->coef c) (concreto->expo e)) ts)))))))))))

;;Auxiliar de coeficiente-de que recorre la lista buscando e de forma decreciente y para cuando lo encuentra o se pasa

(define buscar-coef
  (lambda (ts e)
    (cases terminos ts
      (sin-terminos ()
        (eopl:error 'coeficiente-de "El polinomio no tiene termino con ese exponente"))
      (mas-terminos (t resto)
        (cases termino-tad t
          (termino (coef expo)
            (let ((k (expo->concreto expo)))
              (cond
                ((= k e) (coef->concreto coef))
                ((< k e) (eopl:error 'coeficiente-de "El polinomio no tiene termino con ese exponente"))
                (else (buscar-coef resto e))))))))))

;;funcion auxiliar de eliminar-termino que recorre la lista una sola vez y quita el termino de exponente e

(define eliminar-en
  (lambda (ts e)
    (cases terminos ts
      (sin-terminos ()
        (eopl:error 'eliminar-termino "El polinomio no tiene termino con ese exponente"))
      (mas-terminos (t resto)
        (cases termino-tad t
          (termino (coef expo)
            (let ((k (expo->concreto expo)))
              (cond
                ((= k e) resto)
                ((< k e) (eopl:error 'eliminar-termino "El polinomio no tiene termino con ese exponente"))
                (else (mas-terminos t (eliminar-en resto e)))))))))))

;;funcion auxiliar que se encarga de sumar dos listas de terminos ordenadas decreciente

(define sumar-terminos
  (lambda (ts1 ts2)
    (cases terminos ts1
      (sin-terminos () ts2)
      (mas-terminos (t1 resto1)
        (cases terminos ts2
          (sin-terminos () ts1)
          (mas-terminos (t2 resto2)
            (cases termino-tad t1
              (termino (coef1 expo1)
                (cases termino-tad t2
                  (termino (coef2 expo2)
                    (let ((k1 (expo->concreto expo1))
                          (k2 (expo->concreto expo2)))
                      (cond
                        ((> k1 k2) (mas-terminos t1 (sumar-terminos resto1 ts2)))
                        ((< k1 k2) (mas-terminos t2 (sumar-terminos ts1 resto2)))
                        (else
                         (let ((suma (+ (coef->concreto coef1) (coef->concreto coef2))))
                           (if (zero? suma)
                               (sumar-terminos resto1 resto2)
                               (mas-terminos (termino (concreto->coef suma) expo1)
                                             (sumar-terminos resto1 resto2)))))))))))))))))

;;Funciones de la interfaz

(define polinomio-cero
  (lambda (var)
    (if (symbol? var)
        (poli (nombre-var var) (sin-terminos))
        (eopl:error 'polinomio-cero "La variable debe ser un simbolo"))))

(define insertar-termino
  (lambda (p c e)
    (cond
      ((not (expo-valido? e))
       (eopl:error 'insertar-termino "El exponente no puede ser negativo"))
      ((not (coef-valido? c))
       (eopl:error 'insertar-termino "El coeficiente debe ser exacto"))
      (else
       (cases polinomio p
         (poli (var ts) (poli var (insertar-en ts c e))))))))

(define coeficiente-de
  (lambda (p e)
    (if (not (expo-valido? e))
        (eopl:error 'coeficiente-de "El exponente debe ser un entero no negativo")
        (cases polinomio p
          (poli (var ts) (buscar-coef ts e))))))

(define eliminar-termino
  (lambda (p e)
    (if (not (expo-valido? e))
        (eopl:error 'eliminar-termino "El exponente debe ser un entero no negativo")
        (cases polinomio p
          (poli (var ts) (poli var (eliminar-en ts e)))))))

(define sumar
  (lambda (p q)
    (cases polinomio p
      (poli (varp tsp)
        (cases polinomio q
          (poli (varq tsq)
            (cases variable varp
              (nombre-var (sp)
                (cases variable varq
                  (nombre-var (sq)
                    (if (not (eq? sp sq))
                        (eopl:error 'sumar "Los polinomios deben tener la misma variable")
                        (poli varp (sumar-terminos tsp tsq)))))))))))))


;; auxiliar de polinomio->lista recorre ts una sola vez y arma la vista concreta

(define terminos->lista
  (lambda (ts)
    (cases terminos ts
      (sin-terminos () '())
      (mas-terminos (t resto)
        (cases termino-tad t
          (termino (coef expo)
            (cons (list (coef->concreto coef) (expo->concreto expo))
                  (terminos->lista resto))))))))

;;funcion auxiliar que extrae del ambiente el polinomio del TAD o embiente

(define polinomio->lista
  (lambda (p)
    (cases polinomio p
      (poli (var ts) (terminos->lista ts)))))

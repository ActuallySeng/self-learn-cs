
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

(define (sequence low high stride)
  (let ([new_val (+ low stride)])
    (cond
      [(> low high) null]
      [else (cons low (sequence new_val high stride))])))

;; String List, String -> String List
;; Each element of the output should be the corresponding element of the input appended with suffix.
(define (string-append-map xs suffix)
  (let ([append-func (lambda (s) (string-append s suffix))])
    (map append-func xs)))

;; 'a List, Number -> 'a
(define (list-nth-mod xs n)
  (cond [(< n 0) (error "list-nth-mod: negative number")]
        [(null? xs) (error "list-nth-mod: empty list")]
        [else (let ([i (remainder n (length xs))])
                (car (list-tail xs i)))]))

;; A Stream, Number -> A List
;;  It returns a list holding the first n values produced by s in order.
(define (stream-for-n-steps s n)
  (cond [(= n 0) null]
        [else (cons (car (s)) (stream-for-n-steps (cdr (s)) (- n 1)))]))

;; -> Int * Stream Pair
;; stream of natural numbers (i.e., 1, 2, 3, ...) except numbers divisble by 5 are negated (i.e., 1, 2, 3, 4, -5, 6, 7, 8, 9, -10, 11, ...).
(define funny-number-stream
  (letrec ([f (lambda (x) (cond [(= 0 (remainder x 5)) (cons (- x) (lambda () (f (+ x 1))))]
                                [else (cons x (lambda () (f (+ x 1))))]))])
  (lambda () (f 1))))

;; -> String * Stream
(define dan-then-dog
  (letrec ([f (lambda (x) (cons x (lambda () (f (if (string=? x "dan.jpg") "dog.jpg" "dan.jpg")))))])
    (lambda () (f "dan.jpg"))))

(define (stream-add-zero s)
  (letrec ([f (lambda (x) (cons (cons 0 (list-nth-mod (stream-for-n-steps s x) (- x 1))) (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))

(define (cycle-lists xs ys)
  (letrec ([f (lambda (x) (cons (cons (list-nth-mod xs x) (list-nth-mod ys x)) (lambda () (f (+ x 1)))))])
    (lambda () (f 0))))

(define (vector-assoc v vec)
  (letrec ([f (lambda (n) (cond [(> n (- (vector-length vec) 1)) #f]
                                [(not (pair? (vector-ref vec n))) (f (+ n 1))]
                                [(equal? (car (vector-ref vec n)) v) (vector-ref vec n)]
                                [else (f (+ n 1))]))])
  (f 0)))

(define (cached-assoc xs n)
  (letrec ([cache (make-vector n #f)]
           [current-pos 0]
           [f (lambda (v) (cond [(vector-assoc v cache) (vector-assoc v cache)]
                                [(assoc v xs) (begin (vector-set! cache current-pos (assoc v xs))
                                                     (cond [(< current-pos (- n 1)) (set! current-pos (+ current-pos 1))]
                                                           [else (set! current-pos 0)])
                                                     (assoc v xs))]
                                [else #f]))])
    f))
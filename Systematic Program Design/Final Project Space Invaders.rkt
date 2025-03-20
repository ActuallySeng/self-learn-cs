;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |Final Project Space Invaders|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; Space Invaders


;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

(define HIT-RANGE 10)

(define INVADE-RATE 5)
(define INVADER-RX WIDTH)
(define INVADER-RY 200)

(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer

(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define TANK-HEIGHT/2 (/ (image-height TANK) 2))

(define MISSILE (ellipse 5 15 "solid" "red"))



;; Data Definitions:

(define-struct game (invaders missiles tank))
;; Game is (make-game  (listof Invader) (listof Missile) Tank)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position

;; Game constants defined below Missile data definition

#;
(define (fn-for-game s)
  (... (fn-for-loinvader (game-invaders s))
       (fn-for-lom (game-missiles s))
       (fn-for-tank (game-tank s))))



(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT/2 in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1

(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left

#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dir t)))



(define-struct invader (x y dx))
;; Invader is (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         the invader along x by dx pixels per clock tick

(define I1 (make-invader 150 100 12))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -10))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) 10)) ;> landed, moving right


#;
(define (fn-for-invader invader)
  (... (invader-x invader) (invader-y invader) (invader-dx invader)))


(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates

(define M1 (make-missile 150 300))                       ;not hit I1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit I1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit I1

#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))



(define G0 (make-game empty empty T0))
(define G1 (make-game empty empty T1))
(define G2 (make-game (list I1) (list M1) T1))
(define G3 (make-game (list I1 I2) (list M1 M2) T1))

;; =================
;; Functions:

;; Game -> Game
;; start the world with (main G2)
;; 
(define (main g)
  (big-bang g                   ; Game
    (on-tick   tock)     ; Game -> Game
    (to-draw   render)   ; Game -> Image
    (stop-when ghitground?)      ; Game -> Boolean
    (on-key    handle-key)))    ; Game KeyEvent -> Game

;; Game -> Game
;; produce the next invaders, missiles and tank status.
;; - if missile gets within invader range, invader AND missile gets deleted. 

; (check-expect (tock (make-game (list (make-invader 5 10 10) (make-invader 10 50 10)) (list (make-missile 10 60)) (make-tank 50 -1))) (make-game (appear (handle-loi (cons (make-invader 5 10 10) empty))) (handle-lom empty) (handle-tank (make-tank 50 -1))))

; (check-expect (tock (make-game (list I1) (list M1) T1)) (make-game (appear (handle-loi (list I1))) (handle-lom (list M1)) (handle-tank T1)))

; (define (tock g) g)

(define (tock g)
  (if (empty? (hitinvader (game-invaders g) (game-missiles g)))
      (make-game (appear (handle-loi (game-invaders g))) (handle-lom (game-missiles g)) (handle-tank (game-tank g)))
      (make-game (appear (handle-loi (hitinvader (game-invaders g) (game-missiles g)))) (handle-lom (hitmissile (game-invaders g) (game-missiles g))) (handle-tank (game-tank g)))))


;; ListOfInvaders ListOfMissiles -> ListOfInvaders
;; Returns empty list if any of the missiles hit any of the invaders. Else, Returns list of all invaders that havent got hit.
(check-expect (hitinvader empty empty) empty)
(check-expect (hitinvader (cons (make-invader 10 5 10) empty) empty) empty)
(check-expect (hitinvader empty (cons (make-missile 10 5) empty)) empty)

(check-expect (hitinvader (cons (make-invader 5 10 10) (cons (make-invader 10 50 10) empty)) (cons (make-missile 10 60) empty)) (cons (make-invader 5 10 10) empty))
(check-expect (hitinvader (cons (make-invader 5 10 -10) (cons (make-invader 10 50 10) empty)) (cons (make-missile 10 80) empty)) (cons (make-invader 5 10 -10) (cons (make-invader 10 50 10) empty)))

(check-expect (hitinvader (cons (make-invader 5 10 10) (cons (make-invader 8 50 10) (cons (make-invader 10 65 10) empty))) (cons (make-missile 10 65) (cons (make-missile 8 55) empty))) (cons (make-invader 5 10 10) empty))

; (define (hitinvader loi lom) empty)

(define (hitinvader loi lom)
  (cond [(or (empty? loi) (empty? lom)) empty]
        [else (if (hitmissiles? (first loi) lom)
                  (hitinvader (rest loi) lom)
                  (cons (first loi) (hitinvader (rest loi) lom)))]))


;; Invader ListOfMissile -> Boolean
;; True if invader is hit by 1 of the missiles.
(check-expect (hitmissiles? (make-invader 10 50 10) (list (make-missile 10 30) (make-missile 10 60))) true)
(check-expect (hitmissiles? (make-invader 10 90 10) (list (make-missile 10 30) (make-missile 10 60))) false)


; (define (hitmissiles? i lom) true)

(define (hitmissiles? i lom)
  (cond [(empty? lom) false]
        [else (if (hitsingle? i (first lom))
                  true
                  (hitmissiles? i (rest lom)))]))


;; Invader Missile -> Boolean
;; True if misile hit invader.
(check-expect (hitsingle? (make-invader 10 50 10) (make-missile 10 60)) true)
(check-expect (hitsingle? (make-invader 10 30 10) (make-missile 10 60)) false)

; (define (hitsingle? i m) true)

(define (hitsingle? i m)
  (if (and (<= (abs (- (invader-x i) (missile-x m))) HIT-RANGE) (<= (abs (- (invader-y i) (missile-y m))) HIT-RANGE))
      true
      false))


; (define (filteri loih loi) loi)
#;
(define (filteri loih loi)
  (cond [(empty?) empty]
        [else (if inin?((first loi) loih)
                  (filteri (rest loi) loih)
                  (cons (first loi) (filteri (rest loi) loih)))]))


;; ListOfInvader(hit) ListOfMissile -> ListOfMissile
;; Filters out hit missiles to get leftover missiles.
(check-expect (hitmissile empty empty) empty)
(check-expect (hitmissile (list (make-invader 10 10 5)) (list (make-missile 10 15))) empty)
(check-expect (hitmissile (list (make-invader 20 10 5) (make-invader 20 30 5) (make-invader 30 40 20)) (list (make-missile 20 15) (make-missile 20 30) (make-missile 30 40) (make-missile 60 60))) (list (make-missile 60 60)))
(check-expect (hitmissile (list (make-invader 10 10 5) (make-invader 8 25 4)) (list (make-missile 10 15) (make-missile 15 50) (make-missile 8 30))) (list (make-missile 15 50)))

(check-expect (hitmissile (list (make-invader 5 10 10) (make-invader 10 50 10)) (list (make-missile 10 60))) empty)

; (define (hitmissile loih lom) lom)

(define (hitmissile loih lom)
  (cond [(or (empty? loih) (empty? lom)) empty]
        [else (if (misin? (first lom) loih)
                  (hitmissile loih (rest lom))
                  (cons (first lom) (hitmissile loih (rest lom))))]))


;; Missile ListOfInvader
;; Returns true if missile in listofinvader.

(check-expect (misin? (make-missile 10 50) empty) false)

(check-expect (misin? (make-missile 10 50) (list (make-invader 10 75 10) (make-invader 10 55 10))) true)
(check-expect (misin? (make-missile 10 20) (list (make-invader 10 75 10) (make-invader 10 55 10))) false)

; (define (misin? m loi) false)
(define (misin? m loi)
  (cond [(empty? loi) false]
        (else (if (within? m (first loi))
            true
            (misin? m (rest loi))))))


;; Missile Invader -> Boolean
;; if missile within range of invader and same x return true. HIT-RANGE

(check-expect (within? (make-missile 10 50) (make-invader 10 45 5)) true)
(check-expect (within? (make-missile 10 50) (make-invader 87 45 5)) false)
(check-expect (within? (make-missile 10 50) (make-invader 8 35 5)) false)

; (define (within? m i) false)

(define (within? m i)
  (and (<= (abs (- (invader-x i) (missile-x m))) HIT-RANGE) (<= (abs (- (invader-y i) (missile-y m))) HIT-RANGE)))
  ;(and (= (missile-x m) (invader-x i)) (<= (abs (- (missile-y m) (invader-y i))) HIT-RANGE)))

;; ListOfInvader -> ListOfInvader
;; Produces invaders' next status.
;; - Invader spawns random ly every second (randomness, no check-expect)
;; - Invader's x/y changes by INVADER-X-SPEED/INVADER-X-SPEED each tick.
;; - Invader hit a wall = bounce to the other side, dx changes to negative, vice versa.
(check-expect (handle-loi empty) empty)

(check-expect (handle-loi (cons (make-invader 50 100 INVADER-X-SPEED) empty)) (cons (make-invader (+ 50 INVADER-X-SPEED) (+ 100 INVADER-Y-SPEED) INVADER-X-SPEED) empty)) ;going right
(check-expect (handle-loi (cons (make-invader 30 70 (- INVADER-X-SPEED)) empty)) (cons (make-invader (+ 30 (- INVADER-X-SPEED)) (+ 70 INVADER-Y-SPEED) (- INVADER-X-SPEED)) empty)) ;going left

(check-expect (handle-loi (cons (make-invader WIDTH 100 INVADER-X-SPEED) empty)) (cons (make-invader (+ WIDTH (- INVADER-X-SPEED)) 100 (- INVADER-X-SPEED)) empty)) ;hit right max
(check-expect (handle-loi (cons (make-invader 0 70 (- INVADER-X-SPEED)) empty)) (cons (make-invader (+ 0 INVADER-X-SPEED) 70 INVADER-X-SPEED) empty)) ;HIT left max

; (define (handle-loi loi) loi)

(define (handle-loi loi)
  (cond [(empty? loi) empty]
        [else (cons (downwards (first loi))
                    (handle-loi (rest loi)))]))


;; ListOfInvader -> ListOfInvader
;; Adds new invader to list every tick.

; (define (appear loi) loi)

(define (appear loi)
  (if (< (length loi) INVADE-RATE)
  (cons (make-invader (random WIDTH) (random (round (/ HEIGHT 4))) INVADER-X-SPEED) loi)
  loi))

;; Invader -> Invader
;; Moves invader downwards by INVADER-X-SPEED, INVADER-Y-SPEED
;; - If hit edge, moves other side by changing dx to negative, vice versa.
(check-expect (downwards (make-invader 50 100 INVADER-X-SPEED)) (make-invader (+ 50 INVADER-X-SPEED) (+ 100 INVADER-Y-SPEED) INVADER-X-SPEED)) ; Moveright
(check-expect (downwards (make-invader 30 70 (- INVADER-X-SPEED))) (make-invader (+ 30 (- INVADER-X-SPEED)) (+ 70 INVADER-Y-SPEED) (- INVADER-X-SPEED))) ;Move left

(check-expect (downwards (make-invader WIDTH 100 INVADER-X-SPEED)) (make-invader (+ WIDTH (- INVADER-X-SPEED)) 100 (- INVADER-X-SPEED)))
(check-expect (downwards (make-invader 0 70 (- INVADER-X-SPEED))) (make-invader (+ 0 INVADER-X-SPEED) 70 INVADER-X-SPEED))

; (define (downwards i) i)

(define (downwards i)
  (cond [(or (>= 0 (invader-x i)) (<= WIDTH (invader-x i))) (make-invader (+ (invader-x i) (- (invader-dx i))) (invader-y i) (- (invader-dx i)))]
        [else (make-invader (+ (invader-x i) (invader-dx i)) (+ (invader-y i) INVADER-Y-SPEED) (invader-dx i))]))

;; ListOfMissile -> ListOfMissile
;; Produces missiles' next status.
;; - Missiles move upwards by MISSILE-SPEED
;; - Filters missiles that escapes area.

(check-expect (handle-lom empty) empty)
(check-expect (handle-lom (cons (make-missile 5 30) (cons (make-missile 10 45) empty))) (cons (make-missile 5 (- 30 MISSILE-SPEED)) (cons (make-missile 10 (- 45 MISSILE-SPEED)) empty)))
(check-expect (handle-lom (cons (make-missile 5 5) (cons (make-missile 10 45) empty))) (cons (make-missile 10 (- 45 MISSILE-SPEED)) empty))

; (define (handle-lom lom) lom)

(define (handle-lom lom)
  (cond [(empty? lom) empty]
        [else (if (escape? (upwards (first lom)))
                  (handle-lom (rest lom))
                  (cons (upwards (first lom)) (handle-lom (rest lom))))]))


;; Missile -> Missile
;; Move missile upwards by MISSILE-SPEED

(check-expect (upwards (make-missile 10 15)) (make-missile 10 (- 15 MISSILE-SPEED)))

; (define (upwards m) m)

(define (upwards m)
  (make-missile (missile-x m) (- (missile-y m) MISSILE-SPEED)))


;; Missile -> Boolean
;; True if missile escape area
(check-expect (escape? (make-missile 5 (- 0 10))) true)
(check-expect (escape? (make-missile 5 10)) false)

; (define (escape? m) false)

(define (escape? m)
  (< (missile-y m) 0))


;; Tank -> Tank
;; Produces tank's next status.
;; Tank moves in direction of dir at TANK-SPEED, sticks to wall if hit wall
(check-expect (handle-tank (make-tank 50 1)) (make-tank (+ 50 TANK-SPEED) 1)) ; Going right
(check-expect (handle-tank (make-tank 40 -1)) (make-tank (- 40 TANK-SPEED) -1)) ; Going left

(check-expect (handle-tank (make-tank WIDTH 1)) (make-tank WIDTH 1)) ; Stick to right
(check-expect (handle-tank (make-tank 0 -1)) (make-tank 0 -1)) ; Stick to left

; (define (handle-tank t) t)

(define (handle-tank t)
  (cond [(and (= (tank-dir t) -1) ( = (tank-x t) 0)) t]
        [(and (= (tank-dir t) 1) (= (tank-x t) WIDTH)) t]
        [(= (tank-dir t) 1) (make-tank (+ TANK-SPEED (tank-x t)) (tank-dir t))]
        [ else (make-tank (- (tank-x t) TANK-SPEED) (tank-dir t))]))


;; Game -> Image
;; renders game's elements together into images.

(check-expect (render (make-game (list (make-invader 5 10 5)) (list (make-missile 50 100)) (make-tank 10 10)))
              (place-image INVADER 5 10 (place-image MISSILE 50 100 (place-image TANK 10 (- HEIGHT TANK-HEIGHT/2) BACKGROUND))))

; (define (render g) BACKGROUND)

(define (render g)
  (place-loi-lom-tank (game-invaders g)
       (place-lom-tank (game-missiles g)
       (place-image TANK (tank-x (game-tank g)) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))))


;; ListOfMissile Image -> Image
;; Places missiles images onto tank's image
(check-expect (place-lom-tank empty (place-image TANK 10 (- HEIGHT TANK-HEIGHT/2) BACKGROUND)) (place-image TANK 10 (- HEIGHT TANK-HEIGHT/2) BACKGROUND))

(check-expect (place-lom-tank (list (make-missile 50 100)) (place-image TANK 10 (- HEIGHT TANK-HEIGHT/2) BACKGROUND))
              (place-image MISSILE 50 100 (place-image TANK 10 (- HEIGHT TANK-HEIGHT/2) BACKGROUND)))

; (define (place-lom-tank lom i) BACKGROUND)

(define (place-lom-tank lom i)
  (cond [(empty? lom) i]
        [else (place-m (first lom) 
              (place-lom-tank (rest lom) i))]))

;; Missile Image -> Image
;; Places single missile onto image.
(check-expect (place-m (make-missile 50 100) (place-image TANK 10 (- HEIGHT TANK-HEIGHT/2) BACKGROUND)) (place-image MISSILE 50 100 (place-image TANK 10 (- HEIGHT TANK-HEIGHT/2) BACKGROUND)))

; (define (place-m m i) i)

(define (place-m m i)
  (place-image MISSILE (missile-x m) (missile-y m) i))


;; ListOfInvader Image -> Image
;; Places invaders onto missiles + tank image.
(check-expect (place-loi-lom-tank (list (make-invader 10 50 10)) (place-lom-tank (list (make-missile 30 40)) (place-image TANK 10 (- HEIGHT TANK-HEIGHT/2) BACKGROUND)))
              (place-image INVADER 10 50 (place-image MISSILE 30 40 (place-image TANK 10 (- HEIGHT TANK-HEIGHT/2) BACKGROUND))))

; (define (place-loi-lom-tank loi i) BACKGROUND)

(define (place-loi-lom-tank loi i)
  (cond [(empty? loi) i]
        [else (place-i (first loi) 
              (place-loi-lom-tank (rest loi) i))]))


;; Invader Image -> Image
;; Places single invader onto image.
(check-expect (place-i (make-invader 10 50 10) (place-m (make-missile 50 100) (place-image TANK 10 (- HEIGHT TANK-HEIGHT/2) BACKGROUND))) (place-image INVADER 10 50 (place-m (make-missile 50 100) (place-image TANK 10 (- HEIGHT TANK-HEIGHT/2) BACKGROUND))))

; (define (place-i in i) i)

(define (place-i in i)
  (place-image INVADER (invader-x in) (invader-y in) i))


;; Game KeyEvent -> Game
;; Responses towards keyevent cases:
;; - "right" : tank's direction = 1
;; - "left" : tank's direction = -1
;; - " " : missile created

(check-expect (handle-key (make-game empty empty (make-tank 50 1)) "up") (make-game empty empty (make-tank 50 1)))
(check-expect (handle-key (make-game empty empty (make-tank 50 1)) "right") (make-game empty empty (make-tank 50 1)))
(check-expect (handle-key (make-game empty empty (make-tank 50 1)) "left") (make-game empty empty (make-tank 50 -1)))
(check-expect (handle-key (make-game empty empty (make-tank 50 1)) " ") (make-game empty (cons (make-missile 50 (- HEIGHT TANK-HEIGHT/2)) empty) (make-tank 50 1)))

; (define (handle-key g ke) g)

(define (handle-key g ke)
  (cond [(key=? ke "right") (make-game (game-invaders g) (game-missiles g) (make-tank (tank-x (game-tank g)) 1))]
        [(key=? ke "left") (make-game (game-invaders g) (game-missiles g) (make-tank (tank-x (game-tank g)) -1))]
        [(key=? ke " ") (make-game (game-invaders g) (cons (make-missile (tank-x (game-tank g)) (- HEIGHT TANK-HEIGHT/2))(game-missiles g)) (game-tank g))]
        [else g]))

;; Game -> Boolean
;; Checks if invaders has hit ground through game compound data.
(check-expect (ghitground? (make-game empty empty (make-tank 10 10))) false)

(check-expect (ghitground? (make-game (cons (make-invader 10 5 5) (cons (make-invader 5 (+ 10 HEIGHT) 4) empty)) empty (make-tank 10 10))) true)
(check-expect (ghitground? (make-game (cons (make-invader 10 5 5) (cons (make-invader 5 10 5) empty)) empty (make-tank 10 10))) false)

;(define (ghitground? g) false)

(define (ghitground? g)
  (hitground? (game-invaders g)))


;; ListOfInvader -> Boolean
;; If any invader hits ground (HEIGHT), produce true.
(check-expect (hitground? empty) false)
(check-expect (hitground? (cons (make-invader 10 5 5) (cons (make-invader 5 (+ 10 HEIGHT) 4) empty))) true)
(check-expect (hitground? (cons (make-invader 10 5 5) (cons (make-invader 5 10 5) empty))) false)

; (define (hitground? loi) false)

(define (hitground? loi)
  (cond [(empty? loi) false]
        [else (if (hit? (first loi))
                  true
                  (hitground? (rest loi)))]))


;; Invader -> Boolean
;; If said invader hits ground, produce true.
(check-expect (hit? (make-invader 5 (+ 10 HEIGHT) 4)) true)
(check-expect (hit? (make-invader 5 10 4)) false)

; (define (hit? i) false)

(define (hit? i)
  (> (invader-y i) HEIGHT))
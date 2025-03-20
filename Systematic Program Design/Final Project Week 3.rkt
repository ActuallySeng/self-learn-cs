;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |Final Project Week 3|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #t)))
(require 2htdp/image)
(require 2htdp/universe)

;; Textbox

;; =================
;; Constants:

(define WIDTH 400)
(define HEIGHT 50)
(define TYPELINE (rectangle 5 30 "solid" "blue"))
(define TEXTSIZE 30)
(define TEXTCOLOR "black")
(define MTS (empty-scene WIDTH HEIGHT))
(define CTR-Y (/ HEIGHT 2))

;; =================
;; Data definitions:

(define-struct textbox (t lp capital?))
;; Textbox is (make-textbox String Integer Boolean)
;; interp. String is text, Integer is typeline position, Capital? = true if capital is enabled.
(define TB1 (make-textbox "ABCCBA" 4 false))

#;
(define (fn-tb tb)
  (... (textbox-t tb)
       (textbox-lp tb)
       (textbox-capital? tb)))

;; Template rules used:
;; - compound: 3 fields

;; =================
;; Functions:

;; Textbox -> Textbox
;; start the world with (main (make-textbox "" 0 false))

(define (main tb)
  (big-bang tb                   ; Textbox
    (to-draw   render)           ; Textbox -> Image
    (on-key    handle-key)))     ; Textbox KeyEvent -> Textbox


;; Textbox -> Image
;; render current textbox image depending on text + lineposition.
(check-expect (render (make-textbox "Ali" 2 false))
              (place-image/align (beside
                                  (text (substring "Ali" 0 2) TEXTSIZE TEXTCOLOR)
                                  TYPELINE
                                  (text (substring "Ali" 2 3) TEXTSIZE TEXTCOLOR)) 25 CTR-Y "left" "middle" MTS))

; (define (render tb) MTS)
; template used from Textbox

(define (render tb)
  (place-image/align (beside
                      (text (substring (textbox-t tb) 0 (textbox-lp tb)) TEXTSIZE TEXTCOLOR)
                      TYPELINE
                      (text (substring (textbox-t tb) (textbox-lp tb)) TEXTSIZE TEXTCOLOR))
                     25 CTR-Y "left" "middle" MTS))


;; Textbox KeyEvent -> Textbox
;; Changes text editor state based on key event.
;; If ke = "\b" = Del 1
;; If ke = length 1 = Add directly (depends on capital)
;; If ke = "capital" = capital? true
;; If ke = arrows = change line pos (max dont move)

(check-expect (handle-key (make-textbox "Hello" 2 false) "o") (make-textbox "Heollo" 3 false)) ;Add char, linepos changes
(check-expect (handle-key (make-textbox "Abc" 3 true) "a") (make-textbox "AbcA" 4 true)) ;Capital enabled add char, linepos changes

(check-expect (handle-key (make-textbox "Hello" 5 false) "\b") (make-textbox "Hell" 4 false)) ;Del char, linepos changes
(check-expect (handle-key (make-textbox "Hello" 3 false) "\b") (make-textbox "Helo" 2 false)) ;Del char midway, linepos changes
(check-expect (handle-key (make-textbox "" 0 false) "\b") (make-textbox "" 0 false)) ;Del char when line empty

(check-expect (handle-key (make-textbox "Joe" 3 false) "left") (make-textbox "Joe" 2 false)) ;Move to left
(check-expect (handle-key (make-textbox "Joe" 0 false) "right") (make-textbox "Joe" 1 false)) ;Move to right

(check-expect (handle-key (make-textbox "Joe" 3 false) "right") (make-textbox "Joe" 3 false)) ;Move to right max
(check-expect (handle-key (make-textbox "Joe" 0 false) "left") (make-textbox "Joe" 0 false)) ;Move to left max

(check-expect (handle-key (make-textbox "Za" 0 false) "capital") (make-textbox "Za" 0 true)) ;Enable capital
(check-expect (handle-key (make-textbox "ze" 0 true) "capital") (make-textbox "ze" 0 false)) ;Disable capital

; (define (handle-key tb ke) tb)
; template used from Textbox

(define (handle-key tb ke)
  (cond [(string=? ke "\b")
         (if (and (> (string-length (textbox-t tb)) 0) (> (textbox-lp tb) 0))
             (make-textbox (string-append (substring (textbox-t tb) 0 (- (textbox-lp tb) 1)) (substring (textbox-t tb) (textbox-lp tb) (string-length (textbox-t tb)) )) (- (textbox-lp tb) 1) (textbox-capital? tb))
             (make-textbox (textbox-t tb) (textbox-lp tb) (textbox-capital? tb)))]
        [(= (string-length ke) 1) (make-textbox (newtext tb (capitalize tb ke)) (+ (textbox-lp tb) 1) (textbox-capital? tb))]
        [(and (string=? ke "capital") (false? (textbox-capital? tb))) (make-textbox (textbox-t tb) (textbox-lp tb) true)]
        [(and (string=? ke "capital") (textbox-capital? tb)) (make-textbox (textbox-t tb) (textbox-lp tb) false)]
        [(and (string=? ke "left") (> (textbox-lp tb) 0)) (make-textbox (textbox-t tb) (- (textbox-lp tb) 1) (textbox-capital? tb))]
        [(and (string=? ke "right") (< (textbox-lp tb) (string-length (textbox-t tb)))) (make-textbox (textbox-t tb) (+ (textbox-lp tb) 1) (textbox-capital? tb))]
        [else (make-textbox (textbox-t tb) (textbox-lp tb) (textbox-capital? tb))]))


;; Textbox String -> String
;; Outputs a capitalized string depends on capital? status in tb
(check-expect (capitalize (make-textbox "Abc" 3 false) "a") "a") ;No capitalize
(check-expect (capitalize (make-textbox "Abcd" 3 true) "c") "C") ;Capitalize

; (define (capitalize tb t) "")
; Template used from Textbox

(define (capitalize tb t)
  (if (textbox-capital? tb)
      (string-upcase t)
      t))


;; Textbox String -> String
;; Inserts new char into linepos position of textbox og string.
(check-expect (newtext (make-textbox "John" 2 false) "a") "Joahn")

; (define (newtext tb t) "")
; template used from Textbox

(define (newtext tb t)
  (string-append (substring (textbox-t tb) 0 (textbox-lp tb)) t (substring (textbox-t tb) (textbox-lp tb) (string-length (textbox-t tb)))))


;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname ta-solver-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; ta-solver-starter.rkt



;  PROBLEM 1:
;
;  Consider a social network similar to Twitter called Chirper. Each user has a name, a note about
;  whether or not they are a verified user, and follows some number of people.
;
;  Design a data definition for Chirper, including a template that is tail recursive and avoids
;  cycles.
;
;  Then design a function called most-followers which determines which user in a Chirper Network is
;  followed by the most people.
;

(define-struct chirper (username verified follows))
;; Chirper is (make-chirper String Boolean (listof Chirper)
;; interp. username = Username, verified = if user is verified (true), follows = chirper accs the user is following.

(define CH1 (shared ((-0- (make-chirper "Alex" false (list -5- -6- -1-)))
                     (-1- (make-chirper "Lee" false (list -5- -2-)))
                     (-2- (make-chirper "Son" false (list -5- -6- -3-)))
                     (-3- (make-chirper "Rou" false (list -6- -4-)))
                     (-4- (make-chirper "Lily" false (list -6- -5-)))
                     (-5- (make-chirper "Logan Paul" false (list -6-)))
                     (-6- (make-chirper "MrBeast" false (list -5- -4-))))
              -0-))

(define CH2 (shared ((-0- (make-chirper "Danny" false (list -1-)))
                     (-1- (make-chirper "Daddy" false (list -0-))))
              -0-))

(define CH3 (make-chirper "Joe" false empty))

; template: structural recursion, encapsulated in local, tail recursive, worklist acc, context-preserving acc

(define (fn-for-chirper ch)
  (local [;; todo: (listof Chirper); Worklist acc
          ;; visited: (listof Chirper); Context-preserving, chirper that have been visited.
          
          (define (fn-for-chirper ch todo visited)
            (cond [(member (chirper-username ch) visited) (fn-for-loc todo visited)]
                  [else (fn-for-loc (... todo (chirper-follows)) (... visited))])) ; ... (chirper-verified) (chirper-username)

          (define (fn-for-loc todo visited)
            (cond [(empty? todo) (...)]
                  [else (fn-for-chirper (first todo) (... todo) (... visited))]))]
          
    (fn-for-chirper ch ... ...)))


;; Chirper -> Chirper or false
;; determines which user in a Chirper Network is followed by the most people. False if nobody is most followed. If tie, anybody of the tie.
(check-expect (most-followers CH3) empty)

(check-expect (most-followers CH2) (shared ((-0- (make-chirper "Daddy" false (list -1-)))
                                            (-1- (make-chirper "Danny" false (list -0-))))
                                     -1-)) ; Depends on algorithm, either 1.

(check-expect (most-followers CH1) (shared ((-0- (make-chirper "Alex" false (list -5- -6- -1-)))
                                            (-1- (make-chirper "Lee" false (list -5- -2-)))
                                            (-2- (make-chirper "Son" false (list -5- -6- -3-)))
                                            (-3- (make-chirper "Rou" false (list -6- -4-)))
                                            (-4- (make-chirper "Lily" false (list -6- -5-)))
                                            (-5- (make-chirper "Logan Paul" false (list -6-)))
                                            (-6- (make-chirper "MrBeast" false (list -5- -4-))))
                                     -6-))

; (define (most-followers ch) ch)

(define (most-followers ch)
  (local [(define-struct celeb (chirper followcount))
          
          ;; celebs: (listof Chirper); Context-preserving, list of all chirper's followings
          ;; todo: (listof Chirper); Worklist acc
          ;; visited: (listof Chirper); Context-preserving, chirper that have been visited.
          
          (define (fn-for-chirper ch todo visited celebs)
            (cond [(member (chirper-username ch) visited) (fn-for-loc todo visited celebs)]
                  [else (fn-for-loc (append todo (chirper-follows ch)) (cons (chirper-username ch) visited) (append (chirper-follows ch) celebs))])) ; ... (chirper-verified) (chirper-username)

          (define (fn-for-loc todo visited celebs)
            (cond [(empty? todo) (if (empty? celebs)
                                     empty
                                     (most-famous (sort-loc (find-followcount celebs)) (find-followcount celebs)))]
                  [else (fn-for-chirper (first todo) (rest todo) visited celebs)]))

          (define (find-followcount loc) ;; (listof Chirper) -> (listof Celeb) ; Filters out each celebs, see the length/how many ppl follow, sort, then give the highest.
            (cond [(empty? loc) empty]
                  [else (local
                          [(define (isceleb? x) ;; True if x = (first loc)
                             (string=? (chirper-username x) (chirper-username (first loc))))]
                          
                          (append (list (make-celeb (first loc) (length(filter isceleb? loc))))
                                  (find-followcount (rest loc))))]))

          (define (sort-loc loc) ;; (listof Celeb) -> Natural, Get the highest follows
            (first (sort (map celeb-followcount loc) >)))

          (define (most-famous hfc loc) ;; Natural (listof Celeb) -> Chirper
            (local [(define (fn c)
                      (= (celeb-followcount c) hfc))]
              (celeb-chirper (first (filter fn loc)))))]
    
    (fn-for-chirper ch empty empty empty)))


;  PROBLEM 2:
;
;  In UBC's version of How to Code, there are often more than 800 students taking
;  the course in any given semester, meaning there are often over 40 Teaching Assistants.
;
;  Designing a schedule for them by hand is hard work - luckily we've learned enough now to write
;  a program to do it for us!
;
;  Below are some data definitions for a simplified version of a TA schedule. There are some
;  number of slots that must be filled, each represented by a natural number. Each TA is
;  available for some of these slots, and has a maximum number of shifts they can work.
;
;  Design a search program that consumes a list of TAs and a list of Slots, and produces one
;  valid schedule where each Slot is assigned to a TA, and no TA is working more than their
;  maximum shifts. If no such schedules exist, produce false.
;
;  You should supplement the given check-expects and remember to follow the recipe!



;; Slot is Natural
;; interp. each TA slot has a number, is the same length, and none overlap

(define-struct ta (name max avail))
;; TA is (make-ta String Natural (listof Slot))
;; interp. the TA's name, number of slots they can work, and slots they're available for

(define SOBA (make-ta "Soba" 2 (list 1 3)))
(define UDON (make-ta "Udon" 1 (list 3 4)))
(define RAMEN (make-ta "Ramen" 1 (list 2)))

(define NOODLE-TAs (list SOBA UDON RAMEN))

#;
(define (list
               (make-assignment (make-ta "Udon" 1 (list 3 4)) 4)
               (make-assignment (make-ta "Soba" 2 (list 1 3)) 3)
               (make-assignment (make-ta "Ramen" 1 (list 2)) 2)
               (make-assignment (make-ta "Soba" 2 (list 1 3)) 1)))

(define-struct assignment (ta slot))
;; Assignment is (make-assignment TA Slot)
;; interp. the TA is assigned to work the slot

;; Schedule is (listof Assignment)


;; ============================= FUNCTIONS


;; (listof TA) (listof Slot) -> Schedule or false
;; produce valid schedule given TAs and Slots; false if impossible
;; Conditions:
;; Slots assigned cannot be more than TA's MAX
;; TA can only be assigned to avail slots
;; TA empty, assignment not empty = false
;; TA not empty, assignment empty = produce results immediately.

(check-expect (schedule-tas empty empty) empty)
(check-expect (schedule-tas empty (list 1 2)) false)
(check-expect (schedule-tas (list SOBA) empty) empty)

(check-expect (schedule-tas (list SOBA) (list 1)) (list (make-assignment SOBA 1)))
(check-expect (schedule-tas (list SOBA) (list 2)) false)
(check-expect (schedule-tas (list SOBA) (list 1 3)) (list (make-assignment SOBA 3)
                                                          (make-assignment SOBA 1)))

(check-expect (schedule-tas NOODLE-TAs (list 1 2 3 4))
              (list
               (make-assignment UDON 4)
               (make-assignment SOBA 3)
               (make-assignment RAMEN 2)
               (make-assignment SOBA 1)))

(check-expect (schedule-tas NOODLE-TAs (list 1 2 3 4 5)) false)


; (define (schedule-tas tas slots) empty) ;stub

(define (schedule-tas tas slots)
  (local [(define (assign-ta ta slots)
            (local [(define (inavail? slot)
                      (member slot (ta-avail ta)))

                    (define (assign slot)
                      (make-assignment ta slot))]
              
              (map assign (filter inavail? slots))))

          (define (handle-tas tas slots)
            (cond [(empty? slots) empty]
                  [(empty? tas) false]
                  [else (local [(define assigned (assign-ta (first tas) slots))]
                          (if (false? (handle-tas (rest tas) (rest-slots assigned slots)))
                              false
                              (append assigned (handle-tas (rest tas) (rest-slots assigned slots)))
                              ))]))]

    (handle-tas tas slots))
  )

;; (listof Assignment) (listof Slots) -> (listof Assignment)
;; Filters out finished slots from the original slots.
(check-expect (rest-slots (list (make-assignment SOBA 1)) (list 1)) empty)
(check-expect (rest-slots (list (make-assignment SOBA 1) (make-assignment RAMEN 2)) (list 1 2 3)) (list 3))

; (define (rest-slots done original) original)

(define (rest-slots done original)
  (local [(define (filterdone slot)
            (not (member slot (map assignment-slot done))))]
    (filter filterdone original)))
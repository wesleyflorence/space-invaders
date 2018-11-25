;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname assignment7-wesleyflorence) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;;;; Libraries
(require 2htdp/universe)
(require 2htdp/image)

;;;; Constants
(define WIDTH 500)
(define HEIGHT 500)
(define GAP 30)
(define INITIAL-X 50)
(define INITIAL-Y 50)
(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define SPEED 5)
(define BULLET-RADIUS 2)
(define INVADER-WIDTH 20)
(define INVADER-HEIGHT 20)
(define INVADER-GRAPHIC (rectangle INVADER-WIDTH INVADER-HEIGHT 'solid 'red))
(define INVADER-BULLET (circle BULLET-RADIUS 'solid 'red))
(define MAX-INVADER-BULLETS 10)
(define ROW 4)
(define COLUMN 9)
(define INVADER-COUNT 36)
(define SPACESHIP-WIDTH 20)
(define SPACESHIP-HEIGHT 10)
(define SPACESHIP-GRAPHIC (rectangle SPACESHIP-WIDTH SPACESHIP-HEIGHT 'solid 'black))
(define SPACESHIP-BULLET (circle BULLET-RADIUS 'solid 'black))
(define MAX-SPACESHIP-BULLETS 3)

;;;; Data Definitions
;; An Invader is a Posn
;; INTERP: represents an invader's location

;; A Bullet is a Posn
;; INTERP: represents a bullet's location

;; A SpaceshipBullet is a Posn
;; INTERP: represents a spaceship bullet's location, always black

;; A InvaderBullet is a Posn
;; INTERP: represents a invader bullet's location, always red

;; A KeyEvent is a String
;; INTERP: a key event represents a keyboard event (button pressed)

;; A ListOfBullets (LoB) is one of
;; - empty
;; - (cons Invader LoB)
;; INTERP: represents a list of bullets in the world

;;;; Deconstructor Template
;; lob-fn: LoB -> ???
#; (define (lob-fn lob)
     (cond
       [(empty? lob) ...]
       [(cons? lob) ... (first lob) ...
                    ... (lob-fn (rest lob) ...)]))

;; A ListOfInvaders (LoI) is one of
;; - empty
;; - (cons Invader LoI)
;; INTERP: represents a list of invaders in the world

;; Deconstructor Template
;; lop-fn: LoI -> ???
#;(define (loi-fn loi)
    (cond
      [(empty? loi) ...]
      [(cons? loi) ... (first loi) ...
                   ... (lop-fn (rest loi))...]))

;; A ListOfInvaderBullets (LoIB) is one of
;; - empty
;; - (cons InvaderBullet LoIB)
;; INTERP: represents a list of bullets fired by the invaders in the world

;;;; Deconstructor Template
;; lob-fn: LoIB -> ???
#; (define (loib-fn loib)
     (cond
       [(empty? loib) ...]
       [(cons? loib) ... (first loib) ...
                    ... (loib-fn (rest loib) ...)]))

;; A ListOfPosns (LoP) is one of
;; - empty
;; - (cons Posn LoP)
;; INTERP: represents a list of posns (built in position structures with an X and Y cordinate)

;; Deconstructor Template
;; lop-fn: LoP -> ???
#;(define (lop-fn lop)
    (cond
      [(empty? lop) ...]
      [(cons? lop) ... (first lop) ...
                   ... (lop-fn (rest lop))...]))

;; a Direction is one of
;;  - 'up
;;  - 'down
;;  - 'left
;;  - 'right
;;  - 'none
;; INTERP: the possible directions that a spaceship can move, left, right or not at all
;;         or the direction that bullets can move, simply up or down.



(define-struct spaceship [position direction])
;; A Spaceship is a (make-spaceship Posn Direction)
;; INTERP: the player's spaceship, with its position in the world and direction of movement

;; Deconstructor Template
;; spaceship-fn: Spaceship -> ???
#; (define (spaceship-fn spaceship)
  ... (spaceship-position spaceship) ...
  ... (spaceship-direction spaceship) ...)

;; Examples
(define HERO (make-spaceship (make-posn 250 475) 'none))

;; A ListOfSpaceshipBullets (LoSB) is one of
;; - empty
;; - (cons SpaceshipBullet LoSB)
;; INTERP: represents a list of bullets fired by the spaceship in the world

;;;; Deconstructor Template
;; lob-fn: LoSB -> ???
#; (define (losb-fn losb)
     (cond
       [(empty? losb) ...]
       [(cons? losb) ... (first losb) ...
                    ... (losb-fn (rest losb) ...)]))




(define-struct world [loi spaceship loib losb])
;; A world is a (make-world LoI Spaceship LoIB LoSB)
;; INTERP: the world is made up of images including a list of invaders, a spaceship,
;;         a list of bullets fired by the ivnaders, and a list of bullets fired by the spaceship

;; Examples
(define WORLD1 (make-world (list (make-posn 50 50) (make-posn 100 50))
                           HERO
                           (list (make-posn 300 300) (make-posn 250 250))
                           (list (make-posn 100 350))))

;; Deconstructor Template
#; (define (world-fn world)
     ... (loi-fn (world-invaders world)) ...
     ... (spaceship-fn (world-spaceship world)) ...
     ... (loib-fn (world-loib world)) ...
     ... (losb-fn (world-losb world)) ...)


;;;;; Signature
;; invader-spacing: Real Real -> Real

;;;; Purpose
;; GIVEN: two real numbers
;; RETURNS: the sum of those numbers and the width of an invader graphic

;;;; Examples
;; (invader-spacing 5 GAP) => 55
;; (invader-spacing 10 GAP) => 60

;;;;; Function Definitions
(define (invader-spacing x gap)
  (+ x INVADER-WIDTH gap))

;;;; Tests
(check-expect (invader-spacing 5 GAP) 55)

;;;; Signature
;;invader-columns: NonNegInt NonNegInt NonNegInt -> LoI

;;;; Purpose
;; GIVEN: Two NonNegInts representing x and y cordinate, and the number of columns desired
;; RETURNS: A list of invaders, to be placed on the canvas in a row, evenly spaced by
;;          the predefined gap.

;;;; Examples
;; (invader-columns 50 50 2) => (list (make-posn 50 50) (make-posn 100 50))

;;;; Function Definition
(define (invader-columns x y columns)
  (cond
    [(= columns 0) empty]
    [else (cons (make-posn x y) (invader-columns (invader-spacing x GAP) y (- columns 1)))]))

;;;; Tests
(check-expect (invader-columns 50 50 COLUMN) (list (make-posn 50 50)
                                                   (make-posn 100 50)
                                                   (make-posn 150 50)
                                                   (make-posn 200 50)
                                                   (make-posn 250 50)
                                                   (make-posn 300 50)
                                                   (make-posn 350 50)
                                                   (make-posn 400 50)
                                                   (make-posn 450 50)))

;;;;; Signature
;; invader-rows: NonNegIn NonNegInt NonNegInt -> LoI

;;;; Purpose
;; GIVEN: Two NonNegInts representing x and y coordinates and a number of rows desired
;; RETURNS: a list of invaders, whith positions in rows incremented by half of the predefined gap

;;;; Examples
;; (invader-rows INITIAL-X INITIAL-Y 2) => (list (make-posn 50 50)(make-posn 100 50)(make-posn 150 50)(make-posn 200 50)
;;                                               (make-posn 250 50)(make-posn 300 50)(make-posn 350 50)(make-posn 400 50)
;;                                               (make-posn 450 50)(make-posn 50 85)(make-posn 100 85)(make-posn 150 85)
;;                                               (make-posn 200 85)(make-posn 250 85)(make-posn 300 85)(make-posn 350 85)
;;                                               (make-posn 400 85)(make-posn 450 85))

;;;;; Function Definitions
(define (invader-rows x y rows)
  (cond
    [(= rows 0) empty]
    [else (append (invader-columns x y COLUMN)
                  (invader-rows x (invader-spacing y (* GAP .5)) (- rows 1)))]))

;;;; Tests
(check-expect (invader-rows INITIAL-X INITIAL-Y 2) (list (make-posn 50 50)
                                                                    (make-posn 100 50)
                                                                    (make-posn 150 50)
                                                                    (make-posn 200 50)
                                                                    (make-posn 250 50)
                                                                    (make-posn 300 50)
                                                                    (make-posn 350 50)
                                                                    (make-posn 400 50)
                                                                    (make-posn 450 50)
                                                                    (make-posn 50 85)
                                                                    (make-posn 100 85)
                                                                    (make-posn 150 85)
                                                                    (make-posn 200 85)
                                                                    (make-posn 250 85)
                                                                    (make-posn 300 85)
                                                                    (make-posn 350 85)
                                                                    (make-posn 400 85)
                                                                    (make-posn 450 85)))

;;;; Constants used to create the LoI
(define FLEET (invader-rows INITIAL-X INITIAL-Y ROW))
(define ONE-INVADER (cons (make-posn 50 50) empty))

;;;;; Signature
;;draw-invaders: LoI Image -> Image

;;;; Purpose
;; GIVEN: a list of invaders and an image
;; RETURNS: an image with an invader graphic rendered at each specifeid location

;;;; Examples
;; (draw-invaders ONE-INVADER BACKGROUND) => (place-image INVADER-GRAPHIC 50 50 BACKGROUND)

;;;;; Function Definition
(define (draw-invaders loi image)
  (cond
    [(empty? loi) image]
    [ else (place-image INVADER-GRAPHIC
                  (posn-x (first loi))
                  (posn-y (first loi))
                  (draw-invaders (rest loi) image))]))

;;;; Test
(check-expect (draw-invaders ONE-INVADER BACKGROUND) (place-image INVADER-GRAPHIC 50 50 BACKGROUND))


;;;;; Signature
;; draw-bullets: LoB Image Image -> Image

;;;; Purpose
;; GIVEN: a list of bullets, and two images
;; RETURNS: an image with each bullet in the list of bullets rendered at its specified position

;;;; Examples
;; (draw-bullets (list (make-posn 100 100) (make-posn 150 150)) INVADER-BULLET BACKGROUND) =>
;;               (place-image INVADER-BULLET 100 100 (place-image INVADER-BULLET 150 150 BACKGROUND))

;;;;; Function Definition
(define (draw-bullets lob graphic image)
  (cond
    [(empty? lob) image]
    [else (place-image graphic
                       (posn-x (first lob))
                       (posn-y (first lob))
                       (draw-bullets (rest lob) graphic image))]))

;;;; Test
(check-expect (draw-bullets (list (make-posn 100 100) (make-posn 150 150)) INVADER-BULLET BACKGROUND)
              (place-image INVADER-BULLET 100 100 (place-image INVADER-BULLET 150 150 BACKGROUND)))

;;;;; Signature
;; draw-invader-bullets: LoIB Image -> Image

;;;; Purpose
;; GIVEN: a list of invader bullets and an image
;; RETURNS :an image with each bullet in the list of bullets rendered
;;          at its specified position with an invader bullet

;;;; Examples
;; (draw-invader-bullets (list (make-posn 100 100) (make-posn 150 150)) BACKGROUND) =>
;;               (place-image INVADER-BULLET 100 100 (place-image INVADER-BULLET 150 150 BACKGROUND))

;;;;; Function Definition
(define (draw-invader-bullets loib image)
  (draw-bullets loib INVADER-BULLET image))

;;;; Test
(check-expect (draw-invader-bullets (list (make-posn 100 100) (make-posn 150 150)) BACKGROUND)
              (place-image INVADER-BULLET 100 100 (place-image INVADER-BULLET 150 150 BACKGROUND)))

;;;;; Signature
;; draw-invader-bullets: LoSB Image -> Image

;;;; Purpose
;; GIVEN: a list of spaceship bullets and an image
;; RETURNS :an image with each bullet in the list of bullets rendered
;;          at its specified position with an spaceship bullet

;;;; Examples
;; (draw-invader-bullets (list (make-posn 100 100) (make-posn 150 150)) BACKGROUND) =>
;;               (place-image SPACESHIP-BULLET 100 100 (place-image INVADER-BULLET 150 150 BACKGROUND))

;;;; Function Definition
(define (draw-spaceship-bullets losb image)
  (draw-bullets losb SPACESHIP-BULLET image))

;;;; Test
(check-expect (draw-spaceship-bullets (list (make-posn 100 100) (make-posn 150 150)) BACKGROUND)
              (place-image SPACESHIP-BULLET 100 100 (place-image SPACESHIP-BULLET 150 150 BACKGROUND)))


;;;;; Signature
;; draw-spaceship: Spcaeship Image -> Image

;;;; Purpose
;; GIVEN: an spaceship struct and an image
;; RETURNS: an image with the spaceship graphic rendered at its specified position

;;;; Examples
;; (draw-spaceship HERO BACKGROUND) => (place-image SPACESHIP-GRAPHIC 250 475 BACKGROUND)

;;;;; Function Definition
(define (draw-spaceship spaceship image)
  (place-image SPACESHIP-GRAPHIC
               (posn-x (spaceship-position spaceship))
               (posn-y (spaceship-position spaceship))
               image))

;;;; Test
(check-expect (draw-spaceship HERO BACKGROUND) (place-image SPACESHIP-GRAPHIC 250 475 BACKGROUND))

;;;;; Signature
;; world-draw: World -> Image

;;;; Purpose
;; GIVEN: a world
;; RETURNS: an image with the world (including the spaceship, list of invaders, list of invader bullets
;;           and the list of spaceship bullets) drawn on a background image

;;;; Examples
;; (world-draw WORLD1) => (place-image INVADER-GRAPHIC 50 50
;;                        (place-image INVADER-GRAPHIC 100 50
;;                        (place-image SPACESHIP-GRAPHIC 250 475
;;                        (place-image INVADER-BULLET 300 300
;;                        (place-image INVADER-BULLET 250 250
;;                        (place-image SPACESHIP-BULLET 100 350 BACKGROUND))))))

;;;;; Function Definition
(define (world-draw world)
  (draw-invaders (world-loi world)
                 (draw-spaceship (world-spaceship world)
                                 (draw-invader-bullets (world-loib world)
                                                       (draw-spaceship-bullets (world-losb world) BACKGROUND)))))

;;;; Tests
(check-expect (world-draw WORLD1) (place-image INVADER-GRAPHIC 50 50
                                  (place-image INVADER-GRAPHIC 100 50
                                  (place-image SPACESHIP-GRAPHIC 250 475
                                  (place-image INVADER-BULLET 300 300
                                  (place-image INVADER-BULLET 250 250
                                  (place-image SPACESHIP-BULLET 100 350 BACKGROUND)))))))

;;;;; Signature
;; leftedge?: Spaceship -> Boolean

;;;; Purpose
;; GIVEN: a spaceship
;; RETURNS: true if the spaceship reaches the left edge of the background

;;;; Examples
;; (leftedge? HERO) => #false
;; (leftedge? (make-spaceship (make-posn 0 475) 'none)) => #true

;;;;; Function Definition
(define (leftedge? spaceship)
  (<= (- (posn-x (spaceship-position spaceship)) (/ SPACESHIP-WIDTH 2)) 0))

;;;; Tests
(define HERO-OUTLEFT (make-spaceship (make-posn 0 475) 'none))

(check-expect (leftedge? HERO-OUTLEFT) #true)
(check-expect (leftedge? HERO) #false)

;;;;; Signature
;; rightedge?: Spaceship -> Boolean

;;;; Purpose
;; GIVEN: a spaceship
;; RETURNS: true if the spaceship reaches the right edge of the background

;;;; Examples
;; (rightedge? HERO) => #false
;; (rightedge? (make-spaceship (make-posn 500 475) 'none)) => #true

;;;;; Function Definition
(define (rightedge? spaceship)
  (>= (+ (posn-x (spaceship-position spaceship)) (/ SPACESHIP-WIDTH 2)) WIDTH))

;;;; Tests
(define HERO-OUTRIGHT (make-spaceship (make-posn 500 475) 'none))

(check-expect (rightedge? HERO-OUTRIGHT) #true)
(check-expect (rightedge? HERO) #false)

;;;;; Signature
;; move-spaceship-helper: Spaceship Direction -> Spaceship

;;;; Purpose
;; GIVEN: a spaceship and a direction
;; RETURNS: a new spaceship that had moved in the provided direction by a set number of units

;;;; Examples
;; (move-spaceship-helper HERO 'left) => (make-spaceship (make-posn 245 475) 'left))
;; (move-spaceship-helper HERO 'right) => (make-spaceship (make-posn 255 475) 'right))

;;;;; Function Definition
(define (move-spaceship-helper spaceship direction)
  (cond
    [(symbol=? direction 'left) (make-spaceship (make-posn
                                       (- (posn-x (spaceship-position spaceship)) SPEED)
                                       (posn-y (spaceship-position spaceship)))
                                      'none)]
    [(symbol=? direction 'right) (make-spaceship (make-posn
                                        (+ (posn-x (spaceship-position spaceship)) SPEED)
                                        (posn-y (spaceship-position spaceship)))
                                       'none)]))

;;;; Tests
(check-expect (move-spaceship-helper HERO 'left) (make-spaceship (make-posn 245 475) 'none))
(check-expect (move-spaceship-helper HERO 'right) (make-spaceship (make-posn 255 475) 'none))

;;;;; Signature
;; move-spaceship: Spaceship Direction -> Spaceship

;;;; Purpose
;; GIVEN: a spaceship and a direction
;; RETURNS: a new spaceship that had moved in the provided direction by a set number of units

;;;; Examples
;;
;;;;; Function Definition
(define (move-spaceship spaceship)
  (cond
    [(leftedge? spaceship) (move-spaceship-helper spaceship 'right)]
    [(rightedge? spaceship) (move-spaceship-helper spaceship 'left)]
    [(symbol=? (spaceship-direction spaceship) 'left) (move-spaceship-helper spaceship 'left)]
    [(symbol=? (spaceship-direction spaceship) 'right) (move-spaceship-helper spaceship 'right)]
    [(symbol=? (spaceship-direction spaceship) 'none) spaceship]))

;;;; Tests
(check-expect (move-spaceship (make-spaceship (make-posn 250 475) 'left)) (make-spaceship (make-posn 245 475) 'none))
(check-expect (move-spaceship (make-spaceship (make-posn 250 475) 'right)) (make-spaceship (make-posn 255 475) 'none))

;;;;; Signature
;; move-bullets: LoB Direction -> LoB

;;;; Purpose
;; GIVEN: a list of bullets and a direction
;; RETURNS: a list of bullets with each bullets position moved in the
;;          indicated direction by a number of units, SPEED.

;;;; Examples
;; (move-bullets (list (make-posn 100 100) (make-posn 150 100)) 'up) =>
;;               (list (make-posn 100 95) (make-posn 150 95)))
;; (move-bullets (list (make-posn 100 100) (make-posn 150 100)) 'down) =>
;;               (list (make-posn 100 105) (make-posn 150 105)))

;;;;; Function Definition
(define (move-bullets lob direction)
  (cond
    [(empty? lob) empty]
    [(symbol=? 'down direction) (cons (make-posn (posn-x (first lob))
                                      (+ (posn-y (first lob)) SPEED))
                           (move-bullets (rest lob) direction))]
    [(symbol=? 'up direction) (cons (make-posn (posn-x (first lob))
                                      (- (posn-y (first lob)) SPEED))
                           (move-bullets (rest lob) direction))]))

;;;; Tests
(check-expect (move-bullets empty 'up) empty)
(check-expect (move-bullets (list (make-posn 100 100)
                                  (make-posn 150 100)) 'up)
              (list (make-posn 100 95) (make-posn 150 95)))
(check-expect (move-bullets (list (make-posn 100 100)
                                  (make-posn 150 100)) 'down)
              (list (make-posn 100 105) (make-posn 150 105)))


;;;;; Signature
;; move-spaceship-bullets: LoSP

;;;; Purpose
;; GIVEN: a list of spaceship bullets
;; RETURNS: a list of spaceship bullets with each bullet's position
;;          moved up by a number of units, SPEED.

;;;; Examples
;; (move-spaceship-bullets (list (make-posn 100 100)(make-posn 150 100))) =>
;;                         (list (make-posn 100 95)(make-posn 150 95)))

;;;;; Function Definition
(define (move-spaceship-bullets losb)
  (move-bullets losb 'up))

;;;;Tests
(check-expect (move-spaceship-bullets (list (make-posn 100 100)(make-posn 150 100)))
              (list (make-posn 100 95)(make-posn 150 95)))

;;;;; Signature
;; move-invader-bullets: LoIP

;;;; Purpose
;; GIVEN: a list of invader bullets
;; RETURNS: a list of invader bullets with each bullet's position
;;          moved down by a number of units, SPEED.

;;;; Examples
;; (move-invader-bullets (list (make-posn 100 100)(make-posn 150 100))) =>
;;                         (list (make-posn 100 105)(make-posn 150 105)))

;;;;; Function Definition
(define (move-invader-bullets loib)
  (move-bullets loib 'down))

;;;;Tests
(check-expect (move-invader-bullets (list (make-posn 100 100)(make-posn 150 100)))
              (list (make-posn 100 105)(make-posn 150 105)))

;;;;; Signature
;; bullet-counter: LoB -> NonNegInt

;;;; Purpose
;; GIVEN: a list of bullets
;; RETURNS: the number of bullets within the list

;;;; Examples
;; (bullet-counter empty) => 0
;; (bullet-counter (list (make-posn 20 20)
;;                       (make-posn 25 20)
;;                       (make-posn 30 20))) => 3

;;;;; Function Definition
(define (bullet-counter lob)
  (cond
    [(empty? lob) 0]
    [(cons? lob) (+ 1 (bullet-counter (rest lob)))]))

;;;; Tests
(check-expect (bullet-counter empty) 0)
(check-expect (bullet-counter (list (make-posn 20 20)
                                    (make-posn 25 20)
                                    (make-posn 30 20))) 3)


;;;;; Signature
;; init-spaceship-bullet-list: World -> LoSP

;;;; Purpose
;; GIVEN: a world, with an empty list of spaceship bullets
;; RETURNS: a list of spaceship bullets, with one new bullet in it at the spaceship's location

;;;; Examples
;; (init-spaceship-bullet-list (make-world (list (make-posn 50 50) (make-posn 100 50))
;;                                         HERO
;;                                         empty
;;                                         empty))
;;                             (list (make-posn 250 475)))

;;;;; Function Definition
(define (init-spaceship-bullet-list world)
  (cons (make-posn (posn-x (spaceship-position (world-spaceship world)))
                   (posn-y (spaceship-position (world-spaceship world)))) empty))

;;;; Tests
(check-expect (init-spaceship-bullet-list
               (make-world (list (make-posn 50 50) (make-posn 100 50))
                           HERO
                           empty
                           empty))
              (list (make-posn 250 475)))

;;;;; Signature
;; add-spaceship-bullets: World -> LoSB

;;;; Purpose
;; GIVEN: a world
;; RETURNS: a list of spaceship bullets with a new bullet added at the spaceship's location

;;;; Examples
;; (add-spaceship-bullets (make-world (list (make-posn 50 50) (make-posn 100 50))
;;                                    HERO
;;                                    empty
;;                                    (list (make-posn 150 475))))
;;                     => (list (make-posn 250 475)
;;                        (make-posn 150 475)))

;;;;; Function Definition
(define (add-spaceship-bullets world)
  (append (list (make-posn
                 (posn-x (spaceship-position (world-spaceship world)))
                 (posn-y (spaceship-position (world-spaceship world)))))
          (world-losb world)))

;;;; Tests
(check-expect (add-spaceship-bullets (make-world (list (make-posn 50 50) (make-posn 100 50))
                                                 HERO
                                                 empty
                                                 (list (make-posn 150 475))))
                                     (list (make-posn 250 475)
                                           (make-posn 150 475)))

(check-expect (add-spaceship-bullets (make-world (list (make-posn 50 50) (make-posn 100 50))
                                                 HERO
                                                 empty
                                                 (list (make-posn 150 475)
                                                       (make-posn 50 50)
                                                       (make-posn 30 30))))
                                     (list (make-posn 250 475)
                                           (make-posn 150 475)
                                           (make-posn 50 50)
                                           (make-posn 30 30)))

;;;;; Signature
;; fire-bullets: World -> LoSB

;;;; Purpose
;; GIVEN: a world
;; RETURNS: a list of spaceship bullets, with a new bullet added or
;;          the same list if there are more then 3 bullets on the screen

;;;; Examples
;; (fire-bullets (make-world (list (make-posn 50 50) (make-posn 100 50)) HERO empty empty))
;;  => (list (make-posn 250 475)))

;; (fire-bullets (make-world (list (make-posn 50 50) (make-posn 100 50))
;;                           HERO
;;                           empty
;;                           (list (make-posn 150 475))))
;;                           (list (make-posn 250 475)
;;                           (make-posn 150 475)))

;; (fire-bullets (make-world (list (make-posn 50 50) (make-posn 100 50))
;;                           HERO
;;                           empty
;;                           (list (make-posn 150 475)
;;                                 (make-posn 50 50)
;;                                 (make-posn 30 30))))
;;                        => (list (make-posn 150 475)
;;                                 (make-posn 50 50)
;;                                 (make-posn 30 30)))

;;;;; Function Definition
(define (fire-bullets world)
  (cond
    [(>= (bullet-counter (world-losb world)) MAX-SPACESHIP-BULLETS) (world-losb world)]
    [(= (bullet-counter (world-losb world)) 0) (init-spaceship-bullet-list world)]
    [else (add-spaceship-bullets world)]))

;;;; Tests
(check-expect (fire-bullets (make-world (list (make-posn 50 50) (make-posn 100 50))
                                        HERO
                                        empty
                                        empty))
              (list (make-posn 250 475)))

(check-expect (fire-bullets (make-world (list (make-posn 50 50) (make-posn 100 50))
                                                 HERO
                                                 empty
                                                 (list (make-posn 150 475))))
                                     (list (make-posn 250 475)
                                           (make-posn 150 475)))


(check-expect (fire-bullets (make-world (list (make-posn 50 50) (make-posn 100 50))
                                                 HERO
                                                 empty
                                                 (list (make-posn 150 475)
                                                       (make-posn 50 50)
                                                       (make-posn 30 30))))
                                     (list(make-posn 150 475)
                                           (make-posn 50 50)
                                           (make-posn 30 30)))

;;;;; Signature
;; key-input: World KeyEvent -> World

;;;; Purpose
;; GIVEN: a world and a key event
;; RETURNS: a world with the spaceship's position moved left if the left key is pressed and
;;          right if the right key is pressed. A new bullet is appeneded to the list of
;;          spaceship bullets if the spacebar is pressed

;;;; Examples
;; (key-input (make-world FLEET HERO empty empty) "left")
;; => (make-world FLEET (make-spaceship (make-posn 245 475) 'none) empty empty)

;; (key-input (make-world FLEET HERO empty empty) "right")
;; => (make-world FLEET (make-spaceship (make-posn 255 475) 'none) empty empty)

;; (key-input (make-world FLEET HERO empty empty) " ")
;; => (make-world FLEET HERO empty (list (make-posn 250 475)))

;; (key-input (make-world FLEET HERO empty (list (make-posn 30 475))) " ")
;; => (make-world FLEET HERO empty (list (make-posn 250 475) (make-posn 30 475)))

;; (key-input (make-world FLEET HERO empty (list (make-posn 30 475) (make-posn 40 475) (make-posn 50 475))) " ")
;; => (make-world FLEET HERO empty (list (make-posn 30 475) (make-posn 40 475) (make-posn 50 475)))

;; (key-input WORLD1 "w") => WORLD1

;;;;; Function Definition
(define (key-input world key-event)
  (cond
    [(key=? key-event "left") (make-world
                               (world-loi world)
                               (move-spaceship (make-spaceship (spaceship-position (world-spaceship world)) 'left))
                               (world-loib world)
                               (world-losb world))]
    [(key=? key-event "right") (make-world
                                (world-loi world)
                                (move-spaceship (make-spaceship (spaceship-position (world-spaceship world)) 'right))
                                (world-loib world)
                                (world-losb world))]
    [(key=? key-event " ") (make-world
                            (world-loi world)
                            (world-spaceship world)
                            (world-loib world)
                            (fire-bullets world))]
    [else world]))

;;;; Tests
(check-expect (key-input (make-world FLEET
                                     HERO
                                     empty
                                     empty) "left")
              (make-world FLEET
                          (make-spaceship (make-posn 245 475) 'none)
                          empty
                          empty))
(check-expect (key-input (make-world FLEET
                                     HERO
                                     empty
                                     empty) "right")
              (make-world FLEET
                          (make-spaceship (make-posn 255 475) 'none)
                          empty
                          empty))
(check-expect (key-input (make-world FLEET
                                     HERO
                                     empty
                                     empty) " ")
              (make-world FLEET
                          HERO
                          empty
                          (list (make-posn 250 475))))
(check-expect (key-input (make-world FLEET
                                     HERO
                                     empty
                                     (list (make-posn 30 475))) " ")
              (make-world FLEET
                          HERO
                          empty
                          (list (make-posn 250 475) (make-posn 30 475))))

(check-expect (key-input (make-world FLEET
                                     HERO
                                     empty
                                     (list (make-posn 30 475)
                                           (make-posn 40 475)
                                           (make-posn 50 475))) " ")
              (make-world FLEET
                          HERO
                          empty
                          (list (make-posn 30 475)
                                (make-posn 40 475)
                                (make-posn 50 475))))

(check-expect (key-input WORLD1 "w") WORLD1)

;;;;; Signature
;; posn=?: PosN PosN -> Boolean

;;;; Purpose
;; GIVEN: two posns
;; RETURNS: true if they are the same position,
;;          with the x axis fuzzed for the width of a spaceship/invader

;;;; Examples
;; (posn=? (make-posn 50 50) (make-posn 50 50)) => #true
;; (posn=? (make-posn 50 30) (make-posn 50 50)) => #false
;;;;; Function Definition
(define (posn=? posn1 posn2)
  (and
   (and (<= (- (posn-x posn1) (posn-x posn2)) (/ INVADER-WIDTH 2))
        (>= (- (posn-x posn1) (posn-x posn2)) (- 0 (/ INVADER-WIDTH 2))))
       (= (posn-y posn1) (posn-y posn2))))

;;;; Tests
(check-expect (posn=? (make-posn 50 50) (make-posn 50 50)) #true)
(check-expect (posn=? (make-posn 50 30) (make-posn 50 50)) #false)

;;;;; Signature
;; remove-posn: PosN LoP -> LoP

;;;; Purpose
;; GIVEN: a posn and a list of posns
;; RETURNS: a list with the provided posn removed

;;;; Examples
;; (remove-posn (make-posn 50 70)(list (make-posn 150 50) (make-posn 260 50) (make-posn 50 70)))
;;           => (list (make-posn 150 50)(make-posn 260 50)))

;;;;; Function Definition
(define (remove-posn posn lop)
  (cond
    [(empty? lop) empty]
    [(posn=? posn (first lop)) (remove-posn posn (rest lop))]
    [else (cons (first lop) (remove-posn posn (rest lop)))]))

;;;; Tests
(check-expect (remove-posn (make-posn 50 70)(list (make-posn 150 50)
                                                  (make-posn 260 50)
                                                  (make-posn 50 70)))
              (list (make-posn 150 50)
                    (make-posn 260 50)))

(check-expect (remove-posn (make-posn 60 50)(list (make-posn 150 50)
                                                  (make-posn 60 50)
                                                  (make-posn 350 70)))
              (list (make-posn 150 50)
                    (make-posn 350 70)))

;;;;; Signature
;; find-impacts: LoI Bullet -> Boolean

;;;; Purpose
;; GIVEN: a list of invaders and a bullet
;; RETURNS: true if the bullet hits any invaders in the list

;;;; Examples
;; (find-impacts (list (make-posn 50 100) (make-posn 60 100) (make-posn 70 100)) (make-posn 70 100)) => #true
;; (find-impacts (list (make-posn 50 100) (make-posn 60 100) (make-posn 70 100)) (make-posn 200 100)) => #false

;;;;; Function Definition
(define (find-impacts loi bullet)
  (cond
    [(empty? loi) #false]
    [(posn=? (first loi) bullet) #true]
    [else (find-impacts (rest loi) bullet)]))

;;;; Tests
(check-expect (find-impacts (list (make-posn 50 100) (make-posn 60 100) (make-posn 70 100)) (make-posn 70 100)) #true)
(check-expect (find-impacts (list (make-posn 50 100) (make-posn 60 100) (make-posn 70 100)) (make-posn 200 100)) #false)

;;;;; Signature
;; find-hits: LoI LoB

;;;; Purpose
;; GIVEN: a list of invaders and a list of bullets
;; RETURNS: true if any bullet in the list of bullets hits an invader in teh lsit of invaders

;;;; Examples
;; (find-hits (list (make-posn 50 100)(make-posn 60 100))
;;         => (list (make-posn 200 100)(make-posn 60 100))) #true)

;; (find-hits (list (make-posn 50 100)(make-posn 60 100))
;;         => (list (make-posn 200 100)(make-posn 70 200))) #false)

;;;;; Function Definition
(define (find-hits loi lob)
  (cond
    [(empty? lob) #false]
    [(find-impacts loi (first lob)) #true]
    [else (find-hits loi (rest lob))]))

(check-expect (find-hits (list (make-posn 50 100)
                               (make-posn 60 100)
                               (make-posn 70 100))
                         (list (make-posn 200 100)
                               (make-posn 60 100))) #true)

(check-expect (find-hits (list (make-posn 50 100)
                               (make-posn 60 100)
                               (make-posn 70 100))
                         (list (make-posn 200 100)
                               (make-posn 300 400))) #false)

;;;;; Signature
;; bullet-that-killed: LoI LoB -> Bullet

;;;; Purpose
;; GIVEN: a list of invaders and a list of bullets
;; RETURNS: the bullet in a list of bullets that hits an invader in a list of invaders

;;;; Examples
;; (bullet-that-killed (list (make-posn 50 100) (make-posn 60 100) (make-posn 70 100))
;; => (list (make-posn 200 100) (make-posn 60 100))) (make-posn 60 100))

;;;;; Function Definition
(define (bullet-that-killed loi lob)
  (cond
    [(empty? lob) empty]
    [(find-impacts loi (first lob)) (first lob)]
    [else (bullet-that-killed loi (rest lob))]))

;;;; Tests
(check-expect (bullet-that-killed (list (make-posn 50 100)
                                        (make-posn 60 100)
                                        (make-posn 70 100))
                                  (list (make-posn 200 100)
                                        (make-posn 60 100))) (make-posn 60 100))
;;;;; Signature
;; kill-invader: LoI Bullet -> LoI

;;;; Purpose
;; GIVEN: a list of invaders and a bullet
;; RETURNS: a list of invaders with the invader who was
;;          hit by a bullet removed from the list

;;;; Examples
;; (check-expect (kill-invader (list (make-posn 250 100)
;;                                   (make-posn 60 100)
;;                                   (make-posn 170 100))
;;                             (list (make-posn 12 14)
;;                                   (make-posn 60 100)))
;;            => (list (make-posn 250 100)(make-posn 170 100))

;;;;; Function Definition
(define (kill-invader loi lob)
  (remove-posn (bullet-that-killed loi lob) loi))

;;;; Tests
(check-expect (kill-invader (list (make-posn 250 100)
                                  (make-posn 60 100)
                                  (make-posn 170 100))
                            (list (make-posn 12 14)
                                  (make-posn 60 100)))
              (list (make-posn 250 100)(make-posn 170 100)))

;;;;; Signature
;; remove-successful-bullet: LoI LoB -> LoB

;;;; Purpose
;; GIVEN: a list of invaders and a list of bullets
;; RETURNS: a new list of bullets, with the bullet that impacted an
;;          invader removed from the list

;;;; Examples
;; (remove-successful-bullet (list (make-posn 50 100)
;;                                 (make-posn 60 100)
;;                                 (make-posn 70 100))
;;                           (list (make-posn 12 14)
;;                                 (make-posn 60 100)))
;; => (list (make-posn 12 14)))

;;;;; Function Definition
(define (remove-successful-bullet loi lob)
  (remove-posn (bullet-that-killed loi lob) lob))

;;;; Tests
(check-expect (remove-successful-bullet (list (make-posn 50 100)
                                              (make-posn 60 100)
                                              (make-posn 70 100))
                                        (list (make-posn 12 14)
                                              (make-posn 60 100)))
              (list (make-posn 12 14)))

;;;;; Signature
;; remove-impacts: World -> World

;;;; Purpose
;; GIVEN: a world
;; RETURNS: a world with any invaders and bullets with matching positions (impacts) removed

;;;; Examples
;;  (remove-impacts (make-world (list (make-posn 150 50)
;;                                    (make-posn 60 50)
;;                                    (make-posn 170 60)
;;                                    (make-posn 280 70))
;;                               HERO
;;                               empty
;;                               (list (make-posn 10 10)
;;                                     (make-posn 60 50)
;;                                     (make-posn 40 40)
;;                                     (make-posn 20 20))))
;;         => (make-world (list (make-posn 150 50)
;;                              (make-posn 170 60)
;;                              (make-posn 280 70))
;;                        HERO
;;                        empty
;;                        (list (make-posn 10 10)
;;                              (make-posn 40 40)
;;                              (make-posn 20 20))))

;;;;; Function Definition
(define (remove-impacts world)
  (cond
    [(find-hits (world-loi world) (world-losb world)) (make-world
                                                       (kill-invader (world-loi world) (world-losb world))
                                                       (world-spaceship world)
                                                       (world-loib world)
                                                       (remove-successful-bullet (world-loi world) (world-losb world)))]
    [else world]))

;;;; Tests
(check-expect (remove-impacts (make-world (list (make-posn 150 50)
                                                (make-posn 60 50)
                                                (make-posn 170 60)
                                                (make-posn 280 70))
                                          HERO
                                          empty
                                          (list (make-posn 10 10)
                                                (make-posn 60 50)
                                                (make-posn 40 40)
                                                (make-posn 20 20))))
              (make-world (list (make-posn 150 50)
                                (make-posn 170 60)
                                (make-posn 280 70))
                          HERO
                          empty
                          (list (make-posn 10 10)
                                (make-posn 40 40)
                                (make-posn 20 20))))

(check-expect (remove-impacts WORLD1) WORLD1)

;;;;; Signature
;; outside-bounds?: Bullet -> Boolean

;;;; Purpose
;; GIVEN: a bullet
;; RETURNS: true if the bullet is outside the bounds of the background

;;;; Examples
;; (outside-bounds? (make-posn 100 502)) => #true
;; (outside-bounds? (make-posn 100 -2)) => #true
;; (outside-bounds? (make-posn 100 100)) => #false

;;;;; Function Definition
(define (outside-bounds? bullet)
  (or (<= (+ (posn-y bullet) BULLET-RADIUS) 0)
      (>= (+ (posn-y bullet) BULLET-RADIUS) HEIGHT)))

;;;; Tests
(check-expect (outside-bounds? (make-posn 100 502)) #true)
(check-expect (outside-bounds? (make-posn 100 -2)) #true)
(check-expect (outside-bounds? (make-posn 100 100)) #false)

;;;;; Signature
;; remove-out-bullets: LoB -> LoB

;;;; Purpose
;; GIVEN: a list of bullets
;; RETURNS: a list of bullets, with the bullets that are outside of the background removed

;;;; Examples
;; (remove-out-bullets (list (make-posn 50 50) (make-posn 50 502)))
;; => (list (make-posn 50 50)))

;;;;; Function Definition
(define (remove-out-bullets lob)
  (cond
    [(empty? lob) empty]
    [(outside-bounds? (first lob)) (remove-out-bullets (rest lob))]
    [else (cons (first lob) (remove-out-bullets (rest lob)))]))

;;;; Tests
(check-expect (remove-out-bullets (list (make-posn 50 50)
                                        (make-posn 50 502)))
              (list (make-posn 50 50)))

(check-expect (remove-out-bullets (list (make-posn 50 50)
                                        (make-posn 50 100)))
              (list (make-posn 50 50)
                    (make-posn 50 100)))


;;;;; Signature
;; pick-random-invader: LoI NonNegInt -> Invader

;;;; Purpose
;; GIVEN: a list of invaders and a NonNegInt
;; RETURNS: a the invader in the list whos number corresponds to the integer provided

;;;; Examples
;; (pick-random-invader (list (make-posn 10 10) (make-posn 20 10) (make-posn 30 10)) 1)
;; => (make-posn 20 10))

;;;;; Function Definition
(define (pick-random-invader loi random-number)
  (cond
    [(empty? loi) empty]
    [(empty? (rest loi)) (first loi)]
    [(= 0 random-number) (first loi)]
    [else (pick-random-invader (rest loi) (- random-number 1))]))

(check-expect (pick-random-invader (list (make-posn 10 10)
                                         (make-posn 20 10)
                                         (make-posn 30 10)) 1)
              (make-posn 20 10))

(check-expect (pick-random-invader (list (make-posn 10 10)
                                         (make-posn 20 10)
                                         (make-posn 30 10)) 6)
              (make-posn 30 10))

;;;;; Signature
;; invader-shoot: NonNegInt LoIB LoI -> LoIB

;;;; Purpose
;; GIVEN: a number representing the number of bullets on screen,
;;        a list of invaders bullets and a list of invaders
;; RETURNS: a list of invaders bullets, which are created at a
;;          random invader's location

;;;;; Function Definition
(define (invader-shoot bullets-on-screen loib loi)
  (cond
    [(>= (bullet-counter loib) MAX-INVADER-BULLETS) loib]
    [(= bullets-on-screen 1) loib]
    [else (append (list (pick-random-invader loi (random INVADER-COUNT))) loib)]))

;;;;; Signature
;; spaceship-hit?: Spaceship LoIB -> Boolean

;;;; Purpose
;; GIVEN: a spaceship and a list of invader bullets
;; RETURNS: true if the spaceship ahs been hit

;;;; Examples
;; (spaceship-hit? (make-spaceship (make-posn 50 50) 'none) (list (make-posn 50 50) (make-posn 210 40))) => #true
;; (spaceship-hit? (make-spaceship (make-posn 50 50) 'none) (list (make-posn 350 350) (make-posn 210 40))) => #false

;;;;; Function Definition
(define (spaceship-hit? spaceship loib)
  (cond
    [(empty? loib) #false]
    [(posn=? (spaceship-position spaceship) (first loib)) #true]
    [else (spaceship-hit? spaceship (rest loib))]))

;;;; Tests
(check-expect (spaceship-hit? (make-spaceship (make-posn 50 50) 'none)
                              (list (make-posn 50 50) (make-posn 210 40))) #true)
(check-expect (spaceship-hit? (make-spaceship (make-posn 50 50) 'none)
                              (list (make-posn 350 350) (make-posn 210 40))) #false)

;;;;; Signature
;; spaceship-status: World -> Boolean

;;;; Purpose
;; GIVEN: a world
;; RETURNS: true if a spaceship and any of the bullets in teh list of invader bullets
;;          have collided

;;;; Examples
;; (spaceship-status (make-world empty (make-spaceship (make-posn 50 50) 'none)
;;                              (list (make-posn 50 50) (make-posn 210 40))
;;                              empty)) => #true

;;;;; Function Definition
(define (spaceship-status world)
  (spaceship-hit? (world-spaceship world) (world-loib world)))

;;;; Tests
(check-expect (spaceship-status (make-world
                               empty
                               (make-spaceship (make-posn 50 50) 'none)
                               (list (make-posn 50 50) (make-posn 210 40))
                               empty)) #true)

(check-expect (spaceship-status (make-world
                               empty
                               (make-spaceship (make-posn 50 50) 'none)
                               (list (make-posn 200 50) (make-posn 210 40))
                               empty)) #false)

;;;;; Signature
;; world-stepper: World -> World

;;;; Purpose
;; GIVEN: a world
;; RETURNS: a word after the next clock tick, with each graphic updated

;;;;; Function Definition
(define (world-stepper world)
  (remove-impacts
   (make-world
    (world-loi world)
    (move-spaceship (world-spaceship world))
    (move-invader-bullets (invader-shoot (random INVADER-COUNT) (remove-out-bullets (world-loib world)) (world-loi world)))
    (move-spaceship-bullets (remove-out-bullets (world-losb world))))))


;;;;; Signature
;; end-game?: world -> Boolean

;;;; Purpose
;; GIVEN: a world
;; RETURNS: true if the game needs to stop. A game must stop when a spaceship is hit or
;;          when the list of invaders is empty

;;;;; Function Definition
(define (end-game? world)
  (cond
    [(spaceship-status world) #true]
    [(empty? (world-loi world)) #true]
    [else #false]))

;;;; Constant - creating a world for big bang
(define WORLD-CREATE (make-world FLEET HERO empty empty))

;;;; big bang
(big-bang WORLD-CREATE
  (on-tick world-stepper .05)
  (on-draw world-draw)
  (on-key key-input)
  (stop-when end-game?))

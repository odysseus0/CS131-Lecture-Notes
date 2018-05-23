# Scheme

Scheme is a variant of Lisp language. It has a very simple syntax and it is very easy to represent its programs as data.

## Properties

* Objects are allocated dynamically & never freed.
* Types are latent not manifest
  * Latent: Types belong to objects. Dynamic type checking
  * Manifest: Belong to expressions. Static type checking.
* Static scoping
* call by value
* Objects, procedures, numbers, and continuations are predefined
* Tail Recursion optimization is required

## Dynamic scoping

* Simpler
* Flexible (Shell environment vars)
* More conflicts possible
* Performance
* Less reliable

## Syntax of Scheme

```scheme
; this is a comment

; These are boolean expressions
#t #f

; This is a vector
#(1 2 3)

; This is a string
"string"

; This is a character
#\A

; This is a list that contains 3 and 4
; 3 -> 4 -> ()
(cons 3 (cons 4 '()))

; This is an improper list
; 3 -> 4
(cons 3 4)

; This is a symbol
'abc

; You can also get the list of 3 4 with
'(3 4)

; Improper list of 3 4 with
'(3 . 4)

; You can define a variable with
(define a 3)

; If you want to use the value of a variable in constructing a symbol, you can use quasiquote and use comma to unquote them inside
'(a 4) ; will simply returns (a 4)
`(,a 4) ; will evaluate a and returns (3 4)

; You can also do
`(,(+ 1 2) 4)
```

## Special forms

```scheme
; Different forms of define
(define pi 3.14159)
; You can overwrite predefined system functions
(define caar (lambda (x) (car (car x))))
(define (caar x) (car (car x)))
; The below two definitions of list are the same
(define list (lambda x x)) ; Take an arbitrary number of elements and store them as a list named x
(define (list2 . x) x)

; if cannot be implemented as a function but as a special form
; function will evaluate all its arguments before evaluating the body
(if I T E) ; Will only evaluate T or E depending on the value of I
(and E1 E2 E3) ; Evaluates to false if false; to last true expression if true
(or E1 E2 E3) ; Evaluates to false if false; to first true expression if true
```

## Useful syntactic sugars

```scheme
; let expression for local bindings
(let ((x (* a a))
      (y (* z z)))
  (sqrt (+ (* x x) (* y y))))
; which is simply a syntactic sugar for
(lambda (x y)
  (sqrt (+ (* x x) (* y y))))
(* a a)
(*z z)

; named let for helper function definition and calling
(define (reva l a)
  (if (null? l)
      a
      (reva (cdr l) (cons (car l) a))))

(define (reverse l)
  (reva l '()))
; can be simplified as
(define (reverse l)
  (let reva ((l l) (a '()))
    (if (null? l)
        a
        (reva (cdr l) (cons (car l) a)))))
; without the syntactic sugar, it has to be written as
(define (reverse l )
  (let ((reva
         (lambda (l a)
           (if (null? l)
               a
               (reva (cdr l) (cons (car l) a))))))
    (reva l '())))
; which is quite convoluted to be read clearly
```

## Define syntax (Macro)

What if you want to create the Scheme `and` yourself? You cannot define it as a function. A function will always evaluate all the arguments first before evaluating the body. `define-syntax` will save the day.

```scheme
(define-syntax and
  (syntax-rules ()
    ((and) #t)
    ((and x) x)
    ((and x1 x2 ...)
     (if x1 (and x2 ...) #f))))

(define-syntax or
  (syntax-rules ()
    ((or) #f)
    ((or x) x)
    ((or x1 x2 ...)
     (let ((v x1))
       (if v v (or x2 ...))))))
```

`define-syntax` is basically defining macro. So it is facing the same problem as macro in C and C++. Here is a problematic example.

```scheme
(let ((v 27))
  (or #f v))
; will be expanded to
(let ((v 27))
  (let ((v #f))
    (if v v (or v))))
; which does not do what it intends to do
```

Scheme has a feature called hygienic macro. The local variable bindings in `define-syntax` will automatically keep track of the depth of the variable binding.

In the example above, the two `v` in `(if v v ...)` will be remembered by the system as `v` key-binding with depth 1, while the potential `v` in `(or x2 ...)` as depth 2 so on and so forth. So the system will only look for variable `v` defined in the let binding very outside. In the case of our example, it will be the `(v 27)` binding. It would not look for the one inside it, which is the `(v #f)` binding. However, `(or v)` will ignore the `(v 27)` and look for `(v #f)` directly. This way, we can ensure that the expanded `define-syntax` will mean what it is supposed to.

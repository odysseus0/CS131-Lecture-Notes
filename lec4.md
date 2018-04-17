# Lecture 4

NOTES: This lecture note is incomplete because I was late for class. Use it at your own discretion.

## Syntax (Continued)

- Generate abstract parse trees
  - Tools: Compiler compilers
    - Definition from Wikipedia: "A compiler-compiler or compiler generator is a programming tool that creates a parser, interpreter, or compiler from some form of formal description of a language and machine."
    - Compiler compiler can use left-associative to avoid ambiguity in expressions like `e1 + e2 + e3`, which will be parsed as `(e1 + e2) + e3`.
- Other Problems
  - Expression with competiting side effects in expression

    ```C
      int a, b, c;
      c = f (a = 1, a = 2)
    ```

    - In what order are the two assignments evaluated?
    - According to C language definition, the order is undefined thus implementation dependent
    - If `a` is a big integer (too large to fit into 1 register), then multiple machine instructions are necessary to complete the assignment.
      - Interleaving of instructions will leave the variable a mess
      - Might even affect other variables
    - The behavior of the instruction is undefined
    - This is a semantic problem
  - Languages with dynamic grammars
    - Prolog
      - Predefined operators
        - `:op(500, yfx, [+, x])
        - 500 gives the priority
        - yfx specifies whether the operator is unary or binary, and what the operands are
          - x and y are its operands
          - y allows equal priority
          - x means that only operators with higher priority (that is, with lower priority number, here lower than 500).
          - The operand is left-associative, because operands of equal priority is expanded on the left.
        - :-op(400, fyx, [*,/])
        - :-op(200, fx, [+, -])
          - Unary + and -
        - :-op(700, xfx, [=\=, ==...])
          - Lower priority than others
          - Operands must have higher priority
            - So `3 = 4 = 5` is illegal
            - In C, `a == b == c`
        - :-op(300, xfy, [**])
          - Right-associative because the operator with equal priority is on the right.
      - Extra constraints are expressed non-grammatically

## Homework 2

We are going to construct a simple compiler compiler in homework 2. It will take grammar as input and then output a function that is a parser; it will take a list of tokens as input, and then output a parse in the form of either parse tree or derivation. Real compilers will do a lot more, including but not limited to type checking, identifier checking, and generating machine code. The problem itself is generally hard and please use the simplest algorithm you can think of. You don't have to worry too much about the efficiency of your algorithm.

### Parser

- Basic problems in doing parsing
  - Recursion in the grammar
    - Need to deal with grammar rules like `E -> E + T`
    - To make the problem a bit easier, the homework will only give grammars that take the form `E -> T + E`.
    - Recursion in the grammar will have to be done by recursion in parser
  - Alternation
    - `E -> T + E`
    - `E -> T`
    - Must be solved by doing backtracking in the parse tree
  - Concatenation
    - Hardest part
    - Solution

- Ocaml basic property
  - Good support for higher-order functions
  - No need to worry about strange managment
  - Compile-time (static) type checking
  - Advanced type inference

```ocaml
# 3 + 4 * 5;;
- : int = 23

# let y = 37 * 37;;
val y : int = 1369

# if 0 < 10 then 'a' else 'b';;
- : char = 'a'

# if 0 < 10 then 'a' else 27;;
Error: This expression has type int but an expression was expected of type
         char

# (1, 'x');;
- : int * char = (1, 'x')

# [1; 'x'];;
Error: This expression has type char but an expression was expected of type
         int

```

## Patterns

```ocaml
match E with
  P1 -> e1
| P2 -> e2
  ...
```

`_` wildcard (matches anything)
`x` anything bount to
`27` literals match itself
`p1::p2` matches non-empty list
`[p1;p2;p3]` matches 3-element list
`(p1,p2,p3)` matches 3-element tuple

```ocaml
# [];
- 'a list = []

# List.hd [];
Exception: Failure "hd".
```

We can easily write out own `hd` function.

```ocaml
let myhd x::xs = x
```

The Scheme counterpart of `::` is `cons`. It is used as...

Implementing `cons` in OCaml (in C refugee style)

```ocaml
let cons (h, t) = h::t
val cons : 'a * 'a list -> 'a list = <fun>
```

Not functional enough. Why? Can be curried.

```ocaml
# let pros = (fun h -> (fun t -> h::t))
val pros : 'a -> 'a list -> 'a list = <fun>

(* Now we can do... *)
# let pros27 = pros 27;;
val pros27 : int list -> int list = <fun>

# pros27 [3; 19]
- : int list = [27; 3; 19]

# let pros h t = h::t
val pros : 'a -> 'a list -> 'a list = <fun>
```

The reverse function in OCaml

```ocama
let rec reverse =
  function [] -> []
         | x::xs -> (reverse xs) @ [x]
```

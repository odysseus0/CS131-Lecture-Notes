# Lecture 10: Logic Programming

## Characteristics of Logic Programming

* No assignments. No side effect hassles.
* No functions. No evaluation dependency like `f(g(x))`.
* Declarative view of programming
  * Declaration: `int f(int n);`

* Algorithm = Logic + Control
  * Logic is about correctness. It is about which answers are right.
  * Control is about how to compute answers quickly. It is only about performance.
    * If the code of your control part is bad, it at worst can only hurt your performance. it will not make your program incorrect.
  * Separation of concerns

### Example

This is example is about logic only. We want to write a sorting algorithm. First we need to write down the logic that specifies what it means to sort an array.

```prolog
sort(L, S) :- perm(L, S), sorted(S).

sorted([]).
sorted([_]).
sorted([X, Y|L]) :- X =< Y, sorted([Y|L])

perm([], []).
perm([X|L], P) :- perm(L, LP), append(LP1, LP2, LP), append(LP1, [X|LP2]), P).

append([], L, L).
append([X|L], M, [X|LM]).
append(L, M, LM).
```

* Variables that start with capital letters specify *logical variables*. A line of code that ends with a period symbol is a *clause*.
* `[X, Y | L]` matches a linked list with two elements, first bound to `X` second to `Y`, and the rest of the linked list to `L`.
* *Clause* is one line of declaration that ends with the period.
* *Predicate* is a collection of clauses with the same name.
* Terrible performance. $O(N)$.

### Order within a clause matters

Compared to the original example above, the one below has exactly the same logical meaning, but different control behavior.

```prolog
sort(L, S) :- sorted(S), perm(L, S)
```

The Prolog interpreter does a left-first depth-first search. As a result, the new clause would have better performance for certain questions. The performance will remain the same for question like `sort([4, 3, 5], [3, 4, 5])`. It would immediately check if `[3, 4, 5]` is a sorted version of `[4, 3, 5]`, after which it will check if `[3, 4, 5]` is a permutation of `[3, 4, 5]`. For the original clause, it would first try to check if `[3, 4, 5]` is a permutation of `[4, 3, 5]`.

* Ground terms
* Performance when `sort` is provided non-ground terms
* `X < Y` when both X and Y are logical variables
* `#<#` as a solution
* Why not a good idea to use `sort` to generate sorted list.

## Prolog Syntax

* Term
  * Number: `12`, `1e-9`
  * Atom: `abc`, `aQ_9`, `'Aab x 9'`
  * Variable: `X1`, `Y`
  * Structure: `f(T1, T2, ..., Tn)`
* Syntactic Sugar
  * `E + F` = `'+'(E, F)`
  * `E + F * G` = `'+'(E, '*'(F, G))`
  * `[]` = `'[]'`
  * `[X|Y]` = `'.'(X, Y)`
  * `[X, Y, Z]` = `'.'(X, '.'(Y, '.'(Z, '[]')))`
  * `? :- foo(Y), bar(X)` = `? :- ','(foo(Y), bar(X))`

## Interpretation of Prolog Program

Ask Prolog interpreter `append(A, B, [1,2,3])` and see what happens. Try to figure out how internally it works to generate all the results. Then run it in [Prolog Visualizer](http://www.cdglabs.org/prolog/#/) to see exactly what happened.

```prolog
member(X, [X|_]).
member(X, [_|L]) :- member(X, L).
```

You can have logical variable on both sides.

```prolog
member(b, [a, X, c])
member(X, [a, b, c))
```

Both are valid questions.

```prolog
reverse([], []).
reverse([X|L], R) :- reverse(L, _|), append(_|, [X], R)

reva([], A, A)
reva([X|L], A, R) :- reva(L, [X|A], R)
faster_reverse(L, R) :- reva(L, [], R)
```
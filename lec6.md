# Lecture 6 - Type (Continued)

## Designing floating point number representation

* How to handle overflow?
  * IEEE Standard: Infinity, NaN
  * trap (program halts)
  * saturated arithmetic
  * throw an exception
* General strategy
  * Special values like in IEEE standard
  * Exception handling
    * Mechanism: x86-64 has a special bit you can set. Can set it to 1 and trigger a trap when overflow happens.
    * Argument against:
      * Setting extra bit and preparing throwing exception increase the cost of computation
      * Using try/catch around every floating point computation is tedious
* Real reason why IEEE does it this way:
  * A historical one: Fortran does not have an exception handling mechanism. The big users are writing scientific computing packages, so they want more performance.

## What do we use type for

* Error Checking
* Clarity
* Performance (static typing)
  * Compiler can generate more efficient code

## Type Equivalence

* Name equivalence
  * Same name
* Structural equivalence
  * Behave the same
  * Duck typing

## Subtype

```c
char *p;
char const *q;

// Which of the following assignment is allowed?
p = q;
q = p;
```

* `char` is a subtype of `char const`
* If A is a subtype of B, then type A has all the operations of type B.

## Type Polymorphism

* Function that accepts many types
* In Fortran:
  * `sin(x)`and `cos(x)` can take either float or double as argument
* Strategies
  * Overloading: Multiple function with the same name can be chosen depending on the argument type
  * Coercion: Silently converting the argument from its own type to the type specified in the function

    ```c
    long l = SOMETHING;
    if (l < -2147483648)
    ```

    * The above code is not going to work. It is applying the negation operator to an integer `2147483648`. Because the integer is too large for `int` type, it will be automatically converted to `unsigned int`. Negating `unsigned int` `2147483648` will return `2147483648`.
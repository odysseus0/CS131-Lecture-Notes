# Lecture 2

## Scaling

* size of problems
* size of programs
* size of developer population

## Evolution

* Some History
  * C on PDP-11 (1970s)
  * 4 microseconds to add
  * 1.2 microseconds memory cycle time
  * memory access is faster than CPU
  * Therefore, C makes pointer dereference very convenient.
  * Nowadays, memory access is about 2 order of magnitude slower than CPU.
* C has evolved
  * one way is to change the language.
  * For example, adding inline functionality in C11 standard
  * However, some compilers still have not implemented the feature
  * How to evolve faster?
* Example: C source code in Emacs. Trying to apply a function to 7 elements.

  ```C
  Obj args[7];
  args[0] = exp0;
  args[1] = exp1;
  ...
  Foo(7, args); // apply a function to all elements in an array of size 7
  ```

  * Can be error prone. Not so convenient. Create a way to apply a function to multiple elements in a convenient way.
    * Want to write it in a syntax similar to

      ```C
      Foo(exp0, exp1, ...)
      ```

  * Solution: Macro that computes the elements in the array. Function won't do.

    ```C
    #define ELTS(a) \ (sizeof(a) / sizeof(*(a)))
    #define CALLMANY(f, args) \ ((f) (ELTS(args), args))
    #define CALLN(f, ...) \ CALLMANY(f, (Obj[]) {__VA_ARGS__})
    ```

## Syntax

* form (syntax) is independent from meaning (semantics)
* Syntax is easy. Semantics is hard.
* The first successful theoretical invention in computer science that brings recognition in academia.
* Sentence can be syntactically correct but meaningless.
  * "Colorless green ideas sleep furiously" - N. Chomsky
* Syntax can be harder than you think
  * "Ireland has leprechauns galore." - P. Eggert
  * galore is postpositive
* A sentence can be both syntactically and semantically ambiguous
  * "Time Flies"
  * Noun + Verb
  * Verb + Noun
* Reason to prefer one syntax to another
  * Inertia: make it similar to what people are used to
  * Simple & Regular
  * Two goals can conflict with each other
    * What people are used to are not typically the simplest
      * Reverse Polish Notation is simpler but not widely used
  * Readability
    * Liebnitz's Criterion: A proposition's form should mirror objective reality

      ```C
      i >= 0 && i < n
      0 <= i && i < n
      ```

    * The second one is better. Corresponds better to mental picture of number line, that the smaller number is on the left while bigger one is on the right.
  * "Writability" (Concise)
    * Might conflict with readable goal
    * One-liner is easy to write but hard to read
  * It's redundant
    * Double check unintended mistakes
  * It's unambiguous

## Different parts of syntax

* Program structure (Big Syntax)
  * C: source code file, header file, include, linker
* Fun part
* Tokenization / Lexical Analysis
  * What your character set is
    * Traditionally: ASCII, 7 bits
    * Now: UTF-8, 1 to 4 bytes
      * Controversial
      * Similarly looking characters with different byte representation can cause confusion and even be used for malicious purposes.
        * https://microsoft.com (Replace o wiht Swahili o)
        * `typedef long int` (Replace i with Turkish lower-case i)
  * Identifiers
    * `[A-Za-z][A-Za-z0-9]*`
    * case-sensitive?
    * white space allowed?
      * Fortran allows white space in identifier
      * Made rocket explode
      * Puntch card worker mistakenly typed `,` as `.`

        ```Fortran
        DO 10 I=1,10
          CALL FOO(I)

        DO10I = 1.10
        ...
        ```
  * Numbers

    ```C
    int i = -217473848;
    ```

    * The number is treated as two tokens. `-` is the first part and the positive number is the second number.
    * `-217473848` is the negation of an unsigned number with value `21743848`.
    * Assigning an unsigned number bigger than the largest signed number is implementation dependent.

      ```C
      -217473848 < 0
      // is evaluated as
      -(217473848 < 0)
      ```

  * Operators
    * `= + x / ++`
    * Tokenization is greedy

      ```C
      a+++b
      // is evaluated as
      a++ + b
      // not as
      a + ++b
      ```

  * Comments
    * `/* ... */`
      * Does it nest?
      * Not in C
    * `// ...`
    * Ugly example

      ```C
      int x, y = 0;
      x = 12;
      // What is this @*??/
      y = x + 5;
      print(y);
      ```

      * Somehow `y = x + 5` is skipped
      * It turned out that `??/` is a trigraph that is automatically replaced as `\`.
      * As a result, the newline character at the end of the comment is omitted, and the next line is treated as part of the comment

  * Keyword
    * Can be reserved, that is, it cannot be assigned to other values
    * Can cause compatibility issues
      * Adding new keywords can cause older programs who initialized keywords to break
      * `class` is not a keyword in C but is one in C++
      * It is valid to use `class` as a varaible name in C, but not in C++.

## Grammar

* Components
  * Token (Terminal Symbol)
    * Definition: Member of a finite set
    * When defining grammar, we need to decide which set of terminal symbols to cover.
  * String: Finite sequence of tokens
  * Language: set of strings
  * Sentence: member of a langauge
* Because langauge is usually infinite, we cannot list all of them. So we need some kind of notation for it.
  * Regular expression is not powerful enough
* Context-free Grammar
  * Finite set of production rules, each of which in the form `nonterminal -> symbol*`, where symbol can be either terminal or nonterminal.
  * Start symbol (nonterminal)
  * set of terminals
  * set of nonterminals
  * Example:

    ```txt
    // Production rules
    S -> NP VP
    NP -> n
    NP -> adj NP
    VP -> v
    VP -> VP adv

    // Start symbol
    S

    // Nonterminals
    S NP VP

    // Terminals
    n adj adv v

    // Production example
    S
    NP VP
    NP VP adv
    adj NP VP adv adv
    adj NP VP adv adv
    adj n VP adv adv
    adj n v adv adv
    ```

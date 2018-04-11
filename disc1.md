# Discussion 1A

## Misc

- TA
  - Name: Brett Chalatian
  - Office Hour: Thursday, 12 pm - 2 pm
  - Location: Boelter 2432
- SEASNet servers to use
  - lnxsrv06, 07, 09
  - Remember to include `export PATH=/usr/local/cs/bin:$PATH` in your `.profile` file

## Ocaml

- Functional Programming
  - Function known at run-time
- Statically Typed
  - All the type information all known at compile time
  - Contrast with dynamically typed: type information known only at run-time
- Type Inference
  - Interpreter can deduce the most general type information during function and variable initialization based on given information

    ```ocaml
    let x = 3 + 3
    - x: int = 6
    ```
- Interpreter
  - Can use compiler
- Strongly typed
- How include files
  - `#use "hw1.ml`
- Types
  - int
  - bool
  - float
  - string

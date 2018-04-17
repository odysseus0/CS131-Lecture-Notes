# Lecture 5

## Some more about OCaml

```ocaml
let rec apprev a = function
    [] -> a
  | h::t -> apprev (h::a) t

(* constant time reverse *)
let reverse = apprev []
```

```ocaml
let rec minmum = function
    [] -> max_int
  | h::[] -> h
  | h::t ->
    let min_tail = minmum t in
    if h < min_tail then h else min_tail
```

### Customized Types

```ocaml
type mytype = Foo | Bar of int | Baz of float * string

type 'a mylist =
    Empty
  | NEmpty of 'a * 'a mylist

let example = NEmpty(3, NEmpty(4, NEmpty(-1, Empty)))
```

### OCaml option vs. C pointer & null pointer

```ocaml
type 'a option = None | Some of 'a

let p in
match p with
  None -> -1
| Some x -> x
```

```C
int *p = exp;
return p ? *p : -1;
```

Static type checking force you to check p being both None and Some. In C, the compiler does not force you to do so. It is perfectly legal to write

```C
int *p = exp;
return *p;
```

which will throw null pointer exception if p is a null pointer.

## Compiler

### Translation of Programs

```c
int main(void)
{
  return !getchar();
}
```

- Phase 1: Lexical Analysis/Tokenization
  - Turn text files into tokens
  - Tokens stored in computer also as integers
  - Improve the speed and simplify the logic of later stages of compiler
- Phase 2: Parsing
  - Understand the syntactical structure of the program
- Phase 3: Static Analysis
  - Type Checking
  - Name Checking
  - ...
- Intermediate code generation
  - Generate abstract machine code on a virtual machine; the code can later be optimized and translated into concrete machine code.
- Code optimization
- Code generation: Translating the abstract machine code into machien code specific to the platform
- The rest is left to the assembler

### Dichotomies

- Tools
  - UNIX Software Philosophy: Make each program do one thing well.
  - Good in design. Easy to replace to individual part.
  - Not so convenient when using it. Have to keep track of all the tools in your head.
- Integrated Development Environment (IDE)
  - Small Talk
    - IDE changes its setting by editing its source code directly

- Compilation
  - Source code compiled into machine code
  - More efficient
  - Harder to implement
  - Increased level of optimization makes the debugging harder; machine instruction does not have a nice one-to-one correspondence to the source code anymore
- Interpretation
  - Source code translates into a sequence of intermediate representations (byte code)
  - Interpreter takes intermediate representations and executes the instructions
  - Easier to implement

### Java

- Source code is translated into portable byte code that is machine-independent and can be ported to any platform
- Not as efficient as C++. Slower by a factor of 2 (roughly).
- Inside the JVM interpreter, we add another compiler that compiles JAVA byte code to machine code.
  - Just in time compilation
  - Profiler
    - counts the number of times a method is called
    - If the method is called more than a number of times, then the method is translated into machine code.
  - This is how Javascript now runs in browser

## Type

- What is a type?
  - A set of values with certain associated operations
- Built-in types vs. User-defined types
  - built-in types can give us inspirations when designed our own types

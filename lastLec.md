# Last Lecture

## Array Cost

- In C, `a[i]` checks calculates `a + sizeof(*a) * i`. If the language enforces subscript checking, then we also need to check `i < 0` and `i > sizeof(a)/sizeof(*a)`.
- How to speed things up?
  - By making sizeof a power of 2. That way, multiplication will just be a shift operation.
  - Storing the size of the array in the array object.
  - Do a single unsigned comparison.
- Arrays whose indices do not start from 0.
  - `double rates[1916:2018]`.
  - We can calculate `rates[i]` as `a + (i - 1916) * 8` where `a` points to `rates[1916]`. However, we can just have `a` points to `rates[0]` and calculate `rates[i]` as `a + i * 8`. Less operations.
- Two-dimensional array
  - `double a[10][30];`
  - `a[i][j]` is calculated as `a + (i * sizeof(*a)) + j * sizeof(**a)`
  - It will be faster if the column is a power of 2. That way, multiplication with `sizeof(*a)` will become a shift operation.
- Slicing
  - We want `a[][j]` to return the `jth` column
  - Fortran implements it with array descriptor, where the program stores
    - pointer to zeroth element
    - Lower bound
    - Upper bound
    - stride
      - `a[i]` is calculated as `a + i * stride`
- Cache
  - `double a[10][32]` can potentially cause more cache collision because adding a power of 2 usually sends you into the same location in the cache.
- `strcmp`
  - `vpcmpeqb` instruction of x86 compares multiple bytes together in parallel. For example, comparing 255 bytes at the same time.
  - Might make the CPU decrease the clock cycle time to avoid melting.
- Prolog implements its clause lookup mechanism as hash table.

## Semantics

- What does a program mean?
  - Syntax, a mostly solved problem
  - Semantics
    - Static semantics (compile-time meaning)
    - Dynamic semantics (runtime meaning)
      - Inherently unsolvable problem because of halting problem.
- Attribute grammar (static semantics)
  - parse tree has decoration on each node
    - type of resulting expression
    - symbol table
- Dynamic semantics
  - Operational Semantics
    - To explain a program P in a language L.
    - Write an interpreter I for language L.
    - Run P on I.
    - Assumes a pre-existing language.
  - Axiomatic Semantics
    - Designed for program verification
  - Denotational Semantics

# Python & History of Programming Languages

## History

* Fortran
  * Immensely successfully for scientific computing
  * Fortran program still used as metrics for measuring the speed of super computers
* Basic (1961)
  * Like Fortran but simple and easy to learn and debug
* Shared Cores
  * Loops, subroutines, arrays
* CWI (Netherlands)
  * Have to teach the students to unlearn the habits learned from Fortran and Basic, those that were suitable for the old ages but not anymore.
  * Invented ABC. Reaction to Basic. Basically Basic cleaned up.
  * IDE for Windows.
    * Automatically indenting code.
  * High level data structures
    * Set
    * List
  * Mantra: There is a right way of doing thing and it is in ABC.
  * Did not succeed
* SDC (Santa Monica) 1980
  * Larry Wall
  * Wrote a language called Perl.
  * Grew out of the software tools field.
  * Found that in Unix, there are
    * low level languages
    * all kinds of different scripting languages
  * Combined all above into a kitchen sink language, Perl. Good at glueing together different languages.
  * Mantra: There is more than one way to do it.
  * ABC people believed that the flexibility is a mistake.
* Python

  * Perl + ABC. By the people of ABC.
  * Glueing language. One right way of doing thing.
  * Indentation is part of the grammar.
    * Consequence
      * Hard to write (E)BNF for Python
      * Generating Python code is trickier
      * Anti-Scheme
  * End-of-line(EOL) has grammatical significance

    * Harder to split long line into different lines

    ```Python
    x = a + b + c + d + e
    # Can be rewritten into different lines as
    x = (a + b + c
        + d + e)
    ```

  * Objects

    * Everything is an object, and has
      * Immutable identity (address)
      * Mutable
        * Type
        * Value
      * Attributes
      * Methods
    * Built-in operators
      * `a is b` returns if a and b have identities. Similar to Scheme's `eq?`.
      * `a == b` returns if a and b have the same values. Similar to Scheme's `equal?`.
      * `type(a)` returns the type of `a`. Similar to Java's `a.getClass()`
      * `id(a)` returns the identity of `a`. Similar to Java's `a.hashCode()` but is guaranteed to be unique.
      * `isinstance(a, c)` returns if `a` is an instance of the class `c`. Similar to Java's `a.instanceOf(c)`.
    * OOP

      * Inheritance
        * Multiple inheritance. `class C(A, B)`. Class C inherits from both `A` and `B`.
        * When looking for a method or attribute, Python searches depth first, left to right, through the inheritance tree.
      * A class is an object.
      * Namespace
        * It has a member `__dict__` that is a dictionary of its names.
        * By convention, names starting with `__` are private.
        * Examples
          * `__init__`
          * `__del__`
          * `__str__`: Informal string
          * `__repr__`: Formal string. All needed to recreate the object.
          * `__hash__`
          * `__nonzero__`: We can use all objects that implement `__nonzero__` in the conditional clause of if statement. The if statement simply calls the `__nonzero__` method of the object, and takes its return value as the boolean value used for conditioning.
          * `__cmp__`: returns -1, 0, 1.
          * `__le__`: Less than or equal with
          * `__lt__`: Less than
          * `__add__`
      * Data Types
        * Numeric
          * Integer
          * Float
          * Complex
          * Boolean
        * Sequence
          * Examples:
            * List
            * String
            * Tuple
            * Buffer
          * Sequence Operations
            * `s[i]` returns the i-th element in the sequence
              * Range: `-len(s) <= i < len(s)`
            * `s[i:j]` returns elements of index `x` where `i <= x < j`
            * `s[i:]` returns elements of index `x` where `i <= x < len(s)`
            * `s[:j]` returns elements of index `x` where `0 <= x < j`
            * `len(s)`
            * `min(s)`, `max(s)`
            * `list(s)` construct a list containing all the elements in `s`
          * List Operations
            * `s.append(x)`. Amortized $O(1)$.
            * `s.extend(s1)`. Adds `s1` to the end of `s` in place.
            * `s.count(x)`
            * `s.index(x)`
            * `s.pop(i)`. Returns `s[i]` and deletes it.
            * `s.pop()`. Equivalent with `s.pop(-1)`.
            * `s.sort()`
            * `s.reverse()`
        * Mapping
          * Dictionary
            * `d[k]`. `k` can be any immutable value. Why? Because we want hashing to work.
              * Returns `KeyError` if the key does not exist.
            * `d.get(k)` returns `d[k]` if the key exists and `None` otherwise.
            * `k in d` returns if `d` has key `k`
            * `del d[k]`
            * `len(d)`
            * `d.clear()`
            * `d.copy()`
            * `d.items()`
            * `d.keys()`
            * `d.values()`
        * Callable
          * Lambda expression
            * `f = lambda x, y: x + y`
          * Named Arguments
            * `def arctan(x, y)`
            * `arctan(y = 3, x = 2.5)`
          * Variadic Functions
            * `def printf(fmt, *arg)`
            * `def flexible(a, b, *args, **namedArguments)`
          * Nested Functions with Static Scoping
      * Modules

        * `import foo`. Executable statement. Dynamic Linking.
          * Creates a namespace.
          * Reads from `foo.py` and executes it in the new namespace.
          * Creates a name called `foo` in the caller's namespace. Binds `foo` to the new namespace.
        * `sys.modules`. List all the currently imported modules.
        * `sys.path`
        * `main`

          ```python
          if __name__ == '__main__':
            sys.exit(run(sys.argv[1:]))
          else:
            # useful stuff to do when imported
          ```

      * Packages
        * A way to group modules together in a directory hierarchy.
          * ![Package](https://cdn.programiz.com/sites/tutorial2program/files/PackageModuleStructure.jpg)
        * Leaf nodes are modules
        * Internal nodes are directories

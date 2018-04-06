# Lecture 1

Donald Knuth, the TEX book, the hash trie, and the bash script.

Choice of language/notation matters.

## Sapir Whorf Hypothesis

* The language we use to some extent determines how we view the world and how we think.
* The structural diversities of languages is essentially limitless.

## Course Topics

* Theory
  * Language design
  * Syntax
  * Semantics
  * Functions
  * Names
  * Types
  * Control
  * Objects
  * Exceptions
  * Concurrency
  * Scripting
* Practice
  * OCaml
  * Java
  * Prolog
  * Scheme
  * Python
  * ?

## Core of Course

* Principles and limitations of programming models
* Notations for these models
  * Design
  * Use
  * Support
* Methods to evaluate the strengths and weaknesses in context

## Questions from Faculty

* Why are there so many programming languages?
  * Why not metaprogramming (flexible and allows defining new syntaxes on the fly to solve relevant problems)
* My AI software is too slow
  * Written in Lisp
  * Rewritten in C
  * Faster but now crash a lot
  * Language that is both nice to develop like Lisp and fast as C

## Language Wars

* Java vs. C#
* Python vs. Perl

### How to decide

* Judge by the cost of using the language
  * Execution-time performance
  * Training/learning
  * Development Speed
  * Libraries/Community Support
  * Protability
  * Testability
  * Maintainability
  * Reliability

## Design issues

* Orthogonality
  * Design choices do not interfere with each other
  * Non-orthogonal examples
    * C funciton can return any type other than an array.
    * Historical reason: Evaluation of array varialbe returns the pointer to its first element. If we want to allow array as return type, then `return array` should return the entire array instead of the pointer. This creates incompatibility with legacy code.
* Simplicity
  * Infix is not easy 
* Convenience

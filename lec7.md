# Lecture 7: Parametric Polymorphism

* Template
  * Generate a new copy of the function/class with the type variables substituted with the chosen type.
  * Usually assume that all variables are represented by a pointer
  * Downsides
    * Multiple copies of the object codes
    * Templates are not checked fully. Cannot get static type checking.

* Generics
  * Enable static type checking
  * Downside
    * Have rule sometimes too strict to limit possible functions. Not as flexible as template.
    * A bit slower in performance
    * Rules for type checking are more complicated

## Java

* primitive types vs. reference types
  * Primitive types are stored directly as values, not objects
  * Reference types are stored as objects

### Old Java

```java
List l = new LinkedList();
l.add(new Integer(0));
Integer i = l.iterator().next();
```

* List can contain arbitrary objects
* `l.iterator().next()` will return an object of the type `Object`.
* The compiler will complain on the last expression
* Way to fix it

  ```java
  Integer i = (Integer) l.iterator().next();
  ```

  * Add a run-time check.
  * Hurt the performance
  * Dangerous

### New Java

```java
List<Integer> l = new LinkedList<Integer>();
l.add(new Integer(0));
Integer n = l.iterator().next();
```

## Dark sides of Generics

```java
List<String> ls = Arrays.asList("foo", "bar", "baz");
List<Object> lo = ls;
lo.add(new Thread());
String s = ls.get();
```

The following line causes trouble.

```java
List<Object> lo = ls;
```

It is not legal because `List<String>` is not a subtype of `List<Object>`. Recall that if C is a subtype of P then C can carry out all the operations P can; that is, C's operations are a super set of P's operations.

```java
void printList(List<Object> lo) {
  for (Object o: lo) {
    System.out.println(o);
  }
}
List<String> ls = Arrays.asList{"foo", "bar", "baz"};
printList(ls);
```

This does not work because `List<String>` is not a subtype of `List<Object>`.

Here is the proposed fix:

```java
void printList(List<?> lo) {
  for (Object o: lo) {
    System.out.println(o);
  }
}
```

The idea of wildcard can cause trouble.

```java
void convert(? [] a, List<?> l) {
  for (Object o: a) {
    l.add(a);
  }
}
```

Very problematic as the wildcard can match anything. The first wildcard can match a type and the second wildcard can match a different one.

```java
void convert(T [] a, List<T> l) {
  for (T o: a) {
    l.add(a);
  }
}
```

This will now ensure that the element type of the array will be the same as the one of the list. However, sometimes it can be a bit too strict.

```java
GreenThread[] a = ...;
List<Thread> b = ...;
convert(a,b)
```

This will not work now. How to make it work?

```java
<T> void convert(T [] a, List<? super T> b) {
  for (T o: a) {
    l.add(o);
  }
}
```

Now `convert(a, b)` will work because the element type of list is now limited down to super types of T.

The two expressions below are the same as each other:

```java
<T> void foo(T o)
void foo(? o)
```

Type checking rule of Java is too strict and requires tremendous amount of work and complicated type rules to make simple things like above work.

## Duck Typing

"If it walks like a duck and it quacks like a duck, then it must be a duck."

```python
if isduck(d):
  print("it is a duck");
  d.quake();
```

This is not an example of duck typing.

```python
try:
  d.quake();
```

## Java parallelism

### Supercomputers

* Sunway TaihuLight
  * 40,960 Chinese-designed SW26010 manycore 64-bit RISC processors based on the Sunway architecture
  * Each processor chip contains 256 processing cores, and an additional four auxiliary cores for system management
  * a total of 10,649,600 CPU cores across the entire system
* Metrics to evaluate the power of super computer
  * LINPACK benchmark
    * 93 petaflops
    * an efficiency of 6.051 GFlops/watt
* Green 500
  * Shoubu
    * 7032 MFLOPS/W
    * 1,181,952 total number of cores
    * Xeon E5-2618Lv3 8C 2.3GHz

### The Story of Sun Co. in 1994

* Objectives
  * servers, workstation, network
  * multi-CPU
  * Port this to a toaster
* Language Dilemma
  * C is not flexible enough. It does not support OO.
  * C++ is too complicated
  * Invented C--, a subset of C++. Still not simple enough.
  * Sun used SPARC CPUs at the time. Too expensive for embedded world.
  * Because C family language is platform dependent, they need to compile and maintain multiple versions of binaries for different platforms.
  * Bloated executable
  * Crashes a lot. Not reliable.
* Smalltalk
  * its great ideas
    * Invented by Xerox PARC
    * IDE
    * OO but less bureaucratic
    * compile to portable byte codes
    * garbage collector
    * Runtime subscript checking & others
  * How Sun engineer made a new language out of Smalltalk
    * syntax quite different from C -> make it more C like
    * Take byte code -> transfer it over the internet
    * Dynamic typing -> Static typing
    * Invented Oak, later renamed as Java
    * Supported multiple CPUs

### The Java programming language

* primitive types
  * In C, the sizes of primitive types are machine-dependent
  * In Java, the size of primitives are consistent
* Array

  ```java
  int[] g = new int[100];
  ```

  * Always live in the heap
  * Fixed size once created
  * Size is not part of the type
  * Function can return an array
* Single Inheritance
  * Interface
  * Interface hierarchy
  * A class can implement multiple interfaces at the same time
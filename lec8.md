# Lecture 8

## Java Class vs. Interface

* Syntax

  ```java
  class CC extends AC {

  }

  class CC implements IF {

  }
  ```

  * class extends abstract class
  * class implements Interface
* final
  * Applies to variables, methods, and classes
    * final variable: cannot be reassigned
    * final method: cannot be overridden
    * final class: cannot be inherited
  * Advantage
    * Compiler knows that the method cannot be overridden
    * For code like `final int baz() { return 0; }`, automatic inlining will also become possible.
* Object class

  ```java
  public class Object {
  public Object();
  public boolean equals(Object obj);
  public int hashCode();
  public final Class<? extend Object> getClass();
  public string toString();
  protected void finalize() throws Throwable;
  protected Object clone() throws CloneNotSupportedException;
  }
  class c {
  public int hashCode { return 0; } //Then all objects of class C is going to
  }

  ```

  * The root of the object hierarchy.
  * Every other class implicitly extends it
  * Provide methods that objects of all classes should have.
  * Non-final methods can be overridden for customization in specific classes
    * Override `equals` to set rules on what make two objects equal
      * Default `equals` compare memory addresses, which means that only references to the same objects are considered equal.
      * However, this is not always desirable. For class like `Integer`, two objects should be considered equal if they represent the same integer.
      * To achieve this purpose, the `equals` method is overridden in `Integer` class.
    * There is extra convention that *whenever `a.equals(b)`, then `a.hashCode()` must be same as `b.hashCode()`*.
    * However, the other way needs not to be true. Two objects can return the same `hashCode()` while still not equal.
    * In practice, `equals` and `hashCode` usually need to be overridden together.

## Object Class API

* `public final Class<?> getClass()`
  * Return a class object that `this` object belongs to
  * Yes, an class object, which is an object of class `Class`.
  * `getClass` is a form of reflection.
  * The actual result type is Class<? extends |X|> where |X| is the *erasure* of the static type of the expression on which `getClass` is called.
    * Calling `getClass` on `LinkedList<Thread>` will return `class java.util.LinkedList`. The `Thread` is erased.
* `public string toString()`
  * This is what Java calls when you try to print an object
  * It gives a representation of the object. Can be convenient for display and debugging purpose.
* `protected Object clone() throws CloneNotSupportedException`
  * `throws CloneNotSupportedException`
    * If a method calls another method that throws an exception and does not catch that, it then must state that on its API.
    * This is helpful because whenever we call a method, we know all the potential exceptions that can be thrown.
  * `protected`
    * A protected method can be called by any subclass within its class, but not by unrelated classes.
  * If we want to copy an Object, we want to call this method.
  * Compare to the copy constructor and assignment operator in `C++`. Its purpose here is to generate a deep, not shallow, copy of the object that is equal to each other but is not referring to the same object.

## Thread's Life Cycle in Java

* We can create a thread in Java via `new`
  * `Thread t = new Thread();`
  * The resulting state of the newly created thread is called `new`, that is, the thread is not running.
  * `t.start()`
    * This allocates os resources to the thread with `t.run()`
  * The thread just "does" code
    * While running the code, it is in the `RUNNABLE` state
  * Other operations associated with a thread are
    * Sleep (state: `TIMEDWAITING`)
    * Wait (state: `WAIT`)
    * Do I/O (state: `BLOCKED`)
    * Yield (state: `RUNNABLE`)
  * The OS will keep track of the thread state, and will move/switch around the thread states respective to outside interactions.
  * We can also exit the run method and enters `TERMINATED` state
  * It is similar to a new thread object in the sense that it does not represent anything running. 

## Race Condition & how to protect against it

### Synchronized

Only one object can access a synchronized method/variable/object at a time

```java
class C {
private int foo;
synchronized int bar() {return foo++;} }
```

Without the `synchronized` keyword, it is possible that two threads are calling `bar` of the same object at the same time, leading to a race condition. A common implementation can be mutex as seen in Computer System class.

The problem with `synchronized` is that it hurts the performance. It is only good for small methods. For this reason, Java developers made the switch to create non-synchronized methods that act like the old ones.

### wait

Another way to avoid race condition.


  ```java
  Number n = 0; 
  Class<? extends Number> c = n.getClass();
  ```

* Abstract Class
* Inheritance
* Generics
* Thread
* Thread life cycle
  * Create
  * Destroy
  * Wait
* Synchronized
* Standard
  * wait
  * notify
  * notify all
* Library classes built on wait, notify, notify all
  * Exchanger
  * CyclicBarrier
  * CountDownLatch
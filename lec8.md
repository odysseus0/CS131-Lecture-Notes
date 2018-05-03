# Lecture 8

Credit: I was not on campus for this lecture. The note is based on the awesome personal note of Alex Oh. Thank you Alex!

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
  * WARNING
    * If a final variable refers to an object, it only implies that it cannot be reassigned and refer to another object. It is still allowed to change the content of the object referred to.

## Object Class API

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

  * Object class is the root of the class hierarchy.
  * Every other class implicitly extends it. So, every other class is a subclass of `Object`.
  * It provides methods that objects of all classes should have.
  * Non-final methods can be overridden for customization in specific classes
    * Override `equals` to set rules on what make two objects equal
      * Default `equals` compare memory addresses, which means that only references to the same objects are considered equal.
      * However, this is not always desirable. For class like `Integer`, two objects should be considered equal if they represent the same integer.
      * To achieve this purpose, the `equals` method is overridden in `Integer` class.
    * There is extra convention that *whenever `a.equals(b)`, then `a.hashCode()` must be same as `b.hashCode()`*.
    * However, the other way needs not to be true. Two objects can return the same `hashCode()` while still not equal.
    * In practice, `equals` and `hashCode` usually need to be overridden together.


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
* It is similar to a new thread object in the sense that it does not represent anything running. However, it could not be run any more.
* `t.join()` says that we are going to come back to the thread after another thread has finished.
  * `t.join(500)`: wait 500 ms at most for the other threads to finish. If not, then it will keep running.

The biggest hassle with threads is that they are stepping on each other's toes. Race condition is the nightmare for every thread user, for there is no easy way to defend the program against it.

## How to Fight Race Condition

The threads are great performance booster if we can make them more reliable. Unsurprisingly, Java provides many features for us to protect our program from the harm of race conditions. However, even then, it is still challenging to write correct multi-threaded programs.

Below are some attempts to write thread-safe programs. Keep in mind that these are NOT the right way to do them.

### Synchronized

Only one object can access a synchronized method/variable/object at a time

```java
class C {
private int foo;
synchronized int bar() {return foo++;} }
```

Without the `synchronized` keyword, it is possible that two threads are calling `bar` of the same object at the same time, leading to a race condition. A common implementation can be mutex as seen in Computer System class. Here is a rough yet intuitive way to think about what it does:

```java
synchronized int bar() { 
  // Grab a lock on self
  return foo++;
  // Release the lock
}
```

An application of synchronized method is the write function of hash table. It is important to ensure that no two writes occur at the same time to avoid corrupting the hash table.

The problem with `synchronized` is that it hurts the performance. It is only good for small methods. For this reason, Java developers made an effort to create non-synchronized methods that act like the synchronized ones.

### wait

The `wait` function provides another way to avoid race condition. Here is how it works. When we call `o.wait()` where `o` is an object, it

1. Removes all the locks on this object held by this thread
1. Wait until the object `o` becomes available (this will put us into the state: WAITING)
1. returns

Wait itself will not get the lock back for the current thread. The object has to go out and find the locks themselves after they come back from return.

### notify

`o.notify()` will wake up one of the threads currently waiting on object `o`. Traditionally the order is determined on a first come first serve base.

`notifyAll` will wake up all the threads currently waiting.

If you are confused, here is an excellent explanation from a [StackOverflow post](https://stackoverflow.com/questions/13249835/java-does-wait-release-lock-from-synchronized-block/13664082).

> Thread acquires the intrinsic lock when it enters a synchronized method. Thread inside the synchronized method is set as the owner of the lock and is in RUNNABLE state. Any thread that attempts to enter the locked method becomes BLOCKED.
>
> When thread calls wait it releases the current object lock (it keeps all locks from other objects) and than goes to WAITING state.
>
> When some other thread calls notify or notifyAll on that same object the first thread changes state from WAITING to BLOCKED, Notified thread does NOT automatically reacquire the lock or become RUNNABLE, in fact it must fight for the lock with all other blocked threads.
>
> WAITING and BLOCKED states both prevent thread from running, but they are very different.
>
> WAITING threads must be explicitly transformed to BLOCKED threads by a notify from some other thread.
>
> WAITING never goes directly to RUNNABLE.
>
> When RUNNABLE thread releases the lock (by leaving monitor or by waiting) one of BLOCKED threads automatically takes its place.
>
> So to summarize, thread acquires the lock when it enters synchronized method or when it reenters the synchronized method after the wait.

Eggert says: `wait` and `notify` are receipts for mistakes!

### Other methods

For the topics on `Exchanger`, `CountDownLatch`, and `Cyclicbarrier`, please read the amazing tutorials by Jakob Jenkov. Here are the links:

* [Exchanger](http://tutorials.jenkov.com/java-util-concurrent/exchanger.html)
* [CountDownLatch](http://tutorials.jenkov.com/java-util-concurrent/countdownlatch.html)
* [CyclicBarrier](http://tutorials.jenkov.com/java-util-concurrent/cyclicbarrier.html)

The official Java documentation is always a good choice:

* [Exchanger](https://docs.oracle.com/javase/10/docs/api/java/util/concurrent/Exchanger.html)
* [CountDownLatch](https://docs.oracle.com/javase/10/docs/api/java/util/concurrent/CountDownLatch.html)
* [CyclicBarrier](https://docs.oracle.com/javase/10/docs/api/java/util/concurrent/CyclicBarrier.html)

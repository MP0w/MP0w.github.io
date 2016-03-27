---
layout: post
title:  "When your Swift code breaks the compiler"
permalink: "when-your-swift-code-breaks-the-compiler"
date: 2016-03-27 21:50:00
categories: Swift
tags: "swift compiler opensource lldb debug llvm"
excerpt: "Since when I started programming in **Swift** I tried to switch my mind from `OOP` to [Protocol oriented programming](https://developer.apple.com/videos/play/wwdc2015/408/), it's awesome, until the compiler breaks. Here I will explain how to troubleshoot compiler faults."
summary: "Since when I started programming in Swift I tried to switch my mind from OOP to Protocol oriented programming, it's awesome, until the compiler breaks. Here I will explain how to troubleshoot compiler faults."
cover: sad_mac.jpg
hashtags: swift
---

We all love **Swift**, it’s much more powerful than **Objective-C** and its type safety and type inference almost made me forget the [lack of refactor tools](http://www.openradar.me/20415947). Since when I started programming in Swift I tried to switch my mind from `OOP` to [Protocol oriented programming](https://developer.apple.com/videos/play/wwdc2015/408/), it’s awesome, until the compiler breaks.  

The Swift compiler and the [semantic analysis](https://github.com/apple/swift/tree/master/lib/Sema) are very powerful. Since Swift added many features, like **generics** and **super powered protocols and value types**, the work of the compiler is a bit more difficult compared to Objective-C.  

Swift is a relatively young language so it’s more common than in the past to spot some bugs, it’s part of the game, just we (or at least me) are not used to it. You may spend some time writing your code, modeling your architecture around protocols and then when you try it out: the compiler crashes.  

![Compiler crashed](./assets/seg-fault.png){: .postImage}  

It happened to me some months ago for the first time; Swift was not yet **open source**, the crashlog was not very helpful and I ended up trying to tweak my code until it worked. I commented some lines, moved some code, changed the implementation, removed some protocols, finally it worked… I *just* had to completely change the implementation and work on it 2 more hours trying to understand what was wrong with it (which I can’t remember anymore but was related to Protocols and extensions).  

Swift 2 is quite stable but it still can happen. Yes, it happened again 2 weeks ago.
{% highlight swift %}
let someRanges = [1..<4, 1..<8, 1..<16, 1..<32, 1..<64, 1..<128, 1..<256, 1..<512, 1..<1024]
{% endhighlight %}  

My playground with just one line of code was not working and looked like it stepped into an infinite loop🌪!  

This time I just lost half an hour changing the values more or less randomly until I realized that Swift was open source and I should have gone deeper in the compiler and try to debug it. So I started!  

[Checking out](https://github.com/apple/swift)  (as you can’t debug the one bundled in Xcode) … Reading some READMEs… Compiling…. ☕️ … 😴… ☕️ (Yes takes quite long!)…
I finally had a local copy of Swift, its compiler, and the debugger ready to start!  

1) Launch lldb, create the target with the local copy of the Swift compiler and `r`un (launch the process)
{% highlight bash %}
$ cd ~/SOME_PATH/MY_SWIFT_LOCAL_COPY
$ lldb 
(lldb) target create ./build/Ninja-DebugAssert/swift-macosx-x86_64/bin/swift
Current executable set to ‘./build/Ninja-DebugAssert/swift-macosx-x86_64/bin/swift’ (x86_64).
(lldb) r
{% endhighlight %}  

2) Process starts and eventually stops immediatly but we can just `c`ontinue; we are in the Swift **REPL**!
{% highlight bash %}
Process 27422 launched: ‘./build/Ninja-DebugAssert/swift-macosx-x86_64/bin/swift’ (x86_64)
Process 27422 stopped
* thread #1: tid = 0x75bf0, 0x00007fff5fc01000 dyld`_dyld_start, stop reason = exec
 frame #0: 0x00007fff5fc01000 dyld`_dyld_start
dyld`_dyld_start:
-> 0x7fff5fc01000 <+0>: popq %rdi
 0x7fff5fc01001 <+1>: pushq $0x0
 0x7fff5fc01003 <+3>: movq %rsp, %rbp
 0x7fff5fc01006 <+6>: andq $-0x10, %rsp
(lldb) c
Process 27422 resuming
*** You are running Swift’s integrated REPL, ***
*** intended for testing purposes only. ***
*** The full REPL is built as part of LLDB. ***
*** Type ‘:help’ for assistance. ***
(swift)
{% endhighlight %}  

3) Type the incriminated code
{% highlight bash %}
(swift) let someRanges = [1..<4, 1..<8, 1..<16, 1..<32, 1..<64, 1..<128, 1..<256, 1..<512, 1..<1024]
{% endhighlight %}  

4) We are in an endless loop so just press `ctrl + c` and the process will be paused, then use `bt` to see the **backtrace**.
{% highlight bash %}
(lldb) bt
...
 frame #25: 0x0000000101129ff9 swift`swift::constraints::ConstraintSystem::solveRec(this=0x00007fff5fbf3bf8, solutions=0x00007fff5fbf2ef8, allowFreeTypeVariables=Disallow) + 809 at CSSolver.cpp:1310
 frame #26: 0x000000010112cfd8 swift`swift::constraints::ConstraintSystem::solveSimplified(this=0x00007fff5fbf3bf8, solutions=0x00007fff5fbf2ef8, allowFreeTypeVariables=Disallow) + 3512 at CSSolver.cpp:1739
...
{% endhighlight %}  

In the backtrace we quickly see that two frames are continuously repeated (being a loop 😝), so [solveRec](https://github.com/apple/swift/blob/f560f3caac06723ef174e83b34b0f91b6f86f7ee/lib/Sema/CSSolver.cpp#L1310) and [solveSimplified](https://github.com/apple/swift/blob/f560f3caac06723ef174e83b34b0f91b6f86f7ee/lib/Sema/CSSolver.cpp#L1739) are calling each other!  

Then I needed at least a basic knowledge of the compiler. There are some steps before you actually get to the final executable, as explained in the swift documentation and this [Swift Intermediate Language](http://llvm.org/devmtg/2015-10/slides/GroffLattner-SILHighLevelIR.pdf) amazing presentation:

- Parsing > produce **Abstract Syntax Tree** (**AST**)
- Semantic (lib **Sema**) > Semantic analysis and type checking
- **SIL** generation > Generate **Swift Intermediate Language**
- **LLVM IR** Generation > Generate **LLVM Intermediate Representation**
- LLVM land 🗻…… LLVM continue its job to produce assembly and then the executable unless you need bitcode.  

![compiler-steps](./assets/compiler-steps.png){: .postImageBig}  

These are the main steps and **swiftc** has many options (try! `swiftc --help`) to check each step from the command line, for example my code breaks during the **Type checking** (Sema) so running `swiftc ./bug.swift -dump-parse` would work but `swiftc ./bug.swift -dump-ast` wouldn’t. It’s interesting to checkout all those steps and I encourage you to try it out.  

At that point the bug was identified but as a n00b I had no idea how to fix it, I opened [SR-774](https://bugs.swift.org/browse/SR-774) but still didn’t manage to understand the codebase well enough to fix the bug myself. However it was an important step for me:

- I know a bit more than before about the swift compiler
- I will eventually have more knowledge and be able to fix some issues in future, you have to start somewhere…
- I didn’t blindly tried to fix my code  

Other than identify and report bugs with some more info than just *breaking-snippets*, you might also find out that the bug is fixed in newer, unreleased, versions of the compiler. In fact one week later I had another surprise from the compiler…  

![balotelli-why-always-me](./assets/balotelli-why-always-me.png){: .postImageBig}  

> Feel like Mario Balotelli  

This time the compiler had a segmentation fault:
{% highlight swift %}
let someRanges = [1..<4, 1..<8, 1..<16, 1..<32, 1..<64, 1..<128, 1..<256, 1..<512, 1..<1024]
{% endhighlight %}  

I was ready to debug it 🔫 but *“surprisingly”* the bug was already fixed🎉! It would have been a duplicate of [SR-358](https://bugs.swift.org/browse/SR-358) and I didn’t waste a single second trying to understand what was wrong with my code! I also tried to identify the commit that fixed the bug; but I had an hard time retrieving the commit hash for a given Xcode release. The bug was caused by extensions of protocols that are implementing a method with the same name of one defined in the protocol and a different signature. In my example the method has one parameter while the protocol defines “methodName” without parameters; in the reported issue one was an instance method and the other a type/class method. The compiler should produce an error when compiling that snippet because **Test** doesn’t conform to **A** but would then compile as soon as you implement the protocol.  

I’m glad that Swift is open source, we can learn a lot from it and allows us to be part of the community. I wanted to share my first step in the community, a little one but very important for me; hopefully this can help a bit who, like me, don’t have any experience in this magic land.  

**[1]** I used Swift [master/f560f3caac06723](https://github.com/apple/swift/tree/f560f3caac06723ef174e83b34b0f91b6f86f7ee), newer versions may have fixed the bugs.  
**[2]** More about [LLVM Architecture](http://www.aosabook.org/en/llvm.html).


I originally posted this article on [Medium](https://medium.com/swift-programming/when-your-swift-code-breaks-the-compiler-d2639e1b2bc8#.5pv4w6z2i)
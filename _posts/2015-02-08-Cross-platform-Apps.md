---
layout: post
title:  "Cross Platform Apps with UXKit"
permalink: "cross-platform-apps-with-UXKit"
date: 2015-02-08 21:52:00
categories: UXKit
tags: "UIKit UXKit cross platform applications"
cover: cross-platform1.jpg
---

**UXKit** is a framework used in Photos.app that attempt to port the UIKit APIs to OSX, as a replacement for AppKit. Will this framework allow us to write iOS and OSX Applications without duplicating code?  

As an iOS Developer that had to deal with the gap between UIKit and AppKit during the development of [MiniPlayer for Mac](http://blog.mpow.it/MiniPlayer-Mac) I can't hide my excitment about UXKit. AppKit is not that bad, is just not modern, easy and fast to write as UIKit. I never use Interface Builder for iOS but I had to use it in MiniPlayer because I didn't want to deal too much with AppKit.  

## Sample ##
----------
I started from [this project](https://github.com/justMaku/UXKit-Headers-And-Sample) that contains a modified version of UXKit that works on OSX 10.10.2 and tried to create a simple cross-platform sample Application. I deleted the sample and created one that could be cross-platform.  
The first step was to create a [UIXCompatibility header](https://github.com/MP0w/UXKit-Headers-And-Sample/blob/master/UIXCompatibility.h); it defines `TARGET_UXKIT` or `TARGET_UIKIT` based on the platform, includes the right framework and for `TARGET_UXKIT` uses some `@compatibility_alias` that allows me to use the same classes for both platforms.

{% highlight objc %}
// example
@compatibility_alias UICollectionView UXCollectionView;
{% endhighlight %}

Some `@compatibility_alias` were needed even from AppKit classes like `NSColor` in order to not write `#ifdef`s everywhere; all those bridges should be covered by UXKit if it will ever become public.

This is the more or less Out-of-the-Box result of using [my old and beloved MPSkewed](https://github.com/MP0w/MPSkewed) with UXKit:

![MPSkewed](./assets/cross-platform2.jpg){: .postImageBig}

`UXKit` is still far from completely compatible with `UIKit` but I really hope this project will be refined and available for everyone in future!

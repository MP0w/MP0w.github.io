---
layout: post
title:  "UIView Interactive Animations"
date:   2014-08-18 21:52:00
categories: UIView UIScrollview Animations Transitions
tags: UIView UIScrollview Animations Transitions Interactive percentDriven
summary: "Interactive animations through UIScrollView and Gesture Recognizers"
cover: "scrollview-transition.jpg"
---

As anticipated in [the presentation of the blog]({% post_url 2014-08-11-the-blog-is-alive %}) I will talk about **Interactive Transitions and Animations with UIKit**.
This is the first of three blog post talking about Transitions and Animations; I will start with UIScrollView and gesture driven animations today, UIViewController and UICollectionView Transitions later.  

> A good UX is necessary to build an awesome and usable Application; Interactive Transitions and Animations, other than good looking, could help your App to be more intuitive for Users.

1. UIView Interactive Animations
    * [Drive an Animation](#drive-an-animation)
    * [Percentage](#percentage)
    * [UIGestureRecognizer](#uigesturerecognizer)
    * [UIScrollView](#uiscrollview)
    * [Example](#example)
    * [Modifiers](#modifiers)
2. UIViewController Transitions [^1]
    * UIPercentDrivenInteractiveTransition
    * UIViewControllerAnimatedTransitioning  
3. UICollectionView Transitions [^2]
    * Cell animations
    * UICollectionViewTransitionLayout
{: #markdown-toc}


###Drive an Animation###
------
Build a **Driven Animation** is a bit different that animate an object using CoreAnimation. The easiest way to animate a view looks like this:  

{% highlight objc %}
[UIView animateWithDuration:.2 animations:^{
    myView.alpha=0;
}];
{% endhighlight %}

You can do that after a button is pressed or a cell is tapped, it will fade out the view in `0.2` seconds but there is no way to fully control it.
You can adjust the timing of an animation using CoreAnimation but is still not driven by an user action; in the same moment you start that animation is already known what will happens and when it will finish.  
To build interactive Animations we need to **define the behaviors** of an Object not depending by the time, usually is used the [Percentage](#percentage) of completion of the Animation.


###Percentage###
------
What we need to **drive the animation** is a `float` between 0.0 and 1.0[^3], as it represent 0% to 100% we can call it percentage.
Since we are talking about **Interactive Animations** we will need to get the percentage of completion from an **user interaction**.
I will talk about the most used (by myself): [UIGestureRecognizer](#uigesturerecognizer), [UIScrollView's scroll](#uiscrollview).
*There would be a third one but since is based on UICollectionViewLayout will be in the last episode.*

###UIGestureRecognizer###
------
As of iOS 7.1 SDK there are 7 types of UIGestureRecognizer

>UITapGestureRecognizer  
>UIPinchGestureRecognizer  
>UIRotationGestureRecognizer  
>UISwipeGestureRecognizer  
>UIPanGestureRecognizer  
>UIScreenEdgePanGestureRecognizer  
>UILongPressGestureRecognizer  

Not all of them are suitable for a driven Animation, for example the `UITapGestureRecognizer` do not provide you anything other than a callback after a tap occurs.
The helpful Recognizers that are:  

* `UIRotationGestureRecognizer` with its [rotation property](https://developer.apple.com/library/ios/documentation/uikit/reference/UIRotateGestureRecognizer_Class/Reference/Reference.html#//apple_ref/occ/instp/UIRotationGestureRecognizer/rotation)
* `UIPinchGestureRecognizer` with its [scale property](https://developer.apple.com/library/ios/documentation/uikit/reference/UIPinchGestureRecognizer_Class/Reference/Reference.html#//apple_ref/occ/instp/UIPinchGestureRecognizer/scale)
* `UIPanGestureRecognizer` and `UIScreenEdgePanGestureRecognizer`{: style="font-size:80%;"} with two different methods:
    1. [`translationInView:`](https://developer.apple.com/library/ios/documentation/uikit/reference/UIPanGestureRecognizer_Class/Reference/Reference.html#//apple_ref/occ/instm/UIPanGestureRecognizer/translationInView:)
    2. [`locationInView:`](https://developer.apple.com/library/ios/documentation/uikit/reference/UIGestureRecognizer_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40009279-CH1-SW23)

rotation and scale return a `float`, translationInView: locationInView: returns a `CGPoint` so you can choose x or y based on the kind of animation you need to build.
I will explain you how to normalize any of these values using [UIScrollView's `contentOffset`](#uiscrollview).

###UIScrollView###
------
UIScrollView can drive animations as well as gesture recognizers, we will use the [`contentOffset`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIScrollView_Class/Reference/UIScrollView.html#//apple_ref/doc/uid/TP40006922-CH3-SW6) captured through the ScrollView Delegate [`scrollViewDidScroll:`](https://developer.apple.com/library/ios/documentation/uikit/reference/uiscrollviewdelegate_protocol/reference/uiscrollviewdelegate.html#//apple_ref/occ/intfm/UIScrollViewDelegate/scrollViewDidScroll:).
As soon as the user scrolls the delegate will be called and we will get the offset; we need to normalize the value in order to get a percentage.
An easy way is to define wich one will be the maximum offset and calculate the percentage through it. For example:
{% highlight objc %}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset=scrollView.contentOffset.y;
    CGFloat percentage=offset/250;
    CGFloat value=250*percentage; // negative when scrolling down after the top
}
{% endhighlight %}

When the scrollView is at the top:  
![Scroll Parallax]({{site.assets-path}}scroll1.jpg){: .postImage}

When you scroll up more than the top:  
![Scroll Parallax]({{site.assets-path}}scroll2.jpg){: .postImage}

When you scroll down:  
![Scroll Parallax]({{site.assets-path}}scroll3.jpg){: .postImage}  

Now that you have a percentage value you can do your driven animation.


###Example###
------
An example is the popular Parallax[^parallax] effect on a UIScrollView[^subclass].  
Assuming that we have an `UIImageView` inside our `UIScrollView` we want to increment the height of the ImageView height when we scroll up after the top, and decrement it to have a Parallax effect while scrolling down. We just have to play with `IMAGE_HEIGHT` and the `offset`.

{% highlight objc %}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset=scrollView.contentOffset.y;
    CGFloat percentage=offset/IMAGE_HEIGHT;
    CGFloat value=IMAGE_HEIGHT*percentage; // negative when scrolling up more than the top
    // driven animation
    imageView.frame=CGRectMake(0, value, scrollView.bounds.size.width, IMAGE_HEIGHT-value);
    // if scrolling down after the top
    // y become negative
    // height = original heigh minus a negative value, so: bigger
}
{% endhighlight %} 

![Parallax example gif]({{site.assets-path}}scrollparallax.gif){: .postImage}

You can download the [Example Project]({{site.assets-path}}InteractiveAnimations.zip).

###Modifiers###
------
We can even play with our percentage for different effects. For example if we want to animate the alpha of the label, in this case, we can't use the percentage directly; using `label.alpha=percentage;` we would have a transparent label when the scollview is at top instead of a value==1, and close to 0 when we scroll. What we want is the exact opposite so we can do:
{% highlight objc %}
CGFloat alphaValue=1-fabs(percentage);
label.alpha=alphaValue;
{% endhighlight %} 

We want even the label to quickly disappear when not needed (not near to contentOffset.y==0) so we can use a [cubic funcion](https://www.google.fr/search?client=safari&rls=en&q=cubic+function&ie=UTF-8&oe=UTF-8&gfe_rd=cr&ei=lmfyU-aKNsjI8gfqn4G4CA#q=x%5E3&rls=en)
{% highlight objc %}
label.alpha=pow(alphaValue,3);//alphaValue*alphaValue*alphaValue;
{% endhighlight %} 

That was just an example, manipulate your values to build your animation properly, you can even use a [sine wave](https://www.google.fr/search?client=safari&rls=en&q=sinusoide&ie=UTF-8&oe=UTF-8&gfe_rd=cr&ei=l2nyU9D-EMjI8gfqn4G4CA#q=sin(x)&rls=en) if you like!
Last thing: be careful to the bounds of your animations, to not waste resources; in my project even after the image is not visible I continue to calculate all I need while I should control if it's needed or not.

[^1]: UIViewController Transitions has not been written yet
[^2]: UICollectionView Transitions has not been written yet
[^3]: It can be even >1 or <0  as a percentage can be >100%
[^parallax]: I'm not sure that [Parallax](http://en.wikipedia.org/wiki/Parallax) is the proper name for that effect, but everybody use this name, probably because of the cool side-effect cause by UIViewContentModeScaleAspectFill.
[^subclass]: Since UITableView and UICollectionView are subclass of UIScrollView the example fully works with them, just sometimes is needed to play with the contentInset property to not cover cells.
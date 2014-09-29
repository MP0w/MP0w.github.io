---
layout: post
title:  "UIViewControllers Transitions"
date:   2014-09-29 12:30:00
categories: UIViewController UIPercentDrivenInteractiveTransition Animations Transitions UIViewControllerAnimatedTransitioning UIViewControllerTransitioningDelegate
tags: UIViewController UIPercentDrivenInteractiveTransition Animations Transitions Interactive percentDriven UIViewControllerAnimatedTransitioning UIViewControllerTransitioningDelegate
summary: "UIViewControllers animated or driven transitions"
cover: "viewcontroller-transition.jpg"
excerpt: "More than one month after the first of three articles about Animated and Interactive Transitions in UIKit, I finally found the time to write the second (this) article. I will talk about something really interesting, **UIViewController transitions**, introcuded in iOS 7 and finally fixed in iOS 8."
---

<style>
@media screen and (max-width: 450px) {
code,h2{
word-break: break-all;
}
}
</style>

More than one month after the [first]({% post_url 2014-08-18-UIView-transitions %}) of three articles about Animated and Interactive Transitions in UIKit, I finally found the time to write the second (this) article. I will talk about something really interesting, **UIViewController transitions**, introcuded in iOS 7 and finally fixed in iOS 8[^1].

> A good UX is necessary to build an awesome and usable Application; Interactive Transitions and Animations, other than good looking, could help your App to be more intuitive for Users.

1. [UIView Interactive Animations]({% post_url 2014-08-18-UIView-transitions %})
    * [Drive an Animation]({% post_url 2014-08-18-UIView-transitions %}/#drive-an-animation)
    * [Percentage]({% post_url 2014-08-18-UIView-transitions %}/#percentage)
    * [UIGestureRecognizer]({% post_url 2014-08-18-UIView-transitions %}/#uigesturerecognizer)
    * [UIScrollView]({% post_url 2014-08-18-UIView-transitions %}/#uiscrollview)
    * [Example]({% post_url 2014-08-18-UIView-transitions %}/#example)
    * [Modifiers]({% post_url 2014-08-18-UIView-transitions %}/#modifiers)
2. UIViewController Transitions
    * [UX](#ux)
    * [UIViewControllerTransitioningDelegate](#uiviewcontrollertransitioningdelegate)
    * [UIViewControllerAnimatedTransitioning](#uiviewcontrolleranimatedtransitioning)
    * [UIPercentDrivenInteractiveTransition](#uipercentdriveninteractivetransition)
    * [Example](#example)
    * [Landscape](#landscape)
3. UICollectionView Transitions [^2]
    * Cell animations
    * UICollectionViewTransitionLayout
{: #markdown-toc}


##UX##
--------

For many years and in the 99% of the Applications all developers used the UIKit built in transitions, the popular pop and push animation of `UINavigationController` or `UIViewController`'s modal transition. There was even a little margin of customization through the property [`UIModalTransitionStyle modalTransitionStyle`](https://developer.apple.com/library/ios/Documentation/UIKit/Reference/UIViewController_Class/index.html#//apple_ref/occ/instp/UIViewController/modalTransitionStyle) that allowed 4 differents values:


{% highlight objc %}
typedef NS_ENUM(NSInteger, UIModalTransitionStyle) {
    UIModalTransitionStyleCoverVertical = 0,
    UIModalTransitionStyleFlipHorizontal,
    UIModalTransitionStyleCrossDissolve,
    UIModalTransitionStylePartialCurl,
};
{% endhighlight %}

you could do something different using `+ (void)transitionFromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion` but even that was not enough, almost everyone used the default transitions.
Especially for `UINavigationController` pop something changed with iOS 7, it has built in support to pop a ViewController using a swipe from the left edge [^3]; this is a really natural movement that enhance the **User Experience** of iOS, because is more natural than search with the finger a little *Back Button* and is even more fast. Unfortunately the modal ViewController's lacks this feature.
This tweet better reflect why *Interactive Transitions* are so important to make a good **UX**:

<div class="tweet"><blockquote class="twitter-tweet" lang="it"><p>WHY CANT I JUST USE A SWIPE TO GET BACK <a href="https://t.co/oUTIupNwjM">https://t.co/oUTIupNwjM</a></p>&mdash; Sentry (@Sentry_NC) <a href="https://twitter.com/Sentry_NC/status/516101700328095744">28 Settembre 2014</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script></div>

Usually, building custom transitions, can be a good pratice present a **Modal ViewController** animated and allow an **interactive transiton** to dismiss it, as we can see in *Mail.app* on iOS 8

![Mail.app]({{site.assets-path}}mail8transition.gif){: .postImage}


##UIViewControllerTransitioningDelegate##
--------

Apple introduced some new APIs in iOS 7 to make developer's life easier, one useful for Animated transitions, [the protocol `UIViewControllerAnimatedTransitioning`](https://developer.apple.com/library/ios/Documentation/UIKit/Reference/UIViewControllerAnimatedTransitioning_Protocol/index.html), and one for interactive transitions, [the class `UIPercentDrivenInteractiveTransition`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIPercentDrivenInteractiveTransition_class/index.html).  
To be able to start an animated or interactive transition we have to tell to the **UIViewController** who will coordinate his transition, to do that we have to set the [`id <UIViewControllerTransitioningDelegate> transitioningDelegate`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/#//apple_ref/occ/instp/UIViewController/transitioningDelegate), the delegate will be in charge of provide the object that will coordinate the whole transition:

1. The animated presentation  
`- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source`
2. The animated dismiss  
`- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed`
3. The interactive presentation  
`- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator`
4. The interactive dismiss  
`- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator`

Returning `nil` will end up using the default transition.


##UIViewControllerAnimatedTransitioning##
--------
To build animated transition we just need to pass an object conforming to [`UIViewControllerAnimatedTransitioning`](https://developer.apple.com/library/ios/Documentation/UIKit/Reference/UIViewControllerAnimatedTransitioning_Protocol/index.html) , its methods are pretty easy and to build a basic animated transition we can just do:  

{% highlight objc %}
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 2;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC=[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC=[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *contextView=[transitionContext containerView];

    [contextView insertSubview:toVC.view belowSubview:fromVC.view];

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.alpha=0;
        toVC.view.alpha=1;
    }completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
{% endhighlight %}

The transitionContext will provide us all the stuff necessary to build our animation, then will eventually call [`- (void)animationEnded:(BOOL) transitionCompleted`](https://developer.apple.com/library/ios/Documentation/UIKit/Reference/UIViewControllerAnimatedTransitioning_Protocol/index.html#//apple_ref/occ/intfm/UIViewControllerAnimatedTransitioning/animationEnded:) if implemented. You can play with frames, transforms, alpha or whatever you want to build your personal custom animation.


##UIPercentDrivenInteractiveTransition##
--------

Build a *driven interactive transition* is a bit more long, we need something that [Drive an Animation]({% post_url 2014-08-18-UIView-transitions %}/#drive-an-animation) and generate a [Percentage]({% post_url 2014-08-18-UIView-transitions %}/#percentage) of progress, a PanGesture is great for this purpose.
We should even subclass [UIPercentDrivenInteractiveTransition](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIPercentDrivenInteractiveTransition_class/index.html) and override its methods that will do the animation itself.
The steps of an hypothetical driven dismiss animation are the following:

1. Set the ViewController's transitionDelegate
2. the transition delegate will provide the `animationControllerForDismissedController:` and `interactionControllerForDismissal:` (our `UIPercentDrivenInteractiveTransition` subclass)
3. Once the gesture began we call `dismissViewControllerAnimated:complention:` that will `startInteractiveTransition:`
4. Our gesture will generate the progress [Percentage]({% post_url 2014-08-18-UIView-transitions %}/#percentage) and pass it to `updateInteractiveTransition:`
5. Once finished we can `cancelInteractiveTransition` or `finishInteractiveTransition`

The core of the animation will be something like:

{% highlight objc %}
#pragma mark - UIPercentDrivenInteractiveTransition

- (void)updateInteractiveTransition:(CGFloat)percentComplete{

    if (percentComplete<0) {
        percentComplete=0;
    }else if (percentComplete>1){
        percentComplete=1;
    }

    UIViewController* toViewController = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    CGFloat scale=1-(1-0.7)*percentComplete;

    CGRect frame=toViewController.view.frame;
    frame.origin.y=toViewController.view.bounds.size.height*percentComplete-toViewController.view.bounds.size.height;
    toViewController.view.frame=frame;
    fromViewController.view.transform=CGAffineTransformMakeScale(scale,scale);

}
{% endhighlight %}


##Example##
--------

I quickly build an example that replicate iOS 8's Mail.app animation, is something basic, don't use it at home.
[Download ZIP]({{site.assets-path}}VCtransition.zip){: .button}
As you can see in the code, it will animate the presentation and will drive the interactive dismiss through a `UIPanGestureRecognizer`, *fromViewController* is scaled and *toViewController* go up or down.
Obviously we don't want to create so simple animations, now that we have these great APIs we want to build new UIs that are not only limited to present or dismiss a *ViewController*, we want outstanding transitions in our Apps that enhance the UX.
Yo give you an idea I did a quick test, some months ago, that end up in that example:

<iframe name='quickcast' src='http://quick.as/embed/yvw7u6mb' scrolling='no' frameborder='0' width='100%' allowfullscreen></iframe><script src='http://quick.as/embed/script/1.64'></script>


##Landscape##
--------

When Apple introduced transitions in iOS 7, decided to not manage the orientation of the `containerView`

> For custom presentation transitions we setup an intermediate view between the window and the windows rootViewController's view. This view is the containerView that you perform your animation within. Due to an implementation detail of auto-rotation on iOS, when the interface rotates we apply an affine transform to the windows rootViewController's view and modify its bounds accordingly. Because the containerView inherits its dimensions from the window instead of the root view controller's view, it is always in the portrait orientation.

>If your presentation animation depends upon the orientation of the presenting view controller, you will need to detect the presenting view controller's orientation and modify your animation appropriately. The system will apply the correct transform to the incoming view controller but you're animator need to configure the frame of the incoming view controller.

That was really annoying for Developers that needed to build custom transitions on iPad or on an iPhone App that allowed rotation. Fortunately in iOS 8 this is changed and we don't need workarounds anymore. However if you still need to support iOS 7 you will need to manage it, some people [calculate the frames based on the rotation](http://www.brightec.co.uk/blog/ios-7-custom-view-controller-transitions-and-rotation-making-it-all-work), but this is long, annoying and may break easily especially when you even need to transform your *Views*.
My solution was to place a new `UIWindow` on the top on the animation's `containerView` during the animation and use the `rootViewController`'s view as `containerView`; since that view rotate properly *my ViewController's views* can rotate with it, and I don't need to change half of the code every time I want to change something in the animation.

[^1]: Was not really broken but Apple missed some important parts like [Landscape support](#landscape).
[^2]: UICollectionView Transitions has not been written yet.
[^3]: An App that use a custom NavigationBar may inadvertently disable that using [`setNavigationBarHidden:`](https://developer.apple.com/library/ios/Documentation/UIKit/Reference/UINavigationController_Class/index.html#//apple_ref/occ/instm/UINavigationController/setNavigationBarHidden:animated:) selector, make sure you use [`self.navigationBar.hidden=YES`](https://developer.apple.com/library/ios/Documentation/UIKit/Reference/UIView_class/index.html#//apple_ref/occ/instp/UIView/hidden) to prenvent this.
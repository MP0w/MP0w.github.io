---
layout: sitepage
title: MiniPlayer
cover: MiniPlayerCover.jpg
cover-centered: 1
permalink: MiniPlayer-Mac/
summary: "MiniPlayer lets you control and search your Music from all your favorite services. You will love to listen your Music thanks to its simple and beautiful Design."
---
##{{page.title}}##
{: style="display:none;"}

{% assign app = site.data.apps[0] %}


|![MiniPlayer Icon]({{ site.assets-path }}{{app.icon}}){: .profilepic}|[Download](http://mpow.it/MiniPlayer.zip "Download MiniPlayer"){: .button}|
{: .products}
-------
{% include donate.html %}
{{app.description}}

Three Themes are available : Dynamic, Black and White.  

* Table of Contents Placeholder
{:toc}

###Why is not in the Mac App Store?###
------------
I decided to give Developers the opportunity to build plug-ins, due to the limitation of the sandbox I have to avoid the MAS[^MAS]. If I see that nobody will use/build external plugin I can try to submit in future (is not sure that is accepted because I need some sandbox exceptions)

###Users###
---------
<div class="twittertimeline">
<a class="twitter-timeline" href="https://twitter.com/hashtag/MiniPlayer" data-widget-id="341248617748758528">#MiniPlayer Tweet</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
</div>

###Plug-Ins###
----------
* You can use the built-in Plug-Ins (Spotify, iTunes,Rdio) in the Menu Music Services (Status Bar)
* [Dezeer plugin (beta) by Me](https://www.dropbox.com/s/8hmj6jie7ctxloa/MPSafariDezeerPlugin.miniplayerplugin.zip "Deezer Plug-In")
* Nobody made a third part Plug-In yet...

###Developers###
---------
* You can make your own Plug-In, look [my example on Github](https://github.com/MP0w/MiniPlayer-Plug-In "example plug-in"), all you have to do is a bundle with the extension `.miniplayerplugin` and the `NSPrincipalClass` that conform to the `<MPMiniPlayerPlugin>` protocol
* Your Plug-In can be listed here or included in **MiniPlayer** if you wish, just contact me at manzopower@icloud.com

<div style="width: 290px;margin: 0 auto;">
<img src="{{site.assets-path}}miniplayerSearch.jpg" width="290" />
<iframe width="290" height="155" src="//www.youtube.com/embed/D8XW5Od6QJo" frameborder="0" allowfullscreen></iframe>
</div>

[^MAS]: MAS is the [Acronym](http://en.wikipedia.org/wiki/Acronym "Acronym definition") of  Mac App Store

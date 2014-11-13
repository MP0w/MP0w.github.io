---
layout: depiction
title: "MiniPlayer Changelog"
permalink: MiniPlayer-Mac-changelog/
tags: changelog
summary: "MiniPlayer lets you control and search your Music from all your favorite services. You will love to listen your Music thanks to its simple and beautiful Design."
---

<style>
h2{
font-weight:100 !important;
}
</style>

|![MiniPlayer Icon]({{ site.assets-path }}{{site.data.apps[0].icon}}){: .profilepic}|{{site.data.changelogs[0].mpmac[0].version}}|
{: .products}
---------------

[{% include appStoreButtonSVG.html %}](https://itunes.apple.com/us/app/miniplayer/id931202332?l=it&ls=1&mt=12)

{{site.data.changelogs[0].mpmac[0].changes | markdownify}}  
*released on {{site.data.changelogs[0].mpmac[0].date | date: "%B %-d, %Y" }}*  


{% for release in site.data.changelogs[0].mpmac offset:1 %}
##{{release.version}}##
---------------
{{release.changes | markdownify}}  
*released on {{ release.date | date: "%B %-d, %Y" }}*
{% endfor %}

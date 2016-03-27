---
layout: sitepage
title: "MiniPlayer Changelog"
cover: MiniPlayerCover.jpg
cover-centered: 1
permalink: MiniPlayer-iOS-changelog/
tags: changelog
summary: "MiniPlayer lets you control and search your Music from all your favorite services. You will love to listen your Music thanks to its simple and beautiful Design."
---

<style>
h2{
font-weight:100 !important;
}
</style>

|![MiniPlayer Icon]({{ site.assets-path }}{{site.data.apps[0].icon}}){: .profilepic}|{{site.data.changelogs[1].mpios[0].version}}|
{: .products}
---------------

{{site.data.changelogs[1].mpios[0].changes | markdownify}}  
*released on {{site.data.changelogs[0].mpmac[0].date | date: "%B %-d, %Y" }}*  


{% for release in site.data.changelogs[1].mpios offset:1 %}
## {{release.version}} ##
---------------
{{release.changes | markdownify}}  
*released on {{ release.date | date: "%B %-d, %Y" }}*
{% endfor %}
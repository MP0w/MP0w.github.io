---
layout: sitepage
title: "MiniPlayer Changelog"
cover: MiniPlayerCover.jpg
cover-centered: 1
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
{% include donate.html %}
{{site.data.changelogs[0].mpmac[0].changes | markdownify}}  
*{{site.data.changelogs[0].mpmac[0].date}}*  


{% for release in site.data.changelogs[0].mpmac offset:1 %}
##{{release.version}}##
---------------
{{release.changes | markdownify}}  
*{{release.date}}*  
{% endfor %}
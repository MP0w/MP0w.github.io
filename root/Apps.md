---
layout: sitepage
title: Apps
cover: MiniPlayerCover.jpg
cover-centered: 1
tag: apps cannibalkiwi appstore mac osx
permalink: Apps/
---
<style>.product{margin-bottom: 60px;}</style>

{% for app in site.data.apps %}

|![{{app.name}} Icon]({{ site.assets-path }}{{app.icon}}){: .profilepic}|{{app.name}}|
{: .products}
---------
{{app.description | markdownify}}
[More]({{app.url}} "More"){: .button}
{: .product}
{% endfor %}
---
layout: sitepage
title: Tweaks
cover: MiniPlayerCover.jpg
cover-centered: 1
permalink: Tweaks/
---

<style>
.product{
	margin-bottom: 60px;
}
.video{
	display: block;
	margin: 10px auto;
	margin-top: 15px !important;
}
</style>


{% for tweak in site.data.tweaks %}

{% if tweak.icon %}|![{{tweak.name}} Icon]({{ site.assets-path }}{{tweak.icon}}){: .profilepic}{% endif %}|{{tweak.name}}|
{: .products}
---------
{{tweak.description | markdownify}}
{% if tweak.video %}
  {{tweak.video}}{: .video}
{% endif %}  
[Install]({{tweak.url}} "Install"){: .button}
{: .product}
{% endfor %}


Some other Tweaks have been deprecated because of iOS changes during these years, they are all in my heart and I hope in the hearts of thousands of users that used them!
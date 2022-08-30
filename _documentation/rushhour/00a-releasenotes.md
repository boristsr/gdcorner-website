---
title:  "Release Notes - Rush Hour"
subtitle: "Rush Hour Release Notes"
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour]
comments: true
categories: product
version: 1.0
product-type: Tool
product: rushhour
---

# Archive

<ul>
{% for post in site.documentation reversed %}
    {% if post.product == page.product %}
        {% if post.tags contains "releasenotes" %}
            <li>
                <a href="{{ post.url | relative_url }}" class="{% if post.url == page.url %}is-active{% endif %}">{{ post.title }}</a>
            </li>
        {% endif %}
    {% endif %}
{% endfor %}
</ul>

{% assign printed_posts = 0 %}
{% for post in site.documentation reversed %}
    {% if post.product == page.product %}
        {% if post.tags contains "releasenotes" %}
            {% assign printed_posts = printed_posts | plus: 1 %}
            {% if printed_posts == 1 %}
# Latest - {{ post.title }}
<div class="content">
    {{ post.content | markdownify }}
</div>
            {% endif %}
        {% endif %}
    {% endif %}
{% endfor %}
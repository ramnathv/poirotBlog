---
title: Posts
layout: gallery
---

<style>
ul.thumbnails {
  margin-top: 10px;
}
</style>

<ul class="thumbnails">
  {{# pages }}
  {{# thumbnail }}
  <li class="span4">
    <div class="thumbnail">
      <a href="/posts/{{ link }}">
        <img src="{{thumbnail}}" alt="">
      </a>
      <p>
        {{{title}}}<br/>
        <span class='date'>{{date}}</span>
      </p>
    </div>
  </li>
  {{/ thumbnail }}
  {{/ pages }}
</ul>

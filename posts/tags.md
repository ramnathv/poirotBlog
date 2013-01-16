---
title: Tags
--- 

<ul class="tag_box inline">
{{# tags.all }}
  <li>
    <a href="#{{ name }}-href">{{ name }} <span>{{ count }}</span></a>
  </li>
{{/ tags.all }}
</ul>
{{# tags.all }}
  <h2 id="{{ name }}-href">{{ name }}</h2>
  <ul>
  {{# pages }}
    <li><a href="{{ link }}">{{ title }}</a></li>
  {{/ pages }}
  </ul>
{{/ tags.all }}

---
title       : TimeLine Maps Revisited
job         : McGill University
date        : 2012-12-12
widgets     : [disqus]   # {mathjax, quiz, bootstrap}
thumbnail   : ../assets/img/carousel.png
tags: [tag2, tag3]
--- 

<script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.7.min.js"></script>

### Introduction

Recently, Christopher Gandrud posted an excellent [blog article](http://christophergandrud.github.com/amc-site/maps.html) on how to display timeline maps using `googleVis` and `Twitter Bootstrap`. This slide deck is inspired by the article. 

The main objective of this slide deck is to illustrate

- How to insert Timeline Maps directly in Slidify.
- How to use mustache templates to work with `bootstrap`.


---

**Step 1. Load googleVis and Dataset**

We will first load `googleVis` and an example dataset. This code is directly borrowed from [Christopher Gandrud](https://github.com/christophergandrud/amcData/blob/master/SourceCode/Descriptive/AMCTotalMaps.R)


```r
library(googleVis)

# Load most recent data
URL <- "https://raw.github.com/christophergandrud/amcData/master/MainData/amcCountryYear.csv"
Full <- RCurl::getURL(URL)
Full <- read.csv(textConnection(Full))

# Clean for mapping 
Full <- plyr::rename(Full, c(NumAMCCountryNoNA = "TotalAmcCreated"))
```


---

**Step 2. Generate GeoMaps**


```r
MapAMC <- function(y){
  yearTemp <- y  
  TempMap <-  gvisGeoMap(subset(Full, year == yearTemp &
    TotalAmcCreated != 0), 
    locationvar = "ISOCode", 
    numvar = "TotalAmcCreated",
    options = list(
      colors = "[0xECE7F2, 0xA6BDDB, 0x2B8CBE]",
      width = "700px",
      height = "400px"
    ))
  print(TempMap, file = paste("assets/fig/AMCMap", yearTemp, ".html", sep = ""), 
   tag = "chart")
}

Years <- c(1980, 2011)
lapply(Years, MapAMC)
```


---

**Step 3. DRY Approach to Carousels**

A clean, DRY and reusable approach to using `bootstrap` with markdown is to separate the markup and the content. One way to achieve this is to 

1. Use **mustache** templates to encapsulate the markup.
2. Generate **data** to populate the template.
3. Use **whisker** to render the view.

---

**Step 3A. Create Layout**

First, we create a `mustache` template to encapsulate the markup.


```
<div id="{{id}}" class="carousel slide">
  <!-- Carousel items -->
  <div class="carousel-inner">
  {{# items }}
    <div class="item {{active}}">
       <iframe src="{{src}}" height = 400 width = 700></iframe>
       <div class="carousel-caption">
         <center><h1 style="color:white">{{{caption}}}<h1></center>
       </div>
    </div>
  {{/ items }}
  </div>
  <!-- Carousel nav -->
  <a class="carousel-control left" href="#{{id}}" data-slide="prev">&lsaquo;</a>
  <a class="carousel-control right" href="#{{id}}" data-slide="next">&rsaquo;</a>
</div>
```


---

**Step 3B. Generate Data**

Second, we generate data to populate the template.


```r
carousel = list(
  id    = 'geomaps',
  items = slidify:::zip_vectors(
    src     = sprintf('assets/fig/AMCMap%s.html', Years),
    active  = c('active', rep("", length(Years) - 1)),
    caption = Years
  )
)
```


---

**Step 3C. Render Carousel**

Finally, we render the carousel using the `whisker` package.


```
<div id="geomaps" class="carousel slide">
  <!-- Carousel items -->
  <div class="carousel-inner">
    <div class="item active">
       <iframe src="assets/fig/AMCMap1980.html" height = 400 width = 700></iframe>
       <div class="carousel-caption">
         <center><h1 style="color:white">1980<h1></center>
       </div>
    </div>
    <div class="item ">
       <iframe src="assets/fig/AMCMap2011.html" height = 400 width = 700></iframe>
       <div class="carousel-caption">
         <center><h1 style="color:white">2011<h1></center>
       </div>
    </div>
  </div>
  <!-- Carousel nav -->
  <a class="carousel-control left" href="#geomaps" data-slide="prev">&lsaquo;</a>
  <a class="carousel-control right" href="#geomaps" data-slide="next">&rsaquo;</a>
</div>
```


---

**Display Carousel**

<div id="geomaps" class="carousel slide">
  <!-- Carousel items -->
  <div class="carousel-inner">
    <div class="item active">
       <iframe src="assets/fig/AMCMap1980.html" height = 400 width = 700></iframe>
       <div class="carousel-caption">
         <center><h1 style="color:white">1980<h1></center>
       </div>
    </div>
    <div class="item ">
       <iframe src="assets/fig/AMCMap2011.html" height = 400 width = 700></iframe>
       <div class="carousel-caption">
         <center><h1 style="color:white">2011<h1></center>
       </div>
    </div>
  </div>
  <!-- Carousel nav -->
  <a class="carousel-control left" href="#geomaps" data-slide="prev">&lsaquo;</a>
  <a class="carousel-control right" href="#geomaps" data-slide="next">&rsaquo;</a>
</div>


---

**Note**

Slidify allows use of `bootstrap` directly by including it as a `widget` in the YAML front matter. The widgets themselves are loaded from [slidifyLibraries](http://github.com/ramnathv/slidifyLibraries) which is a support package consisting of external libraries used by Slidify.

Currently, the `boostrap` widget does not ship with custom layouts. But my plan is to add commonly used layouts so that users of Slidify can directly use it without having to do any more work. 

If you are familiar with `bootstrap` and `mustache`, you can contribute to this by forking `slidifyLibraries`, adding layouts to `libraries/widgets/bootstrap/layouts` and sending me a pull request.



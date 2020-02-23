---
layout: post
title: Every Building in Denver
date: 2018-10-30
categories: visualization qgis denver
---

I was inspired by the [Map of Every
Building](https://www.nytimes.com/interactive/2018/10/12/us/map-of-every-building-in-the-united-states.html)
by the NY Times this a few weeks ago and decided to use [the city of Denver's
Building Outlines Dataset](https://www.denvergov.org/opendata/dataset/city-and-county-of-denver-building-outlines-2016)
to create a map of every building specifically for Denver.

Because I had a bit more metadata on the building outlines, I used QGis to
create a map that colored different buildings based on their building type.

![]({{site.url}}/assets/img/posts/2018-10-30-every-building/every-building-denver-1.png)

_[The site.](https://datacolorado.org/denver_buildings)_

The building outlines dataset has metadata on building type: residential,
commercial, public, etc. I used
[QGis](https://qgis.org/en/site/forusers/download.html) to load the shapefile
included in the building datasets and defined each building type with a
different color.

Using the [QTile Plugin](https://plugins.qgis.org/plugins/qtiles/), I was able
to export my map to a browser-presentable [slippy
map](https://wiki.openstreetmap.org/wiki/Slippy_Map). The QTile plugin created
all my [map tiles](https://wiki.openstreetmap.org/wiki/Tiles) and a simple
HTML/JavaScript snippet to view and interact with my map. The final result
[can be seen here](https://datacolorado.org/denver_buildings).

Zooming and panning the map around led to some interesting observations about Denver:

### Visible Arteries

![I-25 and Downtown Denver]({{site.url}}/assets/img/posts/2018-10-30-every-building/i25.png)

I-25 snakes through the city like a giant river. Commercial buildings (yellow)
line the edges of major roads, such as Speer Boulevard and 6th Avenue. South of
downtown, the major industrial parks (brown) are clustered together.

### Neighborhood Shapes

![Typical Denver city Neighborhood]({{site.url}}/assets/img/posts/2018-10-30-every-building/typical-denver-neighborhood.png) | ![Newer Homes in Stapleton]({{site.url}}/assets/img/posts/2018-10-30-every-building/stapleton.png)
<center>Typical Denver homes</center> | <center>Newer homes in Stapleton</center>

Older Denver residential neighborhoods, shown in blue, are laid out like a grid.
Nearly all of them are in small lots with sheds or garages in the back, as
indicated in red. Compare this with newer affluent neighborhoods, such as
Stapleton. Stapleton homes are larger and laid out with more space separating
the homes, without detached garages. From the map, you can see winding
cul-de-sacs, rather than the more space-efficient grid structure.


### Thoughts

This was a relatively quick weekend project that resulted in a way to let me see
Denver in a different light. Play with [the map
yourself](https://datacolorado.org/denver_buildings) and try to find more
interesting patterns, or dig into [Denver's Open Data
Portal](https://www.denvergov.org/opendata) and explore Denver on your own!


<!--
## Step by Step

Here are the steps I took to create map of buildings in Denver:

- Download a shapefile of
[building outlines](https://www.denvergov.org/opendata/dataset/city-and-county-of-denver-building-outlines-2016)
from Denver's Open Data portal.
You can also use Microsoft's building outline set for the entire country, like the NYtimes did,
or look for a similar dataset from your own city.

- Install [QGis](https://qgis.org/en/site/forusers/download.html).

- Load the shapefile into QGis as a layer.

- Create a _categorical map_ and set the fill color for every `BLDG_TYPE` to a different color.

- Install the [QTile Plugin](https://plugins.qgis.org/plugins/qtiles/).

-->

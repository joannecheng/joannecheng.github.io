class MapObject
  map:
    pos: d3.scale.linear()

class Interaction
  scroll: ->
    # pixels that have been scrolled vertically. can also be called 'scrollY'
    tY = window.scrollY
    # window.innerHeight is viewport height
    wH = window.innerHeight
    bY = tY + (wH/2)
    # full document height. subtract 200 for the header
    dH = $(document).height()

    start = wH/dH
    console.log start
    # domain defines breaks as a percentage of document height
    domain = [start, 0.780, 0.880, 1.00]
    # range defines corresponding map locations (NEED TO CHANGE)
    range = [0.0, 0.2, 0.308, 0.9]

    mapObject.map.pos.domain(domain).range(range).clamp(true)

    console.log "mappos " + mapObject.map.pos(bY/dH)

    yOff = (wH - 3600) * mapObject.map.pos(bY/dH)

    offsetter = d3.select('#g-map-scrolloffset')
    console.log yOff
    offsetter.style('top', "#{yOff}px")

class Scroller
  constructor: ->
    @scrollListener()

  scrollListener: =>
    document.addEventListener("scroll", interaction.scroll, false)

mapObject = new MapObject
interaction = new Interaction
new Scroller()

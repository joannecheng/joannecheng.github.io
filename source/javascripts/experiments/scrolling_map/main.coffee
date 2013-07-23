class Interaction
  scroll: ->
    console.log "scrollscrollscrool"


class Scroller
  constructor: ->
    @scrollListener()

  scrollListener: =>
    document.addEventListener("scroll", interaction.scroll, false)

interaction = new Interaction
new Scroller()

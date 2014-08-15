h = 350
w = 400

bechdel_labels = [
  "Fewer than two women",
  "Women don't talk to each other",
  "Women only talk about men",
  "Passes"
]

d3.json '/experiments/bechdel_test/bechdel_over_time.json', (data) ->
  svg = d3.select('.content')
    .append('svg')
    .attr('height', h)
    .attr('width', '100%')

  bars = svg
    .append('g')
    .attr('height', h)
    .attr('width', w)

  barsForYear = bars.selectAll('g.bars')
    .data(data)
    .enter()
    .append('g')
    .classed('bars', true)
    .attr('index', (d, i) -> i)

  barsForYear.selectAll('rect.bar-data')
    .data((d) -> d)
    .enter()
    .append('rect')
    .attr('height', (d) -> (d.percent/100) * h)
    .attr('width', w/data.length - 1)
    .attr('x', (d) ->
      index = d3.select(@.parentNode).attr('index')
      (w/data.length)*index
    )
    .attr('y', (d, i) ->
      previousHeights = 0
      data = @.parentNode.__data__
      index = i
      while index > 0
        previousHeights += (data[index-1].percent/100) * h
        index -= 1
      previousHeights
    )
    .attr('class', (d) -> "result#{d.bechdel_result} #{d.years}")
    .classed('bar-data', true)
    .on('mouseover', (d) ->
      d3.select(this)
        .classed('selected', true)

      t = tooltip()
        .xAttr('years')
        .xLabel('Years')
        .isTimeSeries(false)
        .yLabel('Percent')
        .yAttr('percent')

      svg.call(t)
    )
    .on('mouseout', (d) ->
      d3.selectAll('.tooltip').remove()
      d3.select(this)
        .classed('selected', false)
    )

  sideLabels = svg.append('g')
    .classed('labels', true)
    .selectAll('text.label')
    .data(bechdel_labels)
    .enter()

  keyForLabels = sideLabels
    .append('rect')
    .attr('class', (d, i) -> "result#{i}")
    .attr('width', 10)
    .attr('height', 10)
    .attr('x', w + 15)
    .attr('y', (d, i) -> i * h/4 + 4)

  textForLabels = sideLabels
    .append('foreignObject')
    .attr('y', (d, i) -> i * h/4)
    .attr('x', w)
    .attr('width', 150)
    .attr('height', 100)
    .append('xhtml:body')
    .html((d) -> "<div class='graph-label'>#{d}</div>")
    .classed('label', true)

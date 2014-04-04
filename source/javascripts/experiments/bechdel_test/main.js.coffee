h = 200
w = 400

d3.json '/experiments/bechdel_test/bechdel_over_time.json', (data) ->
  svg = d3.select('.content')
    .append('svg')
    .attr('height', h)
    .attr('width', w)

  barsForYear = svg.selectAll('g.bars')
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

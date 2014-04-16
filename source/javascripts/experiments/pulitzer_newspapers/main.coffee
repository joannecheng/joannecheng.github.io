
d3.csv 'pulitzer_newspapers/pulitzer_circulation_data.csv', (data) ->
  w = 1000
  h = 1200
  svg = d3.select('.content')
    .append('svg')
    .attr('width', w)
    .attr('height', h)
    .append('g')

  circScale = d3.scale.linear()
    .domain([0, 2378827])
    .range([800, 20])

  svg.selectAll('rect.newspaper')
    .data(data)
    .enter()
    .append('rect')
    .classed('newspaper', true)
    .attr('width', 4)
    .attr('height', 4)
    .attr('x', 10)
    #.text((d) -> d.Newspaper)
    .attr('y', (d) ->
      circScale parseInt(d['Daily Circulation, 2004'].replace(/,/g, ''))
    )

  svg.selectAll('rect.newspaper1')
    .data(data)
    .enter()
    .append('rect')
    .classed('newspaper1', true)
    .attr('width', 4)
    .attr('height', 4)
    .attr('x', 400)
    #.text((d) -> d.Newspaper)
    .attr('y', (d) ->
      circScale parseInt(d['Daily Circulation, 2013'].replace(/,/g, ''))
    )

  svg.selectAll('line.newspaper')
    .data(data)
    .enter()
    .append('line')
    .classed('newspaper', true)
    .attr('x1', 12)
    .attr('x2', 400)
    .attr('y1', (d) -> 
      circScale parseInt(d['Daily Circulation, 2004'].replace(/,/g, ''))
    )
    .attr('y2', (d) ->
      circScale parseInt(d['Daily Circulation, 2013'].replace(/,/g, ''))
    )
    .attr('stroke', (d) ->
      circ2013 = parseInt(d['Daily Circulation, 2013'].replace(/,/g, ''))
      circ2004 = parseInt(d['Daily Circulation, 2004'].replace(/,/g, ''))
      console.log "#{circ2013} #{circ2004}"

      console.log "#{circ2013 > circ2004} #{d['Newspaper']}"
      if circ2013 > circ2004
        'red'
      else
        'black'
    )

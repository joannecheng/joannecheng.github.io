d3.csv '/experiments/github_viz/data.json', (error, rawData) ->
  insertMeanIntoDatum = (datum) ->
    if isNaN(datum.merged_at)
      datum.merged_at = Date.parse(new Date())
    [datum.created_at, datum.created_at + 10, datum.merged_at - 10, datum.merged_at]

  width = 1000
  height = 400
  paddingBottom = 20
  data = _.map rawData, (d) ->
    { id: d.id, created_at: Date.parse(d.created_at), merged_at: Date.parse(d.merged_at) }

  minDate = d3.min _.pluck data, 'created_at'
  maxDate = d3.max _.pluck(_.reject(data, (d) -> d.merged_at == 'nil'), 'merged_at')
  xScale = d3.scale.linear().domain([minDate, Date.parse(new Date())]).range([3, width-3])
  yScale = d3.scale.linear().domain([0, Date.parse(new Date()) - minDate]).range([275, 10])

  svg = d3.select('.content')
    .append('svg')
    .attr('class', 'data-container')
    .attr('width', width + 100)
    .attr('height', height + paddingBottom)

  svg.selectAll('line.x-axis')
    .data([0, width]).enter()
    .append('line')
    .attr('x1', 0)
    .attr('x2', width)
    .attr('y1', height)
    .attr('y2', height)
    .attr('stroke', 'black')
    .attr('class', 'x-axis')

  line = d3.svg.line()
    .x((d) ->
      xScale(d))
    .y((d, i) ->
      datum = this.__data__
      if (i == 0 || i == datum.length- 1)
        300
      else
        yScale(_.last(datum) - _.first(datum))
    ).interpolate('basis')

  for datum in data
    datum = insertMeanIntoDatum(datum)
    svg.append('path')
      .datum(datum)
      .attr('d', line)
      .style("fill", "none")
      .style("stroke", "#000000")
      .style("stroke-width", 1)
      .style('opacity', 0.2)
      .attr('transform', "translate(0, 100)")

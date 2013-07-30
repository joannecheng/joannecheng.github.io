lineHeight = 22
lineSpacing = 13

sortByWins = (data) ->
  _.sortBy data, (d) ->
    parseInt d.standing.split('-')[1]

sortByPayroll = (data) ->
  _.sortBy data, (d) ->
    -1 * parseInt d.payroll

findTeamPosition = (d, data) ->
  _.findIndex sortByWins(data), (row) ->
    row.teamname == d.teamname

d3.csv '/experiments/baseball/2012payrollstandings.csv', (error, data) ->
  svg = d3.select('.baseball-chart')
    .append('svg')
    .append('g')

  teamList = svg.selectAll('text.team-name')
    .data(sortByWins(data)).enter()
    .append('text')
    .attr('x', 10)
    .attr('y', (d, i) -> i * lineHeight + lineSpacing)
    .text((d) -> d.teamname )
    .classed('team-name')

  standings = svg.selectAll('text.standing')
    .data(sortByWins(data)).enter()
    .append('text')
    .attr('x', 200)
    .attr('y', (d, i) -> i * lineHeight + lineSpacing)
    .text((d) -> d.standing)
    .classed('standing')

  payroll = svg.selectAll('text.payroll')
    .data(sortByPayroll(data)).enter()
    .append('text')
    .attr('x', 500)
    .attr('y', (d, i) -> i * lineHeight + lineSpacing)
    .text((d) -> "$" + d3.format(",")(d.payroll))
    .classed('payroll')

  teamPayrollLine = svg.selectAll('line.payroll-line')
    .data(sortByPayroll(data)).enter()
    .append('line')
    .attr('y1', (d) -> (findTeamPosition(d, data) - 0.3) * lineHeight + lineSpacing)
    .attr('x1', 246)
    .attr('x2', 493)
    .attr('y2', (d, i) -> (i - 0.3) * lineHeight + lineSpacing)
    .attr('stroke', (d, i) ->
      if i > findTeamPosition(d, data)
        '#3030F0'
      else
        '#F03030'
    )
    .attr('stroke-width', (d, i) -> Math.abs(i - findTeamPosition(d, data))/3)
    .attr('stroke-linecap', 'round')

lineHeight = 14
lineSpacing = 3

sortByWins = (data) ->
  _.sortBy data, (d) ->
    parseInt d.standing.split('-')[1]

sortByPayroll = (data) ->
  _.sortBy data, (d) ->
    -1 * parseInt d.payroll

findTeamPosition = (d, data) ->
  _.findIndex sortByWins(data), (win) ->
    win.teamname == d.teamname

d3.csv '/experiments/baseball/2012payrollstandings.csv', (error, data) ->
  svg = d3.select('.content')
    .append('svg')
    .append('g')

  teamList = svg.selectAll('text.team-name')
    .data(sortByWins(data)).enter()
    .append('text')
    .attr('x', 10)
    .attr('y', (d, i) -> (i + 1) * lineHeight + lineSpacing)
    .text((d) -> d.teamname )
    .classed('team-name')

  standings = svg.selectAll('text.standing')
    .data(sortByWins(data)).enter()
    .append('text')
    .attr('x', 200)
    .attr('y', (d, i) -> (i + 1) * lineHeight + lineSpacing)
    .text((d) -> d.standing)
    .classed('standing')

  payroll = svg.selectAll('text.payroll')
    .data(sortByPayroll(data)).enter()
    .append('text')
    .attr('x', 500)
    .attr('y', (d, i) -> (i + 1) * lineHeight + lineSpacing)
    .text((d) -> "$" + d3.format(",")(d.payroll))
    .classed('payroll')

  teamPayrollLine = svg.selectAll('line.payroll-line')
    .data(sortByPayroll(data)).enter()
    .append('line')
    .attr('y1', (d) -> (findTeamPosition(d, data) + 0.5) * lineHeight + lineSpacing)
    .attr('x1', 245)
    .attr('x2', 495)
    .attr('y2', (d, i) -> (i + 1) * lineHeight + lineSpacing)
    .attr('stroke', (d, i) ->
      if i > findTeamPosition(d, data)
        'blue'
      else
        'red'
    )

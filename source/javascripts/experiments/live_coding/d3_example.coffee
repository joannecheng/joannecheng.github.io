lineSpacing = 20

sortByWins = (data) ->
  _.sortBy data, (d) ->
    parseInt d.standing.split('-')[1]

sortByPayroll = (data) ->
  _.sortBy data, (d) ->
    -1 * parseInt d.payroll

findTeamPosition = (data) ->
  (d) -> _.findIndex sortByWins(data), (row) ->
    row.teamname == d.teamname

payrollFormatter = d3.format(',0')

$ ->
  d3.csv '/experiments/baseball/2012payrollstandings.csv', (error, data) ->
    teamPositionFinder = findTeamPosition(data)
    sortedByWins = sortByWins(data)
    sortedByPayroll = sortByPayroll(data)

    svg = d3.select('#container')
      .append('svg')

    teamList = svg.selectAll('text.team-name')
      .data(sortedByWins).enter()
      .append('text')
      .attr('x', 10)
      .attr('y', (d, i) -> (i+1) * lineSpacing)
      .text((d) -> d.teamname)
      .classed('team-name')

    standingList = svg.selectAll('text.standings')
      .data(sortedByWins).enter()
      .append('text')
      .attr('x', 195)
      .attr('y', (d, i) -> (i+1) * lineSpacing)
      .text((d) -> d.standing)
      .attr('font-size', 13)
      .classed('standings')

    payrollList = svg.selectAll('text.payroll-label')
      .data(sortedByPayroll).enter()
      .append('text')
      .attr('x', 450)
      .attr('y', (d, i) -> (i + 1) * lineSpacing)
      .text((d) -> "$#{payrollFormatter(d.payroll)}")
      .classed('text.payroll-label')

    slopedLines = svg.selectAll('line.sloped-line')
      .data(sortedByPayroll).enter()
      .append('line')
      .attr('x1', 235)
      .attr('y1', (d, i) -> (i+ 0.7) * lineSpacing)
      .attr('x2', 445)
      .attr('y2', (d) -> (teamPositionFinder(d) + 0.7)* lineSpacing)
      .attr('stroke-width', 2)
      .attr('stroke', (d, i) ->
        if teamPositionFinder(d) > i
          '#3030FF'
        else
          '#FF3030'
      )

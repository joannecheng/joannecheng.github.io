$ ->
  d3.csv '/experiments/baseball/2012payrollstandings.csv', (error, data) =>
    wins = (standing) ->
      parseInt standing.split('-')[0]

    series = _.map data, (row) ->
      name: row.teamname
      data: [[parseInt(row.payroll), wins(row.standing)]]

    $('#container').highcharts
      chart:
        type: 'scatter'
      title:
        text: 'Baseball Standing vs Payroll: 2012'
      yAxis:
        title:
          text: 'Number of Wins'
      xAxis:
        title:
          text: 'Payroll (in millions)'
      plotOptions:
        scatter:
          marker:
            radius: 5
            states:
              hover:
                enabled: true
                lineColor: 'rgb(100, 100, 100)'
          tooltip:
            headerFormat: '<b>{series.name}</b><br/>'
            pointFormat: "${point.x:,.0f} paid<br /> {point.y} Number of Wins"
      series: series

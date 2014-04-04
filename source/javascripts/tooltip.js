function tooltip() {
  var tooltipWidth = 94;
  var tooltipHeight = 40;
  var lineHeight = 14;
  var textMargin = 5;
  var leftOffset = 10;
  var xAttr = 'count';
  var yAttr = 'timestamp';
  var yLabel = 'count';
  var xLabel = 'Date';
  var timeFormat = d3.time.format('%b %e');
  var isTimeSeries = true;

  function tooltipChart() {

    function drawRect(svg, xPos, yPos, containerWidth, containerHeight) {
      svg.append('rect')
        .classed('tooltip', true)
        .attr('x', function() {
          var calculatedXPos = xPos + leftOffset;
          if (calculatedXPos + tooltipWidth > containerWidth) {
            return xPos - leftOffset - tooltipWidth;
          }
          return calculatedXPos;
        })
        .attr('y', function() {
          if (yPos + tooltipHeight*2 + 80 > containerHeight) {
            return yPos - tooltipHeight;
          }
          return yPos;
        })
        .attr('width', tooltipWidth)
        .attr('height', tooltipHeight);
    }

    function drawText(svg, xPos, yPos, datapoint, containerWidth, containerHeight) {
      var calculateXPos = function() {
        var calculatedXPos = xPos + leftOffset;
        if (calculatedXPos + tooltipWidth > containerWidth) {
          return xPos + textMargin - leftOffset - tooltipWidth;
        }
        return calculatedXPos + textMargin;
      }

      var calculateYPos = function(lineHeight) {
        if (yPos + tooltipHeight*2 + 80 > containerHeight) {
          return yPos - tooltipHeight + textMargin + lineHeight;
        }
        return yPos + lineHeight;
      }

      svg.append('text')
        .attr('x', calculateXPos)
        .attr('y', calculateYPos(lineHeight))
        .classed('tooltip', true)
        .text(function() {
          if (isTimeSeries) {
            return xLabel+': ' + timeFormat(new Date(datapoint[xAttr]))
          }
          return xLabel + ': ' + datapoint[xAttr];
        })

      svg.append('text')
        .attr('x', calculateXPos)
        .attr('y', calculateYPos(lineHeight*2))
        .classed('tooltip', true)
        .text(function() {
          if($.isNumeric(datapoint[yAttr])) {
            return yLabel + ': ' + d3.round(datapoint[yAttr], 2)
          }
          return yLabel + ': ' + datapoint[yAttr];
        });
    }

    var containerWidth = this[0][0].parentNode.clientWidth;
    var containerHeight = this[0][0].parentNode.clientHeight;
    var datapoint = d3.event.target.__data__;
    if(d3.event.offsetX) {
      var xPos = d3.event.offsetX;
      var yPos = d3.event.offsetY;
    }
    else {
      var parent = this[0][0].parentNode;
      var xPos = d3.event.pageX - parent.offsetLeft;
      var yPos = d3.event.pageY - parent.offsetTop - 80;
    }

    drawRect(this, xPos, yPos, containerWidth, containerHeight);
    drawText(this, xPos, yPos, datapoint, containerWidth, containerHeight);
  }

  tooltipChart.xAttr = function(value) {
    if(!arguments.length) return xAttr;
    xAttr = value;
    return tooltipChart;
  }

  tooltipChart.xLabel = function(value) {
    if(!arguments.length) return xLabel;
    xLabel = value;
    return tooltipChart;
  }

  tooltipChart.yAttr = function(value) {
    if(!arguments.length) return yAttr;
    yAttr = value;
    return tooltipChart;
  }

  tooltipChart.yLabel = function(value) {
    if(!arguments.length) return yLabel;
    yLabel = value;
    return tooltipChart;
  }

  tooltipChart.isTimeSeries = function(value) {
    if(!arguments.length) return isTimeSeries;
    isTimeSeries = value;
    return tooltipChart;
  }

  tooltipChart.remove = function(svg) {
    svg.selectAll('.tooltip')
      .remove();
  }

  return tooltipChart;
}

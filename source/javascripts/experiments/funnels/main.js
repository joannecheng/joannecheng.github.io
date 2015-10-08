"use strict";

// Graph
const width = 600;
const height = 400;
const margin = { top: 20, left: 40, bottom: 40, right: 30 };
const data = [
  { event_collection: "create_user", result: 803 },
  { event_collection: "create_organization", result: 671 },
  { event_collection: "analysis_api_call", result: 0 },
];
const graphAreaHeight = height - margin.top - margin.bottom;
const graphAreaWidth = width - margin.left - margin.right;

// setup DOM elements
const topLabels = d3.select(".funnel")
  .append("div")
  .classed("labels", true)
  .classed("top-labels", true)
  .style({"margin-left": margin.left});

const chart = d3.select(".funnel")
  .append("svg")
  .classed("funnel-graph", true)
  .attr({width: width, height: height})
  .append("g")
  .classed("graph", true)
  .attr("transform", `translate(${margin.left}, ${margin.top})`)

const bottomLabels = d3.select(".funnel")
  .append("div")
  .classed("labels", true)
  .classed("bottom-labels", true)
  .style({"margin-left": margin.left});

// plotting some data
const barWidth = graphAreaWidth / data.length / 2;

const xScale = d3.scale.linear()
  .domain([0, data.length])
  .range([0, graphAreaWidth]);

const yScale = d3.scale.linear()
  .domain([0, d3.max(data, function(d) { return d.result + d.result * 0.05 })])
  .range([graphAreaHeight, 0]);

const bars = chart.append("g")
  .classed("bars", true)
  .selectAll("rect.bar")
  .data(data).enter()
  .append("rect")
  .attr({
    class: "bar",
    x: function(d, i) { return xScale(i); },
    y: function(d) { return yScale(d.result); },
    height: function(d) { return graphAreaHeight - yScale(d.result) },
    width: barWidth
  });

topLabels.selectAll("div.top-label")
  .data(data).enter()
  .append("div")
  .attr("class", "top-label graph-label")
  .style({ width: graphAreaWidth/data.length })
  .html(function(d, i) {
    let collectionLabel = d.event_collection.replace(/_/g, " ");
    collectionLabel = collectionLabel[0].toUpperCase() + collectionLabel.slice(1);
    const labelHtml = `<span class='label-text'>${collectionLabel}</span>`;

    return labelHtml
  });

// writing labels
bottomLabels.selectAll("div.bottom-label")
  .data(data).enter()
  .append("div")
  .attr("class", "bottom-label graph-label")
  .style({ width: graphAreaWidth/data.length })
  .html(function(d, i) {
    let countLabel = '';
    let percentChangeLabel = '';
    if(i > 0) {
      countLabel = -1 * data[i-1].result - d.result;
      percentChangeLabel = (-100*(data[0].result - d.result) / data[0].result)
        .toFixed(2) + "%";
    }
    const countHtml = `<span class='count-text'>${countLabel}</span>`;
    const percentChangeHtml = `<span class='percent-change-text'>
      ${percentChangeLabel}
    </span>`;

    const label = `
      <div class="label-details">
        ${countHtml}${percentChangeHtml}
      </div>
    `
    return label;
  });

// drawing axises

const xAxis = d3.svg.axis()
  .scale(xScale)
  .orient("bottom");

const yAxis = d3.svg.axis()
  .scale(yScale)
  .orient("left");

chart
  .append("g")
  .classed("axis", true)
  .attr("transform", `translate(0, ${graphAreaHeight})`)
  .call(xAxis)

chart
  .append("g")
  .classed("axis", true)
  .call(yAxis);

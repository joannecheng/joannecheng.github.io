"use strict";

// Graph
const width = 600;
const height = 400;
const margin = { top: 30 };

const graphAreaHeight = height - margin.top;

// setup
const topLabels = d3.select(".funnel")
  .append("div")
  .classed("labels", true)
  .classed("top-labels", true);

const chart = d3.select(".funnel")
  .append("svg")
  .classed("funnel-graph", true)
  .attr({width: width, height: height});

const bottomLabels = d3.select(".funnel")
  .append("div")
  .classed("labels", true)
  .classed("bottom-labels", true);

// plotting some data
const data = [
  { event_collection: "create_user", result: 803 },
  { event_collection: "create_organization", result: 671 },
  { event_collection: "analysis_api_call", result: 0 },
]

const barWidth = width / data.length / 2;

const xScale = d3.scale.linear()
  .domain([0, data.length])
  .range([0, width]);

const yScale = d3.scale.linear()
  .domain([0, d3.max(data, function(d) { return d.result })])
  .range([graphAreaHeight - 2, 0]);

const bars = chart.append("g")
  .classed("bars", true)
  .attr("transform", `translate(0, ${margin.top})`)
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
  .style({width: width/data.length + "px"})
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
  .style({width: width/data.length + "px"})
  .html(function(d, i) {
    let countLabel, percentChangeLabel;
    if(i > 0) {
      countLabel = -1 * data[i-1].result - d.result;
      percentChangeLabel = (-100*(data[0].result - d.result) / data[0].result)
        .toFixed(2) + "%";
    }
    else {
      countLabel = '';
      percentChangeLabel = '';
    }
    const countHtml = `<div class='count-text'>${countLabel}</div>`;
    const percentChangeHtml = `<div class='percent-change-text'>
      ${percentChangeLabel}
    </div>`;

    const label = `
      <div class="label-details">
        ${countHtml}${percentChangeHtml}
      </div>
    `

    return label;
  });

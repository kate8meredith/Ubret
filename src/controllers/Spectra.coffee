BaseController = require('./BaseController')
_ = require('underscore/underscore')

class Spectra extends BaseController
  
  name: "Spectra"
  
  constructor: ->
    super
    console.log 'Spectra'
    @subscribe @subChannel, @process
    @bind 'data-received', @plot
  
  render: =>
    console.log "index", @index
    @html require('../views/spectra')({index: @index})
  
  plot: =>
    console.log 'wavelength versus flux', @data[0].wavelengths, @data[0].flux
    
    wavelengths = @data[0].wavelengths
    fluxes = @data[0].flux
    
    margin =
      top: 14
      right: 10
      bottom: 14
      left: 10
    width = 370 - margin.left - margin.right
    height = 200 - margin.top - margin.bottom
    
    x = d3.scale.linear()
      .range([0, width])
    y = d3.scale.linear()
      .range([0, height])
    
    xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom")
    yAxis = d3.svg.axis()
      .scale(y)
      .orient("left")
    
    line = d3.svg.line()
      .x (d, i) ->
        return x(wavelengths[i])
      .y (d, i) ->
        return y(fluxes[i])
    
    svg = d3.select("#spectra-#{@index}").append('svg')
        .attr('width', width + margin.left + margin.right)
        .attr('height', height + margin.top + margin.bottom)
      .append('g')
        .attr('transform', "translate(#{margin.left}, #{margin.top})")
    
    x.domain d3.extent(wavelengths)
    y.domain d3.extent(fluxes)
    console.log 'x', x.domain
    console.log 'y', y.domain
    
    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0, #{height})")
        .call(xAxis)
    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
      .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text("Flux")
    svg.append("path")
        .datum(fluxes)
        .attr("class", "line")
        .attr("d", line)

module.exports = Spectra
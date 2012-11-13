
Graph = window.Ubret.Graph or require('./Graph')

class Histogram2 extends Graph
  axes: 1
  
  template:
    """
    <div class="histogram">
      <div id="<%- selector %>">
        <svg></svg>
      </div>
    </div>
    """
  
  constructor: (opts) ->
    console.log 'Histogram2'
    super opts
    
    # Compute the number of bins for the unfiltered dataset
    @bins = if opts.bins then opts.bins else Math.log(@count) / Math.log(2) + 1
    @axis2 = opts.yLabel or 'Count'
  
  draw: =>
    console.log 'Histogram2 draw'
    
    # Get data from crossfilter object
    data = @dimensions[@axis1].top(Infinity)
    data = _.map(data, (d) => d[@axis1])
    
    domain = d3.extent(data)
    
    

if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = Histogram2
else
  window.Ubret['Histogram2'] = Histogram2
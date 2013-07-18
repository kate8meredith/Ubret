class Table extends Ubret.Tool
  name: 'Table'
  
  mixin: Ubret.Paginated

  initialize: ->
    @table = @d3el.append('table')

  events:
    'next' : 'nextPage drawTable'
    'prev' : 'prevPage drawTable'
    'setting:sortColumn' : 'drawTable'
    'setting:sortOrder': 'drawTable'
    'resize' : 'drawTable'
    'select' : 'drawRows'
    'data' : 'drawTable'

  drawTable: ->
    return unless @data?
    @drawHeader()
    @drawRows()
    @drawPages()

  # Drawing
  drawHeader: ->
    @thead = @table.insert('thead', ":first-child") unless @thead
    @thead.selectAll('th').remove()

    @thead.selectAll("th")
      .data(@data.keys)
      .enter().append("th")
        .on('click', (d, i) => @sortRow d)
        .attr('data-key', (d) -> d)
        .text( (d) => 
          @unitsFormatter(@formatKey d) + ' ' +
            if d is @opts.sortColumn then @arrow() else '')

  drawRows: -> 
    return unless @data?
    @tbody = @table.append('tbody') unless @tbody
    @tbody.selectAll('tr').remove()

    tr = @tbody.selectAll('tr')
      .data(@currentPageData())
      .enter().append('tr')
        .attr('data-id', (d) -> d.uid)
        .attr('class', (d) => 
          if d.uid in @selectedIds then 'selected' else '')
        .on('click', @selection)
    
    tr.selectAll('td')
      .data((d) => @toArray(d))
      .enter().append('td')
        .text((d) -> return d)

  drawPages: ->
    return unless @data?
    @p.remove() if @p
    @p = @d3el
      .append('p')
      .attr('class', 'pages')
      .text("Page: #{parseInt(@opts.currentPage) + 1} of #{@pages().length}")

  # Pagination
  perPage: -> 
    # Assumes top margin + bottom margins = 130px,
    # and table cells are 27px high.
    Math.floor((@height - 90 )/ 27) 

  pageSort: (d) => d[@opts.sortColumn]

  # UI Events
  sortRow: (key) ->
    if key is @opts.sortColumn
      if @opts.sortOrder is 'top'
        @settings {sortOrder: 'bottom'}
      else 
        @settings {sortOrder: 'top'}
    else
      @settings 
        sortOrder: 'top'
        sortColumn: key

  selection: (d, i) =>
    ids = @opts.selectedIds
    if d3.event.shiftKey
      if not (d.uid in ids)
        ids.push d.uid
      else
        ids = _.without ids, d.uid 
    else if d.uid in ids
      ids = _.without ids, d.uid
    else
      ids = [d.uid]
    @selectIds ids

  # Helpers
  toArray: (data) =>
    ret = new Array
    for key in @data.keys
      ret.push data[key]
    return ret

  arrow: =>
    if @opts.sortOrder is 'top'
      return '▲'
    else
      return '▼'

window.Ubret.Table = Table
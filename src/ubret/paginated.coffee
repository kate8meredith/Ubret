Ubret.Paginated = 
  currentPageData: ->
    @currentPage(@opts.currentPage)
    @page(@opts.currentPage)

  page: (number) ->
    startIndex = number * _.result(@, 'perPage')
    endIndex = (number + 1) * _.result(@, 'perPage')
    sortedData = @pageSort(@preparedData())
    sortedData.slice(startIndex, endIndex)

  pages: ->
    Math.ceil(@data.project('all').length / _.result(@, 'perPage'))

  currentPage: (page) ->
    if _.isEmpty(@data.project('all'))
      @opts.currentPage = page
    else if page < 0
      @opts.currentPage = @pages() - 1
    else if page >= @pages()
      @opts.currentPage = page % @pages()
    else if _.isNull(page) or _.isUndefined(page)
      @opts.currentPage = 0
    else
      @opts.currentPage = page

  nextPage: ->
    console.log @
    @settings
      currentPage: parseInt(@opts.currentPage) + 1

  prevPage: ->
    @settings
      currentPage: parseInt(@opts.currentPage) - 1


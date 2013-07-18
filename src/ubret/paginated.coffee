Ubret.Paginated = 
  currentPageData: ->
    @currentPage(@opts.currentPage)
    @pages().toArray()[@opts.currentPage]

  pages: ->
    @getData().page(_.result(@, 'perPage'))

  currentPage: (page) ->
    unless @data? 
      @opts.currentPage = page
    else if page < 0
      @opts.currentPage = @pages().length - 1
    else if page >= @pages().length
      @opts.currentPage = page % @pages().length
    else if _.isNull(page) or _.isUndefined(page)
      @opts.currentPage = 0
    else
      @opts.currentPage = page

  nextPage: ->
    @settings
      currentPage: parseInt(@opts.currentPage) + 1

  prevPage: ->
    @settings
      currentPage: parseInt(@opts.currentPage) - 1

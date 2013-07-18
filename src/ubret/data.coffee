class Data
  constructor: (data) ->
    if _.isArray(data)
      @data = Lazy(data)
    else
      @data = data

  keys: ->
    _.keys @data.first()

  project: (keys...) ->
    return @data.toArray() if keys[0] = all
    @data.map((d) -> d.pick.apply(null, keys)).toArray()

  filter: (func) ->
    new Data(@data.filter(func))

  addField: (field, func) ->
    new Data(@data.map((d) -> d[field] = func(d)))

  groupBy: (func) ->
    new Data(@data.groupBy(func))

  page: (perPage) ->
    new Data(@data.groupBy((d) => @data.indexOf(d) % perPage))

  each: (func) ->
    @data.each(func)
    @data

@Ubret.Data = Data
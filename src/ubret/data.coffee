class Data
  constructor: (data) ->
    if _.isArray(data)
      @data = Lazy(data)
    else
      @data = data

  project: (keys...) ->
    new Data(@data.map((d) -> d.pick.apply(null, keys))).toArray()

  filter: (func) ->
    new Data(@data.filter(func))

  addField: (field, func) ->
    new Data(@data.map((d) -> d[field] = func(d)))

  groupBy: (func) ->
    new Data(@data.groupBy(func))

  each: (func) ->
    @data.each(func)
    @data

@Ubret.Data = Data
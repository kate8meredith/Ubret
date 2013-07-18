class Data
  constructor: (data) ->
    if _.isArray(data)
      @data = Lazy(data)
    else
      @data = data
    @keys = @getKeys()

  getKeys: ->
    _.keys @data.first()

  query: ({project, where, withFields, sort, perPage}) ->
    data = @data
    data = data.filter(where) if filter?
    data = data.sort(sort) if sort?

    if _.isArray withFields
      _.each(((f) -> data = data.addField(f)), @)
    else
      data = data.addField(withFields)

    projection = data.project(project)
    projection = projection.page(perPage) if perPage?
    projection 

  project: (keys...) ->
    if keys[0] in ['all', '*']
      data = @data 
    else
      data = @data.map((d) -> _.pick.call(null, d, keys...))
    new Projection(data)

  filter: (func) ->
    new Data(@data.filter(func))

  sort: ({func, direction}) ->
    data = @data.sort(func)
    data = data.reverse() if direction is 'desc'
    new Data(data)

  addField: ({field, func}) ->
    new Data(@data.map((d) -> d[field] = func(d)))

class Projection
  constructor: (@data) ->
    @length = @data.reduce(((x) -> x + 1), 0)
    @keys = @getKeys()

  getKeys: ->
    _.keys @data.first()

  groupBy: (func) ->
    @data.groupBy(func).toArray()

  each: (func) ->
    @projection.each(func)
    @data

  page: (perPage) ->
    return @data if perPage is 1
    new Projection(@data.groupBy((d) -> Math.floor(d / perPage))
      .map((d) -> d[1]))

  toArray: ->
    @data.toArray()

@Ubret.Data = Data
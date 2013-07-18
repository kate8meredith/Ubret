class Tool extends Ubret.EventEmitter
  constructor: (options) ->
    @includeMixins()
    @opts = {}
    @selectedIds = []
    @unitsFormatter = d3.units 'astro'

    @id = options.id
    @el = document.createElement('div')
    @el.id = @id 
    @d3el = d3.select(@el)

    super
    @initialize() if @initialize?

    @resize(options)
    @select(options.selectedIds)
    @settings(options.setttings)
    @setData(options)

  includeMixins: ->
    if _.isArray @mixin
      _.each @mixin, @includeMixin, @
    else
      @includeMixin(@mixin)

  includeMixin: (m) ->
    _.extend @, m

  setData: ({data, filters, fields}, triggerEvent=true) ->
    @rawData = data if data?
    @filters = filters if filters?
    @fields = fields if fields?

    @data = new Ubret.Data(@rawData)

    _.each @filters or [], (f) ->
      @data = @data.filter(f)

    _.each @fields or [], (f) ->
      @data = @data.addField(f)

    @push 'data', @childData()

  getData: ->
    unless @data?
      throw new Error("No Data")
    else if @data.toArray?
      @data
    else
      @data.project('*')

  select: (ids, reset=false, triggerEvent=true) ->
    if _.isArray(ids)
      if reset
        @selectedIds = _.clone(ids)
      else
        @selectedIds = _.uniq @selectedIds.concat(ids)
    else if ids?
      @selectedIds.push ids
    @push 'select', @selectedIds if triggerEvent

  resize: ({height, width}, triggerEvent=true) ->
    @height = height
    @width = width
    @push 'resize', {height: @height, width: @width} if triggerEvent

  setParent: (tool=null, triggerEvent=true) ->
    @parentId = tool.id

    channels = _.map ['data', 'select'], (c) -> @parentId + ":" + c
    callbacks = [((data) -> @setData({data: data}))
                 ((ids) -> @select(ids))]

    @setupEvents(_.object(channels, callbacks))

    @setData({data: tool.data})
    @select(tool.selectedIds)

  settings: (settings, triggerEvent=true) ->
    return unless settings?
    _.map settings, @setting, @
    @push 'settings', settings if triggerEvent
    @

  setting: (value, setting, triggerEvent=true) ->
    if typeof @[setting] is 'function'
      @[setting](value)
    else
      @opts[setting] = value
    @push "setting:#{setting}", value if triggerEvent

  childData: ->
    @data  
    
  formatKey: (key) ->
    (key.replace(/_/g, " ")).replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()

Ubret.Tool = Tool

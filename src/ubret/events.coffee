Ubret._events = {}

Ubret.Events = 
  listenTo: (channel, fn, context=null) ->
    if Ubret._events[channel]?
      Ubret._events[channel].push {fn: fn, ctx: context}
    else
      Ubret._events[channel] = [{fn: fn, ctx: context}]

  stopListening: (channel, fn, context=null) ->
    return unless Ubret._events[channel]
    Ubret._events[channel] = _.without Ubret._events[channel], {fn: fn, ctx: context}

  push: (channel, args...) ->
    _.each Ubret._events[channel], (cb) -> cb.fn.apply(cb.ctx, args)

class EventEmitter
  constructor: ->
    @setupEvents()

  setupEvents: (events=null) ->
    events = events or @events
    return unless events?
    @channels = _.chain(events)
      .map(((_, channel) -> [@id + ":" + channel, new EventChannel(@id + ":" + channel)]), @)
      .object()
      .value()

    _.each events, ((cb, channel) -> 
      if _.isString(cb)
        cbs = cb.split(' ')
        _.each cbs, ((cb) ->
          @channels[@id + ":" + channel].each(@[cb], @)), @
      else
        @channels[@id + ":" + channel].each(cb, @)), @
    console.log @channels

  push: (channel, args...) ->
    channel = @id + ":" + channel
    Ubret.Events.push(channel, args...)

class EventChannel extends Lazy.Sequence
  constructor: (@channel) ->

  each: (fn, ctx=null) ->
    Ubret.Events.listenTo(@channel, fn, ctx)

Ubret.EventEmitter = EventEmitter
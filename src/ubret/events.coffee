Ubret.Events = 
  events: {}

  stopListening: (channel, fn) ->

  listenTo: (channel, fn) ->

  push: (channel, args...) ->
    


class EventChannel extends Lazy.Sequence
  constructor: (@channel) ->

  each: (fn) ->
    Ubret.Events.listenTo(@channel, fn)
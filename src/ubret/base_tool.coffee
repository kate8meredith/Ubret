class BaseTool

  required_opts: ['data', 'selector', 'el', 'keys']

  constructor: (opts) ->
    
    for opt in @required_opts
      throw "missing option #{opt}" unless _.has opts, opt
    
    @data = opts.data
    @selector = opts.selector
    @keys = opts.key
    @el = opts.el
    
    @selectElementCb = opts.selectElementCb or ->
    @selectKeyCb = opts.selectKeyCb or ->

    @selectedElement = opts.selectedElement or null
    @selectedKey = opts.selectedKey or 'id'

  selectElement: (id) =>
    @selectedElement = id
    @selectElementCb id
    @start()

  selectKey: (key) =>
    @selectedKey = key
    @selectKeyCb key
    @start()

  # Helpers
  prettyKey: (key) =>
    @capitalizeWords(@underscoresToSpaces(key))

  uglifyKey: (key) =>
    @spacesToUnderscores(@lowercaseWords(key))

  underscoresToSpaces: (string) ->
    string.replace /_/g, " "

  capitalizeWords: (string) ->
    string.replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()

  spacesToUnderscores: (string) ->
    string.replace /\s/g, "_"

  # Helpers
  formatKey: (key) ->
    (key.replace(/_/g, " ")).replace /(\b[a-z])/g, (char) ->
      char.toUpperCase()
      
if typeof require is 'function' and typeof module is 'object' and typeof exports is 'object'
  module.exports = BaseTool
else
  window.Ubret['BaseTool'] = BaseTool
BaseController = require('./BaseController')
_ = require('underscore/underscore')

class Map extends BaseController
  @mapOptions =
    attributionControl: false
    
  # Set the default image path for Leaflet
  L.Icon.Default.imagePath = 'css/images'

  name: "Map"
  
  selected_icon: new L.icon {
      className: 'selected_icon'
      iconUrl: '/css/images/marker-icon-orange.png'
      iconSize: [25, 41]
      iconAnchor: [13, 41]
    }

  default_icon: new L.icon {
      className: 'default_icon'
      iconUrl: '/css/images/marker-icon.png'
      iconSize: [25, 41]
      iconAnchor: [13, 41]
    }

  constructor: ->
    super
    @circles = []
    @subscribe @subChannel, @process

  render: =>
    @html require('../views/map')({index: @index})

  start: =>
    @createSky() unless @map
    @plotObjects() if @data
    
  createSky: =>
    @map = L.map("sky-#{@index}", Map.mapOptions).setView([0, 180], 6)
    @layer = L.tileLayer('/tiles/#{zoom}/#{tilename}.jpg',
      maxZoom: 7
    )
    @layer.getTileUrl = (tilePoint) ->
      zoom = @_getZoomForUrl()
      convertTileUrl = (x, y, s, zoom) ->
        pixels = Math.pow(2, zoom)
        d = (x + pixels) % (pixels)
        e = (y + pixels) % (pixels)
        f = "t"
        g = 0
        while g < zoom
          pixels = pixels / 2
          if e < pixels
            if d < pixels
              f += "q"
            else
              f += "r"
              d -= pixels
          else
            if d < pixels
              f += "t"
              e -= pixels
            else
              f += "s"
              d -= pixels
              e -= pixels
          g++
        x: x
        y: y
        src: f
        s: s

      url = convertTileUrl(tilePoint.x, tilePoint.y, 1, zoom)
      return "/tiles/#{zoom}/#{url.src}.jpg"

    @layer.addTo @map
  
  plotObject: (subject, options) =>
    coords = [subject.dec, subject.ra]
    options = 
      icon = new L.icon {
          iconSize: [25, 41]
          iconAnchor: [13, 41]
        }
    
    circle = new L.marker(coords, options)
    circle.zooniverse_id = subject.zooniverse_id
    
    circle.addTo(@map)
    circle.bindPopup require('../views/map_popup')({subject})
    circle.on 'click', =>
      # Set previous selected subject back to default icon
      if @selected_subject?
        @selected_subject.setIcon @default_icon

      @selected_subject = circle
      circle.openPopup()
      circle.setIcon @selected_icon

      @publish [{message: "selected", item_id: circle.zooniverse_id}]

    @circles.push circle
    
  plotObjects: =>
    @map.removeLayer(marker) for marker in @circles
    @circles = new Array
    @filterData()
    @plotObject subject for subject in @filteredData

    latlng = new L.LatLng(@data[0].dec, @data[0].ra)
    @map.panTo latlng
 
  selected: (itemId) =>
    item = _.find @data, (subject) ->
      subject.zooniverse_id = itemId
    latlng = new L.LatLng(item.dec, item.ra)
    circle = (c for c in @circles when c.zooniverse_id is itemId)[0]

    # Set previous selected subject back to default icon
    if @selected_subject?
      @selected_subject.setIcon @default_icon

    @selected_subject = circle
    circle.openPopup()
    circle.setIcon @selected_icon

  # Events
  setFullscreenMode: =>
    @el.addClass 'fullscreen'
    @el.children('div').css
      position: 'fixed'
      top: 0
      left: 0
      width: '100%'
      height: '100%'
      z_index: '0'
    @map.invalidateSize true

  
module.exports = Map
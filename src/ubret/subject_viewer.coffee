class SubjectViewer extends Ubret.BaseTool
  name: 'Subject Viewer'
  
  constructor: ->
    _.extend @, Ubret.Sequential
    super 

  events:
    'next' : 'nextPage render'
    'prev' : 'prevPage render'
    'data' : 'render'
    'selection' : 'render'

  render: =>
    return if @d3el? and _.isEmpty(@preparedData())
    @d3el.selectAll('div.subject').remove()

    subjectData = @currentPageData()

    subject = @d3el.append('div')
      .attr('class', 'subject')

    subject.append('ul').selectAll('ul')
      .data(@toArray(subjectData)).enter()
        .append('li')
        .attr('data-key', (d) -> d[0])
        .html((d) => 
          "<label>#{@unitsFormatter(@formatKey(d[0]))}:</label> 
            <span>#{d[1]}</span>")

    subject.selectAll('ul')
      .insert('li', ':first-child')
        .attr('class', 'heading')
        .html('<label>Key</label> <span>Value</span>')

    if _.isArray(subjectData[0].image)
      images = subject.insert('div.images', ":first-child")
      new Ubret.MultiImageView(images[0][0], subjectData[0].image)
    else
      subject.insert('img', ":first-child")
        .attr('class', 'image')
        .attr('src', subjectData[0].image)

  toArray: (data) =>
    data = data[0]
    arrayedData = new Array
    arrayedData.push [key, data[key]] for key in @opts.keys
    arrayedData

window.Ubret.SubjectViewer = SubjectViewer
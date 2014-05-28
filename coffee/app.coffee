Models =
  Sections: Backbone.Collection.extend({})

Views = 

  Main : 

    className: 'content'
    views: []
    initialize: ->
      @setupViews([
        {name: 'Heading', options: {text:'FMITKU = {'} }
        {name: 'Sections'}
        {name: 'Heading', options: {text:'}'} }
      ])
      @render()

    setupViews: (views) ->
      for view in views
        View = Backbone.View.extend(Views[view.name])
        @views.push new View(view.options)

    template: ->
      (view.$el for view in @views)

    render: ->
      @$el.empty().append @template()

  Heading:
    className: 'font-thin super-size'
    tagName: 'h1'

    initialize: (options) ->
      _(@).extend(options)
      @render()

    template: ->

      @.text or 'Heading'

    render: ->
      @$el.empty().append @template()

  Sections:
    className: 'sections'

    initialize: ->
      @setupViews()
      @render()

    setupViews: ->
      sections = []
      models.sections.each (model,id) ->
        View = Backbone.View.extend(Views.Section)
        sections.push new View({model:model})

      @sections = sections

    template: ->
      (section.$el for section in @sections)

    render: ->
      @$el.empty().append @template()

  Section: 
    className:'section'

    events: 
      'click':'toggleExpand'

    initialize: ->
      @render()

    template: ->
      title = @model.id
      title = title.replace(/./,title[0].toUpperCase())

      [
        div {class:'title'}, title + ': '
        div {class:'paren'}, '{'
        div {class:'block'}, '  '
        div {class:'paren'}, '}'
      ].join ''

    isExpanded: ->
      lineHeight = 20
      @$('.block').height() > lineHeight

    expand: ->
      @$('.block').transition({display: 'block'}).transition({height:'40'})

    contract: ->
      @$('.block').transition({height:'0'}).transition({display: 'inline'})

    toggleExpand: (e) ->
      @isExpanded() and @contract() or @expand()

    render: ->
      @$el.empty().append @template()
      @delegateEvents()

models =
  sections : new Models.Sections([
    {id:'story'}
    {id:'purpose'}
    {id:'products'}
    {id:'services'}
    {id:'team'}
    {id:'partners'}
    {id:'contact'}
  ])
views = new (Backbone.View.extend(Views.Main))

window.f = 
  models: models
  views: views
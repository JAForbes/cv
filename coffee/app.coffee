Models = {}
Models.Section = Backbone.Model.extend({
  initialize: ->
    id = @id.replace(/\s/g,'_')
    @set('content',marked.parse($('#templates #'+id).text()))
})
Models.Sections = Backbone.Collection.extend({
  model: Models.Section
})
Views = 

  Main : 

    className: 'content'
    views: []
    initialize: ->
      @setupViews([
        {name: 'Heading', options: {text:'James Forbes = {'} }
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
      title = title[0].toUpperCase() + title.slice(1)
      [
        div {class:'title'}, title + ':'
        div {class:'block'}, [
          div {class:'paren'}, '{'
          div {class: 'content'}, '<br>' + @model.get('content')
          div {class:'paren'}, '}'
        ]
      ].join ''

    isExpanded: ->
      lineHeight = 20
      @$('.block .content').height() > lineHeight

    expand: ->
      @$('.block .content')
        .css({maxWidth: '100%'})
        .transition({maxHeight:'100%'})
    
    contract: ->
      @$('.block .content').css({maxWidth:'0%'}).transition({maxHeight:'0%'})

    toggleExpand: (e) ->
      @isExpanded() and @contract() or @expand()

    render: ->
      @$el.empty().append @template()
      @delegateEvents()

models =
  sections : new Models.Sections([
    {id:'overview'}
    {id:'ideal employment'}
    {id:'experience'}
    {id:'history'}
    {id:'achievements'}
    {id:'interests'}
    {id:'reference'}
  ])
views = new (Backbone.View.extend(Views.Main))

$('.content').replaceWith(views.$el)

window.f = 
  models: models
  views: views
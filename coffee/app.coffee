Models = 
  Sections: Backbone.Collection.extend()

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
      @sections[0].toggleExpand()

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
      'click .title,.paren':'toggleExpand'

    initialize: ->
      @render()

    template: ->
      title = @model.id
      title = (title[0].toUpperCase() + title.slice(1)).replace(/_/g,' ')

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
      @$('.block .content')
        .transition({maxHeight:0})

    toggleExpand: (e) ->
      @isExpanded() and @contract() or @expand()

    render: ->
      @$el.empty().append @template()
      @delegateEvents()

modeled = $('script[type="text/markdown"]').map ->
      {
        id:$(this)[0].id
        content: marked.parse(
          $(this).text()
        ) 
      }
    .get()

models =
  sections : new Models.Sections(
    modeled
  )
views = new (Backbone.View.extend(Views.Main))

$('.content').replaceWith(views.$el)

window.f = 
  models: models
  views: views
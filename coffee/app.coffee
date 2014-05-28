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
      title = title[0].toUpperCase() + title.slice(1)
      [
        div {class:'title'}, title + ': '
        div {class:'paren'}, '{'
        div {class:'block'}, div {class: 'content'}, '<br>' + @model.get('content')
        div {class:'paren'}, '}'
      ].join ''

    isExpanded: ->
      lineHeight = 20
      @$('.block').height() > lineHeight

    expand: ->
      @$('.block')
        .transition({display: 'block'})
        .transition({height:'70'},
          ->
            $content = $(@).find('.content')
            $content
              .css({opacity:0,display:'block'})
              .transition({opacity:1})

        )

    contract: ->
      @$('.content')
        .transition({opacity:0})
        .transition({display:'block'}, ->
          $block = $(@).parents('.block')
          $block
            .transition({height:0})
            .transition({display:'none'})
        )

    toggleExpand: (e) ->
      @isExpanded() and @contract() or @expand()

    render: ->
      @$el.empty().append @template()
      @delegateEvents()

models =
  sections : new Models.Sections([
    {id:'story', content: "Two brothers, building beautiful things."}
    {id:'purpose', content: "The world is broken.  We aim to fix it."}
    {id:'products', content: "We are a young company.  We are currently building a scoping AI for major infrastructure companies" }
    {id:'services', content: "We deploy our AI on the field for you." }
    {id:'team', content: "FMITKU is the brain child of brothers; James (Code) and John Forbes (Engineer)"}
    {id:'partners', content: "We are working closely with Thiess, NBN Co, Optus and Telstra"}
    {id:'contact', content: "You can always reach us via email contact@fmitku.com or via twitter @fmitku" }
  ])
views = new (Backbone.View.extend(Views.Main))

$('.content').replaceWith(views.$el)

window.f = 
  models: models
  views: views
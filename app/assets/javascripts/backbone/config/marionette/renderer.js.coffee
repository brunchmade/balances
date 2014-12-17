do (Marionette) ->

  _.extend Marionette.Renderer,

    # User Handlbar templates
    render: (templatePath, data) ->
      path = @getTemplate(templatePath)
      template = HandlebarsTemplates["backbone/apps/#{path}"]
      unless template
        throw "Template #{templatePath} not found!"
      template(data)

    getTemplate: (template) ->
      array = template.split('/')
      array.splice(-1, 0, 'templates')
      array.join('/')

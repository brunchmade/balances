Handlebars.registerHelper 'include', (template, options) ->
  # Find the partial in question.
  partial = Handlebars.partials[template]

  # Extend the current context with the options passed-in.
  context = _.extend({}, this, options.hash)

  # Render and mark as safe so it isn't escaped.
  new Handlebars.SafeString(partial(context))

Handlebars.registerHelper 'routes', (route, opts...) ->
  Routes[route] opts...

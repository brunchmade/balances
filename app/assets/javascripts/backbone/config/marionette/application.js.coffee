do (Backbone) ->

  _.extend Backbone.Marionette.Application::,

    getCurrentRoute: ->
      Backbone.history.fragment

    navigate: (route, options = {}) ->
      Backbone.history.navigate route, options

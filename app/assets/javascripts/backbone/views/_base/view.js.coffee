@Balances.module 'Views', (Views, App, Backbone, Marionette, $, _) ->

  _.extend Marionette.View::,

    reRender: ->
      @render()
      @triggerMethod 'show' if @_isShown

    templateHelpers: ->
      gon: gon

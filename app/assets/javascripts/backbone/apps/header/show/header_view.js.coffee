@Balances.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  ##############################################################################
  # Layout
  ##############################################################################

  class Show.Layout extends App.Views.Layout
    template: 'header/show/layout'
    className: 'top-bar'

    initialize: ->
      @listenTo App.vent, 'update:header:nav', @_updateNav

    serializeData: ->
      _.extend super,
        is_signed_in: App.currentUser.isSignedIn()

    _updateNav: ->
      switch App.getCurrentRoute()
        when 'addresses'
          @$('.menu a:eq(0)').addClass 'current'

@Balances.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  ##############################################################################
  # Layout
  ##############################################################################

  class Show.Layout extends App.Views.Layout
    template: 'header/show/layout'
    className: 'top-bar'

    serializeData: ->
      _.extend super,
        is_signed_in: App.currentUser.isSignedIn()
        fiat_currencies: gon.fiat_currencies
        user_voice_url: gon.user_voice_url

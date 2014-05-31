@Balances.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  ##############################################################################
  # Layout
  ##############################################################################

  class Show.Layout extends App.Views.Layout
    template: 'header/show/layout'
    className: 'top-bar'

    regions:
      balanceRegion: '#header-balance-region'

    initialize: ->
      @listenTo App.vent, 'update:header:nav', @_updateNav

    serializeData: ->
      _.extend super,
        is_signed_in: App.currentUser.isSignedIn()

    _updateNav: ->
      switch App.getCurrentRoute()
        when 'addresses'
          @$('.menu a:eq(0)').addClass 'current'


    ##############################################################################
    # Balance
    ##############################################################################

    class Show.Balance extends App.Views.ItemView
      template: 'header/show/balance'
      id: 'header-balance'

      events:
        'click #d-fiat a': '_clickConversion'

      initialize: ->
        @listenTo App.vent, 'updated:fiat:currency', @reRender

      serializeData: ->
        _.extend super,
          balance: App.fiatCurrency.symbol + @model.get("total_#{App.fiatCurrency.short_name}")
          fiat_currency_short_name: App.fiatCurrency.short_name.toUpperCase()

      onShow: ->
        @$("#d-fiat a[data-conversion=#{App.fiatCurrency.short_name}]").addClass 'current'

      _clickConversion: (event) ->
        event.preventDefault()
        $target = $(event.currentTarget)
        App.execute 'update:fiat:currency', $target.data('conversion')

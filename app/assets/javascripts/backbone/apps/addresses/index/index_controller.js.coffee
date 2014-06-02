@Balances.module 'AddressesApp.Index', (Index, App, Backbone, Marionette, $, _) ->

  class Index.Controller extends App.Controllers.Base
    initialize: ->
      @addresses = App.currentUser.addresses
      @layout = new Index.Layout

      @listenTo @addresses, 'change:sort:order', ->
        @addresses.fetch
          reset: true
          data:
            order: @addresses.sortOrder

      @listenTo @layout, 'show', ->
        @showHeader()
        @showSidebar()
        @showForm()
        @showList()

      App.mainContentRegion.show @layout

    showHeader: ->
      @layout.headerRegion.show new Index.Header
        collection: @addresses

    showSidebar: ->
      @sidebarLayout = new Index.Sidebar
        model: App.currentUser
        collection: @addresses

      @listenTo @sidebarLayout, 'show', ->
        @showSidebarBalances()

      @layout.sidebarRegion.show @sidebarLayout

    showSidebarBalances: ->
      @sidebarLayout.balances.show new Index.SidebarBalances
        model: App.currentUser
        collection: @addresses

    showForm: ->
      @layout.formRegion.show new Index.Form
        model: new App.Entities.Address
        collection: @addresses

    showList: ->
      @layout.listRegion.show new Index.List
        model: App.currentUser
        collection: @addresses

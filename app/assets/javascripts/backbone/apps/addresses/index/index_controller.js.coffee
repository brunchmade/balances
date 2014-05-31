@Balances.module 'AddressesApp.Index', (Index, App, Backbone, Marionette, $, _) ->

  class Index.Controller extends App.Controllers.Base
    initialize: ->
      @layout = new Index.Layout

      @listenTo @layout, 'show', ->
        @showHeader()
        @showSidebar()
        @showForm()
        @showList()

      App.mainContentRegion.show @layout

    showHeader: ->
      @layout.headerRegion.show new Index.Header
        collection: App.currentUser.addresses

    showSidebar: ->
      @layout.sidebarRegion.show new Index.Sidebar
        collection: App.currentUser.addresses

    showForm: ->
      @layout.formRegion.show new Index.Form
        model: new App.Entities.Address
        collection: App.currentUser.addresses

    showList: ->
      @layout.listRegion.show new Index.List
        model: App.currentUser
        collection: App.currentUser.addresses

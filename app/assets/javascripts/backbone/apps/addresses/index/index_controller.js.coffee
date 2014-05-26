@Balances.module 'AddressesApp.Index', (Index, App, Backbone, Marionette, $, _) ->

  class Index.Controller extends App.Controllers.Base
    initialize: ->
      @layout = new Index.Layout

      @listenTo @layout, 'show', ->
        @showSidebar()
        @showForm()
        @showList()

      App.mainRegion.show @layout

    showSidebar: ->
      @layout.sidebarRegion.show new Index.Sidebar
        collection: App.request('get:current:user').addresses

    showForm: ->
      @layout.formRegion.show new Index.Form
        model: new App.Entities.Address
        collection: App.request('get:current:user').addresses

    showList: ->
      @layout.listRegion.show new Index.List
        model: App.request('get:current:user')
        collection: App.request('get:current:user').addresses

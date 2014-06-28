@Balances.module 'AddressesApp.Index', (Index, App, Backbone, Marionette, $, _) ->

  class Index.Controller extends App.Controllers.Base
    initialize: ->
      @addresses = App.currentUser.addresses
      @announcements = new App.Entities.Announcements
      @layout = new Index.Layout

      # Sorting addresses is done server side.
      @listenTo @addresses, 'change:sort:order', ->
        @addresses.fetch
          reset: true
          data:
            order: @addresses.sortOrder
            filter: @addresses.currencyFilter

      # Filtering addresses is done server side.
      @listenTo @addresses, 'change:currency:filter', ->
        @addresses.fetch
          reset: true
          data:
            order: @addresses.sortOrder
            filter: @addresses.currencyFilter

      # Show regions
      @listenTo @layout, 'show', ->
        @showHeader()
        @showSidebar()
        @showForm()
        @showList()

      App.mainContentRegion.show @layout

    showHeader: ->
      @layout.headerRegion.show new Index.Header

    showSidebar: ->
      @announcements.fetch(reset: true)

      @sidebarLayout = new Index.Sidebar
        model: App.currentUser
        collection: @addresses

      @listenTo @sidebarLayout, 'show', ->
        @showSidebarBalances()

      @listenTo @announcements, 'reset', ->
        @showSidebarAnnouncement() if @announcements.length > 0

      @layout.sidebarRegion.show @sidebarLayout

    showSidebarBalances: ->
      @sidebarLayout.balances.show new Index.SidebarBalances
        model: App.currentUser
        collection: @addresses

    showSidebarAnnouncement: ->
      @sidebarLayout.announcement.show new Index.SidebarAnnouncement
        model: @announcements.first()
        collection: @announcements

    showForm: ->
      @layout.formRegion.show new Index.Form
        model: new App.Entities.Address
        collection: @addresses

    showList: ->
      @layout.listRegion.show new Index.List
        model: App.currentUser
        collection: @addresses

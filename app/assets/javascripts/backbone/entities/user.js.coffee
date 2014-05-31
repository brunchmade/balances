@Balances.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  ##############################################################################
  # Models
  ##############################################################################

  class Entities.UserBase extends Entities.Model
    initialize: (attributes, options = {}) ->
      @listenTo @, 'change:username change:email', @_updateDisplayName
      @_onInitialize attributes, options

    displayName: ->
      @get('username') or @get('email')

    _updateDisplayName: ->
      @set display_name: @displayName()

  class Entities.CurrentUser extends Entities.UserBase
    isSignedIn: ->
      !!@id

    _onInitialize: (attributes, options = {}) ->
      @addresses = new App.Entities.Addresses(options.addresses or {})

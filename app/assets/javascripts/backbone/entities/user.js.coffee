@Balances.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  #############################################################################
  # Models
  #############################################################################

  class Entities.UserBase extends Entities.Model
    initialize: (attributes, options = {}) ->
      @listenTo @, 'change:username change:email', @_updateDisplayName
      @_onInitialize attributes, options

    displayName: ->
      @get('username') or @get('email')

    _updateDisplayName: ->
      @set display_name: @displayName()

  class Entities.CurrentUser extends Entities.UserBase
    urlRoot: ->
      Routes.users_path()

    isSignedIn: ->
      !!@id

    needsTwoFactorAuth: ->
      !!@get('needs_two_factor_auth')

    _onInitialize: (attributes, options) ->
      addresses = options.addresses or {}
      addressesOptions = {}
      if @get('last_selected_conversion')
        addressesOptions.conversion = @get('last_selected_conversion')
      @addresses = new App.Entities.Addresses addresses, addressesOptions

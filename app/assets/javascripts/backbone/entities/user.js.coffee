@Balances.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  ##############################################################################
  # Models
  ##############################################################################

  class Entities.CurrentUser extends Entities.Model
    initialize: (attributes, options = {}) ->
      @addresses = new App.Entities.Addresses(options.addresses or {})

class B.Models.CurrentUser extends Backbone.Model

  initialize: (attrs, opts) ->
    @addresses = new B.Collections.Addresses(opts.addresses or {})

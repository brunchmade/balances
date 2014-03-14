class B.Collections.Addresses extends Backbone.Collection

  model: B.Models.Address
  url: -> '/addresses'

  sortOrder: 'name'
  conversion: 'all'

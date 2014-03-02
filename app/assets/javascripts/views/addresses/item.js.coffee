class B.Views.AddressList extends Backbone.Marionette.ItemView

  template: HandlebarsTemplates['addresses/item']
  tagName: 'tr'

  serializeData: ->
    _.extend super,
      display_name: if @model.get('name') then @model.get('name') else @model.get('public_address')

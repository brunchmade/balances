class B.Views.AddressList extends Backbone.Marionette.CompositeView

  template: HandlebarsTemplates['addresses/list']
  itemViewContainer: '#address-list'
  itemView: B.Views.AddressList
  id: 'address-list-container'

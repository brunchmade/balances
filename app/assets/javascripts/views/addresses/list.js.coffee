class B.Views.AddressList extends Backbone.Marionette.CompositeView

  template: HandlebarsTemplates['addresses/list']
  itemViewContainer: '#address-list'
  itemView: B.Views.AddressList
  id: 'address-list-container'

  events:
    'click #d-filters a': '_handleSort'

  _handleSort: (event) ->
    event.preventDefault()
    $target = $(event.currentTarget)
    newSort = $target.data('sort')
    @collection.fetch
      reset: true
      data:
        order: newSort

    # Update dropdown
    @$('#d-filters .current').removeClass 'current'
    $target.addClass 'current'
    @$('.sort-by span').text $target.text()

    # Close dropdown
    @$('.sort-by').click()

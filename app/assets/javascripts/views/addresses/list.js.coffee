class B.Views.AddressList extends Backbone.Marionette.CompositeView

  template: HandlebarsTemplates['addresses/list']
  itemViewContainer: '#address-list'
  itemView: B.Views.AddressItem
  id: 'address-list-container'

  events:
    'click #d-filters a': '_handleSort'
    'click #d-balances a': '_handleConversion'

  onRender: ->
    @_updateSort()
    @_updateConversion()

  _handleSort: (event) ->
    event.preventDefault()
    @collection.sortOrder = $(event.currentTarget).data('sort')

    @collection.fetch
      reset: true
      data:
        order: @collection.sortOrder

    @_updateSort()
    # Closes dropdown
    @$('.sort-by').click()

  _handleConversion: (event) ->
    event.preventDefault()
    $target = $(event.currentTarget)
    @collection.conversion = $target.data('conversion')
    @render()

  _updateSort: ->
    $target = @$("#d-filters a[data-sort='#{@collection.sortOrder}']")
    @$('#d-filters .current').removeClass 'current'
    $target.addClass 'current'
    @$('.sort-by span').text $target.text()

  _updateConversion: ->
    $target = @$("#d-balances a[data-conversion='#{@collection.conversion}']")
    @$('#d-balances .current').removeClass 'current'
    $target.addClass 'current'
    @$('.currency-type span').text $target.text()

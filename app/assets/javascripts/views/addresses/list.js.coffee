class B.Views.AddressList extends Backbone.Marionette.CompositeView

  template: HandlebarsTemplates['addresses/list']
  itemViewContainer: '#address-list'
  itemView: B.Views.AddressItem
  id: 'address-list-container'

  events:
    'click #d-filters a': '_handleSort'
    'click #d-balances a': '_handleConversion'

  serializeData: ->
    _.extend super,
      @_getConversion(),

  onRender: ->
    @_updateSort()
    @_updateConversion()

  _getConversion: ->
    switch @collection.conversion
      when 'all'
        balance_value: @model.get('total_btc')
        converted_shortname: 'BTC'
      when 'btc'
        balance_value: @model.get('total_btc')
        converted_shortname: 'BTC'
      when 'doge'
        balance_value: @model.get('total_doge')
        converted_shortname: 'DOGE'
      when 'ltc'
        balance_value: @model.get('total_ltc')
        converted_shortname: 'LTC'
      when 'usd'
        balance_value: "$#{@model.get('total_usd')}"
        converted_shortname: ''
      else
        balance_value: @model.get('total_btc')
        converted_shortname: 'BTC'


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

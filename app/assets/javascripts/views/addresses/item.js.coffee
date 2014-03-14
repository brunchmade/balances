class B.Views.AddressItem extends Backbone.Marionette.ItemView

  template: HandlebarsTemplates['addresses/item']
  tagName: 'tr'

  serializeData: ->
    _.extend super,
      @getConversion(),
      display_name: if @model.get('name') then @model.get('name') else @model.get('public_address')

  getConversion: ->
    switch @model.collection.conversion
      when 'all'
        balance_value: @model.get('balance')
        converted_shortname: @model.get('shortname')
      when 'btc'
        balance_value: @model.get('balance_btc')
        converted_shortname: 'BTC'
      when 'doge'
        balance_value: @model.get('balance_doge')
        converted_shortname: 'DOGE'
      when 'ltc'
        balance_value: @model.get('balance_ltc')
        converted_shortname: 'LTC'
      else
        balance_value: @model.get('balance')
        converted_shortname: @model.get('shortname')

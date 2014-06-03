@Balances.module 'AddressesApp.Index', (Index, App, Backbone, Marionette, $, _) ->

  ##############################################################################
  # Layout
  ##############################################################################

  class Index.Layout extends App.Views.Layout
    template: 'addresses/index/layout'
    tagName: 'section'

    regions:
      headerRegion: '#address-header-region'
      sidebarRegion: '#address-sidebar-region'
      formRegion: '#address-form-region'
      listRegion: '#address-list-region'


  ##############################################################################
  # Header
  ##############################################################################

  class Index.Header extends App.Views.ItemView
    template: 'addresses/index/header'
    id: 'address-header'

    ui:
      newAddressBtn: '.add-new a'

    events:
      'click @ui.newAddressBtn': '_clickNewAddress'

    initialize: ->
      @listenTo App.vent, 'updated:fiat:currency', @reRender

    serializeData: ->
      _.extend super,
        fiat_currency: App.fiatCurrency
        to_fiat_currency: "to_#{App.fiatCurrency.short_name}"

    _clickNewAddress: (event) ->
      event.preventDefault()
      App.vent.trigger 'toggle:addresses:form'


  ##############################################################################
  # Sidebar
  ##############################################################################

  class Index.Sidebar extends App.Views.Layout
    template: 'addresses/index/sidebar'
    tagName: 'aside'
    id: 'address-sidebar'

    regions:
      balances: '#addresses-sidebar-balances'

  class Index.SidebarBalances extends App.Views.Layout
    template: 'addresses/index/sidebar_balances'
    tagName: 'ul'
    id: 'currency-filters'

    initialize: ->
      @listenTo App.vent, 'updated:fiat:currency', @reRender

    serializeData: ->
      _.extend super,
        fiat_currency: App.fiatCurrency
        balance: @model.get('totals')[App.fiatCurrency.short_name]
        balance_fiat_currency: "balance_#{App.fiatCurrency.short_name}"
        has_btc: @collection.some (model) -> model.get('currency') is gon.cryptocurrencies['btc'].name
        has_doge: @collection.some (model) -> model.get('currency') is gon.cryptocurrencies['doge'].name
        has_ltc: @collection.some (model) -> model.get('currency') is gon.cryptocurrencies['ltc'].name


  ##############################################################################
  # List
  ##############################################################################

  class Index.Empty extends App.Views.ItemView
    template: 'addresses/index/empty'
    tagName: 'tr'

  class Index.Item extends App.Views.ItemView
    template: 'addresses/index/item'
    tagName: 'tr'

    serializeData: ->
      _.extend super,
        conversion: @_getConversion()

    _getConversion: ->
      conversion = {}

      conversion.balance =
        if _.contains _.keys(gon.cryptocurrencies), @model.collection.conversion
          @model.get("balance_#{gon.cryptocurrencies[@model.collection.conversion].short_name}")
        else if _.contains _.keys(gon.fiat_currencies), @model.collection.conversion
          fiatCurrency = gon.fiat_currencies[@model.collection.conversion]
          fiatCurrency.symbol + @model.get("balance_#{fiatCurrency.short_name}")
        else
          @model.get('balance')

      conversion.short_name =
        if _.contains _.keys(gon.cryptocurrencies), @model.collection.conversion
          gon.cryptocurrencies[@model.collection.conversion].short_name_upper
        else if _.contains _.keys(gon.fiat_currencies), @model.collection.conversion
          ''
        else
          @model.get('short_name')

      conversion

  class Index.List extends App.Views.CompositeView
    template: 'addresses/index/list'
    itemViewContainer: '#address-list'
    itemView: Index.Item
    emptyView: Index.Empty
    id: 'address-list-container'

    ui:
      'fiatCurrency': '#d-balances li:last-child a'
      'sortBy': '.sort-by'
      'sortByLabel': '.sort-by span'
      'conversionPrelabel': '.currency-type .conversion-prelabel'
      'conversionLabel': '.currency-type .conversion-label'

    collectionEvents:
      'change:conversion': 'reRender'

    events:
      'click #d-filters a': '_clickSort'
      'click #d-balances a': '_clickConversion'

    initialize: ->
      @listenTo App.vent, 'updated:fiat:currency', @_updateFiatCurrency

    serializeData: ->
      _.extend super,
        selected_currency: @collection.conversion
        fiat_currency: App.fiatCurrency
        conversion: @_getConversion()
        has_btc: @collection.some (model) -> model.get('currency') is gon.cryptocurrencies['btc'].name
        has_doge: @collection.some (model) -> model.get('currency') is gon.cryptocurrencies['doge'].name
        has_ltc: @collection.some (model) -> model.get('currency') is gon.cryptocurrencies['ltc'].name

    onShow: ->
      @_updateSort()
      @_updateConversion()

    _getConversion: ->
      conversion = {}

      conversion.balance =
        if _.contains _.keys(gon.cryptocurrencies), @collection.conversion
          @model.get('totals')[gon.cryptocurrencies[@collection.conversion].short_name]
        else if _.contains _.keys(gon.fiat_currencies), @collection.conversion
          fiatCurrency = gon.fiat_currencies[@collection.conversion]
          fiatCurrency.symbol + @model.get('totals')[fiatCurrency.short_name]
        else
          @model.get('totals').btc

      conversion.short_name =
        if _.contains _.keys(gon.cryptocurrencies), @collection.conversion
          gon.cryptocurrencies[@collection.conversion].short_name_upper
        else if _.contains _.keys(gon.fiat_currencies), @collection.conversion
          gon.fiat_currencies[@collection.conversion].short_name_upper
        else
          gon.cryptocurrencies['btc'].short_name_upper

      conversion

    _clickSort: (event) ->
      event.preventDefault()
      @collection.setSortOrder $(event.currentTarget).data('sort')
      @_updateSort()
      @ui.sortBy.click() # Closes dropdown

    _clickConversion: (event) ->
      event.preventDefault()
      $target = $(event.currentTarget)
      @collection.setConversion $target.data('conversion')

    _updateFiatCurrency: ->
      if _.contains _.pluck(gon.fiat_currencies, 'short_name'), @collection.conversion
        @collection.setConversion App.fiatCurrency.short_name
      else
        @ui.fiatCurrency.attr(
          class: "icon #{App.fiatCurrency.short_name}"
          title: "Show values in #{App.fiatCurrency.name}"
          'data-conversion': App.fiatCurrency.short_name
        ).text "Fiat (#{App.fiatCurrency.short_name_upper})"

    _updateSort: ->
      $target = @$("#d-filters a[data-sort='#{@collection.sortOrder}']")
      @$('#d-filters .current').removeClass 'current'
      $target.addClass 'current'
      @ui.sortByLabel.text $target.text()

    _updateConversion: ->
      $target = @$("#d-balances a[data-conversion='#{@collection.conversion}']")
      @$('#d-balances .current').removeClass 'current'
      $target.addClass 'current'
      @ui.conversionPrelabel.toggle @collection.conversion isnt 'all'
      @ui.conversionLabel.text $target.text()


  ##############################################################################
  # Form
  ##############################################################################

  class Index.Form extends App.Views.ItemView
    template: 'addresses/index/form'
    id: 'address-form'
    tagName: 'article'

    ui:
      balance: '.address-balance'
      currencyType: '.currency-type'
      inputAddress: '.address-public-address'
      inputName: '.address-name'
      hiddenAddress: '.hidden-public-address'
      hiddenAddressFirstbits: '.hidden-public-firstbits'
      btnQrScan: '.scan-qr'
      btnSave: '.btn-save'
      btnCancel: '.btn-cancel'

    modelEvents:
      'change:currency_image_path': '_changeCurrencyImage'
      'change:is_valid': '_changeIsValid'

    events:
      'keydown @ui.inputAddress': '_keydownInput'
      'paste @ui.inputAddress': '_pasteInput'
      'cut @ui.inputAddress': '_cutInput'
      'click @ui.btnSave': '_clickSave'
      'click @ui.btnCancel': '_clickCancel'

    initialize: ->
      @listenTo App.vent, 'toggle:addresses:form', @_toggle
      @listenTo App.vent, 'scan:qr', @_scanQr

    _keydownInput:
      _.debounce (event) ->
        return if isPasteKey(event) or
                  isSelectAllKey(event) or
                  isArrowKey(event)

        public_address = @ui.inputAddress.val()
        @model.set(public_address: public_address)

        @_clearErrors()

        if public_address.length is 0
          @model.set(currency_image_path: null)
        else if public_address.length < 27
          @model.fetchCurrency()
        else
          @model.fetchInfo
            error: =>
              @_addError()
      , 800

    _pasteInput: (event) ->
      # Timeout so that the paste event completes and the input has data.
      $.doTimeout 50, =>
        public_address = @ui.inputAddress.val()
        @model.set(public_address: public_address)

        @_clearErrors()

        if public_address.length < 27 or public_address.length > 34
          @_addError()
          return

        @model.fetchInfo
          error: =>
            @_addError()

    _cutInput: (event) ->
      # Timeout so that the cut event completes and the input has data.
      $.doTimeout 50, =>
        if @ui.inputAddress.val().length is 0
          @model.clear()
          @_clearErrors()

    _toggle: ->
      @$el.slideToggle()

    _scanQr: ->
      public_address = @ui.inputAddress.val()
      @model.set(public_address: public_address)

      @_clearErrors()

      if public_address.length < 27 or public_address.length > 34
        @_addError()
        return

      @model.fetchInfo
        error: =>
          @_addError()

    _clickSave: (event) ->
      event.preventDefault()
      balance = @ui.balance.text()
      @model.set
        balance: balance.slice(0, _.indexOf(balance, ' ')).replace(/,/g, '')
        name: _.str.trim(@ui.inputName.val())

      @collection.create @model.attributes,
        success: (model, response, options) =>
          @_reset()
        error: (model, response, options) ->
          _.each JSON.parse(response.responseText).errors, (msg, key) =>
            mark "#{_.str.titleize(_.str.humanize(key))} #{msg}"

    _clickCancel: (event) ->
      event.preventDefault()
      @_reset(false)

    _changeCurrencyImage: ->
      if @model.get('currency_image_path')
        @ui.currencyType.addClass('is-filled').html $('<img />',
          src: @model.get('currency_image_path')
          alt: @model.get('currency'))
      else
        @ui.currencyType.removeClass('is-filled').html('')

    _changeIsValid: ->
      if @model.get('is_valid')
        @ui.btnQrScan.hide()
        @ui.btnSave.css('display', 'inline-block')
        @ui.btnCancel.css('display', 'inline-block')
        @ui.hiddenAddressFirstbits.text @model.get('public_address').slice(0,8)
        @ui.inputAddress
          .addClass('is-valid')
          .css('width', @ui.hiddenAddressFirstbits.outerWidth())
          .prop('disabled', true)
        @ui.balance.text("#{@model.get('balance')} #{@model.get('short_name')}").show()
        inputNameWidth = @$('.address-input').outerWidth() - @ui.inputAddress.outerWidth() - @ui.balance.outerWidth() - 10
        @ui.inputName.css('width', inputNameWidth).show().focus()
      else
        @model.clear()
        @_addError()

    _addError: ->
      @ui.inputAddress.addClass 'is-invalid'

    _clearErrors: ->
      @ui.inputAddress.removeClass 'is-invalid'

    _reset: (clearAddress = true) ->
      @model.clear()
      @_clearErrors()
      @ui.btnQrScan.show()
      @ui.btnSave.hide()
      @ui.btnCancel.hide()
      @ui.inputName.val('').hide()
      @ui.balance.text('').hide()
      @ui.inputAddress.removeClass('is-valid').prop('disabled', false).css('width', '100%')
      @ui.inputAddress.val('') if clearAddress

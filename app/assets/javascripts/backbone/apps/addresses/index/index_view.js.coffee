@Balances.module 'AddressesApp.Index', (Index, App, Backbone, Marionette, $, _) ->

  ##############################################################################
  # Layout
  ##############################################################################

  class Index.Layout extends App.Views.Layout
    template: 'addresses/index/layout'
    tagName: 'section'

    regions:
      formRegion: '#address-form-region'
      listRegion: '#address-list-region'

  ##############################################################################
  # List
  ##############################################################################

  class Index.Item extends App.Views.ItemView
    template: 'addresses/index/item'
    tagName: 'tr'

    serializeData: ->
      _.extend super,
        display_name: if @model.get('name') then @model.get('name') else @model.get('public_address'),
        @_getConversion()

    _getConversion: ->
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
        when 'usd'
          balance_value: '$' + @model.get('balance_usd')
          converted_shortname: ''
        when 'eur'
          balance_value: '€' + @model.get('balance_eur')
          converted_shortname: ''
        when 'gbp'
          balance_value: '£' + @model.get('balance_gbp')
          converted_shortname: ''
        when 'jpy'
          balance_value: '¥' + @model.get('balance_jpy')
          converted_shortname: ''
        else
          balance_value: @model.get('balance')
          converted_shortname: @model.get('shortname')

  class Index.List extends App.Views.CompositeView
    template: 'addresses/index/list'
    itemViewContainer: '#address-list'
    itemView: Index.Item
    id: 'address-list-container'

    events:
      'click #d-filters a': '_handleSort'
      'click #d-balances a': '_handleConversion'

    serializeData: ->
      _.extend super,
        selected_currency: @collection.conversion
        @_getConversion()

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
          balance_value: '$' + @model.get('total_usd')
          converted_shortname: ''
        when 'eur'
          balance_value: '€' + @model.get('total_eur')
          converted_shortname: ''
        when 'gbp'
          balance_value: '£' + @model.get('total_gbp')
          converted_shortname: ''
        when 'jpy'
          balance_value: '¥' + @model.get('total_jpy')
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

    events:
      'keydown @ui.inputAddress': '_handleKeyupInput'
      'paste @ui.inputAddress': '_handlePasteInput'
      'cut @ui.inputAddress': '_handleCutInput'
      'click @ui.btnSave': '_handleSave'
      'click @ui.btnCancel': '_handleCancel'

    initialize: ->
      @listenTo App.vent, 'scan:qr', @_handleScanQr

    _handleKeyupInput:
      _.debounce (event) ->
        return if isPasteKey(event) or
                  isSelectAllKey(event) or
                  isArrowKey(event)

        inputVal = @ui.inputAddress.val()
        @_clearErrors()

        if inputVal.length is 0
          @_clearCurrencyImage()
        else if inputVal.length < 27
          @model.detectCurrency
            data:
              public_address: inputVal
            success: (response) =>
              @_setCurrencyImage response
        else
          @model.info
            data:
              public_address: inputVal
            success: (response) =>
              if response.is_valid
                @_isValidAddress response
              else
                @_addError()
            error: =>
              @_addError()
      , 800

    _handlePasteInput: (event) ->
      # Timeout so that the paste event completes and the input has data.
      $.doTimeout 50, =>
        inputVal = @ui.inputAddress.val()
        @_clearErrors()
        @_clearCurrencyImage()

        if inputVal.length < 27 or inputVal.length > 34
          @_addError()
          return

        @model.info
          data:
            public_address: inputVal
          success: (response) =>
            if response.is_valid
              @_isValidAddress response
            else
              @_addError()
          error: =>
            @_addError()

    _handleCutInput: (event) ->
      # Timeout so that the cut event completes and the input has data.
      $.doTimeout 50, =>
        if @ui.inputAddress.val().length is 0
          @_clearErrors()
          @_clearCurrencyImage()

    _handleScanQr: ->
      inputVal = @ui.inputAddress.val()
      @_clearErrors()
      @_clearCurrencyImage()

      if inputVal.length < 27 or inputVal.length > 34
        @_addError()
        return

      @model.info
        data:
          public_address: inputVal
        success: (response) =>
          if response.is_valid
            @_isValidAddress response
          else
            @_addError()
        error: =>
          @_addError()

    _handleSave: (event) ->
      event.preventDefault()
      balance = @ui.balance.text()
      @collection.create
        balance: balance.slice(0, _.indexOf(balance, ' ')).replace(/,/g, '')
        currency: @ui.currencyType.find('img').attr('alt')
        name: _.str.trim(@ui.inputName.val())
        public_address: _.str.trim(@ui.inputAddress.val())
      ,
        wait: true
        success: (model, response, options) =>
          @_reset()
        error: (model, response, options) ->
          _.each JSON.parse(response.responseText).errors, (msg, key) =>
            mark "#{_.str.titleize(_.str.humanize(key))} #{msg}"

    _handleCancel: (event) ->
      event.preventDefault()
      @_reset(false)

    _setCurrencyImage: (response) ->
      @ui.currencyType.addClass('is-filled').html $('<img />',
        src: response.currency_image_path
        alt: response.currency)

    _isValidAddress: (response) ->
      @_setCurrencyImage response
      @ui.btnQrScan.hide()
      @ui.btnSave.css('display', 'inline-block')
      @ui.btnCancel.css('display', 'inline-block')
      @ui.hiddenAddressFirstbits.text @ui.inputAddress.val().slice(0,8)
      @ui.inputAddress
        .addClass('is-valid')
        .css('width', @ui.hiddenAddressFirstbits.outerWidth())
        .prop('disabled', true)
      @ui.balance.text("#{response.balance} #{response.shortname}").show()
      inputNameWidth = @$('.address-input').outerWidth() - @ui.inputAddress.outerWidth() - @ui.balance.outerWidth() - 10
      @ui.inputName.css('width', inputNameWidth).show().focus()
      @

    _addError: ->
      @ui.inputAddress.addClass 'is-invalid'

    _clearErrors: ->
      @ui.inputAddress.removeClass 'is-invalid'

    _clearCurrencyImage: ->
      @ui.currencyType.removeClass('is-filled').html('')

    _reset: (clearAddress = true) ->
      @_clearErrors()
      @_clearCurrencyImage()
      @ui.btnQrScan.show()
      @ui.btnSave.hide()
      @ui.btnCancel.hide()
      @ui.inputName.val('').hide()
      @ui.balance.text('').hide()
      @ui.inputAddress.removeClass('is-valid').prop('disabled', false).css('width', '100%')
      @ui.inputAddress.val('') if clearAddress

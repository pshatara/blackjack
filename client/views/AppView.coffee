class window.AppView extends Backbone.View

  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button> <button class="re-shuffle">Re-Shuffle?</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    "click .hit-button": ->
      @model.get('playerHand').hit()
    "click .stand-button": ->
      @model.get('dealerHand').stand(@model.get('playerHand').scores())
    "click .re-shuffle": ->
      @model.get('deck').length = 0
      @model.get('deck').shuffle()

  initialize: ->
    @render()
    hand = @model.get('playerHand')
    hand.on('win', @win, @)
    hand.on('lose', @lose, @)
    dealerHand = @model.get('dealerHand')
    dealerHand.on('win', @dealerWin, @)
    dealerHand.on('lose', @dealerLose, @)

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

  dealerWin: ->
    @lose()
  dealerLose:->
    @win()
  win: ->
    setTimeout(=>
      if confirm "You won! Play again?"
        @newGame()
    , 100);


  lose: ->
    setTimeout(=>
      if confirm "You lose... Play again?"
        @newGame()
    , 100);

  newGame: ->
    if @model.get('deck').length < 4
      @model.get('deck').shuffle()
    @model.deal()

    hand = @model.get('playerHand')
    hand.on('win', @win, @)
    hand.on('lose', @lose, @)
    dealerHand = @model.get('dealerHand')
    dealerHand.on('win', @dealerWin, @)
    dealerHand.on('lose', @dealerLose, @)
    @render()

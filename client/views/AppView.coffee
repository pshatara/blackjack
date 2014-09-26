class window.AppView extends Backbone.View

  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button> <button class="re-shuffle">Re-Shuffle?</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    "click .hit-button": ->
      @model.get('playerHand').hit()
      # @model.get('playerHand').bustOr21()
    "click .stand-button": -> @model.get('playerHand').stand()

  initialize: ->
    @render()
    hand = @model.get('playerHand')
    hand.on('win', @win, @)
    hand.on('lose', @lose, @)

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

  win: ->
    if confirm "You won! Play again?"
      @newGame()

  lose: ->
    if confirm "You lose... Play again?"
      @newGame()

  newGame: ->
    console.log "newGame in AppView"
    @model.deal()
    hand = @model.get('playerHand')
    hand.on('win', @win, @)
    hand.on('lose', @lose, @)
    @render()

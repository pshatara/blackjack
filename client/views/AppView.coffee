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
      console.log "playerHand " , @model.get('playerHand').scores()
      @model.get('dealerHand').stand(@model.get('playerHand').scores())

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
    console.log "DEALER WINS"
    @lose()
  dealerLose:->
    console.log "DEALER LOSES"
    @win()
  win: ->
    console.log "YOU WIN"
    if confirm "You won! Play again?"
      @newGame()

  lose: ->
    console.log "YOU LOSE"
    if confirm "You lose... Play again?"
      @newGame()

  newGame: ->
    console.log "newGame in AppView"
    @model.deal()
    hand = @model.get('playerHand')
    hand.on('win', @win, @)
    hand.on('lose', @lose, @)
    dealerHand = @model.get('dealerHand')
    dealerHand.on('win', @dealerWin, @)
    dealerHand.on('lose', @dealerLose, @)
    @render()

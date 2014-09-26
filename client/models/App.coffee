#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

  deal: ->
    console.log 'deal in App Model'
    deck = @get 'deck'
    console.log 'deck: ' + deck
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

  winOrLose: ->
    @get 'playerHand'.bustOr21()


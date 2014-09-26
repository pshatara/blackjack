class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop()).last()
    console.log "hit in hand"
    @bustOr21()

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false
    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0
    if hasAce then [score, score + 10] else [score]

  bustOr21: ->
    scoreArray = @scores()

    console.log "bustOr21 in hand"

    if scoreArray[0] == 21 or scoreArray[1] == 21
      console.log "trigger win"
      @trigger('win', this)
    if scoreArray[0] > 21 and (not scoreArray[1] or scoreArray[1] > 21)
      console.log "trigger lose"
      @trigger('lose', this)

class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer) ->
    if not @isDealer then @bustOr21();

  hit: (scores) ->
    if @deck.length == 0 then @deck.shuffle()
    @add(@deck.pop()).last()
    console.log "hit in hand", scores
    if @isDealer then @compare(scores) else @bustOr21()

  scores: ->
    # console.log 'scores'
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

  stand: (scores) ->
    console.log('stand ', scores)
    if not @models[0].get('revealed') then @models[0].flip()

    if @scores()[1]!=undefined and @scores()[1] > 16 then @compare(scores)
    else if @scores()[0] <= 16 then @hit(scores)
    else @compare(scores)

  bustOr21: ->
    scoreArray = @scores()

    console.log "bustOr21 in hand"

    if scoreArray[0] == 21 or scoreArray[1] == 21
      console.log "trigger win"
      @trigger 'win', @
    if scoreArray[0] > 21 and (not scoreArray[1] or scoreArray[1] > 21)
      console.log "trigger lose"
      @trigger 'lose', @

  compare: (scores) ->
    console.log(scores, @scores())
    userScore = scores[1]

    # USER - If ace and score is greater than 21, use low ace
    if userScore == undefined or userScore > 21
      console.log 'User score set to ' + scores[0]
      userScore = scores[0]


    if @scores()[1]?
      if userScore > @scores()[1]
        if @scores()[1] <= 16 then @hit(scores)

      #If dealer has higher score
      else if @scores()[1] < 22
        @trigger "win", @
        return
      # else @trigger "lose"

    #If dealer has lower score
    console.log 'user scores array is ' + scores
    console.log ('user score ' + userScore)
    if userScore > @scores()[0]
      if @scores()[0] <= 16 then @hit(scores)
      else @trigger "lose"
    #If dealer has higher score
    else if @scores()[0] < 22 then @trigger "win", @
    else @trigger "lose"

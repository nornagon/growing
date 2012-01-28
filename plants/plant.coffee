# generic plant definition
# A plant is constructed with
#  - a reference to the game (see ../game.coffee)
#  - a reference to the atom (game toolkit by nornagon), 
#  - a seed - an object with a .number property which is a float of any value (0.0 - 1.0 maybe a nice range?)

# plants expect to have their draw function called on a canvas which has already been translated and rotated in to position.
# A plant expect the ground to be at 0,0, and grows upward (e.g. towards 0,-X)
# draw is called with args:
#  - growth cycle - a number between 0.0 and 1.0, representing the life cycle of the plant.
#  - time - current time in seconds - basically; e.g. (Date.now() / 1000)

class Plant
  constructor: (@seed, @angle) ->
    @age = 0
    @duration = 360 # seconds - default - contains both birth and life, but not death
    @birth_duration = 90 # seconds
    @death_duration = 90 # seconds
    @opacity = 1.0 # we start out fully opaque
    
  update: (dt) ->
    @opacity = 1.0 - @stage_progress() if @stage() == 'death'
    @age += dt
  draw: ->
    ctx = atom.ctx
    ctx.beginPath()
    ctx.fillColor = 'black'
    
  stage: -> # returns current stage - 'birth', 'life', 'death'
    if @age > @duration
      'death'
    else if @age < @birth_duration
      'birth'
    else
      'life'
    
  stage_progress: -> # returns number 0-1.0 indicating progress through current stage
    stage = @stage()
    if stage == 'birth'
      @age / @birth_duration
    else if stage == 'life'
      (@age - @birth_duration) / (@duration - @birth_duration)
    else if stage == 'death'
      @age - @duration / @death_duration
    
    

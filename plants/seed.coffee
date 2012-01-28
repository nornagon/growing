seedRadius = 6
fallSpeed = 10

class Seed
  constructor: (@type, @angle, @height) ->
    @seed = randInt(1000)
    #new @type
    #@type.seed.color

  drawGround: ->
    ctx.save()
    ctx.translate 400, 300
    ctx.rotate @angle
    ctx.beginPath()
    ctx.arc planetRadius + planetWidth / 2 + @height, 0, seedRadius, 0, 2*Math.PI, false
    ctx.fillStyle = @type.seed.color
    ctx.fill()

    ctx.restore()

  update: (dt) ->
    @height = Math.max(0, @height - dt * fallSpeed)
  
  grow: -> # construct and return a plant
    new @type(this)
    
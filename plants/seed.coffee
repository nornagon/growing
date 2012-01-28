seedRadius = 4
fallSpeed = 10
groundHeight = 2

class Seed
  constructor: (@type, @angle, @height) ->
    @seed = randInt(1000)
    @alpha = 1

    # State = 'falling' -> 'resting' -> 'lifting'
    @state = 'falling'
    #new @type
    #@type.seed.color

  color: -> "hsla(#{@type.seed.hueOffset},54%,79%,#{@alpha})"

  drawGround: ->
    return if @state is 'done'

    ctx.save()
    ctx.translate 400, 300
    ctx.rotate @angle
    ctx.beginPath()
    ctx.arc planetRadius + planetWidth / 2 + @height, 0, seedRadius, 0, 2*Math.PI, false
    ctx.fillStyle = @color()
    ctx.fill()

#    ctx.strokeStyle = 'black'
#    ctx.lineWidth = 2
#    ctx.stroke()

    ctx.restore()

  update: (dt) ->
    switch @state
      when 'falling'
        @height -= dt * fallSpeed
        if @height <= groundHeight
          @height = groundHeight
          @state = 'resting'

      when 'lifting'
        @height += dt * 20
        @alpha -= dt * 1 * 0.3
        if @alpha <= 0
          @state = 'done'

  collect: ->
    @state = 'lifting'


seedRadius = 4
fallSpeed = 10
groundHeight = 2

class Seed
  constructor: (@type, @angle, @height) ->
    @seed = randInt(1000)
    @alpha = 1

    # State = 'falling' -> 'resting' -> 'lifting' -> 'held' -> 'planting' -> 'germination' -> 'fading'
    @state = 'falling'
    #new @type
    #@type.seed.color

  color: -> "hsla(#{@type.seed.hueOffset},54%,79%,#{@alpha})"

  draw: ->
    return if @state is 'done'

    ctx.save()
    ctx.translate 400, 300
    ctx.rotate @angle
    ctx.beginPath()
    ctx.arc 0, planetRadius + planetWidth / 2 + @height, seedRadius, 0, 2*Math.PI, false
    ctx.fillStyle = @color()
    ctx.fill()

#    ctx.strokeStyle = 'black'
#    ctx.lineWidth = 2
#    ctx.stroke()

    ctx.restore()

  update: (dt) ->
    switch @state
      when 'falling', 'planting'
        @height -= dt * fallSpeed
        if @height <= groundHeight
          if @state is 'falling'
            @height = groundHeight
            @state = 'resting'
          else
            @state = 'germination'
            @gtime = @type.seed.germinationTime

      when 'germination'
        @gtime -= dt
        if @gtime <= 0
          @state = 'fading'

      when 'lifting'
        @height += dt * 20
        @alpha -= dt * 1 * 0.3
        if @alpha <= 0
          @state = 'held'

      when 'fading'
        @alpha -= dt * 0.5
        if @alpha <= 0
          @state = 'done'
          game.plants.push new @type(@seed, @angle)


  collect: ->
    @state = 'lifting'

  plant: (@angle) ->
    @state = 'planting'
    @height = 20
    @alpha = 1


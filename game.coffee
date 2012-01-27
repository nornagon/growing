
canvas = atom.canvas
ctx = atom.ctx

vary = (amt) -> 2 * amt * (Math.random() - 0.5)
rand = (amt) -> amt * Math.random()
randInt = (amt) -> Math.floor rand(amt)

randomPlanetColor = -> "hsl(#{128 + vary(6) - 3}, 52%, #{83 + vary(3)}%)"
#randomPlanetColor = -> 'black'

sq = (x) -> x * x

class Particle
  constructor: ->
    @x = @y = @vx = @vy = @radius = 0
    @start = Date.now()
    @radius = 10
    @end = @start + 10 * 1000

  alpha: (time) ->
    dist = @end - @start
    return 0 if time >= @end
    
    Math.sin ((time - @start) / dist * Math.PI)

  color: -> "rgba(0,0,0,#{@alpha(Date.now())})"

  update: (dt) ->
    @x += dt * @vx
    @y += dt * @vy

  draw: ->
    ctx.beginPath()
    ctx.arc @x, @y, @radius, 0, 2*Math.PI, false
    color = @color Date.now()
    #console.log color
    ctx.fillStyle = color
    ctx.shadowColor = color
    ctx.fill()

class BackgroundPlanet extends Particle
  init: (isStart) ->
    @x = Math.random() * 800
    @y = Math.random() * 600
    @radius = sq(rand 13)
    @vx = vary(5)
    @vy = vary(5)
    @start = Date.now()
    @start -= randInt(30 * 1000) if isStart
    @end = Date.now() + 20 * 1000 + randInt(30 * 1000)

    @h = 128 - rand(6)
    @s = 52
    @l = 83 + vary(3)

  constructor: (isStart) ->
    @init isStart

  color: (time) -> "hsla(#{@h},#{@s}%,#{@l}%,#{@alpha time})"

  update: (dt) ->
    super(dt)
    @init() if Date.now() > @end

class Game extends atom.Game
  constructor: ->
    super()

    canvas.width = 800
    canvas.height = 600

    @backgroundPlanets = (new BackgroundPlanet(true) for [1..15])
    @particles = []

    @bgcolor = 'hsl(128,52%,83%)'
    ctx.fillStyle = @bgcolor

    @radius = 170
    @planetWidth = 23

    @dudeAngle = 3 * Math.PI / 2
    @dudeSpeed = 0.3

    @dudeHead = 25
    @dudeFeet = 5
    @dudeColor = 'red'

    @plant = new CircuitTree

    p = new Particle()
    p.x = 400
    p.y = 300
    p.vx = p.vy = 10
    @particles.push p

  update: (dt) ->
    @dudeAngle += dt * @dudeSpeed
    @dudeAngle %= 2*Math.PI

    p.update(dt) for p in @backgroundPlanets

    now = Date.now()
    i = 0
    # Update particles and delete any that have expired
    while i < @particles.length
      p = @particles[i]
      p.update(dt)
      if p.end <= now
        @particles[p] = @particles[@particles.length - 1]
        @particles.length--
      else
        i++

    @plant.update dt

  draw: ->
    ctx.fillStyle = 'rgb(174,231,191)'
    ctx.fillRect 0, 0, 800, 600

    @drawBackgroundPlanets()

    @drawPlanet()
    @drawDude()

    ctx.save()
    ctx.translate 400, 300
    ctx.rotate 2
    ctx.translate 0, @radius+10
    @plant.draw()
    ctx.restore()

    @drawParticles()

  drawBackgroundPlanets: ->
    ctx.shadowOffsetX = 0
    ctx.shadowOffsetY = 0
    ctx.shadowBlur = 8
    p.draw() for p in @backgroundPlanets

    ctx.shadowBlur = 0
    ctx.shadowColor = 'transparent'

  drawPlanet: ->
    ctx.beginPath()
    ctx.lineWidth = @planetWidth
    ctx.arc 400, 300, @radius, 0, 2*Math.PI, false

    ctx.strokeStyle = 'black'
    ctx.stroke()

  drawDude: ->
    ctx.save()
    ctx.translate(400, 300)
    ctx.rotate(@dudeAngle)
    ctx.beginPath()
    ctx.moveTo @radius + @dudeFeet, 0
    ctx.lineTo @radius + @dudeHead, 0
    ctx.strokeStyle = @dudeColor
    ctx.lineWidth = 5
    ctx.stroke()

    ctx.restore()

  drawParticles: ->
    p.draw() for p in @particles

game = new Game()
game.run()


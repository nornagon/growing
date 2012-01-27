
canvas = atom.canvas
ctx = atom.ctx

vary = (amt) -> 2 * amt * (Math.random() - 0.5)
rand = (amt) -> amt * Math.random()
randInt = (amt) -> Math.floor rand(amt)

randomPlanetColor = -> "hsl(#{128 + vary(6) - 3}, 52%, #{83 + vary(3)}%)"
#randomPlanetColor = -> 'black'

sq = (x) -> x * x

plants =
  binary: BinaryBush


planetRadius = 170
planetWidth = 23


class Particle
  constructor: ->
    @x = @y = @vx = @vy = @radius = 0
    @start = Date.now()
    @radius = 10
    @end = @start + 10 * 1000
    @fuzzy = 1000

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

    #ctx.fillStyle = color
    g = ctx.createRadialGradient @x, @y, @radius * 0.9, @x, @y, @radius
    g.addColorStop(0, color)
    g.addColorStop(1 - Math.min(0.95, @fuzzy / @radius), color)
    g.addColorStop(1, color.split(',').slice(0, 3).join(',') + ', 0.0)') # worst thing ever, to replace alpha part with 0.0
    ctx.fillStyle = g
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

    @h = vary(6)
    @s = 54 + vary(4)
    @l = 79 + vary(5)

  constructor: (isStart) ->
    super()
    @init isStart

  color: (hue, time, amul=1) -> "hsla(#{hue},#{@s}%,#{@l}%,#{amul * @alpha time})"

  update: (dt) ->
    super(dt)
    @init() if Date.now() > @end

  draw: (bgHue) ->
    ctx.beginPath()
    ctx.arc @x, @y, @radius, 0, 2*Math.PI, false
    hue = @h + bgHue

    g = ctx.createRadialGradient @x, @y, @radius * 0.9, @x, @y, @radius
    color = @color hue, Date.now()
    g.addColorStop 0, color
    g.addColorStop 1, @color hue, Date.now(), 0
    ctx.fillStyle = g
    ctx.fill()

class Game extends atom.Game
  constructor: ->
    super()

    canvas.width = 800
    canvas.height = 600

    @backgroundPlanets = (new BackgroundPlanet(true) for [1..15])
    @particles = []

    @backgroundHue = 138


    @dudeAngle = 3 * Math.PI / 2
    @dudeSpeed = 0.3

    @dudeHead = 25
    @dudeFeet = 5
    @dudeColor = 'white'
    
    @plants = [
      @plant = new CircuitTree
      @other_plant = new BinaryBush
    ]

    # Map from plant name -> number
    @playerSeeds = {}
    
    @groundSeeds = []

    @addSeed BinaryBush, 1, 40

    ###
    p = new Particle()
    p.x = 400
    p.y = 300
    p.vx = p.vy = 10
    @particles.push p
    ###

  addSeed: (type, angle, height) -> @groundSeeds.push new Seed type, angle, height

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

    i.update(dt) for i in @plants

    seed.update(dt) for seed in @groundSeeds
    @backgroundHue += 1*dt
    #@plant.update dt

  draw: ->
    @drawBackground()

    seed.drawGround() for seed in @groundSeeds

    @drawPlanet()
    @drawDude()


    @drawPlant(x, p) for p, x in @plants
    
    @drawParticles()

  drawPlant: (rotation, plant_object) ->
    ctx.save()
    ctx.translate 400, 300
    ctx.rotate rotation
    ctx.translate 0, planetRadius+10
    plant_object.draw()
    ctx.restore()
    
  drawBackground: ->
    ctx.fillStyle = "hsl(#{@backgroundHue},54%,76%)"
    ctx.fillRect 0, 0, 800, 600
    @drawBackgroundPlanets()

  drawBackgroundPlanets: ->
    p.draw(@backgroundHue) for p in @backgroundPlanets

  drawPlanet: ->
    ctx.beginPath()
    ctx.lineWidth = planetWidth
    ctx.arc 400, 300, planetRadius, 0, 2*Math.PI, false

    ctx.strokeStyle = 'black'
    ctx.stroke()

  drawDude: ->
    ctx.save()
    ctx.translate(400, 300)
    ctx.rotate(@dudeAngle)
    ctx.beginPath()
    ctx.arc planetRadius + planetWidth/2 - 1, 0, 20, Math.PI / 2, 3 * Math.PI / 2, true
    ctx.fillStyle = @dudeColor
    ctx.fill()

    ctx.restore()

  drawParticles: ->
    p.draw() for p in @particles

game = new Game()
game.run()


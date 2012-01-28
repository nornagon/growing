
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

avatar = new Image
avatar.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAglQAAIJUBXAiQdwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAgfSURBVFjDnVddbBTXFV7/Q+JCRHCDitSCmlQl7s9Tmjw0okXhHR4qS8lLqEifLKXvicRKRCJSpQQh9cFqwHjnxzAJphWtk9KfVUCxJWtbQZDVEIf4wdi7nr1z79yZ/fH+3p7v3l28C0aQWLramfHMOd895zvfOTehlEo8eiV6zFKtlew1y+szq33f/n+iJ5HQ7z/S9mM67nSY7FcqTWtigK4HFxe9QXOdbj3HO6oLzLcA0O04nU72ZzITA0vqzNDKirc9l0s9qRSWN+zTUurvdH3lCbrfrtTs0OJictCA+U1fC8g3jkDP5o6xu9mhHDkMlL1jRX6wKxufG1lfd5/xC94e35/cUyi4z2Sz3oiU3i5F7wDgsprcZoC0U7Q1kC123nae7l9amh3Czjj3dsJBsTj9PSGm90npPBdF7o+D2B0NAneUsdQBPCPH+xmb2ot3ufJ2AsjS0pkhk7Z2WrpT8gAAzwPidP/y8uQ2hPhuNPU0HPu+9Wwcp34i5YUXyPkvWZg6FITW4SCwDrPQPcS59TL+l+P2T31pPcuYt1epT3YhRcYWUoKNPRRA4t7OEfJ8/ux3stlzI0I4P8jSLnOB/RILnVeYcI/kufVaIKxjQegeD2n5gf3bPHdeY8I+Ss8IlP1SEJwfxbcEdjdswSZsJ5OqKx0dAEzOTci84TiG88l9Qlg/z+atX8Exhf/1QDpvstB+KxD2SR7ap7Do/h0mnLfp2e8BTET0buweXKdvc2FqPzjj+95wy3bffQBM3k3oMwO53B+ejCjsQE/k+hlCTTscY9waD4RzIpD2+36QOktOHV/YHsOia/o9y4R1mgCeYNwZD8KpMXwLEGtkC6m8Sbbho6NMNwGg1JArWk+BSCCXEO5BCudYa9enKOcf0O8lcnQ1EO51GX9yIwjtOdr5NfrfVT+wZjQQejdP0fBDeyyvbbijeeLRsph8SinwQZOyC0Avyg2sjWNvBCSScvpF5JRLa9zn1ru+sKby3J5l3J6j55/nhfNlpXq3EBWvZwnMl3hGjueIH7P0/hRA0O+4iKwjsAUSIxU5rR8TAybiqieRTCZM7jVJ7B3YPScmE+rDQeQeQ9gZhRyGefjRf4nxcLYSxv/g9YaslytflAjMOp5xeemOkH++kefux/qbwEpqspItVAeqKVCzOwwhASABAFC6dD8UTpLIoM4JxC+we4SRyHUaoQ0p3KWNW/mokA4IiIgLc2XagapUV+tc/q0UFz4rVqor5VKZgiMvLTCdDud0oG24R7JkM5f703742ExDsrfF/nb4z43IDec51DSX9qua7aFDebeuiujKF41GsUarUa2t12t13gSAZrNOa0PRc7pvqEJpgTPu3jI8Ic5w+y1K3auctMMnsVLK3W1kO90GYPKPMlknSWVx6oCInV/r0EnnJBgOkuWFdVsWPg3rddFQW/w1m1VVLN+qUIp8cn6bvr9Gjqk6nJMicl6HTdiGD9M7UA33AHiDAABth7yGBeeVILKO8wjMty+SAM1RFL6itDAKcx073RrA51UuLzImpr+mtM3jW66rxz2+HkA1z48WyIfSDQx9QgPQPX0QkgkAccV7XktsmHoD7Nd1zq154sAK5bdYr0vy3twqCKrR3GhWqmvVYvkG87lDACwNIIzc40a2AWBSA1hU3mBHBBAOcGDmu2gsWuepArTCUQpk9HGmVvOLjWa5gZxvFQGAqtVZvdmsNau1XEHImXmdPkojlekxkuxDjF04gM6Zy3WkINnS/zU18UREBEFXo52/DOJQPjUJKYT/LJb+s0pLFIoLJSJh437n1epaXcb/jgPx0SoPL/8vCD/8lyYwSTQHCcmmb7robhAe8wX6QqsKklSG721foX4O7WbU1RizjwpSQCHd9ykNMwSGQkoawN21cuWrCpzWG1ETCxCq1dUq5T5LmnCbNjBPRJxhQbsM7aPolKI8vQ/zBEq+rYat4QNCdGaIZHfHCgkRREMTUbSESBghopAu8OjynWotWyYu1KLCpxGVp6DQV6kM6yL66zLe0YpJ36Av6PCTLYgbRE6RD6U2m1KiNTz2mkaUokZ0ZbeW4tL0i+sUBTQhyCqDFIf2LJcfLtCuN0rlW3mKxtdUnneiwrXV8sZtX0ZXbxq5dqY0gaUzjs6I9rwRXvgh2rsZ5yZaDSmhI6DVkH77OptRHNvPo6VSKY0hFQwGSV7p/pKI/nJNxDPz1Gzmjf7b18No9jPK9+W8EZ9TpANvopGJOHUQ7DcS7+00Kqj6OqbnRE+7HyAKa6RSaJ3lsvd9tFIz+dhjnHajWy3kVauj7VBELurFIVbkOKB2LKwTaEJ+sNmO0drv3p152ijgxEDneGaGAg2ieyBB5wJptAGKhJ52qDR1mxWpt2mX77Q63rsYTiC5QtKuMZBgahJmIEFvyaLDdg0kOuIPzoQGRLI/vZzcZkYyT49k6OdmzLIOI6coUZCLdv8GFpyi1BjyrQVncyRDf8mrzZHs/rlwi3Fc9baHUr81lKIyQEwwWRYvvICahrAAEBwi1HjGpG2GUh9D6dRefOur9DCcZzK/u0e8R50LOsbyM0NgLciDQQVGoRP5/NSP9FiuI3P+gbEcHa89listuQ8/GzzkVNR5MMkMLC+ntxkgEztl+2BSwMEEhxJvD66RZxxMoCXGMdgOuW07T/R8w7NhG4jXh4HFsBdHs/e2g82+/8dhEAtcwfVNcmoUDrnWg+djnREf62TcImevAZNsgcHKDLSvM/cOqF3h7vm2Z8OtyHnf0fzBZYB2HeUfafv/dZF4IuewZj8AAAAASUVORK5CYII="

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


    @dudeLocation = 3 * Math.PI / 2
    @dudeAngle = 0
    @dudeSpeed = 0.16

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
    @dudeLocation += dt * @dudeSpeed
    @dudeLocation %= 2*Math.PI
    @dudeAngle += dt * 2
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

    @drawPlanet()
    @drawDude()

    seed.drawGround() for seed in @groundSeeds

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

  drawDude2: ->
    ctx.save()
    ctx.translate(400, 300)
    ctx.rotate(@dudeLocation)
    ctx.beginPath()
    ctx.arc planetRadius + planetWidth/2 - 1, 0, 20, Math.PI / 2, 3 * Math.PI / 2, true
    ctx.fillStyle = @dudeColor
    ctx.fill()

    ctx.restore()

  drawDude: ->
    ctx.save()
    ctx.translate(400, 300)
    ctx.rotate @dudeLocation
    ctx.translate planetRadius + planetWidth/2 + 15 + Math.sin(@dudeAngle) * 2, 0
    #ctx.rotate @dudeAngle

    ctx.drawImage avatar, -16, -16

    ctx.restore()

  drawParticles: ->
    p.draw() for p in @particles

game = new Game()
game.run()


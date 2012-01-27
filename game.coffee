
canvas = atom.canvas
ctx = atom.ctx

vary = (amt) -> 2 * amt * (Math.random() - 0.5)
rand = (amt) -> amt * Math.random()
randInt = (amt) -> Math.floor rand(amt)

randomPlanetColor = -> "hsl(#{128 + vary(6) - 3}, 52%, #{83 + vary(3)}%)"
#randomPlanetColor = -> 'black'

sq = (x) -> x * x

class BackgroundPlanet
  init: (isStart) ->
    @x = Math.random() * 800
    @y = Math.random() * 600
    @radius = sq(rand 13)
    @vx = vary(5)
    @vy = vary(5)
    @start = Date.now()
    @start -= randInt(10 * 1000) if isStart
    @end = Date.now() + 20 * 1000 + randInt(30 * 1000)

    @h = 128 - rand(6)
    @s = 52
    @l = 83 + vary(3)

  constructor: (isStart) ->
    @init isStart

  alpha: (time) ->
    dist = @end - @start
    return 0 if time >= @end
    
    Math.sin ((Date.now() - @start) / dist * Math.PI)

  color: (time, amul=1) -> "hsla(#{@h},#{@s}%,#{@l}%,#{amul * @alpha time})"

  update: (dt) ->
    @x += dt * @vx
    @y += dt * @vy

    @init() if Date.now() > @end


class Game extends atom.Game
  constructor: ->
    super()

    canvas.width = 800
    canvas.height = 600

    @backgroundPlanets = (new BackgroundPlanet(true) for [1..15])

    @bgcolor = 'hsl(128,52%,83%)'
    ctx.fillStyle = @bgcolor

    @radius = 170
    @planetWidth = 23

    @dudeAngle = 0
    @dudeSpeed = 0.3

    @dudeHead = 25
    @dudeFeet = 5
    @dudeColor = 'red'

    @plant = new CircuitTree

  update: (dt) ->
    @dudeAngle += dt * @dudeSpeed
    @dudeAngle %= 2*Math.PI

    p.update(dt) for p in @backgroundPlanets

    @plant.update dt

  draw: ->
    @drawBackground()

    @drawPlanet()
    @drawDude()

    #ctx.save()
    #ctx.translate 400, 300
    #ctx.rotate 2
    #ctx.translate 0, @radius+10
    #@plant.draw()
    #ctx.restore()

  drawBackground: ->
    ctx.fillStyle = 'rgb(174,231,191)'
    ctx.fillRect 0, 0, 800, 600

    now = Date.now()
    for p in @backgroundPlanets
      ctx.beginPath()
      ctx.arc p.x, p.y, p.radius, 0, 2*Math.PI, false
      color = p.color now
      g = ctx.createRadialGradient(p.x, p.y, p.radius * 0.9, p.x, p.y, p.radius)
      g.addColorStop 0, color
      g.addColorStop 1, p.color now, 0
      ctx.fillStyle = g
      ctx.fill()
    return


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


game = new Game()
game.run()


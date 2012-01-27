
canvas = atom.canvas
ctx = atom.ctx

vary = (amt) -> 2 * amt * (Math.random() - 0.5)

randomPlanetColor = -> "hsl(#{128 + vary(5)}, 52%, #{83 + vary(4)}%)"
#randomPlanetColor = -> 'black'

sq = (x) -> x * x

class Game extends atom.Game
  constructor: ->
    super()

    canvas.width = 800
    canvas.height = 600

    @backgroundPlanets = []
    for [1..5]
      @backgroundPlanets.push
        x:Math.random() * 800
        y:Math.random() * 600
        radius:Math.random() * 200
        color:randomPlanetColor()
        vx:sq(Math.random() * 6) - 18
        vy:sq(Math.random() * 6) - 18

    @bgcolor = 'hsl(128,52%,83%)'
    ctx.fillStyle = @bgcolor

    @radius = 170
    @planetWidth = 23

    @dudeAngle = 0
    @dudeSpeed = 0.3

    @dudeHead = 25
    @dudeFeet = 5
    @dudeColor = 'red'

  update: (dt) ->
    @dudeAngle += dt * @dudeSpeed
    @dudeAngle %= 2*Math.PI

    for p in @backgroundPlanets
      p.x += dt * p.vx
      p.y += dt * p.vy

#      unless -p.radius < p.x < 800+p.radius and -p.radius < p.y < 600+p.radius


  draw: ->
    @drawBackground()

    @drawPlanet()
    @drawDude()


  drawBackground: ->
    ctx.fillStyle = 'rgb(174,231,191)'
    ctx.fillRect 0, 0, 800, 600

    for p in @backgroundPlanets
      ctx.beginPath()
      ctx.arc p.x, p.y, p.radius, 0, 2*Math.PI, false
      ctx.fillStyle = p.color
      ctx.fill()


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


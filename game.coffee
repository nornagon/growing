
canvas = atom.canvas
ctx = atom.ctx

class Game extends atom.Game
  constructor: ->
    super()

    canvas.width = 800
    canvas.height = 600

    @radius = 200
    @planetWidth = 10

  update: ->
  draw: ->
    ctx.fillStyle = 'white'
    ctx.fillRect 0, 0, 800, 600

    @drawPlanet()


  drawPlanet: ->
    ctx.beginPath()
    ctx.strokeStyle = 'black'
    ctx.lineWidth = @planetWidth
    ctx.arc 400, 300, @radius, 0, 2*Math.PI, false
    ctx.stroke()


game = new Game()
game.run()


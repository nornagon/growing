class Reed extends Plant
  constructor: ->
    @mature = 30
    @age = 0
    @height = Math.random() * 10 + 5
  update: (dt) ->
    @age += dt
  draw: ->
    ctx = atom.ctx
    ctx.beginPath()
    ctx.moveTo 0, 0
    ctx.lineTo 0, @age/@mature * @height
    ctx.strokeStyle = 'black'
    ctx.stroke()
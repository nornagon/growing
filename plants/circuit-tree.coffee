class CircuitTree extends Plant
  constructor: (seed) ->
    super seed
    @sprouts = []
    for i in [0..5]
      @sprouts.push {
        bornTime: if i == 2 then 0 else Math.random()*15
        offsetX: ((i-3)/5) * 15
      }
  update: (dt) ->
    super dt
  draw: ->
    ctx = atom.ctx
    ctx.strokeStyle = 'black'
    ctx.lineWidth = 0.5
    for s in @sprouts
      sprout_age = @age - s.bornTime
      if sprout_age >= 0
        ctx.beginPath()
        ctx.moveTo s.offsetX, 0
        ctx.lineTo s.offsetX, sprout_age
        ctx.stroke()
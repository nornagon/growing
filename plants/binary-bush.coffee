class BinaryBush extends Plant
  constructor: (seed) ->
    super seed
    @depth = 5
  update: (dt) ->
    super dt
  draw: ->
    @drawBranch @depth
  drawBranch: (depth) ->
    # draws a single branch, then branches again, until depth is exhausted
    return unless depth > 0
    tau = Math.PI * 2
    
    ctx = atom.ctx
    ctx.fillStyle = GameColors.stalk
    ctx.lineWidth = depth
    ctx.beginPath()
    base_width = depth / 5
    ctx.moveTo -base_width, 0
    ctx.lineTo base_width, 0
    ctx.lineTo 0, depth * 10
    ctx.closePath()
    ctx.fill()
    
    ctx.translate 0, depth * 10
    ctx.rotate(tau / 8)
    @drawBranch depth - 1
    ctx.rotate(tau / 4)
    @drawBranch depth - 1
  drawFruit: ->
    ctx = atom.ctx
    ctx.fillStyle = 'red'
    ctx.beginPath()
    ctx.arc 0, 0, 0, 0, false
    ctx.fill
    
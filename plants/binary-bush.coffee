class BinaryBush extends Plant
  constructor: (seed) ->
    super seed
    @depth = 7
    @duration = 90 # seconds
  update: (dt) ->
    super dt
    @current_depth = @depth * (1 + Math.sin(@age / @duration * Math.PI)) / 2
  draw: ->
    @drawBranch(@current_depth) # if @age < @duration
  drawBranch: (depth) ->
    # draws a single branch, then branches again, until depth is exhausted
    return unless depth > 0
    tau = Math.PI * 2
    
    ctx = atom.ctx
    ctx.fillStyle = GameColors.stalk
    ctx.lineWidth = depth
    ctx.beginPath()
    base_width = depth / 2
    top_width = depth / 3
    branch_length = depth * 6
    ctx.moveTo -base_width, 0
    ctx.lineTo base_width, 0
    ctx.lineTo top_width, branch_length
    ctx.lineTo -top_width, branch_length
    ctx.closePath()
    ctx.fill()
    
    ctx.save();
    ctx.translate 0, branch_length
    ctx.rotate(tau / 8)
    @drawBranch depth - 1
    ctx.restore();
  
    ctx.save();
    ctx.translate 0, branch_length
    ctx.rotate(-(tau / 8))
    @drawBranch depth - 1
    ctx.restore()
    
  drawFruit: ->
    ctx = atom.ctx
    ctx.fillStyle = 'red'
    ctx.beginPath()
    ctx.arc 0, 0, 0, 0, false
    ctx.fill()
    
BinaryBush.seed =
  color: 'red'


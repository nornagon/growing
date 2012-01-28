class BinaryBush extends Plant
  constructor: (seed, angle) ->
    super seed, angle
    @depth = 7
    @duration = 10 # seconds
    @tau = Math.PI * 2
    @fruit_radius = 3
    
    @randoms = (@natural_random() for x in [0..@depth * 10])
    
  update: (dt) ->
    super dt
    @current_depth = @depth * (1 + Math.sin((@stage_progress() * @tau) - Math.PI / 2)) / 2 if @stage() == 'birth'
    
  draw: ->
    
    atom.ctx.save()
    @next_random.idx = 0 # reset random lookup function back to how it was last time we drew..
    @drawBranch(@current_depth, 0) if @age < @duration
    atom.ctx.restore()
    
  next_random: ->
    @next_random.idx += 1
    @randoms[@next_random.idx % @randoms.length]
    
  natural_random: ->
    (1.5 - (Math.random() + Math.random() + Math.random())) / 1.5
    
  drawBranch: (depth, level) ->
    # draws a single branch, then branches again, until depth is exhausted
    return unless depth > 0
    @next_random.idx = level
    
    ctx = atom.ctx
    ctx.fillStyle = GameColors.stalk
    ctx.lineWidth = depth
    ctx.beginPath()
    base_width = depth / 1.5
    top_width = depth / 3
    length_mod = 6 + @next_random()
    length_mod *= 4 if depth == @current_depth
    branch_length = Math.min(1, depth) * length_mod 
    ctx.moveTo -base_width, 0
    ctx.lineTo base_width, 0
    ctx.lineTo top_width, branch_length
    ctx.lineTo -top_width, branch_length
    ctx.closePath()
    ctx.fill()
    
    if depth <= 1 && @current_depth > @depth - 1
      ctx.save();
      ctx.translate 0, branch_length
      @drawFruit(depth)
      ctx.restore()
    else
      splay_1 = @next_random()
      splay_2 = @next_random()
      
      ctx.save();
      ctx.translate 0, branch_length
      ctx.rotate(@tau / 8 - splay_1 / 2)
      @drawBranch depth - 1, level + 1
      ctx.restore();
  
      ctx.save();
      ctx.translate 0, branch_length
      ctx.rotate(-((@tau / 8) + splay_2 / 2))
      @drawBranch depth - 1, level + 1
      ctx.restore()
    
  drawFruit: (cycle)->
    ctx = atom.ctx
    ctx.fillStyle = 'red'
    ctx.beginPath()
    ctx.arc 0, 0, @fruit_radius * cycle, @tau, false
    ctx.closePath()
    ctx.fill()
    
BinaryBush.seed =
  hueOffset: 60
  germinationTime: 4


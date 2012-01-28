class Nutrients
  constructor: ->
    @buckets = new Array(16)
    for i in [0...@buckets.length]
      @buckets[i] = 0.8 + vary(0.1)
    @levelRate = 0.005
    @color = 'hsla(0,74%,85%,0.4)'

  left: (i) -> (i - 1 + @buckets.length) % @buckets.length
  right: (i) -> (i + 1) % @buckets.length
  update: (dt) ->
    for b,i in @buckets
      # level out the values in the buckets over time
      if @buckets[@left i] - b < 0
        amt = @levelRate*dt*(b-@buckets[@left i])
        @buckets[i] -= amt
        @buckets[@left i] += amt
      if @buckets[@right i] - b < 0
        amt = @levelRate*dt*(b-@buckets[@right i])
        @buckets[i] -= amt
        @buckets[@right i] += amt

  total: ->
    @buckets.reduce (m,o) -> m+o
  draw: ->
    ctx = atom.ctx
    ctx.beginPath()
    ctx.arc 0,0,planetRadius,0, TAU, true
    cpdist = TAU/@buckets.length/2
    for v,i in @buckets
      r = (1-v*0.4) * planetRadius * 0.9
      theta = i/@buckets.length * TAU
      x = Math.cos(theta)*r
      y = Math.sin(theta)*r
      if i == 0
        ctx.moveTo x, y
      else
        cpX = Math.cos(theta-cpdist)*r
        cpY = Math.sin(theta-cpdist)*r
        ctx.bezierCurveTo prevCP.x, prevCP.y, cpX, cpY, x, y
      prevCP = { x: Math.cos(theta+cpdist)*r, y: Math.sin(theta+cpdist)*r }

    r = (1-@buckets[0]*0.4)*planetRadius*0.9
    cpX = Math.cos(0-cpdist)*r
    cpY = Math.sin(0-cpdist)*r
    ctx.bezierCurveTo prevCP.x, prevCP.y, cpX, cpY, r, 0
    ctx.fillStyle = @color
    ctx.fill()
        
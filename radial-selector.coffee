class RadialSelector
  constructor: ->
    @seed_store = [{ kind: 'red', quantity: 80 }, { kind: 'green', quantity: 2 }, { kind: 'purple', quantity: 5 }] # , { kind: 'yellow', quantity: 3 }]
    @selector_image = new Image
    @selector_image.src = 'assets/selector.png'
    
  adjust: (seed_kind, adjustment) ->
    # adjust the quantity of any kind of seed by name - provide a positive or negative number to add or subtract
    success = false
    for value in @seed_store
      if value.kind == seed_kind
        value.quantity += adjustment
        success = true
    
    unless success
      @seed_store.push({ kind: seed_kind, quantity: adjustment })
    
  # get current seed kind and quantity  
  selection: ->
    @seed_store[@selected_index] if @selected_index?
  
  # get a list of available seed kinds
  available_seeds: ->
    seed.kind for seed in @seed_store
    
  # update state with mouse information
  update: ->
    @selected_index = 0;
    
    @square_distance ?= (x, y) ->
      (x * x) + (y * y)
    
    # calculate which seed type is pointing towards the cursor
    y_offset = atom.canvas.height / 2 - atom.input.mouse.y
    x_offset = atom.input.mouse.x - atom.canvas.width / 2
    
    
    @selected_index = if @square_distance(x_offset, y_offset) < @square_distance(planetRadius - planetWidth/2, 0)
      angle = Math.atan2(y_offset, x_offset) / Math.PI * 180 + 180
      angle = ((angle + 360 - (360 / (@seed_store.length * 4))) % 360)
      angle -= 90
      Math.floor((360-angle) / (360 / @seed_store.length)) % @seed_store.length; # selects the index closest to the mouse pointer
    
  # draw interface to canvas
  draw: ->
    tao = Math.PI * 2
    
    turn = tao / @seed_store.length
    deg = (deg) -> (-deg / 360) * tao
    
    for item, index in @seed_store
      ctx.save()
      ctx.rotate index * turn
      @draw_seed_row item.kind, item.quantity # TODO: kind should lookup seed object and fetch it's colour
      ctx.restore()
      
    if @selected_index?
      ctx.save()
      ctx.rotate deg(@selected_index * (360 / -@seed_store.length))
      ctx.rotate deg(-90)
      ctx.drawImage(@selector_image, -7, -45)
      ctx.restore()
    
    
  draw_seed_row: (color, quantity) ->
    mid_range_radius = 120 #px
    max_dots = 8
    offset_from_center = 30
    computed_position = (avatar_num) -> offset_from_center + Math.atan(avatar_num / 5) * mid_range_radius
    computed_radius = (avatar_num) -> Math.exp(-1.5 * (avatar_num / max_dots)) * 6
    
    ctx = atom.ctx
    ctx.fillStyle = color
    for i in [0... Math.min(max_dots, quantity)]
      ctx.save()
      ctx.translate 0, computed_position(i)
      ctx.beginPath()
      ctx.arc 0, 0, computed_radius(i), 0, Math.PI * 2, false
      ctx.closePath()
      ctx.fill()
      ctx.restore()
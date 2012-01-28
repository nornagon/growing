class Path
  constructor: ->
  point: (a) -> {x:0, y:0}

class LinePath extends Path
  constructor: (@length) ->
  point: (a) -> {x:0, y:a*@length}

class CirclePath extends Path
  constructor: (length, @radius, @dir) ->
    @maxTheta = length / radius
  point: (a) ->
    theta = a * @maxTheta
    {
      x: (Math.cos(theta) - 1) * @radius * @dir
      y: Math.sin(theta) * @radius
    }

class Curl
  constructor: ->
    length = rand(20)+23
    radius = rand(30)+20
    dir = randInt(2)*2-1
    @initialPath = new LinePath length
    @finalPath = new CirclePath length, radius, dir
  pointAt: (a, t) ->
    from = @initialPath.point a
    to = @finalPath.point a
    {
      x: lerp(t, from.x, to.x)
      y: lerp(t, from.y, to.y)
    }



class Curlicure extends Plant
  constructor: (seed, angle) ->
    super seed, angle
    @components = []
    for i in [0..5]
      @components.push {
        age: -rand(4)
        stage: ->
          x = @age/@maxAge
          #(1-(x-1)*(x-1))*@maxAge
          (Math.sqrt(Math.sin(x*Math.PI/2)))*@maxAge
        growthRate: 0.5 + vary(0.1)
        maxAge: 25 + vary(5)
        posX: vary(16)
        width: 0.3 + vary(0.3)
        curl: new Curl
      }

  update: (dt) ->
    super dt
    console.log @stage(), @age
    for c in @components
      if c.age < c.maxAge
        c.age = Math.min c.maxAge, c.age + c.growthRate * dt
      if @stage() == 'life' and !c.seed? and c.age > c.maxAge * 0.8 and Math.random() < 0.1*dt
        c.seed = -rand(10)
      if @stage() == 'death' and c.seed < 0
        c.seed = undefined
      if c.seed? and c.seed < 2
        c.seed += 0.5 * dt
      if c.seed >= 2 and Math.random() < 0.1*dt
        age = c.stage()/c.maxAge
        endPoint = c.curl.pointAt age, age
        [d, theta] = treePos2Polar @angle, c.posX + endPoint.x, endPoint.y
        console.log @angle, c.posX, endPoint.x, endPoint.y
        game.addSeed Curlicure, theta, d-planetRadius
        c.seed = -20*rand(10)
  draw: ->
    ctx = atom.ctx
    for c in @components
      continue if c.age < 0
      @drawComponent c

  drawComponent: (c) ->
    ctx = atom.ctx
    ctx.save()
    ctx.globalAlpha = @opacity
    ctx.translate c.posX, 0
    age = c.stage()
    samples = Math.floor(age)
    ctx.beginPath()
    for i in [0..samples]
      t = age/c.maxAge * i/samples
      p = c.curl.pointAt t, age/c.maxAge
      if i == 0
        ctx.moveTo p.x, p.y
      else
        ctx.lineTo p.x, p.y

    ctx.lineWidth = 1 + age/c.maxAge * c.width
    ctx.strokeStyle = 'black'
    ctx.stroke()
    if c.seed? and c.seed > 0
      ctx.beginPath()
      ctx.arc p.x, p.y, c.seed, 0, Math.PI*2
      ctx.fillStyle = 'red'
      ctx.fill()
    ctx.restore()
      
Curlicure.seed =
  hue: 0
  radius: 2
  germinationTime: 4

class BinaryBush extends Plant
  constructor: (atom, seed)->
    @atom = atom
    @seed = seed
    
  update: ->
  draw: (growth_cycle, time)->
    ctx = @atom.ctx
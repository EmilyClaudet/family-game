--NPC class for future use

NPC = {}

function NPC:new(x,y,v,xoff,yoff,w,h) --will include spritesheet later
  directions = {
    down = love.graphics.newQuad(0, 0, 32, 32, 32, 96),
    up = love.graphics.newQuad(0, 32, 32, 32, 32, 96),
    left = love.graphics.newQuad(0, 64, 32, 32, 32, 96),
    right = love.graphics.newQuad(0, 96, 32, 32, 32, 96)
  }

  o = {
    x = x,
    y = y,
    v = v,
    xoff = xoff,
    yoff = yoff,
    w = w,
    h = h,
    directions = directions,
    images = spritesheet,
    facing = directions.down,
    dialoguebox = {x = x + xoff, y = y + yoff - 32, w = w, h = h}
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function NPC:move(x,y)
  self.x = self.x + x
  self.y = self.y + y
end

function NPC:turn(dir)
  self.facing = directions.dir
end

function NPC:speak(player,dialogue,dt)
  dialogue.printText(dt)
  if player.curr_anim == player.animations["downidle"] then
    NPC.turn(up)
  elseif player.curr_anim == player.animations["upidle"] then
    NPC.turn(down)
  elseif player.curr_anim == player.animations["leftidle"] then
    NPC.turn(right)
  elseif player.curr_anim == player.animations["rightidle"] then
    NPC.turn(left)
  end
end

return NPC

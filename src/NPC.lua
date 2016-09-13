
direction = {
  down = love.graphics.newQuad(0, 0, 32, 32, 32, 96),
  up = love.graphics.newQuad(0, 32, 32, 32, 32, 96),
  left = love.graphics.newQuad(0, 64, 32, 32, 32, 96),
  right = love.graphics.newQuad(0, 96, 32, 32, 32, 96)
}

NPC = {}

function NPC:new(x,y,v,xoff,yoff,w,h,spritesheet)
  o = {
    x = x,
    y = y,
    v = v,
    xoff = xoff,
    w = w,
    h = h,
    images = spritesheet,
    facing = direction.down
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
  self.facing = direction.dir
end

function NPC:speak(dialogue)

end

return NPC

--NPC class for future use

NPC = {}

function NPC:new(x,y,v,xoff,yoff,w,h,dialogue) --will include spritesheet later
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
    dialogue = dialogue,
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

function NPC:speak(player,key)
  if key == "space" and checkcollision(player.dialoguebox, self.dialoguebox) then
    self.dialogue.start = true
    player.control = false
    if self.dialogue.curr_let == self.dialogue.curr_linelen and key == "space" then
      self.dialogue.curr_let = 0
      self.dialogue.curr_line = self.dialogue.curr_line + 1
      if self.dialogue.curr_line > self.dialogue.numberofLines then
        self.dialogue.start = false
        self.dialogue.curr_line = 1
        player.control = true
      end
      self.dialogue.curr_linelen = string.len(self.dialogue.lines[self.dialogue.curr_line])
    end
  end

end

return NPC

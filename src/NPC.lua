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
--[[
function NPC:decide(player,key)
  self.dialogue.curr_line = self.dialogue.numberofLines
  self.dialogue.curr_let = string.len(self.dialogue.lines[self.dialogue.curr_line])
  self.dialogue.drawdecisionbox = true
end]]

function NPC:comment(player,key)
  if key == "space" and checkcollision(player.dialoguebox, self.dialoguebox) then
--    self.dialogue.lines = lines
    self.dialogue.start = true
    player.control = false
    --checks if whole message has been typed. If player then presses space message goes to next line.
    if self.dialogue.curr_let == self.dialogue.curr_linelen and key == "space" then
      self.dialogue.curr_let = 0
      self.dialogue.curr_line = self.dialogue.curr_line + 1
      --if next line does not exist dialogue stops and current line reset for next dialogue triggered.
      if self.dialogue.curr_line > self.dialogue.numberofLines then
        self.dialogue.start = false
        self.dialogue.curr_line = 1
        player.control = true
      end
      self.dialogue.curr_linelen = string.len(self.dialogue.lines[self.dialogue.curr_line])
    end

  end

end



--VERY messy. Need to break down into smaller functions!
function NPC:question(player,key)
  if key == "space" and self.dialogue.drawdecisionbox then
    if player.cursor.yoff == 45 then
      self.dialogue.lines = self.dialogue.topresponse
    else
      self.dialogue.lines = self.dialogue.bottomresponse
    end
    self.dialogue.curr_line = 1
    self.dialogue.curr_let = 0
    self.dialogue.drawdecisionbox = false
    self.dialogue.isDecision = false
    self.dialogue.numberofLines = #self.dialogue.lines
  end

  if key == "space" and checkcollision(player.dialoguebox, self.dialoguebox) and self.dialogue.drawdecisionbox == false then
    self.dialogue.start = true
    player.control = false
    --checks if whole message has been typed. If player then presses space message goes to next line.
    if self.dialogue.curr_let == string.len(self.dialogue.lines[self.dialogue.curr_line]) and key == "space" then
      self.dialogue.curr_let = 0
      self.dialogue.curr_line = self.dialogue.curr_line + 1
      --if next line does not exist dialogue stops and current line reset for next dialogue triggered.
      if self.dialogue.curr_line > self.dialogue.numberofLines then
        --for decision
        if self.dialogue.isDecision then
          self.dialogue.curr_line = self.dialogue.numberofLines
          self.dialogue.curr_let = string.len(self.dialogue.lines[self.dialogue.curr_line])
          self.dialogue.drawdecisionbox = true
        else
          self.dialogue.start = false
          self.dialogue.lines = self.dialogue.startlines
          self.dialogue.curr_line = 1
          self.dialogue.isDecision = true
          self.dialogue.numberofLines = #self.dialogue.lines
          player.control = true
        end
      end
    end
  end

  if key == "down" and self.dialogue.drawdecisionbox and player.cursor.movedown then
    player.cursor.yoff = player.cursor.yoff + 30
    player.cursor.movedown = false
    player.cursor.moveup = true
  elseif key == "up" and self.dialogue.drawdecisionbox and player.cursor.moveup then
    player.cursor.yoff = player.cursor.yoff - 30
    player.cursor.movedown = true
    player.cursor.moveup = false
  end
end

return NPC

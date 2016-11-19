
--NPC class for future use
NPC = {}

function NPC:new(x,y,v,xoff,yoff,w,h,dialogue) --will include spritesheet later
  comment = require("comment")
  question = require("question")

  if dialogue.question then
    dialogue = question:new(dialogue.lines,dialogue.decision)
  else
    dialogue = comment:new(dialogue.lines)
  end

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

function NPC:comment(player,key)
  if key == "space" and checkcollision(player.dialoguebox, self.dialoguebox) then
    self.dialogue.start = true
    player.control = false
    --if player presses space before message is typed out message automatically is typed
    if self.dialogue.curr_let > 2 and self.dialogue.curr_let < self.dialogue.curr_linelen then
      self.dialogue.curr_let = self.dialogue.curr_linelen
    --checks if whole message has been typed. If player then presses space message goes to next line.
    elseif self.dialogue.curr_let == self.dialogue.curr_linelen then
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

--break down into smaller functions?
function NPC:question(player,key)

  if checkcollision(player.dialoguebox, self.dialoguebox) then
    if self.dialogue.drawdecisionbox == false then
      if key == "space" then
        self.dialogue.start = true
        player.control = false
        --if player presses space before message is typed out message automatically is typed
        if self.dialogue.curr_let > 2 and self.dialogue.curr_let < string.len(self.dialogue.lines[self.dialogue.curr_line]) then
          self.dialogue.curr_let = string.len(self.dialogue.lines[self.dialogue.curr_line])
        --checks if whole message has been typed. If player then presses space message goes to next line.
        elseif self.dialogue.curr_let == string.len(self.dialogue.lines[self.dialogue.curr_line]) then
          self.dialogue.curr_let = 0
          self.dialogue.curr_line = self.dialogue.curr_line + 1
          --if next line does not exist dialogue stops and current line reset for next dialogue triggered.
          if self.dialogue.curr_line > self.dialogue.numberofLines then
            --if question has not occurred yet then isDecision will be true
            if self.dialogue.isDecision then
              self.dialogue.curr_line = self.dialogue.numberofLines
              self.dialogue.curr_let = string.len(self.dialogue.lines[self.dialogue.curr_line])
              self.dialogue.drawdecisionbox = true
            else
              --if question already occurred then dialogue is over. lines are reset for looping speech.
              self.dialogue.start = false
              self.dialogue.lines = self.dialogue.startlines
              self.dialogue.curr_line = 1
              self.dialogue.isDecision = true
              self.dialogue.numberofLines = #self.dialogue.lines
              player.control = true
              --reset cursor position and conditions
              self.dialogue.cursorPosY = self.dialogue.topdecPosy+self.dialogue.cursorOffY
              player.cursor.movedown = true
              player.cursor.moveup = false
            end
          end
        end
      end
    --when question is asked and player gives response with space the spoken lines are replaced with a response depending on position of the cursor.
    else
      if key == "space" then
        if self.dialogue.cursorPosY == self.dialogue.topdecPosy+self.dialogue.cursorOffY then
          self.dialogue.lines = self.dialogue.topresponse
        else
          self.dialogue.lines = self.dialogue.bottomresponse
        end
        self.dialogue.curr_line = 1
        self.dialogue.curr_let = 0
        self.dialogue.drawdecisionbox = false
        self.dialogue.isDecision = false
        self.dialogue.numberofLines = #self.dialogue.lines
      --when question is asked and player presses up or down to switch response
      elseif key == "down" and self.dialogue.drawdecisionbox and player.cursor.movedown then
        self.dialogue.cursorPosY = self.dialogue.cursorPosY + self.dialogue.decDiffy
        player.cursor.movedown = false
        player.cursor.moveup = true
      elseif key == "up" and self.dialogue.drawdecisionbox and player.cursor.moveup then
        self.dialogue.cursorPosY = self.dialogue.topdecPosy+self.dialogue.cursorOffY
        player.cursor.movedown = true
        player.cursor.moveup = false
      end
    end

  end
end

function NPC:speak(player,key)
  if self.dialogue.isQuestion then
    self:question(player,key)
  else
    self:comment(player,key)
  end
end

return NPC

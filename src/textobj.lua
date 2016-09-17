
textobj = {}

function textobj:new(lines,decision)
  o = {
    startlines = lines,
    lines = lines,
    numberofLines = #lines,
    color = {255,255,255},

    curr_line = 1,
    curr_let = 0,
    curr_linelen = string.len(lines[1]),
    elapsed_time = 0,
    scroll_time = 0.1,
    start = false,

    isDecision = decision.on,
    topchoice = decision.topchoice,
    bottomchoice = decision.bottomchoice,
    topresponse = decision.topresponse,
    bottomresponse = decision.bottomresponse,
    drawdecisionbox = false
  }

  setmetatable(o, self)
  self.__index = self
  return o
end

function textobj:textUpdate(dt)
if self.start then
  if self.elapsed_time > self.scroll_time then
    if string.len(self.lines[self.curr_line]) > self.curr_let then
      self.curr_let = self.curr_let + 1
    else
      self.curr_let = string.len(self.lines[self.curr_line])
    end
  self.elapsed_time = 0
  end
  self.elapsed_time = self.elapsed_time + dt
end
end

function textobj:textDraw(player,wwidth,wheight)
  if self.start then
    love.graphics.setColor(255,255,255,255)
    messageBox = {x = player.x - wwidth/4 + 30, y = player.y + wheight/8, w = wwidth/2 - 60, h = 45}
    love.graphics.rectangle("fill",messageBox.x,messageBox.y,messageBox.w,messageBox.h,2,2)

    love.graphics.setColor(0,0,0,255)
    printedText = string.sub(self.lines[self.curr_line],0,self.curr_let)
    love.graphics.print(printedText, player.x - wwidth/4 + 40, player.y + wheight/8 + 16)

    love.graphics.rectangle("line",messageBox.x,messageBox.y,messageBox.w,messageBox.h,2,2)
    if self.drawdecisionbox then
      decisionBox = {x = messageBox.x + messageBox.w - 74, y = messageBox.y - 74, w = 74, h = 74}
      love.graphics.setColor(255,255,255,255)
      love.graphics.rectangle("fill",decisionBox.x,decisionBox.y,decisionBox.w,decisionBox.h)
      love.graphics.setColor(0,0,0,255)
      love.graphics.rectangle("line",decisionBox.x,decisionBox.y,decisionBox.w,decisionBox.h)

      love.graphics.print(self.topchoice,decisionBox.x+20,decisionBox.y+15)
      love.graphics.print(self.bottomchoice,decisionBox.x+20,decisionBox.y+45)

      love.graphics.circle("fill",player.x+player.cursor.xoff,player.y+player.cursor.yoff,3)
    end
  end
end

return textobj

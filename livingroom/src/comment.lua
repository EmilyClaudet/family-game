
comment = {}
local font = love.graphics.newFont("res/fonts/ARCADECLASSIC.TTF", 13)

function comment:new(lines,wwidth)
  messageBoxW = wwidth/2 - 60
  messageBoxH = 45
  o = {
    lines = lines,
    numberofLines = #lines,
    color = {255,255,255},
    font = font,

    curr_line = 1,
    curr_let = 0,
    curr_linelen = string.len(lines[1]),
    elapsed_time = 0,
    scroll_time = 0.1,
    start = false,

    messageBoxW = messageBoxW,
    messageBoxH = messageBoxH,
    textLimit = messageBoxW - 40
  }

  setmetatable(o, self)
  self.__index = self
  return o
end

function comment:textUpdate(dt)
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

function comment:textDraw(player,wwidth,wheight)
  if self.start then
    love.graphics.setColor(255,255,255,255)
    messageBox = {x = player.x - wwidth/4 + 30, y = player.y + wheight/8, w = self.messageBoxW, h = self.messageBoxH}
    love.graphics.rectangle("fill",messageBox.x,messageBox.y,messageBox.w,messageBox.h,2,2)

    love.graphics.setColor(0,0,0,255)
    printedText = string.sub(self.lines[self.curr_line],0,self.curr_let)

    totalWidth = font:getWidth(self.lines[self.curr_line])
    totalHeight = math.ceil(totalWidth/self.textLimit)*font:getHeight(self.lines[self.curr_line])
    startHeight = (self.messageBoxH - totalHeight)/2

    love.graphics.printf(printedText, messageBox.x + 20, messageBox.y + startHeight, self.textLimit, "left")
    love.graphics.rectangle("line",messageBox.x,messageBox.y,messageBox.w,messageBox.h,2,2)
  end
end

return comment

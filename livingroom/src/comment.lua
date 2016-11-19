
comment = {}
local font = love.graphics.newFont("res/fonts/ARCADECLASSIC.TTF", 13)

function comment:new(lines)
  wwidth = love.graphics.getWidth()
  wheight = love.graphics.getHeight()

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
    scroll_time = 0.05,
    start = false,

    isQuestion = false,
    messageBox = {xoff = -wwidth/4 + 30, yoff = wheight/8, w = messageBoxW, h = messageBoxH},
    textoffx = 20,
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

function comment:textDraw(player)
  if self.start then
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle("fill", player.x + self.messageBox.xoff, player.y + self.messageBox.yoff, self.messageBox.w, self.messageBox.h,2,2)

    love.graphics.setColor(0,0,0,255)
    printedText = string.sub(self.lines[self.curr_line],0,self.curr_let)

    --finding start height of text
    totalWidth = font:getWidth(self.lines[self.curr_line])
    totalHeight = math.ceil(totalWidth/self.textLimit)*font:getHeight(self.lines[self.curr_line])
    startHeight = (self.messageBox.h - totalHeight)/2

    love.graphics.printf(printedText, player.x + self.messageBox.xoff + self.textoffx, player.y + self.messageBox.yoff + startHeight, self.textLimit, "left")
    love.graphics.rectangle("line",player.x + self.messageBox.xoff, player.y + self.messageBox.yoff, self.messageBox.w, self.messageBox.h,2,2)
  end
end

return comment

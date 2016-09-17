
textobj = {}

function textobj:new(lines)
  o = {
    lines = lines,
    numberofLines = #lines,
    color = {255,255,255},

    curr_line = 1,
    curr_let = 0,
    curr_linelen = string.len(lines[1]),
    elapsed_time = 0,
    scroll_time = 0.1,
    start = false,
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
  end
end

return textobj

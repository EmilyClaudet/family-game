
textobj = {}

function textobj:new(lines)
  lineLength = {}
  for i,v in ipairs(lines) do
    table.insert(lineLength,v)
  end

  o = {
    lines = lines,
    numberofLines = #lines,
    lineLength = lineLength,
    color = {255,255,255},

    curr_line = lines[1],
    curr_let = 1,
    elapsed_time = 0,
    scroll_time = 0.1
  }

  setmetatable(o, self)
  self.__index = self
  return o
end

function textobj:textUpdate(dt)
  if self.elapsed_time > self.scroll_time then
    if string.len(self.curr_line) > self.curr_let then
      self.curr_let = self.curr_let + 1
    else
      self.curr_let = string.len(self.curr_line)
    end
  self.elapsed_time = 0
  end
  self.elapsed_time = self.elapsed_time + dt
end

function textobj:textDraw(player,wwidth,wheight)
  love.graphics.setColor(0,0,0,255)
  printedText = string.sub(self.curr_line,0,self.curr_let)
  love.graphics.print(printedText, player.x - wwidth/4 + 15, player.y + wheight/8 + 16)
end

return textobj


question = {}
local font = love.graphics.newFont("res/fonts/ARCADECLASSIC.TTF", 13)

function question:new(lines,decision)
  wwidth = love.graphics.getWidth()
  wheight = love.graphics.getHeight()

  --find width of longest decision option to find necessary width of decision box
  topWidth = font:getWidth(decision.topchoice)
  botWidth = font:getWidth(decision.bottomchoice)
  if topWidth >= botWidth then
    decisiontxtW = topWidth
  else
    decisiontxtW = botWidth
  end

  dectxtHeight = font:getHeight(decision.bottomchoice)

  messageBoxOffx = 60   --message box x offset from window edge
  messageBoxY = wheight/8   --y coord of message box
  messageBoxW = wwidth/2 - messageBoxOffx*2   --message box width
  messageBoxH = 50
  textoffx = 20   --x offset of text from message box

  decisionOffx = 20   --x offset of decision text from decision box
  decisionH = 50  --height of decision box
  decisionW = decisiontxtW + 2*decisionOffx   --width of decision box

  topdecPosy = (decisionH - 2*dectxtHeight)/3   --y position of top decision text based on decision box height
  botdecPosY = topdecPosy*2 + dectxtHeight      --y position of bottom decision text
  decDiffy = botdecPosY - topdecPosy            --difference of positions. Used in NPC:question to change cursor position

  cursorOffY = 7    --cursor offset from choice text
  cursorRadius = 3
  o = {
    startlines = lines,
    lines = lines,
    numberofLines = #lines,
    color = {255,255,255},

    curr_line = 1,
    curr_let = 0,
    curr_linelen = string.len(lines[1]),
    elapsed_time = 0,
    scroll_time = 0.05,
    start = false,

    isQuestion = true,
    isDecision = true,
    topchoice = decision.topchoice,
    bottomchoice = decision.bottomchoice,
    topresponse = decision.topresponse,
    bottomresponse = decision.bottomresponse,
    drawdecisionbox = false,

    messageBox = {xoff = -wwidth/4 + messageBoxOffx, yoff = messageBoxY, w = messageBoxW, h = messageBoxH}, --message box position and size
    decisionW = decisionW,
    decisionH = decisionH,
    decisionOffx = decisionOffx,
    topdecPosy = topdecPosy,
    botdecPosY = botdecPosY,
    cursorOffY = cursorOffY,
    cursorPosY = topdecPosy+cursorOffY,
    cursorRadius = cursorRadius,
    decDiffy = decDiffy,
    textoffx = textoffx,
    textLimit = messageBoxW - 2*textoffx    --maximum horizontal limit of text within message box
  }

  setmetatable(o, self)
  self.__index = self
  return o
end

function question:textUpdate(dt)
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

function question:textDraw(player)
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

    --draw decision box
    if self.drawdecisionbox then
      --find position and size of decision box taking width of decision text into account
      decisionBox = {x = player.x + self.messageBox.xoff + self.messageBox.w - self.decisionW, y = player.y + self.messageBox.yoff - self.decisionH, w = self.decisionW, h = self.decisionH}
      love.graphics.setColor(255,255,255,255)
      love.graphics.rectangle("fill",decisionBox.x,decisionBox.y,decisionBox.w,decisionBox.h,2,2)
      love.graphics.setColor(0,0,0,255)
      love.graphics.rectangle("line",decisionBox.x,decisionBox.y,decisionBox.w,decisionBox.h,2,2)

      love.graphics.print(self.topchoice,decisionBox.x+self.decisionOffx,decisionBox.y+self.topdecPosy)
      love.graphics.print(self.bottomchoice,decisionBox.x+self.decisionOffx,decisionBox.y+self.botdecPosY)

      --draw player decision cursor
      love.graphics.circle("fill",decisionBox.x+self.decisionOffx/2,decisionBox.y+self.cursorPosY,self.cursorRadius)

--      love.graphics.circle("fill",decisionBox.x+self.decisionOffx/4,player.y+player.cursor.yoff,3)
    end
  end
end

return question

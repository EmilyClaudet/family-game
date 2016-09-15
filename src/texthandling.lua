TimerMax = 0.1
typeTimer = 0.1
typePosition = 0

function textInstance(text)
  return {
    text = text,
    curr_line = text[1],
    curr_let = 1,
    numberofLines = text.numberofLines
  }
end

function textUpdate(txtIns,dt)
  return {
    typeTimer = typeTimer - dt
    if typeTimer <= 0 then
      typeTimer = 0.1
      typePosition = typePosition + 1
      printedText = string.sub(txtIns.curr_line,0,)
    end
  }
end

function textDraw(txtIns,player)
  love.graphics.setColor(0,0,0,255)
  printedText = string.sub(txtIns.curr_line,0)
  love.graphics.print(printedText, player.x - wwidth/4 + 15, player.y + wheight/8 + 16)
end

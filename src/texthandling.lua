
function textInstance(text)
  return {
    text = text,
    curr_line = text.lines[1],
    curr_let = 1,
    numberofLines = text.numberofLines,
    elapsed_time = 0,
    scroll_time = 0.1
  }
end

function textUpdate(txtIns,dt)
  if txtIns.elapsed_time > txtIns.scroll_time then
    if string.len(txtIns.curr_line) > txtIns.curr_let then
      txtIns.curr_let = txtIns.curr_let + 1
    else
      txtIns.curr_let = string.len(txtIns.curr_line)
    end
  txtIns.elapsed_time = 0
  end
  txtIns.elapsed_time = txtIns.elapsed_time + dt
end

function textDraw(txtIns,player,wwidth,wheight)
  love.graphics.setColor(0,0,0,255)
  printedText = string.sub(txtIns.curr_line,0,txtIns.curr_let)
  love.graphics.print(printedText, player.x - wwidth/4 + 15, player.y + wheight/8 + 16)
end

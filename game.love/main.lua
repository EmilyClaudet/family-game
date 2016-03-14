-- Lets make a mutant move left and right

function love.load()
   player = love.graphics.newImage("emily.png")
   npc = love.graphics.newImage("atherine.png")
   x = 100
   y = 100
   i = 500
   j = 500
   speed = 200
end

function love.update(dt)
   if love.keyboard.isDown("right") then
      x = x + (speed * dt)
   end
   if love.keyboard.isDown("left") then
      x = x - (speed * dt)
   end

   if love.keyboard.isDown("down") then
      y = y + (speed * dt)
   end
   if love.keyboard.isDown("up") then
      y = y - (speed * dt)
   end
   if love.keyboard.isDown("escape") then
      love.event.quit()
   end
end

function love.draw()
   love.graphics.draw(player, x, y)
   love.graphics.draw(npc, i, j)
end

local STI = require "libs.STI"
local bump = require "libs.bump"
local arenabase = require "maps.arena"
local world = bump.newWorld()

local littleone = require("littleone")
local player = require("player")
require "collision" --get collision functions

--constants
local scale = 1
local wwidth = love.graphics.getWidth()
local wheight = love.graphics.getHeight()
local LOspeed = 150
local playerx = 64
local playery = 64
local playerspeed = 125
local tilelength = 32
local spritewidth = 32
local caught = 0
local bed = {x = 32, y = 160, w = 96, h = 96}
local gamestate = "play"

local timeRemaining = 20
local elapsedTime = 0

--checks for any overlap between two boxes. Returns true if there is
function checkcollision(box1, box2)
  return box1.x < box2.x + box2.w and
         box2.x < box1.x + box1.w and
         box1.y < box2.y + box2.h and
         box2.y < box1.y + box1.h
end

--finds which direction to bounce off and triggers desired bounce function
function bounce(LO,block)
  --compares overlap size in x direction with overlap size in y direction to see which is largest.
  --if x overlap is largest bounce will be in y direction
  if (LO.x+LO.w-block.x) > (block.y+block.h-LO.y) then
    --compares y position of hit boxes to see if little one is above or below block. Bounces accordingly
    if LO.y > block.y then LO:bounceDown() else LO:bounceUp() end
  else  --bounce is in x direction
    --compares x position of hit boxes to see if little one is on the right or left
    if LO.x < block.x then LO:bounceLeft() else LO:bounceRight() end
  end

  --alter animation accordingly
  LO:chgFacing()
end

--function checks for collisions between all little ones and all blocks
function checkBounce(dt,littleone,blocklist)
  LOpos = {x = littleone.x, y = littleone.y, w = littleone.w, h = littleone.h}
  for i,block in ipairs(blocklist) do
    if checkcollision(LOpos,block) then
      bounce(littleone,block)
    end
  end
end

--checks for collisions at the edges. Prevents little ones from bouncing off edges out of the map (Glitch!)
function checkEdges(LO)
  if LO.x > wwidth-64 then
    LO:bounceLeft()
    LO:chgFacing()
  elseif LO.x < 32 then
    LO:bounceRight()
    LO:chgFacing()
  elseif LO.y > wheight-64 then
    LO:bounceUp()
    LO:chgFacing()
  elseif LO.y < 32 then
    LO:bounceDown()
    LO:chgFacing()
  end
end

function love.load()
  --loading map
  map = STI.new("maps/arena.lua", {"box2d"})
  --function returns list of collidable block positions and sizes. Also adds collidable layer to bump world for player collision
  blocklist = addCollisionLayer(world,arenabase,map,tilelength)

  booboo = love.graphics.newImage("images/booboosheet.png")
  booboo:setFilter( 'nearest', 'nearest' )    --Scales image so that pixels are sharp

  --define player. will use Catherine sprite when assets come through!
  player = player:new(booboo, playerx, playery, spritewidth, spritewidth, playerspeed)
  world:add(
    player,
    player.x,
    player.y,
    player.w,
    player.h) --adds player as collidable object in world


  --random seed to generate different pseudo random sequence for directions each play through
  math.randomseed(os.time())

  --defining little ones. Will update when all assets come through!
  --little ones will always spawn on latter half of the arena to give a challenge to the player
  booboo1 = littleone:new(booboo, math.random(wwidth/2,wwidth-64), math.random(32,wheight-64), spritewidth, spritewidth, math.random(), LOspeed)
  booboo1:chgFacing() --update animation according to random x and y directions of spawn

  booboo2 = littleone:new(booboo, math.random(wwidth/2,wwidth-64), math.random(32,wheight-64), spritewidth, spritewidth, math.random(), LOspeed)
  booboo2:chgFacing()

  booboo3 = littleone:new(booboo, math.random(wwidth/2,wwidth-64), math.random(32,wheight-64), spritewidth, spritewidth, math.random(), LOspeed)
  booboo3:chgFacing()

  littleones = {booboo1, booboo2, booboo3}

end

function love.update(dt)
  if gamestate == "play" then
    elapsedTime = elapsedTime + dt
  end

  if elapsedTime > 1 then
    timeRemaining = timeRemaining - 1
    elapsedTime = 0
  end

  map:update(dt)
  player:updateinstance(dt)

  --updates little ones and checks for bounces
  for i,littleone in ipairs(littleones) do
    littleone:updateinstance(dt,player)
    checkBounce(dt,littleone,blocklist)
    checkEdges(littleone)
  end

  --update character position based on where player moves
  --redefines player's collision box for dialogue depending on which way he faces
  local dx,dy = 0,0
  if player.control then
  if (love.keyboard.isDown(player.down)) then
    dy = player:walkdown(dy,dt)
  end
  if (love.keyboard.isDown(player.right)) then
    dx = player:walkright(dx,dt)
  end
  if (love.keyboard.isDown(player.left)) then
    dx = player:walkleft(dx,dt)
  end
  if (love.keyboard.isDown(player.up)) then
    dy = player:walkup(dy,dt)
  end
  end
  move(world,player,dx,dy)

  if caught == 3 then
    gamestate = "won"
    player.control = false
  end

  if timeRemaining <= 0 then
    gamestate = "lost"
    player.control = false
  end

  if(love.keyboard.isDown('escape')) then
      love.event.quit()
  end

end

function love.keyreleased(key)
--puts character in idle state if player releases walking keys.
	if player.control then
	if key == player.down then
		player:standdown()
	end
	if key == player.right then
		player:standright()
	end
	if key == player.left then
		player:standleft()
	end
	if key == player.up then
		player:standup()
	end
	end

--check if player catches little one
  if key == "space" and player.canGrab then
    for i,littleone in ipairs(littleones) do
      if littleone.canMove and
        checkcollision({x = player.x, y = player.y, w = player.w, h = player.h},
                       {x = littleone.x, y = littleone.y, w = littleone.w, h = littleone.h}) then
        player.canGrab = false --makes player unable to catch more than one little one
        littleone.canMove = false --makes little one follow player
        littleone:caught() --rotates sprite
      end
    end
  end

--check if player places little one in bed
  if key == "space" and player.canGrab == false then
    for i,littleone in ipairs(littleones) do
      --ensures little one is being held by player but not already in bed
      if littleone.canMove == false and littleone.inBed == false then
        --ensure player is near enough to the bed to place little one in it
        if checkcollision({x = player.x, y = player.y, w = player.w, h = player.h}, bed) then
          littleone.inBed = true
          player.canGrab = true --allows player to grab other little ones again

          --update number caught. offx and offy ensure little ones are placed in different spots in the bed.
          caught = caught+1
          if caught == 1 then offx = 0 offy = 0
          elseif caught == 2 then offx = 32 offy = 16
          elseif caught == 3 then offx = 0 offy = 32 end

          littleone:bedtime(offx,offy)
        end
      end
    end
  end

end

function love.draw()
  love.graphics.scale(scale)
  map:draw()
  player:drawinstance()

  for i,littleone in ipairs(littleones) do
    littleone:drawinstance()
  end

  font = love.graphics.newFont(20)
  love.graphics.setFont(font)
  love.graphics.setColor(0,0,0)

  --print timer
  love.graphics.printf( timeRemaining, wwidth-75, 64, 100, "left" )

  --print message depending on if player wins or loses
  if gamestate == "won" then
    love.graphics.printf( "You caught the little ones in time!", (wwidth-400)/2, wheight-96, 400, "center" )
  elseif gamestate == "lost" then
    love.graphics.printf( "You didn't put the little ones to bed in time!", (wwidth-400)/2, wheight-96, 400, "center" )
  end
end

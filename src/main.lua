local STI = require "libs.STI"
local bump = require "bump"
local house = require "house"

local player = require("player") --adds player class
local textobj = require("textobj") --adds dialogue class
local NPC = require("NPC") --adds NPC class

local playerX = 160
local playerY = 360
local playerspeed = 80

local NPCspeed = 80
local NPCoffsetx = 5
local NPCoffsety = 2
local NPCw = 20
local NPCh = 30

local scale = 2
local tilelength = 32
local world = bump.newWorld()
local wwidth = love.graphics.getWidth()
local wheight = love.graphics.getHeight()

require "collision"

function love.load()
	-- load map file
	map = STI.new("res/maps/house.lua", {"box2d"})
	music = love.audio.newSource("res/audio/FinalDestinationBrawl.mp3")
	collisions(world,house,map,tilelength)

	local booboo = love.graphics.newImage("res/images/booboosheet.png")
	booboo:setFilter( 'nearest', 'nearest' )    --Scales image so that pixels are sharp

	player = player:new(booboo,playerspeed,playerX,playerY,18,28,8,4)		--instatiates booboo sprite

	world:add(
		player,
		player.x + player.xoff,
		player.y + player.yoff,
		player.w,
		player.h) --adds player as collidable object in world

--defines emily NPC
	for k, object in pairs(map.objects) do
		if object.name == "Emily" then
			emilyPos = {x = object.x, y = object.y}
			emilyNPC = NPC:new(object.x,object.y,NPCspeed,NPCoffsetx,NPCoffsety,NPCw,NPCh)
		end
	end

--defines emily dialogue. should group this into emilyNPC object somehow
	emilydialogue = textobj:new({
	    "Hello my Booboo",
	    "How are you today?",
	    "I'm hungry. I'm going to eat you."
	})

end

function love.update(dt)
	-- Update world
	map:update(dt)
	--Update player character
	player:updateinstance(dt)
	--Update text
	emilydialogue:textUpdate(dt)

	--update character position based on where player moves
	--redefines player's collision box for dialogue depending on which way he faces
	local dx,dy = 0,0
	if player.control then
	if (love.keyboard.isDown(player.down)) then
		player.curr_anim = player.animations["down"]
		player.dialoguebox.x = player.x
		player.dialoguebox.y = player.y + player.h
    dy = player.speed * dt
  end
	if (love.keyboard.isDown(player.right)) then
		player.curr_anim = player.animations["right"]
		player.dialoguebox.x = player.x + player.w
		player.dialoguebox.y = player.y
    dx = player.speed * dt
  end
	if (love.keyboard.isDown(player.left)) then
		player.curr_anim = player.animations["left"]
		player.dialoguebox.x = player.x - player.w
		player.dialoguebox.y = player.y
    dx = -player.speed * dt
  end
  if (love.keyboard.isDown(player.up)) then
		player.curr_anim = player.animations["up"]
		player.dialoguebox.x = player.x
		player.dialoguebox.y = player.y - player.h
    dy = -player.speed * dt
  end
	end
	move(world,player,dx,dy)

  if(love.keyboard.isDown('escape')) then
      love.event.quit()
  end
end

--returns true if a collision between box1 and 2 occurs
function checkcollision(box1, box2)
  return box1.x < box2.x + box2.w and
         box2.x < box1.x + box1.w and
         box1.y < box2.y + box2.h and
         box2.y < box1.y + box1.h
end

function love.keyreleased(key)
--puts character in idle state if player releases walking keys.
	if player.control then
	if key == player.down then
		player.curr_frame = 1
		player.curr_anim = player.animations["downidle"]
	end
	if key == player.right then
		player.curr_frame = 1
		player.curr_anim = player.animations["rightidle"]
	end
	if key == player.left then
		player.curr_frame = 1
		player.curr_anim = player.animations["leftidle"]
	end
	if key == player.up then
		player.curr_frame = 1
		player.curr_anim = player.animations["upidle"]
	end
	end

--Updates which line NPC says
	if key == "space" and checkcollision(player.dialoguebox, emilyNPC.dialoguebox) then
		emilydialogue.start = true
		player.control = false
		if emilydialogue.curr_let == emilydialogue.curr_linelen and key == "space" then
			emilydialogue.curr_let = 0
			emilydialogue.curr_line = emilydialogue.curr_line + 1
			if emilydialogue.curr_line > emilydialogue.numberofLines then
				emilydialogue.start = false
				emilydialogue.curr_line = 1
				player.control = true
			end
			emilydialogue.curr_linelen = string.len(emilydialogue.lines[emilydialogue.curr_line])
		end
	end

end

function love.draw()
	love.graphics.scale(scale)
	love.graphics.translate( (wwidth/4 - player.x), (wheight/4 - player.y) )
  -- Draw world
  map:draw()
  map:setDrawRange(5, 5, 256, 256)
  -- Draw player
  player:drawinstance()
	-- Play music
	--  music:play()
	emilydialogue:textDraw(player,wwidth,wheight)
	--Draws text, including message box
end

function love.quit()
    print('Quitting Family Game...')
end

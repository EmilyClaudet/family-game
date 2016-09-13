local STI = require "libs.STI"
local playerX = 160
local playerY = 160
local bump = require "bump"
local house = require "house"
local playerspeed = 80
local scale = 2
local booboo = require("booboo") --adds booboo sprite data
local tilelength = 32
local world = bump.newWorld()
local wwidth = love.graphics.getWidth()
local wheight = love.graphics.getHeight()
local NPC = require("NPC")
local dialogue = require("dialogue")
continue = false


require "handling" --adds functions getinstance, updateinstance, drawinstance
require "collision"

printedText = ""
TimerMax = 0.1
typeTimer = 0.1
typePosition = 0
counter = {}
i = 1

function love.load()
	-- load map file
	map = STI.new("res/maps/house.lua", {"box2d"})
	music = love.audio.newSource("res/audio/FinalDestinationBrawl.mp3")
	collisions(world,house,map,tilelength)

	booboo = getinstance(booboo.attributes())		--instatiates booboo sprite

  player = {
				x = playerX,
				y = playerY,
				w = tilelength,
				h = tilelength,
				speed = playerspeed,
				char = booboo,
				down = "down",
				right = 'right',
				left = 'left',
				up = "up",
				control = true
    }

--metatables to easily access booboo attributes
	setmetatable(player, { __index = booboo })
	setmetatable(booboo, { __index = booboo.curr_sprite})

	world:add(
		player,
		player.x,
		player.y,
		player.width,
		player.height)

	welcome = dialogue:new("welcome",{"Hello my Booboo","How are you today?","This is the Terrace"})
end

function love.update(dt)
	-- Update world
	map:update(dt)
	--Update player character
	updateinstance(player.char, dt)

	--update character position based on where player moves
	--changes player animation through changing char element
	local dx,dy = 0,0
	if (love.keyboard.isDown(player.down)) then
		player.char.curr_anim = player.animations["down"]
    dy = player.speed * dt
  end
	if (love.keyboard.isDown(player.right)) then
		player.char.curr_anim = player.animations["right"]
    dx = player.speed * dt
  end
	if (love.keyboard.isDown(player.left)) then
		player.char.curr_anim = player.animations["left"]
    dx = -player.speed * dt
  end
  if (love.keyboard.isDown(player.up)) then
		player.char.curr_anim = player.animations["up"]
    dy = -player.speed * dt
  end

	move(world,player,dx,dy)
	welcome:printText(dt,1)

  if(love.keyboard.isDown('escape')) then
      love.event.quit()
  end
end

function love.keyreleased(key)
--puts character in idle state if player releases walking keys.
	if key == player.down then
		player.char.curr_frame = 1
		player.char.curr_anim = player.animations["downidle"]
	end
	if key == player.right then
		player.char.curr_frame = 1
		player.char.curr_anim = player.animations["rightidle"]
	end
	if key == player.left then
		player.char.curr_frame = 1
		player.char.curr_anim = player.animations["leftidle"]
	end
	if key == player.up then
		player.char.curr_frame = 1
		player.char.curr_anim = player.animations["upidle"]
	end

end

function love.draw()
	love.graphics.scale(scale)
	love.graphics.translate( (wwidth/4 - player.x), (wheight/4 - player.y) )
  -- Draw world
  map:draw()
  map:setDrawRange(5, 5, 256, 256)
  -- Draw player
  drawinstance(player.char, player.x, player.y)
	-- Play music
--  music:play()
	love.graphics.setColor(255,255,255,255)
	if printedText ~= "" then
		love.graphics.rectangle("fill", player.x - wwidth/4 + 10, player.y + wheight/8, wwidth/2 - 20, wheight/16, 2, 2)
	end
	love.graphics.setColor(0,0,0,255)
	love.graphics.print(printedText, player.x - wwidth/4 + 15, player.y + wheight/8 + 16)
end

function love.quit()
    print('Quitting Family Game...')
end

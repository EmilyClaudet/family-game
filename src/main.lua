local STI = require "libs.STI"
local playerX = 160
local playerY = 160
local bump = require "bump"
local house = require "house"
local playerspeed = 80
local scale = 2
local world = love.physics.newWorld(0, 0)
local booboo = require("booboo") --adds booboo sprite data
local tilelength = 32
local world = bump.newWorld()
local wwidth = love.graphics.getWidth()
local wheight = love.graphics.getHeight()
require "handling" --adds functions getinstance, updateinstance, drawinstance

function findxy(index,width)
	row = math.floor(index/width)
	col = math.fmod(index,width) - 1
	return {xpos = col*tilelength, ypos = row*tilelength}
end

function love.load()
	-- load map file
	map = STI.new("res/maps/house.lua", {"box2d"})
	music = love.audio.newSource("res/audio/FinalDestinationBrawl.mp3")

	for n,layer in pairs(house.layers) do
		if layer.properties["collidable"] then
			for i,tile in pairs(layer.data) do
				if tile > 0 then
					tilex = findxy(i,layer.width).xpos
					tiley = findxy(i,layer.width).ypos
					block = {x = tilex, y = tiley, w = tilelength, h = tilelength}
					world:add(block, block.x, block.y, block.w, block.h)
				end
			end
		end
	end

	booboo = getinstance(booboo.attributes())		--instatiates booboo sprite

	--player table allows easy access for player attributes and controls
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
		up = "up"
	}

	world:add(
		player,
		player.x,
		player.y,
		player.char.curr_sprite.width,
		player.char.curr_sprite.height)
end

function love.update(dt)
	-- Update world
	map:update(dt)
	--Update player character
	updateinstance(player.char,dt)

	--update character position based on where player moves
	--changes player animation through changing char element
	local dx,dy = 0,0
	if (love.keyboard.isDown(player.down)) then
		player.char.curr_anim = player.char.curr_sprite["animations"]["down"]
    dy = player.speed * dt
  end
	if (love.keyboard.isDown(player.right)) then
		player.char.curr_anim = player.char.curr_sprite["animations"]["right"]
    dx = player.speed * dt
  end
	if (love.keyboard.isDown(player.left)) then
		player.char.curr_anim = player.char.curr_sprite["animations"]["left"]
    dx = -player.speed * dt
  end
  if (love.keyboard.isDown(player.up)) then
		player.char.curr_anim = player.char.curr_sprite["animations"]["up"]
    dy = -player.speed * dt
  end

	if dx ~= 0 or dy ~= 0 then
    local cols
    player.x, player.y, cols, cols_len = world:move(player, player.x + dx, player.y + dy)
    for i=1, cols_len do
			local col = cols[i]
		end
	end

  if(love.keyboard.isDown('escape')) then
      love.event.quit()
  end
end

function love.keyreleased(key)
--puts character in idle state if player releases walking keys.
	if key == player.down then
		player.char.curr_frame = 1
		player.char.curr_anim = player.char.curr_sprite["animations"]["downidle"]
	end
	if key == player.right then
		player.char.curr_frame = 1
		player.char.curr_anim = player.char.curr_sprite["animations"]["rightidle"]
	end
	if key == player.left then
		player.char.curr_frame = 1
		player.char.curr_anim = player.char.curr_sprite["animations"]["leftidle"]
	end
	if key == player.up then
		player.char.curr_frame = 1
		player.char.curr_anim = player.char.curr_sprite["animations"]["upidle"]
	end
end

function love.draw()
	love.graphics.scale(scale)
	love.graphics.translate( (wwidth/4 - player.x), (wheight/4 - player.y) )
  -- Draw world
  map:draw()
  -- map:box2d_draw(map)
  map:setDrawRange(5, 5, 256, 256)
	-- map:box2d_init(world)
  -- Draw player
  drawinstance(player.char,player.x,player.y)
	-- Play music
  music:play()
end

function love.quit()
    print('Quitting Family Game...')
end

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

--SHOULD STORE PER NPC!! Will be fixed
local NPCoffsetx = 5
local NPCoffsety = 2
local NPCw = 20
local NPCh = 30

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

--adding collisions for background
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

--collisions for NPCs. Need custom widths!
	for k, object in pairs(map.objects) do
		NPC = {x = object.x+NPCoffsetx, y = object.y+NPCoffsety, w = NPCw, h = NPCh}
		world:add(NPC, NPC.x, NPC.y-tilelength, NPC.w, NPC.h)
	end

	booboo = getinstance(booboo.attributes())		--instatiates booboo sprite

-- Create a Custom Layer
  map:addCustomLayer("Player Layer", 3)
-- Add data to Custom Layer
  spriteLayer = map.layers["Player Layer"]
  spriteLayer.sprites = {
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
  }

	world:add(
		spriteLayer.sprites.player,
		spriteLayer.sprites.player.x,
		spriteLayer.sprites.player.y,
		spriteLayer.sprites.player.char.curr_sprite.width,
		spriteLayer.sprites.player.char.curr_sprite.height)
end

function love.update(dt)
	-- Update world
	map:update(dt)
	--Update player character
	updateinstance(spriteLayer.sprites.player.char, dt)

	--update character position based on where player moves
	--changes player animation through changing char element
	local dx,dy = 0,0
	if (love.keyboard.isDown(spriteLayer.sprites.player.down)) then
		spriteLayer.sprites.player.char.curr_anim = spriteLayer.sprites.player.char.curr_sprite["animations"]["down"]
    dy = spriteLayer.sprites.player.speed * dt
  end
	if (love.keyboard.isDown(spriteLayer.sprites.player.right)) then
		spriteLayer.sprites.player.char.curr_anim = spriteLayer.sprites.player.char.curr_sprite["animations"]["right"]
    dx = spriteLayer.sprites.player.speed * dt
  end
	if (love.keyboard.isDown(spriteLayer.sprites.player.left)) then
		spriteLayer.sprites.player.char.curr_anim = spriteLayer.sprites.player.char.curr_sprite["animations"]["left"]
    dx = -spriteLayer.sprites.player.speed * dt
  end
  if (love.keyboard.isDown(spriteLayer.sprites.player.up)) then
		spriteLayer.sprites.player.char.curr_anim = spriteLayer.sprites.player.char.curr_sprite["animations"]["up"]
    dy = -spriteLayer.sprites.player.speed * dt
  end

	if dx ~= 0 or dy ~= 0 then
    local cols
    spriteLayer.sprites.player.x, spriteLayer.sprites.player.y, cols, cols_len = world:move(spriteLayer.sprites.player, spriteLayer.sprites.player.x + dx, spriteLayer.sprites.player.y + dy)
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
	if key == spriteLayer.sprites.player.down then
		spriteLayer.sprites.player.char.curr_frame = 1
		spriteLayer.sprites.player.char.curr_anim = spriteLayer.sprites.player.char.curr_sprite["animations"]["downidle"]
	end
	if key == spriteLayer.sprites.player.right then
		spriteLayer.sprites.player.char.curr_frame = 1
		spriteLayer.sprites.player.char.curr_anim = spriteLayer.sprites.player.char.curr_sprite["animations"]["rightidle"]
	end
	if key == spriteLayer.sprites.player.left then
		spriteLayer.sprites.player.char.curr_frame = 1
		spriteLayer.sprites.player.char.curr_anim = spriteLayer.sprites.player.char.curr_sprite["animations"]["leftidle"]
	end
	if key == spriteLayer.sprites.player.up then
		spriteLayer.sprites.player.char.curr_frame = 1
		spriteLayer.sprites.player.char.curr_anim = spriteLayer.sprites.player.char.curr_sprite["animations"]["upidle"]
	end
end

function love.draw()
	love.graphics.scale(scale)
	love.graphics.translate( (wwidth/4 - spriteLayer.sprites.player.x), (wheight/4 - spriteLayer.sprites.player.y) )
  -- Draw world
  map:draw()
  map:setDrawRange(5, 5, 256, 256)
  -- Draw player
  drawinstance(spriteLayer.sprites.player.char, spriteLayer.sprites.player.x, spriteLayer.sprites.player.y)
	-- Play music
  music:play()
end

function love.quit()
    print('Quitting Family Game...')
end

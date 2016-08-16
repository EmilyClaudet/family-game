local STI = require "libs.STI"
local playerX = 200
local playerY = 200
local playerspeed = 80
local scale = 2
local world = love.physics.newWorld(0, 0)
local booboo = require("booboo") --adds booboo sprite data
require "handling" --adds functions getinstance, updateinstance, drawinstance

function love.load()
	-- load map file
	map = STI.new("res/maps/house.lua", {"box2d"})
	music = love.audio.newSource("res/audio/mrbluesky.mp3")

	booboo = getinstance(booboo.attributes())		--instatiates booboo sprite

	--player table allows easy access for player attributes and controls
	player = {
		x = playerX,
		y = playerY,
		speed = playerspeed,
		char = booboo,
		down = "down",
		right = 'right',
		left = 'left',
		up = "up"
	}
end

function love.update(dt)
	-- Update world
	map:update(dt)
	--Update player character
	updateinstance(player.char,dt)

	--update character position based on where player moves
	--changes player animation through changing char element
	if (love.keyboard.isDown(player.down)) then
		player.char.curr_anim = player.char.curr_sprite["animations"]["down"]
    player.y = player.y + (player.speed * dt)
  end
	if (love.keyboard.isDown(player.right)) then
		player.char.curr_anim = player.char.curr_sprite["animations"]["right"]
    player.x = player.x + (player.speed * dt)
  end
	if (love.keyboard.isDown(player.left)) then
		player.char.curr_anim = player.char.curr_sprite["animations"]["left"]
    player.x = player.x - (player.speed * dt)
  end
  if (love.keyboard.isDown(player.up)) then
		player.char.curr_anim = player.char.curr_sprite["animations"]["up"]
    player.y = player.y - (player.speed * dt)
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

local STI = require "libs.STI"
local bump = require "bump"
local house = require "..res.maps.house"

local player = require("player") --adds player class
local question = require("question") --adds question class
local comment = require("comment") --adds comment class
local NPC = require("NPC") --adds NPC class
local dialogue = require("dialogue")

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

--returns true if a collision between box1 and 2 occurs
function checkcollision(box1, box2)
  return box1.x < box2.x + box2.w and
         box2.x < box1.x + box1.w and
         box1.y < box2.y + box2.h and
         box2.y < box1.y + box1.h
end

--defines Emily as an NPC from data from the map. Will update when spritesheet comes
function defineNPCs(map)
	for k, object in pairs(map.objects) do
		if object.name == "Emily" then
			emilydialogue = dialogue.emily
			emily = NPC:new(object.x,object.y,NPCspeed,NPCoffsetx,NPCoffsety,NPCw,NPCh,emilydialogue)
		end

    if object.name == "Catherine" then
      catherinedialogue = dialogue.catherine
      catherine = NPC:new(object.x,object.y,NPCspeed,NPCoffsetx,NPCoffsety,NPCw,NPCh,catherinedialogue)
    end

    if object.name == "Christopher" then
			christopherdialogue = dialogue.christopher
			christopher = NPC:new(object.x,object.y,NPCspeed,NPCoffsetx,NPCoffsety,NPCw,NPCh,christopherdialogue)
		end

    if object.name == "Mark" then
      markdialogue = dialogue.mark
      mark = NPC:new(object.x,object.y,NPCspeed,NPCoffsetx,NPCoffsety,NPCw,NPCh,markdialogue)
    end

	end
end

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

	defineNPCs(map)
end

function love.update(dt)
	-- Update world
	map:update(dt)
	--Update player character
	player:updateinstance(dt)
	--Update text
	emily.dialogue:textUpdate(dt)
  catherine.dialogue:textUpdate(dt)
  christopher.dialogue:textUpdate(dt)
  mark.dialogue:textUpdate(dt)

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

	emily:speak(player,key)
  catherine:speak(player,key)
  christopher:speak(player,key)
  mark:speak(player,key)
end
--[[
function drawNPCs(NPCs,player)
  for NPC in NPCs do
    if NPC.y > player.y then
      NPC:draw()
    end
  end
  player:draw()
  for NPC in NPCs do
    if NPC.y <= player.y then
      NPC:draw()
    end
  end
end
]]
function love.draw()
	love.graphics.scale(scale)
	love.graphics.translate( (wwidth/4 - player.x), (wheight/4 - player.y) )
  -- Draw world
  map:draw()
  map:setDrawRange(5, 5, 256, 256)
  -- Draw player
  player:drawinstance()
  map:drawLayer(map.layers["Foreground"])
	-- Play music
	--  music:play()
	emily.dialogue:textDraw(player)
  catherine.dialogue:textDraw(player)
  christopher.dialogue:textDraw(player)
  mark.dialogue:textDraw(player)
	--Draws text, including message box
end

function love.quit()
    print('Quitting Family Game...')
end

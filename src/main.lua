local STI = require "libs.STI"
local bump = require "bump"
local house = require "..res.maps.house"

local player = require("player") --adds player class
local question = require("question") --adds question class
local comment = require("comment") --adds comment class
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
			emilyPos = {x = object.x, y = object.y}

			emilydialogue = question:new({
				"Hello my Booboo.",
				"How are you today?",
				"I'm hungry. Can I eat you?"
			},
			{
				topchoice = "yes",
				bottomchoice = "no",
				topresponse = {"Oh really?","I will come to get you soon then!"},
				bottomresponse = {"But why not my Booboo?","You look so tasty."}
			})

			emily = NPC:new(emilyPos.x,emilyPos.y,NPCspeed,NPCoffsetx,NPCoffsety,NPCw,NPCh,emilydialogue)
		end

    if object.name == "Catherine" then
      catherinePos = {x = object.x, y = object.y}
      catherinedialogue = comment:new({
        "Won my leetal!",
        "You are so precious my Boobooru desu ka."
      })

      catherine = NPC:new(catherinePos.x,catherinePos.y,NPCspeed,NPCoffsetx,NPCoffsety,NPCw,NPCh,catherinedialogue)
    end

    if object.name == "Christopher" then
			christopherPos = {x = object.x, y = object.y}

			christopherdialogue = question:new({
				"MERLIN.",
				"How is the demon dermon?"
			},
			{
				topchoice = "good",
				bottomchoice = "not good",
				topresponse = {"Aww love this ever!"},
				bottomresponse = {"Oh no why not ever?"}
			})

			christopher = NPC:new(christopherPos.x,christopherPos.y,NPCspeed,NPCoffsetx,NPCoffsety,NPCw,NPCh,christopherdialogue)
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

	emily:question(player,key)
  catherine:comment(player,key)
  christopher:question(player,key)
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
	emily.dialogue:textDraw(player,wwidth,wheight)
  catherine.dialogue:textDraw(player,wwidth,wheight)
  christopher.dialogue:textDraw(player,wwidth,wheight)
	--Draws text, including message box
end

function love.quit()
    print('Quitting Family Game...')
end

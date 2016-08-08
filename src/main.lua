local STI = require "libs.STI"
local avatar
local frames = {}
local activeFrame
local cuurentFrame = 1
local playerX = 200
local playerY = 200
local speed = 200

-- constants
local DOWN = 2
local UP = 3
local LEFT = 4
local RIGHT = 5

function love.load()
	-- load map file 
	map = STI.new("res/maps/house.lua", {"box2d"})
	music = love.audio.newSource("res/audio/mrbluesky.mp3")
	avatar = love.graphics.newImage("res/images/avatar.png")
end

function love.update(dt)
	-- Update world
	map:update(dt)

	if (love.keyboard.isDown('left')) then
        playerX = playerX - (speed * dt)
        direction = LEFT
    end

    if (love.keyboard.isDown('right')) then
        playerX = playerX + (speed * dt)
        direction = RIGHT
    end

    if (love.keyboard.isDown('up')) then
        playerY = playerY - (speed * dt)
        direction = UP
    end

    if (love.keyboard.isDown('down')) then
        playerY = playerY + (speed * dt)
        direction = DOWN
    end

    if(love.keyboard.isDown('escape')) then
        love.event.quit()
    end
end

function love.draw()
    -- Draw world
    map:draw()
    map:setDrawRange(5, 5, 256, 256)
    -- Draw player
    love.graphics.draw(avatar, playerX, playerY)
    -- Play music and sound effects
    music:play()
end

function love.quit()
    print('Quitting Family Game...')
end



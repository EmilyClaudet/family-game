local STI = require "libs.STI"
local avatar
local playerX = 200
local playerY = 200
local speed = 160
local world = love.physics.newWorld(0, 0)
local frames = {}
local activeFrame
local currentFrame = 1
local elapsedTime = 0

-- constants
local DOWN = 1
local RIGHT = 2
local LEFT = 3
local UP = 4

function love.load()
	-- load map file 
	map = STI.new("res/maps/house.lua", {"box2d"})
	music = love.audio.newSource("res/audio/mrbluesky.mp3")
	avatar = love.graphics.newImage("res/images/avatar.png")

    frames[DOWN] = {}
    frames[DOWN][1] = love.graphics.newQuad(0, 0, 32, 32, avatar:getDimensions())
    frames[DOWN][2] = love.graphics.newQuad(32, 0, 32, 32, avatar:getDimensions())
    frames[DOWN][3] = love.graphics.newQuad(64, 0, 32, 32, avatar:getDimensions())
    frames[DOWN][4] = love.graphics.newQuad(96, 0, 32, 32, avatar:getDimensions())

    frames[RIGHT] = {}
    frames[RIGHT][1] = love.graphics.newQuad(0, 32, 32, 32, avatar:getDimensions())
    frames[RIGHT][2] = love.graphics.newQuad(32, 32, 32, 32, avatar:getDimensions())
    frames[RIGHT][3] = love.graphics.newQuad(64, 32, 32, 32, avatar:getDimensions())
    frames[RIGHT][4] = love.graphics.newQuad(96, 32, 32, 32, avatar:getDimensions())

    frames[LEFT] = {}
    frames[LEFT][1] = love.graphics.newQuad(0, 64, 32, 32, avatar:getDimensions())
    frames[LEFT][2] = love.graphics.newQuad(32, 64, 32, 32, avatar:getDimensions())
    frames[LEFT][3] = love.graphics.newQuad(64, 64, 32, 32, avatar:getDimensions())
    frames[LEFT][4] = love.graphics.newQuad(96, 64, 32, 32, avatar:getDimensions())

    frames[UP] = {}
    frames[UP][1] = love.graphics.newQuad(0, 96, 32, 32, avatar:getDimensions())
    frames[UP][2] = love.graphics.newQuad(32, 96, 32, 32, avatar:getDimensions())
    frames[UP][3] = love.graphics.newQuad(64, 96, 32, 32, avatar:getDimensions())
    frames[UP][4] = love.graphics.newQuad(96, 96, 32, 32, avatar:getDimensions())

    direction = DOWN
    activeFrame = frames[DOWN][currentFrame]

end

function love.update(dt)
	-- Update world
	map:update(dt)

    elapsedTime = elapsedTime + dt

    if (elapsedTime > 0.1) then
        if(currentFrame < 4 ) then
            currentFrame = currentFrame + 1
        else
            currentFrame = 1
        end
        elapsedTime = 0
    end

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

    activeFrame = frames[direction][currentFrame]

end

function love.draw()
    -- Draw world
    map:draw()
    -- map:box2d_draw(map)
    map:setDrawRange(5, 5, 256, 256)
	-- map:box2d_init(world)
    -- Draw player
    love.graphics.draw(avatar, activeFrame, playerX, playerY, 0)
    -- Play music
    music:play()
end

function love.quit()
    print('Quitting Family Game...')
end



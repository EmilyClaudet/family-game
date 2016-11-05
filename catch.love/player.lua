player = {}

function player:new(image,x,y,w,h,speed)
  animations = {
    downidle = {
      love.graphics.newQuad(0, 0, 32, 32, image:getDimensions())
    },
    rightidle = {
      love.graphics.newQuad(0, 32, 32, 32, image:getDimensions())
    },
    leftidle = {
      love.graphics.newQuad(0, 64, 32, 32, image:getDimensions())
    },
    upidle = {
      love.graphics.newQuad(0, 96, 32, 32, image:getDimensions())
    },
    down = {
      love.graphics.newQuad(0, 0, 32, 32, image:getDimensions()),
      love.graphics.newQuad(32, 0, 32, 32, image:getDimensions()),
      love.graphics.newQuad(64, 0, 32, 32, image:getDimensions()),
      love.graphics.newQuad(96, 0, 32, 32, image:getDimensions())
    },
    right = {
      love.graphics.newQuad(0, 32, 32, 32, image:getDimensions()),
      love.graphics.newQuad(32, 32, 32, 32, image:getDimensions()),
      love.graphics.newQuad(64, 32, 32, 32, image:getDimensions()),
      love.graphics.newQuad(96, 32, 32, 32, image:getDimensions())
    },
    left = {
      love.graphics.newQuad(0, 64, 32, 32, image:getDimensions()),
      love.graphics.newQuad(32, 64, 32, 32, image:getDimensions()),
      love.graphics.newQuad(64, 64, 32, 32, image:getDimensions()),
      love.graphics.newQuad(96, 64, 32, 32, image:getDimensions())
    },
    up = {
      love.graphics.newQuad(0, 96, 32, 32, image:getDimensions()),
      love.graphics.newQuad(32, 96, 32, 32, image:getDimensions()),
      love.graphics.newQuad(64, 96, 32, 32, image:getDimensions()),
      love.graphics.newQuad(96, 96, 32, 32, image:getDimensions())
    }
  }

  o = {
    spritesheet = image,
    animations = animations,
    curr_anim = animations.downidle,
    curr_frame = 1,
    elapsed_time = 0,
    frameduration = 0.13,

    x = x,
    y = y,
    w = w,
    h = h,
    speed = speed,

    up = "up",
    down = "down",
    left = "left",
    right = "right",

    control = true,
    canGrab = true
  }

  self.__index = self
  setmetatable(o, self)
  return o
end

function player:updateinstance(dt)
  if self.elapsed_time > self.frameduration then

    if self.curr_frame < #self.curr_anim then   --only add 1 to current frame if it is less than the number of frames in current animation
      self.curr_frame = self.curr_frame + 1
    else
      self.curr_frame = 1    --reset current frame to 1 if current frame is equal to total number of frames in current animation
    end

    self.elapsed_time = 0    --reset elapsed time each time current frame changes

  end
  self.elapsed_time = self.elapsed_time + dt

  if self.control == false then
    self.curr_frame = 1
    self.curr_anim = self.animations.downidle
  end
end

--draw sprite
function player:drawinstance()
  love.graphics.draw(
  self.spritesheet,
  self.curr_anim[self.curr_frame],
  self.x,
  self.y
  )
end

function player:walkdown(dy,dt)
  self.curr_anim = self.animations["down"]
  return self.speed * dt
end

function player:walkright(dx,dt)
  self.curr_anim = self.animations["right"]
  return self.speed * dt
end

function player:walkleft(dx,dt)
  self.curr_anim = self.animations["left"]
  return -self.speed * dt
end

function player:walkup(dy,dt)
  self.curr_anim = self.animations["up"]
  return -self.speed * dt
end

function player:standdown()
  self.curr_frame = 1
  self.curr_anim = self.animations["downidle"]
end

function player:standright()
  self.curr_frame = 1
  self.curr_anim = self.animations["rightidle"]
end

function player:standleft()
  self.curr_frame = 1
  self.curr_anim = self.animations["leftidle"]
end

function player:standup()
  self.curr_frame = 1
  self.curr_anim = self.animations["upidle"]
end

return player

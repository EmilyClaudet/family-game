--Use to define players

player = {}

function player:new(image,speed,x,y,w,h,xoff,yoff)
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
--      spritename = string(image),
      frameduration = 0.13,
      animations = animations,
      curr_anim = animations.downidle,
      curr_frame = 1,
      elapsed_time = 0,

      x = x,
      y = y,
      w = w,
      h = h,
      speed = speed,
      rotation = 0,
      flip_h = 1,   --set as either 1 or -1 (facing right or left respectively)
      flip_v = 1,
      xoff = xoff,
      yoff = yoff,

      down = "down",
      right = 'right',
      left = 'left',
      up = "up",
      control = true,

      dialoguebox = {x = x, y = y + h, w = w, h = h}, --defines area which player can interact with
      cursor = {moveup = false, movedown = true}--cursor to show what choice player is over
    }

    setmetatable(o, self)
    self.__index = self
    return o
end

--update sprite and loop through animation frames
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
end

--draw sprite
function player:drawinstance()
  love.graphics.draw(
  self.spritesheet,
  self.curr_anim[self.curr_frame],
  self.x,
  self.y,
  self.rotation,
  self.flip_h,
  self.flip_v,
  self.xoff,
  self.yoff
  )
end

function player:walkdown(dy,dt)
  self.curr_anim = self.animations["down"]
  self.dialoguebox.x = self.x
  self.dialoguebox.y = self.y + self.h
  return self.speed * dt
end

function player:walkright(dx,dt)
  self.curr_anim = self.animations["right"]
  self.dialoguebox.x = self.x + self.w
  self.dialoguebox.y = self.y
  return self.speed * dt
end

function player:walkleft(dx,dt)
  self.curr_anim = self.animations["left"]
  self.dialoguebox.x = self.x - self.w
  self.dialoguebox.y = self.y
  return -self.speed * dt
end

function player:walkup(dy,dt)
  self.curr_anim = self.animations["up"]
  self.dialoguebox.x = self.x
  self.dialoguebox.y = self.y - self.h
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

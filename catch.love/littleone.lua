littleone = {}

--function outputs 1 if 1 and -1 if 0. Input is always 0 or 1 to make random decision between walking in positive or negative direction
function plusOrMinus(zeroOrOne)
  if zeroOrOne == 1 then
    return 1
  else
    return -1
  end
end

function littleone:new(image,x,y,w,h,magx,speed)
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

--magnitude in y direction found from random value of the x magnitude to ensure total magnitude is always 1 (ie little one always walks at the same speed)
    magy = math.sqrt(1.0 - magx^2)

--generating random direction for both x and y co-ordinates.
--multiply with magnitudes to get final normalised directions
    dirx = magx*plusOrMinus(math.random(0,1))
    diry = magy*plusOrMinus(math.random(0,1))

  o = {
    spritesheet = image,
    animations = animations,
    curr_anim = animations.downidle,
    curr_frame = 1,
    elapsed_time = 0,
    frameduration = 0.13,
    rot = 0,
    scalex = 1,
    scaley = 1,
    offx = 0,
    offy = 0,

    x = x,
    y = y,
    w = w,
    h = h,
    dirx = dirx,
    diry = diry,
    speed = speed,

    canMove = true,
    inBed = false
  }

  setmetatable(o, self)
  self.__index = self
  return o
end

function littleone:updateinstance(dt,player)
  --update little one to walk in desired random direction
  if self.canMove then
    self.x = self.x + self.dirx*self.speed*dt
    self.y = self.y + self.diry*self.speed*dt
  elseif self.inBed == false then
    self.x = player.x+32
    self.y = player.y-12
--    self.curr_anim = player.curr_anim
  end

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
function littleone:drawinstance()
  love.graphics.draw(
  self.spritesheet,
  self.curr_anim[self.curr_frame],
  self.x,
  self.y,
  self.rot,
  self.scalex,
  self.scaley,
  self.offx,
  self.offy
  )
end

--changes the little one animation depending on which direction it is moving.
--must call every time a bounce function is called
function littleone:chgFacing()
  if self.canMove then
  if self.diry > 0 and self.diry >= math.abs(self.dirx) then
    self.curr_anim = self.animations.down
  elseif self.diry < 0 and math.abs(self.diry) >= math.abs(self.dirx) then
    self.curr_anim = self.animations.up
  elseif self.dirx > 0 and self.dirx > math.abs(self.diry) then
    self.curr_anim = self.animations.right
  elseif self.dirx < 0 and math.abs(self.dirx) > math.abs(self.diry) then
    self.curr_anim = self.animations.left
  end
  end
end

function littleone:caught()
  self.rot = 1.57
--  self.offx = 32
end

function littleone:bedtime(offx,offy)
  self.rot = 0
  self.x = 32 + offx
  self.y = 192 + offy
  self.curr_frame = 1
  self.curr_anim = self.animations["downidle"]
end

--bounce functions ensure little one bounces in desired direction
function littleone:bounceLeft()
  if self.canMove then
  magx = math.random(1,100)/100
  magy = math.sqrt(1.0 - magx^2)
  self.dirx = -magx
  self.diry = magy*plusOrMinus(math.random(0,1))
--  print("Left!")
  end
end

function littleone:bounceRight()
  if self.canMove then
  magx = math.random(1,100)/100
  magy = math.sqrt(1.0 - magx^2)
  self.dirx = magx
  self.diry = magy*plusOrMinus(math.random(0,1))
--  print("Right!")
  end
end

function littleone:bounceUp()
  if self.canMove then
  magy = math.random(1,100)/100
  magx = math.sqrt(1.0 - magy^2)
  self.dirx = magx*plusOrMinus(math.random(0,1))
  self.diry = -magy
--  print("Up!")
  end
end

function littleone:bounceDown()
  if self.canMove then
  magy = math.random(1,100)/100
  magx = math.sqrt(1.0 - magy^2)
  self.dirx = magx*plusOrMinus(math.random(0,1))
  self.diry = magy
--  print("Down!")
  end
end

return littleone

--holds all data for booboo sprite

booboo = {}

local avatar = love.graphics.newImage("res/images/avatar.png")
avatar:setFilter( 'nearest', 'nearest' )    --Scales image so that pixels are sharp

--table which returns all attributes of booboo sprite (quads,)
function booboo.attributes()
  return {
    spritesheet = avatar,
    spritename = "booboo",
    frameduration = 0.13,
    width = 17,
    height = 28,

    animations = {
      downidle = {
        love.graphics.newQuad(0, 0, 32, 32, avatar:getDimensions())
      },
      rightidle = {
        love.graphics.newQuad(0, 32, 32, 32, avatar:getDimensions())
      },
      leftidle = {
        love.graphics.newQuad(0, 64, 32, 32, avatar:getDimensions())
      },
      upidle = {
        love.graphics.newQuad(0, 96, 32, 32, avatar:getDimensions())
      },
      down = {
        love.graphics.newQuad(0, 0, 32, 32, avatar:getDimensions()),
        love.graphics.newQuad(32, 0, 32, 32, avatar:getDimensions()),
        love.graphics.newQuad(64, 0, 32, 32, avatar:getDimensions()),
        love.graphics.newQuad(96, 0, 32, 32, avatar:getDimensions())
      },
      right = {
        love.graphics.newQuad(0, 32, 32, 32, avatar:getDimensions()),
        love.graphics.newQuad(32, 32, 32, 32, avatar:getDimensions()),
        love.graphics.newQuad(64, 32, 32, 32, avatar:getDimensions()),
        love.graphics.newQuad(96, 32, 32, 32, avatar:getDimensions())
      },
      left = {
        love.graphics.newQuad(0, 64, 32, 32, avatar:getDimensions()),
        love.graphics.newQuad(32, 64, 32, 32, avatar:getDimensions()),
        love.graphics.newQuad(64, 64, 32, 32, avatar:getDimensions()),
        love.graphics.newQuad(96, 64, 32, 32, avatar:getDimensions())
      },
      up = {
        love.graphics.newQuad(0, 96, 32, 32, avatar:getDimensions()),
        love.graphics.newQuad(32, 96, 32, 32, avatar:getDimensions()),
        love.graphics.newQuad(64, 96, 32, 32, avatar:getDimensions()),
        love.graphics.newQuad(96, 96, 32, 32, avatar:getDimensions())
      }
    }
  }
end
return booboo

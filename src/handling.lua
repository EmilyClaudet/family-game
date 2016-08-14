
--function to define sprite status at a given moment. Instantiates sprite so that all current information about sprite may be retrieved in one function
function getinstance (sprite)
  if sprite == nil then return nil end
--default starting state: facing downwards on first frame with start time 0
  return {
    curr_sprite = sprite,
    curr_anim = sprite["animations"]["downidle"],
    curr_frame = 1,
    elapsed_time = 0,
    rotation = 0,
    offset_x = 0,
    offset_y = 0,
    flip_h = 1,   --set as either 1 or -1 (facing right or left respectively)
    flip_v = 1
  }
end

--update sprite and loop through animation frames. Takes INSTATIATED sprite, ie: getinstance(sprite), not just: sprite
function updateinstance (spr, dt)
  if spr.elapsed_time > spr.curr_sprite["frameduration"] then

    if spr.curr_frame < #spr.curr_anim then   --only add 1 to current frame if it is less than the number of frames in current animation
      spr.curr_frame = spr.curr_frame + 1
    else
      spr.curr_frame = 1    --reset current frame to 1 if current frame is equal to total number of frames in current animation
    end

    spr.elapsed_time = 0    --reset elapsed time each time current frame changes

  end
  spr.elapsed_time = spr.elapsed_time + dt
end

--draw sprite. Again function takes INSTATIATED sprite. x and y are player x,y co-ordinates
function drawinstance (spr, x, y)
  love.graphics.draw(
  spr.curr_sprite["spritesheet"],
  spr.curr_anim[spr.curr_frame],
  x,
  y,
  spr.rotation,
  spr.flip_h,
  spr.flip_v,
  spr.offset_x,
  spr.offset_y
  )
end

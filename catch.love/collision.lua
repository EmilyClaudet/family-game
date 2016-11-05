
function findxy(index,width,tilelength)
	row = math.floor(index/width)
	col = math.fmod(index,width) - 1
	return {xpos = col*tilelength, ypos = row*tilelength}
end

function addCollisionLayer(world,house,map,tilelength)
	blocklist = {}	--list of blocks' positions and sizes
  --adding collisions for background
  	for n,layer in pairs(house.layers) do
  		if layer.properties["Collidable"] then
  			for i,tile in pairs(layer.data) do
  				if tile > 0 then
  					tilex = findxy(i,layer.width,tilelength).xpos
  					tiley = findxy(i,layer.width,tilelength).ypos
						table.insert(blocklist,{x = tilex, y = tiley, w = tilelength, h = tilelength})
  					block = {x = tilex, y = tiley, w = tilelength, h = tilelength}
  					world:add(block, block.x, block.y, block.w, block.h)	--add blocks to world for player collision
  				end
  			end
  		end
  	end
	return blocklist	--return list of blocks to loop through and check for little one collisions at every update
end

--corrects position of player when player moves into collision layer
function move(world,player,dx,dy)
  if dx ~= 0 or dy ~= 0 then
    local cols
    player.x, player.y, cols, cols_len = world:move(player, player.x + dx, player.y + dy)
    for i=1, cols_len do
      local col = cols[i]
    end
  end
end

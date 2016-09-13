
function findxy(index,width,tilelength)
	row = math.floor(index/width)
	col = math.fmod(index,width) - 1
	return {xpos = col*tilelength, ypos = row*tilelength}
end

function collisions(world,house,map,tilelength)
  --adding collisions for background
  	for n,layer in pairs(house.layers) do
  		if layer.properties["collidable"] then
  			for i,tile in pairs(layer.data) do
  				if tile > 0 then
  					tilex = findxy(i,layer.width,tilelength).xpos
  					tiley = findxy(i,layer.width,tilelength).ypos
  					block = {x = tilex, y = tiley, w = tilelength, h = tilelength}
  					world:add(block, block.x, block.y, block.w, block.h)
  				end
  			end
  		end
  	end

    NPCoffsetx = 5
    NPCoffsety = 2
    NPCw = 20
    NPCh = 30

  --collisions for NPCs. Need custom widths!
  	for k, object in pairs(map.objects) do
  		NPC = {x = object.x+NPCoffsetx, y = object.y+NPCoffsety, w = NPCw, h = NPCh}
  		world:add(NPC, NPC.x, NPC.y-tilelength, NPC.w, NPC.h)
  	end
end

function move(world,player,dx,dy)
  if dx ~= 0 or dy ~= 0 then
    local cols
    player.x, player.y, cols, cols_len = world:move(player, player.x + dx, player.y + dy)
    for i=1, cols_len do
      local col = cols[i]
    end
  end
end

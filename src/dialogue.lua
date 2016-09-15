

dialogue = {}

function dialogue:new(title,text)
  o = {
		title = title,
		text = text
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function dialogue:printText(dt)

			if love.keyboard.isDown("space") then
        messageBox.on = true
				continue = true
				table.insert(counter,1)
				if #counter == 1 then typePosition = 0 end
			end

			if continue and i <= #self.text then
				typeTimer = typeTimer - dt
				if typeTimer <= 0 then
					typeTimer = 0.1
					typePosition = typePosition + 1
					printedText = string.sub(self.text[i],0,typePosition)
				end
			elseif continue then
				printedText = ""
        messageBox.on = false
			end

			if i <= #self.text then
				if typePosition == string.len(self.text[i]) then
					continue = false
					i = i + 1
					for k in pairs(counter) do counter[k] = nil end
				end
			end
		end

function dialogue:messageBox(player,wwidth,wheight)
  messageBox.x = player.x - wwidth/4 + 10
	messageBox.y = player.y + wheight/8
	messageBox.w = wwidth/2 - 20
	messageBox.h = wheight/16
end

return dialogue

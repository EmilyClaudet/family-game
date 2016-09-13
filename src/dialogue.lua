

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
--[[	for j = 1,#self.text do
		continue = true
		while continue do
]]

			if love.keyboard.isDown("space") then
--				continue = false
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
			end

			if i <= #self.text then
				if typePosition == string.len(self.text[i]) then
					continue = false
					i = i + 1
					for k in pairs(counter) do counter[k] = nil end
				end
			end
		end
--[[
		end
		continue = true
		printedText = ""
		typePosition = 0
	end
]]


return dialogue

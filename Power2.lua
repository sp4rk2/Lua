local component = require("component")

local  gpu = component.gpu

local width, height = gpu.getResolution()

local frameColour = 0x333333

function clearScreen()
	local oldColour = gpu.getBackground(false)
	gpu.setBackground(0x000000, false)
	gpu.fill(1, 1, width, height, " ")
	gpu.setBackground(oldColour, false)
end

-- function frame()
-- 	local oldColour = gpu.getBackground(false)
-- 	gpu.setBackground(frameColour, false)
-- 	gpu.fill(1, 1, w, 1, " ")
-- 	gpu.setBackground(oldColour, false)
-- end

function main()
	clearScreen()
	-- frame()
end

while true do
	main()
	os.sleep(0.25)
end
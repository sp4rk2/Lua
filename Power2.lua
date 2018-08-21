local component = require("component")

local  gpu = component.gpu

local width, height = gpu.getResolution()

local frameColour = 0xFFFFFF

local barColour1 = 0x06989A
local barColour2 = 0x34E2E2

local title = {"Testing", "(MPMv0.1)"}
local titleColour = 0xFFFFFF

function clearScreen()
	local oldColour = gpu.getBackground(false)
	gpu.setBackground(0x000000, false)
	gpu.fill(1, 1, width, height, " ")
	gpu.setBackground(oldColour, false)
end

function frame()
	local oldColour = gpu.getBackground(false)
	gpu.setBackground(frameColour, false)
	--Outer frame
	gpu.fill(1, 1, width, 1, " ")
	gpu.fill(1, 1, 2, height, " ")
	gpu.fill(1, height, width, 1, " ")
	gpu.fill(width - 1, 1, 2, height, " ")
	--Divider
	gpu.fill((width / 4) * 3, 1, 1, height, " ")
	gpu.setBackground(oldColour, false)
end

function centerText(text, space)
	return math.ceil(((space - string.len(text)) / 2)) * " " .. text
end

function header()
	local oldColour = gpu.getForeground(false)
	gpu.setForeground(titleColour, false)

	local headerSpace = ((width / 4) * 3) - 3

	gpu.set(3, ((width / 4) * 3) + 1, centerText(title[0], headerSpace))

	gpu.setForeground(oldColour, false)

end


function main()
	clearScreen()
	frame()
	header()
end

while true do
	main()
	os.sleep(0.25)
end
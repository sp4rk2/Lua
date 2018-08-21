local component = require("component")

local  gpu = component.gpu

local width, height = gpu.getResolution()

local frameColour = 0xFFFFFF

local barColour1 = 0x06989A
local barColour2 = 0x34E2E2

local header = {
	"Mainframe Power Monitor", 
	"(MPMv0.1)"
}

local headerColour = 0xFFFFFF

local titleColour = 0xFFFFFF

local statisticKeyColour = 0x06989A
local statisticValueColour = 0x34E2E2

local cellCount = 0
local tslu = 0
local lowestRF = 0
local lowestRFTime = 0
local highestRF = 0
local highestRFTime = 0

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
	local padding = math.ceil((space - string.len(text)) / 2)
	local output = ""
	for _ = 1, padding do
		output = output .. " "
	end
	return output .. text
end

function tableLength(tableInput)
  local output = 0
  for _ in pairs(tableInput) do 
  	output = output + 1 
  end
  return output
end

function header()
	local oldColour = gpu.getForeground(false)
	gpu.setForeground(headerColour, false)

	local headerSpace = (width / 4) - 3
	local paddingLeft = ((width / 4) * 3) + 1
	for index=1, tableLength(header) do
		gpu.set(paddingLeft, index + 3, centerText(header[index], headerSpace))
	end
	gpu.setForeground(oldColour, false)
end

function statistics()
	local oldColour = gpu.getForeground(false)
	gpu.setForeground(titleColour, false)

	local paddingLeft = ((width / 4) * 3) + 2
	local paddingTop = 8 + tableLength(title)
	local titleSpace = (width / 4) - 3

	gpu.set(paddingLeft - 1, paddingTop, centerText("Statistics", titleSpace))
	paddingTop = paddingTop + 2

	gpu.setForeground(statisticKeyColour, false)
	gpu.set(paddingLeft, paddingTop, "Cell Count: ")
	gpu.set(paddingLeft, paddingTop + 1, "TSLU: ")
	gpu.set(paddingLeft, paddingTop + 3, "Available RF: ")
	gpu.set(paddingLeft, paddingTop + 5, "Lowest RF: ")
	gpu.set(paddingLeft, paddingTop + 6, "Lowest RF Time: ")
	gpu.set(paddingLeft, paddingTop + 8, "Highest RF: ")
	gpu.set(paddingLeft, paddingTop + 9, "Highest RF: ")

	gpu.setForeground(statisticValueColour, false)
	gpu.set(paddingLeft + 16, paddingTop, cellCount)
	gpu.set(paddingLeft + 16, paddingTop + 1, TSLU)
	gpu.set(paddingLeft + 16, paddingTop + 3, 0)
	gpu.set(paddingLeft + 16, paddingTop + 5, lowestRF)
	gpu.set(paddingLeft + 16, paddingTop + 6, lowestRFTime)
	gpu.set(paddingLeft + 16, paddingTop + 8, highestRF)
	gpu.set(paddingLeft = 16, paddingTop + 9, highestRFTime)

	gpu.setForeground(oldColour, false)

end

function main()
	while true do
		clearScreen()
		frame()
		header()
		os.sleep(0.25)
	end
end


main()
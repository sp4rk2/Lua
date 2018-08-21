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

local valuesRF = {}

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

function setFrame()
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

function setHeader()
	local oldColour = gpu.getForeground(false)
	gpu.setForeground(headerColour, false)

	local headerSpace = (width / 4) - 3
	local paddingLeft = ((width / 4) * 3) + 1
	for index=1, tableLength(header) do
		gpu.set(paddingLeft, index + 3, centerText(header[index], headerSpace))
	end
	gpu.setForeground(oldColour, false)
end

function setStatistics()
	local oldColour = gpu.getForeground(false)
	gpu.setForeground(titleColour, false)

	local paddingLeft = ((width / 4) * 3) + 2
	local paddingTop = 8 + tableLength(header)
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
	gpu.set(paddingLeft, paddingTop + 9, "Highest RF Time: ")

	gpu.setForeground(statisticValueColour, false)
	gpu.set(width - string.len(tostring(cellCount)) - 3, paddingTop, tostring(cellCount))
	gpu.set(width - string.len(tostring(tslu)) - 3, paddingTop + 1, tostring(tslu))
	gpu.set(width - string.len(tostring(0)) - 3, paddingTop + 3, tostring(0))
	gpu.set(width - string.len(tostring(lowestRF)) - 3, paddingTop + 5, tostring(lowestRF))
	gpu.set(width - string.len(tostring(lowestRFTime)) - 3, paddingTop + 6, tostring(lowestRFTime))
	gpu.set(width - string.len(tostring(highestRF)) - 3, paddingTop + 8, tostring(highestRF))
	gpu.set(width - string.len(tostring(highestRFTime)) - 3, paddingTop + 9, tostring(highestRFTime))

	gpu.setForeground(oldColour, false)

end

function setRFValues()
	local graphLength = (width / 4 * 3) - 8
	for index = 1, graphLength do
		valuesRF[index] = 1
	end
end

function updateRFValues()
	table.insert(valuesRF, 1, math.random(30))
	table.remove(numbers)
end

-- function updateStatistics()

-- end

function graph()
	local oldColour = gpu.getBackground(false)
	gpu.setBackground(0xFFFFFF, false)
	local paddingLeft = (width / 4 * 3) - 1
	local paddingTop = height - 1
	local colourSwitch = true
	for index = 1, tableLength(valuesRF) do
		if colourSwitch == true then
			gpu.setBackground(barColour1, false)
			colourSwitch = false
		else
			gpu.setBackground(barColour2, false)
			colourSwitch = true
		end

		gpu.fill(paddingLeft, paddingTop - valuesRF[tableLength(valuesRF) - index + 1], 1, valuesRF[tableLength(valuesRF) - index + 1], " ")

		paddingLeft = paddingLeft - 1

	end

	gpu.setBackground(oldColour, false)


end

function main()
	setRFValues()
	while true do
		clearScreen()
		setFrame()
		setHeader()
		setStatistics()
		updateRFValues()
		graph()
		os.sleep(3)
	end
end


main()
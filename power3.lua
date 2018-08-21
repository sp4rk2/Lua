local component = require("component")

local  gpu = component.gpu

local width, height = gpu.getResolution()

local frameColour = 0xFFFFFF

local barColour1 = 0x06989A
local barColour2 = 0x34E2E2

local header = {
	"Mainframe Power Monitor", 
	"(MPMv0.2)"
}

local headerColour = 0xFFFFFF

local titleColour = 0xFFFFFF

local statisticKeyColour = 0x06989A
local statisticValueColour = 0x34E2E2

local valuesRF = {}

local cellCount = 90
local available = component.energy_device.getEnergyStored() * cellCount
local max = component.energy_device.getMaxEnergyStored() * cellCount
local updateTime = 2
local lowestRF = component.energy_device.getEnergyStored() * cellCount
local lowestRFTime = 0
local highestRF = component.energy_device.getEnergyStored() * cellCount
local highestRFTime = 0

local colourSwitch = true

local headerSpace = 0
local headerPaddingLeft = 0

local statisticsPaddingLeft = 0
local statisticsPaddingTop = 0
local titleSpace = 0

local graphLength = 0

local graphPaddingLeft = 0
local graphPaddingTop = 0

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

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
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
	for index=1, tableLength(header) do
		gpu.set(headerPaddingLeft, index + 3, centerText(header[index], headerSpace))
	end
	gpu.setForeground(oldColour, false)
end

function setStatistics()
	local oldColour = gpu.getForeground(false)
	gpu.setForeground(titleColour, false)

	gpu.set(statisticsPaddingLeft - 1, statisticsPaddingTop, centerText("Statistics", titleSpace))
	statisticsPaddingTop = statisticsPaddingTop + 2

	gpu.setForeground(statisticKeyColour, false)
	gpu.set(statisticsPaddingLeft, statisticsPaddingTop, "Cell Count: ")
	gpu.set(statisticsPaddingLeft, statisticsPaddingTop + 1, "TSLU: ")
	gpu.set(statisticsPaddingLeft, statisticsPaddingTop + 3, "Available: ")
	gpu.set(statisticsPaddingLeft, statisticsPaddingTop + 5, "Lowest: ")
	gpu.set(statisticsPaddingLeft, statisticsPaddingTop + 6, "Lowest Time: ")
	gpu.set(statisticsPaddingLeft, statisticsPaddingTop + 8, "Highest: ")
	gpu.set(statisticsPaddingLeft, statisticsPaddingTop + 9, "Highest Time: ")

	gpu.setForeground(statisticValueColour, false)
	gpu.set(width - string.len(tostring(cellCount)) - 3, statisticsPaddingTop, tostring(cellCount))
	gpu.set(width - string.len(tostring(updateTime) .. "seconds") - 3, statisticsPaddingTop + 1, tostring(updateTime) .. "seconds")
	gpu.set(width - string.len(tostring(available) .. "/" .. tostring(max)) - 3, statisticsPaddingTop + 3, tostring(available) .. "/" .. tostring(max))
	gpu.set(width - string.len(tostring(lowestRF) .. "RF") - 3, statisticsPaddingTop + 5, tostring(lowestRF) .. "RF")
	gpu.set(width - string.len(tostring(lowestRFTime)) - 3, statisticsPaddingTop + 6, tostring(lowestRFTime))
	gpu.set(width - string.len(tostring(highestRF) .. "RF") - 3, statisticsPaddingTop + 8, tostring(highestRF) .. "RF")
	gpu.set(width - string.len(tostring(highestRFTime)) - 3, statisticsPaddingTop + 9, tostring(highestRFTime))
	gpu.setForeground(oldColour, false)
end

function calculateValues()
	headerSpace = (width / 4) - 3
	headerPaddingLeft = ((width / 4) * 3) + 1

	statisticsPaddingLeft = ((width / 4) * 3) + 2
	statisticsPaddingTop = 8 + tableLength(header)
	titleSpace = (width / 4) - 3

	graphLength = (width / 4 * 3) - 11

	graphPaddingLeft = (width / 4 * 3) - 2
	graphPaddingTop = height - 1
	for index = 1, graphLength do
		valuesRF[index] = 1
	end
end

function updateRFValues()
	available = component.energy_device.getEnergyStored() * cellCount

	if available >= highestRF then
		highestRF = available
	end
	if available <= lowestRF then
		lowestRF = available
	end
	percent = round((available / max) * height - 20, 0)

	table.insert(valuesRF, 1, percent)
	table.remove(valuesRF)
end

-- function updateStatistics()

-- end

function graph()
	gpu.setBackground(0xFFFFFF, false)
	for index = 1, tableLength(valuesRF) do
		if colourSwitch == true then
			gpu.setBackground(barColour1, false)
			colourSwitch = false
		else
			gpu.setBackground(barColour2, false)
			colourSwitch = true
		end

		gpu.fill(graphPaddingLeft, graphPaddingTop - valuesRF[tableLength(valuesRF) - index + 1], 1, valuesRF[tableLength(valuesRF) - index + 1], " ")

		graphPaddingLeft = graphPaddingLeft - 1
	end
end

function main()
	calculateValues()
	while true do
		updateRFValues()
		clearScreen()
		setFrame()
		setHeader()
		setStatistics()
		graph()
		os.sleep(updateTime)
	end
end


main()


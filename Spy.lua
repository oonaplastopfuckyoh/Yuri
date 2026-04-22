--// SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

--// CONFIG
local FILTER_KEYWORDS = {
	"vfx",
	"effect",
	"particle",
	"trail"
}

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SmartLogger"
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 430, 0, 280)
main.Position = UDim2.new(0, 20, 0.5, -140)
main.BackgroundColor3 = Color3.fromRGB(20,20,25)
Instance.new("UICorner", main)

local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0,40,0,40)
toggle.Position = UDim2.new(0,20,0.5,-20)
toggle.Text = "L"
toggle.BackgroundColor3 = Color3.fromRGB(170,90,255)
Instance.new("UICorner", toggle)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Smart Logs"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold

-- Position Tracker
local posLabel = Instance.new("TextLabel", main)
posLabel.Size = UDim2.new(1, -10, 0, 20)
posLabel.Position = UDim2.new(0, 5, 0, 28)
posLabel.BackgroundTransparency = 1
posLabel.TextColor3 = Color3.fromRGB(180,180,180)
posLabel.Font = Enum.Font.Code
posLabel.TextSize = 13
posLabel.TextXAlignment = Enum.TextXAlignment.Left
posLabel.Text = "Position: Loading..."

-- Scroll
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1,-10,1,-90)
scroll.Position = UDim2.new(0,5,0,50)
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,6)

-- Clear
local clear = Instance.new("TextButton", main)
clear.Size = UDim2.new(0,80,0,25)
clear.Position = UDim2.new(1,-90,1,-30)
clear.Text = "Clear"
clear.BackgroundColor3 = Color3.fromRGB(60,30,110)
Instance.new("UICorner", clear)

-- Toggle
main.Visible = true
toggle.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

--// POSITION TRACKER
RunService.RenderStepped:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local pos = char.HumanoidRootPart.Position
		posLabel.Text = string.format("Position: X %.1f | Y %.1f | Z %.1f", pos.X, pos.Y, pos.Z)
	end
end)

--// STORAGE
local logs = {}

--// FILTER FUNCTION
local function isFiltered(name)
	local lower = string.lower(name)
	for _, keyword in ipairs(FILTER_KEYWORDS) do
		if string.find(lower, keyword) then
			return true
		end
	end
	return false
end

--// CREATE LOG UI
local function createLog(displayName, data)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,-5,0,30)
	frame.BackgroundColor3 = Color3.fromRGB(30,30,35)
	frame.Parent = scroll
	Instance.new("UICorner", frame)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,-10,1,0)
	label.Position = UDim2.new(0,5,0,0)
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = Color3.fromRGB(200,200,200)
	label.Font = Enum.Font.Code
	label.TextSize = 13
	label.Text = displayName .. " (x1)"
	label.Parent = frame

	local expanded = false
	local detail

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			expanded = not expanded
			
			if expanded then
				if not detail then
					detail = Instance.new("TextLabel")
					detail.Size = UDim2.new(1,-10,0,40)
					detail.Position = UDim2.new(0,5,1,0)
					detail.BackgroundTransparency = 1
					detail.TextWrapped = true
					detail.Font = Enum.Font.Code
					detail.TextSize = 12
					detail.TextColor3 = Color3.fromRGB(150,150,150)
					detail.Parent = frame
				end
				detail.Text = data
				frame.Size = UDim2.new(1,-5,0,70)
			else
				frame.Size = UDim2.new(1,-5,0,30)
			end
		end
	end)

	return {
		frame = frame,
		label = label,
		update = function(count, newData)
			label.Text = displayName .. " (x"..count..")"
			if detail then
				detail.Text = newData
			end
		end
	}
end

--// SORT
local function sortLogs()
	local sorted = {}
	for _, entry in pairs(logs) do
		table.insert(sorted, entry)
	end

	table.sort(sorted, function(a, b)
		return a.count > b.count
	end)

	for i, entry in ipairs(sorted) do
		entry.ui.frame.LayoutOrder = i
	end
end

--// ADD LOG
local function addLog(remoteName, dataTable)
	if isFiltered(remoteName) then return end

	local data = HttpService:JSONEncode(dataTable)
	local key = remoteName .. "|" .. data

	if logs[key] then
		local entry = logs[key]
		entry.count += 1
		entry.ui.update(entry.count, data)
	else
		local displayName = remoteName .. " → " .. data
		local ui = createLog(displayName, data)

		logs[key] = {
			count = 1,
			ui = ui
		}
	end

	sortLogs()
end

--// CLEAR
clear.MouseButton1Click:Connect(function()
	for _, v in pairs(scroll:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end
	logs = {}
end)

--// REMOTE LOGGER
for _, v in pairs(game:GetDescendants()) do
	if v:IsA("RemoteEvent") then
		v.OnClientEvent:Connect(function(...)
			addLog(v.Name, {...})
		end)
	end
end

addLog("System", {"Logger initialized"})

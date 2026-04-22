
--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

------------------------------------------------
--// GUI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "YuriHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

------------------------------------------------
--// UI SCALE
------------------------------------------------
local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = gui

local scaleValue = 1

------------------------------------------------
--// COLORS
------------------------------------------------
local MAIN = Color3.fromRGB(170,90,255)
local BG = Color3.fromRGB(15,15,20)
local SIDEBAR_BG = Color3.fromRGB(12,12,16)

------------------------------------------------
--// MAIN FRAME
------------------------------------------------
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,430,0,290)
frame.Position = UDim2.new(0.5,-215,0.5,-145)
frame.BackgroundColor3 = BG
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

------------------------------------------------
--// TOP BAR
------------------------------------------------
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0.18,0)
topBar.BackgroundColor3 = Color3.fromRGB(10,10,14)
topBar.BorderSizePixel = 0
topBar.Parent = frame
Instance.new("UICorner",topBar).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.Text = "Hub ni Yuri"
title.Font = Enum.Font.Arcade
title.TextSize = 22
title.TextColor3 = MAIN
title.BackgroundTransparency = 1
title.Parent = topBar

------------------------------------------------
--// CLOSE BUTTON (MOVED LEFT)
------------------------------------------------
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,24,0,24)
closeBtn.Position = UDim2.new(1,-40,0.5,-12) -- FIXED (moved left)
closeBtn.Text = "×"
closeBtn.BackgroundColor3 = Color3.fromRGB(255,70,120)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = topBar
Instance.new("UICorner",closeBtn).CornerRadius = UDim.new(1,0)

------------------------------------------------
--// MINI UI (Y)
------------------------------------------------
local mini = Instance.new("TextButton")
mini.Size = UDim2.new(0,42,0,42)
mini.Position = UDim2.new(0,20,0.5,-21)
mini.Text = "Y"
mini.BackgroundColor3 = MAIN
mini.TextColor3 = Color3.fromRGB(255,255,255)
mini.Font = Enum.Font.GothamBold
mini.TextSize = 18
mini.Visible = false
mini.Parent = gui
Instance.new("UICorner",mini).CornerRadius = UDim.new(1,0)

------------------------------------------------
--// DRAG MAIN UI (FIXED)
------------------------------------------------
do
	local dragging = false
	local start, pos

	topBar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			start = i.Position
			pos = frame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if dragging then
			local d = i.Position - start
			frame.Position = UDim2.new(
				pos.X.Scale,
				pos.X.Offset + d.X,
				pos.Y.Scale,
				pos.Y.Offset + d.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

------------------------------------------------
--// DRAG MINI UI (FIXED)
------------------------------------------------
do
	local dragging = false
	local start, pos

	mini.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			start = i.Position
			pos = mini.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if dragging then
			local d = i.Position - start
			mini.Position = UDim2.new(
				pos.X.Scale,
				pos.X.Offset + d.X,
				pos.Y.Scale,
				pos.Y.Offset + d.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

------------------------------------------------
--// BODY + SIDEBAR
------------------------------------------------
local body = Instance.new("Frame")
body.Size = UDim2.new(1,0,0.82,0)
body.Position = UDim2.new(0,0,0.18,0)
body.BackgroundTransparency = 1
body.Parent = frame

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0,125,1,0)
sidebar.BackgroundColor3 = SIDEBAR_BG
sidebar.BorderSizePixel = 0
sidebar.Parent = body
Instance.new("UICorner",sidebar).CornerRadius = UDim.new(0,10)

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0,6)
list.Parent = sidebar

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0,10)
pad.PaddingLeft = UDim.new(0,8)
pad.Parent = sidebar

------------------------------------------------
--// SIDEBAR BUTTONS (2X SPACING FIX)
------------------------------------------------
local tabs = {
	{"Main","Main"},
	{"⚡ Auto","Auto"},
	{"👤 Player","Player"},
	{"🌐 Webhook","Webhook"},
	{"••• Misc","Misc"},
	{"⚙️ Config","Config"}
}

for _,v in ipairs(tabs) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-10,0,30)
	b.BackgroundColor3 = Color3.fromRGB(18,18,22)
	b.TextColor3 = MAIN
	b.Font = Enum.Font.Gotham
	b.TextSize = 13

	if v[1] == "Main" then
		b.Text = "Main"
		b.TextXAlignment = Enum.TextXAlignment.Center
	else
		b.Text = "        "..v[1] -- 2X MORE SPACE ADDED HERE
		b.TextXAlignment = Enum.TextXAlignment.Left
	end

	b.Parent = sidebar
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)
end

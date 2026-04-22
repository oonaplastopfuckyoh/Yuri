--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "YuriHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,420,0,280)
frame.Position = UDim2.new(0.5,-210,0.5,-140)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

-- DIMMER PURPLE OUTLINE
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(170, 90, 255)
stroke.Thickness = 2
stroke.Transparency = 0.35
stroke.Parent = frame

--// TOP BAR
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0.18,0)
topBar.BackgroundColor3 = Color3.fromRGB(18,10,28)
topBar.Parent = frame
Instance.new("UICorner",topBar).CornerRadius = UDim.new(0,12)

-- TITLE (SMALLER + BETTER FONT)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.Text = "Hub ni Yuri"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamSemibold
title.TextSize = 14
title.BackgroundTransparency = 1
title.Parent = topBar

-- CLOSE BUTTON (FIXED ALIGNMENT)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,22,0,22)
closeBtn.Position = UDim2.new(1,-30,0.5,-11)
closeBtn.Text = "×"
closeBtn.BackgroundColor3 = Color3.fromRGB(255,70,120)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = topBar
Instance.new("UICorner",closeBtn).CornerRadius = UDim.new(1,0)

--// BODY
local body = Instance.new("Frame")
body.Size = UDim2.new(1,0,0.82,0)
body.Position = UDim2.new(0,0,0.18,0)
body.BackgroundTransparency = 1
body.Parent = frame

--// SIDEBAR
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0.22,0,1,0)
sidebar.BackgroundColor3 = Color3.fromRGB(18,18,18)
sidebar.Parent = body
Instance.new("UICorner",sidebar).CornerRadius = UDim.new(0,10)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Parent = sidebar

-- PUSH CONTENT DOWN
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0,10)
padding.Parent = sidebar

--// PAGES
local pages = {}

local function page(name)
	local p = Instance.new("Frame")
	p.Size = UDim2.new(0.78,0,1,0)
	p.Position = UDim2.new(0.22,0,0,0)
	p.BackgroundTransparency = 1
	p.Visible = false
	p.Parent = body
	pages[name] = p
	return p
end

local Main = page("Main")
local Auto = page("Auto")
local PlayerP = page("Player")
local Webhook = page("Webhook")
local Misc = page("Misc")
local Config = page("Config")

Main.Visible = true
local currentTab = "Main"

local function switch(tab)
	currentTab = tab
	for n,p in pairs(pages) do
		p.Visible = (n == tab)
	end
end

--// SIDEBAR BUTTONS + TOGGLE DOTS
for _,t in ipairs({"Main","Auto","Player","Webhook","Misc","Config"}) do
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.9,0,0,28)
	container.BackgroundTransparency = 1
	container.Parent = sidebar

	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.8,0,1,0)
	b.BackgroundColor3 = Color3.fromRGB(35,35,50)
	b.Text = t
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.Parent = container
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)

	-- mini toggle indicator
	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0,6,0,6)
	dot.Position = UDim2.new(0.85,0,0.5,-3)
	dot.BackgroundColor3 = Color3.fromRGB(100,100,100)
	dot.Parent = container
	Instance.new("UICorner",dot).CornerRadius = UDim.new(1,0)

	local active = false

	b.MouseButton1Click:Connect(function()
		switch(t)
		active = not active

		if active then
			dot.BackgroundColor3 = Color3.fromRGB(170,90,255)
		else
			dot.BackgroundColor3 = Color3.fromRGB(100,100,100)
		end
	end)
end

--// DRAG (IMPROVED)
local dragging, startPos, startFramePos

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		startPos = input.Position
		startFramePos = frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - startPos
		frame.Position = UDim2.new(
			startFramePos.X.Scale,
			startFramePos.X.Offset + delta.X,
			startFramePos.Y.Scale,
			startFramePos.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

--// CLOSE
local open = true
closeBtn.MouseButton1Click:Connect(function()
	open = not open
	body.Visible = open
end)

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

--// MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,420,0,280)
frame.Position = UDim2.new(0.5,-210,0.5,-140)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(170,90,255)
stroke.Transparency = 0.35
stroke.Thickness = 2
stroke.Parent = frame

--// TOP BAR
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0.18,0)
topBar.BackgroundColor3 = Color3.fromRGB(18,10,28)
topBar.Parent = frame
Instance.new("UICorner",topBar).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.Text = "Hub ni Yuri"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Parent = topBar

--// CLOSE → MINIMIZE LOGO MODE
local minimized = false

local miniIcon = Instance.new("TextButton")
miniIcon.Size = UDim2.new(0,40,0,40)
miniIcon.Position = UDim2.new(0,10,0.5,-20)
miniIcon.Text = "Y"
miniIcon.Visible = false
miniIcon.BackgroundColor3 = Color3.fromRGB(170,90,255)
miniIcon.TextColor3 = Color3.fromRGB(255,255,255)
miniIcon.Font = Enum.Font.GothamBold
miniIcon.TextSize = 18
miniIcon.Parent = gui
Instance.new("UICorner",miniIcon).CornerRadius = UDim.new(1,0)

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
layout.VerticalAlignment = Enum.VerticalAlignment.Center -- CENTERED
layout.Parent = sidebar

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0,10)
padding.Parent = sidebar

--// PAGES
local pages = {}

local function createPage(name)
	local p = Instance.new("Frame")
	p.Size = UDim2.new(0.78,0,1,0)
	p.Position = UDim2.new(0.22,0,0,0)
	p.BackgroundTransparency = 1
	p.Visible = false
	p.Parent = body
	pages[name] = p
	return p
end

local Main = createPage("Main")
local Auto = createPage("Auto")
local PlayerP = createPage("Player")
local Webhook = createPage("Webhook")
local Misc = createPage("Misc")
local Config = createPage("Config")

Main.Visible = true

local function switch(tab)
	for n,p in pairs(pages) do
		p.Visible = (n == tab)
	end
end

--// TOGGLE SYSTEM PER PAGE
local function addToggle(parent, text, y)
	local state = false

	local f = Instance.new("Frame")
	f.Size = UDim2.new(0.9,0,0,30)
	f.Position = UDim2.new(0.05,0,0,y)
	f.BackgroundColor3 = Color3.fromRGB(25,25,25)
	f.Parent = parent
	Instance.new("UICorner",f).CornerRadius = UDim.new(0,8)

	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(0.7,0,1,0)
	l.Text = text
	l.TextColor3 = Color3.fromRGB(255,255,255)
	l.BackgroundTransparency = 1
	l.Font = Enum.Font.Gotham
	l.TextSize = 12
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Parent = f

	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,50,0,20)
	b.Position = UDim2.new(1,-60,0.5,-10)
	b.Text = "OFF"
	b.BackgroundColor3 = Color3.fromRGB(120,120,120)
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Parent = f
	Instance.new("UICorner",b).CornerRadius = UDim.new(1,0)

	b.MouseButton1Click:Connect(function()
		state = not state
		if state then
			b.Text = "ON"
			b.BackgroundColor3 = Color3.fromRGB(170,90,255)
		else
			b.Text = "OFF"
			b.BackgroundColor3 = Color3.fromRGB(120,120,120)
		end
	end)
end

--// SIDEBAR BUTTONS (NO INDICATORS, CENTERED)
for _,t in ipairs({"Main","Auto","Player","Webhook","Misc","Config"}) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.85,0,0,28)
	b.BackgroundColor3 = Color3.fromRGB(35,35,50)
	b.Text = t
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.Parent = sidebar
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)

	b.MouseButton1Click:Connect(function()
		switch(t)
	end)
end

--// EXAMPLE PAGE TOGGLES (EACH TAB OWNED)
addToggle(Main,"Main Toggle",20)
addToggle(Auto,"Auto Farm",20)
addToggle(PlayerP,"Speed Boost",20)
addToggle(Webhook,"Webhook Send",20)
addToggle(Misc,"Extra Feature",20)
addToggle(Config,"Save Config",20)

--// CLOSE → MINIMIZE LOGO
closeBtn.MouseButton1Click:Connect(function()
	minimized = true
	frame.Visible = false
	miniIcon.Visible = true
end)

miniIcon.MouseButton1Click:Connect(function()
	minimized = false
	frame.Visible = true
	miniIcon.Visible = false
end)

--// DRAG
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

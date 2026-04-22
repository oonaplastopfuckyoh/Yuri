--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

------------------------------------------------
--// GUI SETUP
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "YuriHub_UI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = gui

------------------------------------------------
--// COLORS
------------------------------------------------
local MAIN = Color3.fromRGB(170,90,255)
local DARK = Color3.fromRGB(10,10,15)
local DARKER = Color3.fromRGB(5,5,8)
local TEXT = Color3.fromRGB(210,170,255)

------------------------------------------------
--// MAIN FRAME
------------------------------------------------
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,420,0,280)
frame.Position = UDim2.new(0.5,-210,0.5,-140)
frame.BackgroundColor3 = DARKER
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke")
stroke.Color = MAIN
stroke.Transparency = 0.4
stroke.Thickness = 2
stroke.Parent = frame

------------------------------------------------
--// TOP BAR
------------------------------------------------
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0.18,0)
topBar.BackgroundColor3 = DARK
topBar.Parent = frame
Instance.new("UICorner",topBar).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.Text = "Hub ni Yuri"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = MAIN
title.BackgroundTransparency = 1
title.Parent = topBar

------------------------------------------------
--// BODY
------------------------------------------------
local body = Instance.new("Frame")
body.Size = UDim2.new(1,0,0.82,0)
body.Position = UDim2.new(0,0,0.18,0)
body.BackgroundTransparency = 1
body.Parent = frame

------------------------------------------------
--// SIDEBAR
------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0.25,0,1,0)
sidebar.BackgroundColor3 = DARK
sidebar.Parent = body

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0,6)
list.HorizontalAlignment = Enum.HorizontalAlignment.Left
list.VerticalAlignment = Enum.VerticalAlignment.Top
list.Parent = sidebar

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0,10)
pad.PaddingLeft = UDim.new(0,8)
pad.Parent = sidebar

------------------------------------------------
--// PAGES
------------------------------------------------
local pages = {}

local function createPage(name)
	local p = Instance.new("Frame")
	p.Size = UDim2.new(0.75,0,1,0)
	p.Position = UDim2.new(0.25,0,0,0)
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

------------------------------------------------
--// ACTIVE GLOW SYSTEM
------------------------------------------------
local activeButton = nil

local function setActive(btn)
	if activeButton then
		activeButton.BackgroundColor3 = Color3.fromRGB(20,20,25)
		local old = activeButton:FindFirstChild("Glow")
		if old then old:Destroy() end
	end

	activeButton = btn
	btn.BackgroundColor3 = Color3.fromRGB(35,15,60)

	local glow = Instance.new("UIStroke")
	glow.Name = "Glow"
	glow.Color = MAIN
	glow.Thickness = 2
	glow.Transparency = 0.2
	glow.Parent = btn

	task.spawn(function()
		while activeButton == btn do
			TweenService:Create(glow, TweenInfo.new(0.6), {Transparency = 0.6}):Play()
			task.wait(0.6)
			if activeButton ~= btn then break end
			TweenService:Create(glow, TweenInfo.new(0.6), {Transparency = 0.2}):Play()
			task.wait(0.6)
		end
	end)
end

------------------------------------------------
--// SIDEBAR BUTTONS
------------------------------------------------
local tabs = {
	{"Main","Main"},
	{"Auto","Auto"},
	{"Player","Player"},
	{"Webhook","Webhook"},
	{"Misc","Misc"},
	{"Config","Config"}
}

for _,v in ipairs(tabs) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-10,0,28)
	b.BackgroundColor3 = Color3.fromRGB(20,20,25)
	b.Text = "   " .. v[1]
	b.TextXAlignment = Enum.TextXAlignment.Left
	b.TextColor3 = TEXT
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.Parent = sidebar
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)

	b.MouseButton1Click:Connect(function()
		switch(v[2])
		setActive(b)
	end)
end

------------------------------------------------
--// SAMPLE CONTENT
------------------------------------------------
local function addLabel(parent,text)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1,0,0,30)
	t.Text = text
	t.TextColor3 = Color3.fromRGB(255,255,255)
	t.BackgroundTransparency = 1
	t.Font = Enum.Font.Gotham
	t.TextSize = 14
	t.Parent = parent
end

addLabel(Main,"Main Page")
addLabel(Auto,"Auto Page")
addLabel(PlayerP,"Player Page")
addLabel(Webhook,"Webhook Page")
addLabel(Misc,"Misc Page")
addLabel(Config,"Config Page")

------------------------------------------------
--// DRAG SYSTEM
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
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - start
			frame.Position = UDim2.new(pos.X.Scale,pos.X.Offset+delta.X,pos.Y.Scale,pos.Y.Offset+delta.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

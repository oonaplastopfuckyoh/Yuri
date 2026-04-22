
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
local TEXT = MAIN

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

------------------------------------------------
--// TITLE (COOLER FONT CHANGE)
------------------------------------------------
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.Text = "Hub ni Yuri"
title.Font = Enum.Font.Arcade -- 🔥 COOLER FONT
title.TextSize = 22
title.TextColor3 = MAIN
title.BackgroundTransparency = 1
title.Parent = topBar

------------------------------------------------
--// CLOSE + MINI
------------------------------------------------
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,24,0,24)
closeBtn.Position = UDim2.new(1,-30,0.5,-12)
closeBtn.Text = "×"
closeBtn.BackgroundColor3 = Color3.fromRGB(255,70,120)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = topBar
Instance.new("UICorner",closeBtn).CornerRadius = UDim.new(1,0)

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

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
	frame.Visible = true
	mini.Visible = false
end)

------------------------------------------------
--// BODY
------------------------------------------------
local body = Instance.new("Frame")
body.Size = UDim2.new(1,0,0.82,0)
body.Position = UDim2.new(0,0,0.18,0)
body.BackgroundTransparency = 1
body.Parent = frame

------------------------------------------------
--// SIDEBAR (FIXED)
------------------------------------------------
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
--// PAGE AREA
------------------------------------------------
local pageHolder = Instance.new("Frame")
pageHolder.Size = UDim2.new(1,-125,1,0)
pageHolder.Position = UDim2.new(0,125,0,0)
pageHolder.BackgroundTransparency = 1
pageHolder.Parent = body

local pages = {}

local function newPage(name)
	local p = Instance.new("Frame")
	p.Size = UDim2.new(1,0,1,0)
	p.BackgroundTransparency = 1
	p.Visible = false
	p.Parent = pageHolder
	pages[name] = p
	return p
end

local Main = newPage("Main")
local Auto = newPage("Auto")
local PlayerP = newPage("Player")
local Webhook = newPage("Webhook")
local Misc = newPage("Misc")
local Config = newPage("Config")

Main.Visible = true

local function switch(tab)
	for n,p in pairs(pages) do
		p.Visible = (n == tab)
	end
end

------------------------------------------------
--// ACTIVE BUTTON
------------------------------------------------
local active

local function setActive(btn)
	if active then
		active.BackgroundColor3 = Color3.fromRGB(18,18,22)
	end
	active = btn
	btn.BackgroundColor3 = Color3.fromRGB(40,20,70)
end

------------------------------------------------
--// SIDEBAR BUTTONS (SPACING FIXED + MAIN CENTERED)
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
		b.Text = "    "..v[1] -- spacing preserved
		b.TextXAlignment = Enum.TextXAlignment.Left
	end

	b.Parent = sidebar
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)

	b.MouseButton1Click:Connect(function()
		switch(v[2])
		setActive(b)
	end)
end

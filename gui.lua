
--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

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
local function updateScale()
	uiScale.Scale = scaleValue
end

------------------------------------------------
--// COLORS
------------------------------------------------
local MAIN = Color3.fromRGB(170,90,255)
local DARK = Color3.fromRGB(10,10,15)
local DARK2 = Color3.fromRGB(5,5,8)
local TEXT = Color3.fromRGB(210,170,255)

------------------------------------------------
--// MAIN FRAME
------------------------------------------------
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,420,0,280)
frame.Position = UDim2.new(0.5,-210,0.5,-140)
frame.BackgroundColor3 = DARK2
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

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
title.Font = Enum.Font.GothamSemibold
title.TextSize = 20
title.TextColor3 = MAIN
title.BackgroundTransparency = 1
title.Parent = topBar

------------------------------------------------
--// CLOSE + MINI SYSTEM
------------------------------------------------
local isOpen = true

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
	isOpen = false
	frame.Visible = false
	mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
	isOpen = true
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
sidebar.Size = UDim2.new(0,120,1,0)
sidebar.BackgroundColor3 = DARK
sidebar.Parent = body

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
pageHolder.Size = UDim2.new(1,-120,1,0)
pageHolder.Position = UDim2.new(0,120,0,0)
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
--// ACTIVE TAB GLOW
------------------------------------------------
local active

local function setActive(btn)
	if active then
		active.BackgroundColor3 = Color3.fromRGB(20,20,25)
		local g = active:FindFirstChild("Glow")
		if g then g:Destroy() end
	end

	active = btn
	btn.BackgroundColor3 = Color3.fromRGB(35,15,60)

	local glow = Instance.new("UIStroke")
	glow.Name = "Glow"
	glow.Color = MAIN
	glow.Thickness = 2
	glow.Transparency = 0.2
	glow.Parent = btn
end

------------------------------------------------
--// SIDEBAR BUTTONS
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
	b.Size = UDim2.new(1,-10,0,28)
	b.BackgroundColor3 = Color3.fromRGB(20,20,25)
	b.Text = "   "..v[1]
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
--// UI SCALE CONTROL (CONFIG)
------------------------------------------------
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,0,30)
label.Text = "UI Scale: 100%"
label.TextColor3 = TEXT
label.BackgroundTransparency = 1
label.Font = Enum.Font.Gotham
label.Parent = Config

local minus = Instance.new("TextButton")
minus.Size = UDim2.new(0,30,0,30)
minus.Position = UDim2.new(0,10,0,40)
minus.Text = "-"
minus.Parent = Config

local plus = Instance.new("TextButton")
plus.Size = UDim2.new(0,30,0,30)
plus.Position = UDim2.new(0,50,0,40)
plus.Text = "+"
plus.Parent = Config

local function refresh()
	uiScale.Scale = scaleValue
	label.Text = "UI Scale: "..math.floor(scaleValue*100).."%"
end

minus.MouseButton1Click:Connect(function()
	scaleValue = math.clamp(scaleValue-0.1,0.5,1.5)
	refresh()
end)

plus.MouseButton1Click:Connect(function()
	scaleValue = math.clamp(scaleValue+0.1,0.5,1.5)
	refresh()
end)

refresh()

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
			local d = i.Position - start
			frame.Position = UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

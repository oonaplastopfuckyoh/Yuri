
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
--// UI SCALE (RESTORED)
------------------------------------------------
local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = gui

local currentScale = 1
local function applyScale()
	uiScale.Scale = currentScale
end
applyScale()

------------------------------------------------
--// COLORS
------------------------------------------------
local MAIN = Color3.fromRGB(170,90,255)
local DARK = Color3.fromRGB(10,10,15)
local DARKER = Color3.fromRGB(5,5,8)
local TEXT = Color3.fromRGB(210,170,255)

------------------------------------------------
--// MAIN FRAME (NO OUTLINE = FIX OVERLAP)
------------------------------------------------
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,420,0,280)
frame.Position = UDim2.new(0.5,-210,0.5,-140)
frame.BackgroundColor3 = DARKER
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
title.Font = Enum.Font.GothamSemibold -- restored cleaner style
title.TextSize = 20
title.TextColor3 = MAIN
title.BackgroundTransparency = 1
title.Parent = topBar

------------------------------------------------
--// CLOSE BUTTON (RESTORED)
------------------------------------------------
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,22,0,22)
closeBtn.Position = UDim2.new(1,-28,0.5,-11)
closeBtn.Text = "×"
closeBtn.BackgroundColor3 = Color3.fromRGB(255,70,120)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = topBar
Instance.new("UICorner",closeBtn).CornerRadius = UDim.new(1,0)

------------------------------------------------
--// BODY
------------------------------------------------
local body = Instance.new("Frame")
body.Size = UDim2.new(1,0,0.82,0)
body.Position = UDim2.new(0,0,0.18,0)
body.BackgroundTransparency = 1
body.Parent = frame

------------------------------------------------
--// SIDEBAR (FIXED SPACING - NO OVERLAP)
------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0.23,0,1,0)
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

local function newPage(name)
	local p = Instance.new("Frame")
	p.Size = UDim2.new(0.77,0,1,0)
	p.Position = UDim2.new(0.23,0,0,0)
	p.BackgroundTransparency = 1
	p.Visible = false
	p.Parent = body
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
--// ACTIVE GLOW SIDEBAR
------------------------------------------------
local activeButton

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
			TweenService:Create(glow,TweenInfo.new(0.6),{Transparency=0.6}):Play()
			task.wait(0.6)
			if activeButton ~= btn then break end
			TweenService:Create(glow,TweenInfo.new(0.6),{Transparency=0.2}):Play()
			task.wait(0.6)
		end
	end)
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
--// UI SCALE RESTORE (CONFIG)
------------------------------------------------
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0.9,0,0,20)
label.Position = UDim2.new(0.05,0,0,20)
label.Text = "UI Scale: 100%"
label.TextColor3 = TEXT
label.BackgroundTransparency = 1
label.Font = Enum.Font.Gotham
label.Parent = Config

local minus = Instance.new("TextButton")
minus.Size = UDim2.new(0,25,0,25)
minus.Position = UDim2.new(0.05,0,0,50)
minus.Text = "-"
minus.Parent = Config

local plus = Instance.new("TextButton")
plus.Size = UDim2.new(0,25,0,25)
plus.Position = UDim2.new(0.15,0,0,50)
plus.Text = "+"
plus.Parent = Config

local function update()
	uiScale.Scale = currentScale
	label.Text = "UI Scale: "..math.floor(currentScale*100).."%"
end

minus.MouseButton1Click:Connect(function()
	currentScale = math.clamp(currentScale-0.1,0.5,1.5)
	update()
end)

plus.MouseButton1Click:Connect(function()
	currentScale = math.clamp(currentScale+0.1,0.5,1.5)
	update()
end)

update()

------------------------------------------------
--// CLOSE FUNCTION
------------------------------------------------
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

------------------------------------------------
--// DRAG
------------------------------------------------
do
	local dragging=false
	local start,pos

	topBar.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			dragging=true
			start=i.Position
			pos=frame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
			local d=i.Position-start
			frame.Position=UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			dragging=false
		end
	end)
end

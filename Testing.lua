
--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

------------------------------------------------
-- CLEAN GUI
------------------------------------------------
local old = player.PlayerGui:FindFirstChild("YuriHub")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "YuriHub"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

------------------------------------------------
-- COLORS
------------------------------------------------
local BG = Color3.fromRGB(10,10,14)
local SIDEBAR = Color3.fromRGB(12,12,18)
local MAIN = Color3.fromRGB(170,90,255)
local TEXT = Color3.fromRGB(210,180,255)

------------------------------------------------
-- MAIN FRAME
------------------------------------------------
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 520, 0, 320)
frame.Position = UDim2.new(0.5, -260, 0.5, -160)
frame.BackgroundColor3 = BG
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

------------------------------------------------
-- TOP BAR
------------------------------------------------
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,45)
topBar.BackgroundColor3 = Color3.fromRGB(8,8,12)
topBar.BorderSizePixel = 0
topBar.Parent = frame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.Text = "Hub ni Yuri"
title.Font = Enum.Font.Arcade
title.TextSize = 24
title.TextColor3 = MAIN
title.BackgroundTransparency = 1
title.Parent = topBar

------------------------------------------------
-- CLOSE
------------------------------------------------
local close = Instance.new("TextButton")
close.Size = UDim2.new(0,28,0,28)
close.Position = UDim2.new(1,-38,0.5,-14)
close.Text = "×"
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.TextColor3 = Color3.fromRGB(255,255,255)
close.BackgroundColor3 = Color3.fromRGB(255,80,120)
close.Parent = topBar
Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)

------------------------------------------------
-- BODY
------------------------------------------------
local body = Instance.new("Frame")
body.Size = UDim2.new(1,0,1,-45)
body.Position = UDim2.new(0,0,0,45)
body.BackgroundTransparency = 1
body.Parent = frame

------------------------------------------------
-- SIDEBAR
------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0,150,1,0)
sidebar.BackgroundColor3 = SIDEBAR
sidebar.BorderSizePixel = 0
sidebar.Parent = body
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0,12)

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0,8)
list.Parent = sidebar

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0,12)
pad.PaddingLeft = UDim.new(0,10)
pad.Parent = sidebar

------------------------------------------------
-- CONTENT AREA
------------------------------------------------
local content = Instance.new("Frame")
content.Size = UDim2.new(1,-150,1,0)
content.Position = UDim2.new(0,150,0,0)
content.BackgroundTransparency = 1
content.Parent = body

------------------------------------------------
-- PAGES
------------------------------------------------
local pages = {}

local function newPage(name)
	local p = Instance.new("Frame")
	p.Size = UDim2.new(1,0,1,0)
	p.BackgroundTransparency = 1
	p.Visible = false
	p.Parent = content
	pages[name] = p
	return p
end

local main = newPage("main")
main.Visible = true

------------------------------------------------
-- SWITCH
------------------------------------------------
local function switch(tab)
	for n,p in pairs(pages) do
		p.Visible = (n == tab)
	end
end

------------------------------------------------
-- ACTIVE BUTTON
------------------------------------------------
local active

local function setActive(btn)
	if active then
		active.BackgroundColor3 = Color3.fromRGB(18,18,25)
	end
	active = btn
	btn.BackgroundColor3 = MAIN
end

------------------------------------------------
-- SIDEBAR BUTTONS (MATCH MOCKUP STYLE)
------------------------------------------------
local tabs = {
	{"🏠","main"},
	{"⚡","auto"},
	{"👤","player"},
	{"🌐","webhook"},
	{"•••","misc"},
	{"⚙️","config"}
}

for _,v in ipairs(tabs) do
	local icon, name = v[1], v[2]

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,-12,0,38)
	btn.BackgroundColor3 = Color3.fromRGB(18,18,25)
	btn.Text = ""
	btn.Parent = sidebar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

	local ic = Instance.new("TextLabel")
	ic.Size = UDim2.new(0,30,1,0)
	ic.Position = UDim2.new(0,10,0,0)
	ic.BackgroundTransparency = 1
	ic.Text = icon
	ic.TextColor3 = MAIN
	ic.Font = Enum.Font.Gotham
	ic.TextSize = 16
	ic.Parent = btn

	local tx = Instance.new("TextLabel")
	tx.Size = UDim2.new(1,-50,1,0)
	tx.Position = UDim2.new(0,45,0,0)
	tx.BackgroundTransparency = 1
	tx.Text = name
	tx.TextColor3 = TEXT
	tx.Font = Enum.Font.Gotham
	tx.TextSize = 14
	tx.TextXAlignment = Enum.TextXAlignment.Left
	tx.Parent = btn

	btn.MouseButton1Click:Connect(function()
		switch(name)
		setActive(btn)
	end)
end

------------------------------------------------
-- CLOSE
------------------------------------------------
close.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

------------------------------------------------
-- DRAG
------------------------------------------------
local dragging, start, startPos

topBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		start = i.Position
		startPos = frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(i)
	if dragging then
		local d = i.Position - start
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + d.X,
			startPos.Y.Scale,
			startPos.Y.Offset + d.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function()
	dragging = false
end)

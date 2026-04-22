
--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

------------------------------------------------
--// PREVENT DUPLICATE GUI
------------------------------------------------
local old = player:WaitForChild("PlayerGui"):FindFirstChild("YuriHub")
if old then old:Destroy() end

------------------------------------------------
--// GUI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "YuriHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

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
--// CLOSE BUTTON
------------------------------------------------
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,24,0,24)
closeBtn.Position = UDim2.new(1,-40,0.5,-12)
closeBtn.Text = "×"
closeBtn.BackgroundColor3 = Color3.fromRGB(255,70,120)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = topBar
Instance.new("UICorner",closeBtn).CornerRadius = UDim.new(1,0)

------------------------------------------------
--// MINI Y BUTTON (FIXED)
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
--// DRAG FUNCTION
------------------------------------------------
local function drag(obj, handle)
	local dragging = false
	local start, pos

	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			start = i.Position
			pos = obj.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if dragging then
			local d = i.Position - start
			obj.Position = UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function()
		dragging = false
	end)
end

drag(frame, topBar)
drag(mini)

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
--// PAGE SYSTEM
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
local activeBtn
local function setActive(btn)
	if activeBtn then
		activeBtn.BackgroundColor3 = Color3.fromRGB(18,18,22)
	end
	activeBtn = btn
	btn.BackgroundColor3 = Color3.fromRGB(60,30,110)
end

------------------------------------------------
--// SIDEBAR (FINAL CLEAN)
------------------------------------------------
local tabs = {
	{"","main"},
	{"⚡","Auto"},
	{"👤","Player"},
	{"🌐","Webhook"},
	{"•••","Misc"},
	{"⚙️","Config"}
}

for _,v in ipairs(tabs) do
	local icon, key = v[1], v[2]

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,-10,0,30)
	btn.BackgroundColor3 = Color3.fromRGB(18,18,22)
	btn.Text = ""
	btn.Parent = sidebar
	Instance.new("UICorner",btn).CornerRadius = UDim.new(0,8)

	local ic = Instance.new("TextLabel")
	ic.Size = UDim2.new(0,22,1,0)
	ic.Position = UDim2.new(0,8,0,0)
	ic.BackgroundTransparency = 1
	ic.Text = icon
	ic.TextColor3 = MAIN
	ic.Font = Enum.Font.Gotham
	ic.TextSize = 16
	ic.Parent = btn

	local tx = Instance.new("TextLabel")
	tx.Size = UDim2.new(1,-40,1,0)
	tx.Position = UDim2.new(0,35,0,0)
	tx.BackgroundTransparency = 1
	tx.Text = key
	tx.TextColor3 = MAIN
	tx.Font = Enum.Font.Gotham
	tx.TextSize = 15
	tx.TextXAlignment = Enum.TextXAlignment.Left
	tx.Parent = btn

	btn.MouseButton1Click:Connect(function()
		switch(key)
		setActive(btn)
	end)
end

------------------------------------------------
--// CLOSE + MINI TOGGLE (FIXED)
------------------------------------------------
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
	frame.Visible = true
	mini.Visible = false
end)

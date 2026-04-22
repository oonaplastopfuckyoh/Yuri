--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "YuriHub"
gui.ResetOnSpawn = false
gui.Parent = playerGui

--// SCALE
local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = gui

--// MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 280)
frame.Position = UDim2.new(0.5, -210, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- black background
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16) -- Increased corner radius

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(180, 80, 255) -- neon purple
stroke.Thickness = 3 -- thicker glow
stroke.Transparency = 0
stroke.Parent = frame

-- Glow effect using extra Frame around main frame (optional for neon effect)
local glow = Instance.new("ImageLabel")
glow.Image = "rbxassetid://3570695787" -- a rounded rectangle image
glow.Size = UDim2.new(1, 16, 1, 16)
glow.Position = UDim2.new(0, -8, 0, -8)
glow.BackgroundTransparency = 1
glow.ImageColor3 = Color3.fromRGB(180, 80, 255)
glow.ScaleType = Enum.ScaleType.Slice
glow.SliceCenter = Rect.new(10, 10, 118, 118)
glow.Parent = frame
glow.ZIndex = 0

--// TOP BAR
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0.18, 0)
topBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- black
topBar.BorderSizePixel = 0
topBar.Parent = frame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 16)

-- Title Label with custom font
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, -4) -- lift text slightly
title.Text = "Hub n Yuri"
title.TextColor3 = Color3.fromRGB(180, 80, 255) -- neon purple
title.Font = Enum.Font.Script -- cursive style font
title.TextSize = 32 -- larger font size for header
title.TextXAlignment = Enum.TextXAlignment.Center
title.BackgroundTransparency = 1
title.Parent = topBar

-- Separator line vertical between sidebar and body
local separator = Instance.new("Frame")
separator.Size = UDim2.new(0, 1, 1, 0)
separator.BackgroundColor3 = Color3.fromRGB(100, 50, 140)
separator.Position = UDim2.new(0.2, 0, 0, 0)
separator.BorderSizePixel = 0
separator.Parent = frame

--// BODY
local body = Instance.new("Frame")
body.Size = UDim2.new(0.8, 0, 0.82, 0)
body.Position = UDim2.new(0.2, 0, 0.18, 0)
body.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- black
body.Parent = frame
Instance.new("UICorner", body).CornerRadius = UDim.new(0, 12)

--// SIDEBAR
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0.2, 0, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- dark near black
sidebar.Parent = frame
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 16)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = sidebar

-- Icons for sidebar buttons
local icons = {
	Main = "⚡", -- lightning
	Auto = "⚡",
	Player = "👤",
	Webhook = "🌐",
	Misc = "...",
	Config = "⚙"
}

local pages = {}

local function page(name)
	local p = Instance.new("Frame")
	p.Size = UDim2.new(1, 0, 1, 0)
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

local sidebarButtons = {}

local function updateButtonStyles()
	for name, button in pairs(sidebarButtons) do
		if name == currentTab then
			button.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
			button.TextColor3 = Color3.fromRGB(255, 255, 255)
			button.Icon.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			button.TextColor3 = Color3.fromRGB(180, 80, 255)
			button.Icon.TextColor3 = Color3.fromRGB(180, 80, 255)
		end
	end
end

local function switch(tab)
	currentTab = tab
	for n, p in pairs(pages) do
		p.Visible = (n == tab)
	end
	updateButtonStyles()
end

--// SIDEBAR BUTTONS (with icons)
for _, t in ipairs({"Main", "Auto", "Player", "Webhook", "Misc", "Config"}) do
	local b = Instance.new("Frame")
	b.Size = UDim2.new(1, -20, 0, 36)
	b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	b.Parent = sidebar
	b.LayoutOrder = _
	
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)

	local iconLabel = Instance.new("TextLabel")
	iconLabel.Size = UDim2.new(0, 28, 1, 0)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Text = icons[t]
	iconLabel.Font = Enum.Font.SourceSans -- clear font for icons
	iconLabel.TextSize = 24
	iconLabel.TextColor3 = Color3.fromRGB(180, 80, 255)
	iconLabel.TextXAlignment = Enum.TextXAlignment.Center
	iconLabel.Parent = b

	local textButton = Instance.new("TextButton")
	textButton.Size = UDim2.new(1, -28, 1, 0)
	textButton.Position = UDim2.new(0, 28, 0, 0)
	textButton.BackgroundTransparency = 1
	textButton.Text = string.lower(t) -- lowercase text
	textButton.TextColor3 = Color3.fromRGB(180, 80, 255)
	textButton.Font = Enum.Font.SourceSansBold
	textButton.TextSize = 18
	textButton.TextXAlignment = Enum.TextXAlignment.Left
	textButton.Parent = b

	b.Icon = iconLabel
	b.Button = textButton

	textButton.MouseButton1Click:Connect(function()
		switch(t)
	end)

	sidebarButtons[t] = b
end

updateButtonStyles() -- initial styles on startup

--// PAGE CONTENT (example for Main)
local t1 = Instance.new("TextLabel")
t1.Text = "testing"
t1.Font = Enum.Font.SourceSansSemibold
t1.TextSize = 36
t1.TextColor3 = Color3.fromRGB(180, 80, 255) -- purple text
t1.BackgroundTransparency = 1
t1.Position = UDim2.new(0.05, 0, 0.1, 0)
t1.Size = UDim2.new(0.5, 0, 0, 50)
t1.Parent = Main

local t2 = Instance.new("TextLabel")
t2.Text = "tanging"
t2.Font = Enum.Font.SourceSansSemibold
t2.TextSize = 36
t2.TextColor3 = Color3.fromRGB(180, 80, 255)
t2.BackgroundTransparency = 1
t2.Position = UDim2.new(0.05, 0, 0.3, 0)
t2.Size = UDim2.new(0.5, 0, 0, 50)
t2.Parent = Main

--// CLOSE BUTTON (optional)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -32, 0, 4)
closeBtn.Text = "×"
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
closeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 24
closeBtn.Parent = frame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

local open = true
closeBtn.MouseButton1Click:Connect(function()
	open = not open
	body.Visible = open
	sidebar.Visible = open
	separator.Visible = open
end)

--// DRAGGING (unchanged)
local dragging, st, pos

topBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		st = i.Position
		pos = frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(i)
	if dragging then
		local d = i.Position - st
		frame.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
	end
end)

UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

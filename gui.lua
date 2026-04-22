--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "YuriHub"
gui.ResetOnSpawn = false
gui.Parent = playerGui

--// MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 280)
frame.Position = UDim2.new(0.5, -210, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- black background
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

-- Simple neon border using UIStroke
local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(180, 80, 255) -- neon purple
stroke.Transparency = 0
stroke.Parent = frame

-- Optionally subtle outer glow frame behind main frame
local glowFrame = Instance.new("Frame")
glowFrame.Size = UDim2.new(1, 12, 1, 12)
glowFrame.Position = UDim2.new(0, -6, 0, -6)
glowFrame.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
glowFrame.BackgroundTransparency = 0.9
glowFrame.ZIndex = 0
glowFrame.Parent = gui
Instance.new("UICorner", glowFrame).CornerRadius = UDim.new(0, 16)

--// TOP BAR
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0.18, 0)
topBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
topBar.BorderSizePixel = 0
topBar.Parent = frame
topBar.ZIndex = 2
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 16)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Hub n Yuri"
title.TextColor3 = Color3.fromRGB(180, 80, 255)
title.Font = Enum.Font.Script
title.TextSize = 36
title.TextXAlignment = Enum.TextXAlignment.Center
title.BackgroundTransparency = 1
title.Parent = topBar
title.ZIndex = 3

--// SIDEBAR
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0.2, 0, 0.82, 0)
sidebar.Position = UDim2.new(0, 0, 0.18, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
sidebar.Parent = frame
sidebar.ZIndex = 3
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 16)

local layout = Instance.new("UIListLayout")
layout.Parent = sidebar
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Sidebar buttons data: {Name, IconText}
local tabs = {
	{ Name = "Main", Icon = "⚡" },
	{ Name = "Auto farm", Icon = "⚡" },
	{ Name = "Player", Icon = "👤" },
	{ Name = "Webhook", Icon = "🌐" },
	{ Name = "Misc", Icon = "…" },
	{ Name = "Config", Icon = "⚙" },
}

local sidebarButtons = {}

-- Create Sidebar Buttons
for i, tabData in ipairs(tabs) do
	local btnFrame = Instance.new("Frame")
	btnFrame.Size = UDim2.new(1, -20, 0, 36)
	btnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btnFrame.LayoutOrder = i
	btnFrame.Parent = sidebar
	Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 10)
	btnFrame.ZIndex = 4

	local iconLabel = Instance.new("TextLabel")
	iconLabel.Size = UDim2.new(0, 30, 1, 0)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Font = Enum.Font.GothamBold
	iconLabel.Text = tabData.Icon
	iconLabel.TextColor3 = Color3.fromRGB(180, 80, 255)
	iconLabel.TextSize = 22
	iconLabel.TextXAlignment = Enum.TextXAlignment.Center
	iconLabel.Parent = btnFrame
	iconLabel.ZIndex = 5

	local btnText = Instance.new("TextButton")
	btnText.Size = UDim2.new(1, -30, 1, 0)
	btnText.Position = UDim2.new(0, 30, 0, 0)
	btnText.BackgroundTransparency = 1
	btnText.Font = Enum.Font.Gotham
	btnText.Text = string.lower(tabData.Name)
	btnText.TextColor3 = Color3.fromRGB(220, 220, 220)
	btnText.TextSize = 18
	btnText.TextXAlignment = Enum.TextXAlignment.Left
	btnText.Parent = btnFrame
	btnText.ZIndex = 5

	btnText.MouseButton1Click:Connect(function()
		switch(tabData.Name)
	end)

	-- Store reference for style updates
	sidebarButtons[tabData.Name] = btnFrame
end

--// SEPARATOR
local separator = Instance.new("Frame")
separator.Size = UDim2.new(0, 2, 0.82, 0)
separator.Position = UDim2.new(0.2, 0, 0.18, 0)
separator.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
separator.BorderSizePixel = 0
separator.Parent = frame
separator.ZIndex = 3

--// BODY (pages container)
local body = Instance.new("Frame")
body.Size = UDim2.new(0.78, 0, 0.82, 0)
body.Position = UDim2.new(0.22, 0, 0.18, 0)
body.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
body.Parent = frame
body.ZIndex = 2
Instance.new("UICorner", body).CornerRadius = UDim.new(0, 10)

--// PAGES container and initializer
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
local AutoFarm = page("Auto farm")
local Player = page("Player")
local Webhook = page("Webhook")
local Misc = page("Misc")
local Config = page("Config")

local currentTab = "Main"
pages[currentTab].Visible = true

-- Function to switch active tab/page and update sidebar button styles
function switch(tab)
	if currentTab == tab then return end
	if pages[currentTab] then pages[currentTab].Visible = false end
	if pages[tab] then pages[tab].Visible = true end
	currentTab = tab

	for name, btnFrame in pairs(sidebarButtons) do
		if name == tab then
			btnFrame.BackgroundColor3 = Color3.fromRGB(180, 80, 255) -- purple bg
			for _, child in pairs(btnFrame:GetChildren()) do
				if child:IsA("TextButton") or child:IsA("TextLabel") then
					child.TextColor3 = Color3.fromRGB(255, 255, 255)
				end
			end
		else
			btnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			for _, child in pairs(btnFrame:GetChildren()) do
				if child:IsA("TextButton") or child:IsA("TextLabel") then
					child.TextColor3 = child:IsA("TextLabel") and Color3.fromRGB(180, 80, 255) or Color3.fromRGB(220, 220, 220)
				end
			end
		end
	end
end

-- Initial update for buttons
switch(currentTab)

--// PAGE CONTENT example for "Main"
local label1 = Instance.new("TextLabel")
label1.Text = "testing"
label1.Font = Enum.Font.GothamSemibold
label1.TextSize = 32
label1.TextColor3 = Color3.fromRGB(180, 80, 255)
label1.BackgroundTransparency = 1
label1.Position = UDim2.new(0.05, 0, 0.1, 0)
label1.Size = UDim2.new(0.7, 0, 0, 50)
label1.Parent = Main
label1.ZIndex = 10

local label2 = Instance.new("TextLabel")
label2.Text = "tanging"
label2.Font = Enum.Font.GothamSemibold
label2.TextSize = 32
label2.TextColor3 = Color3.fromRGB(180, 80, 255)
label2.BackgroundTransparency = 1
label2.Position = UDim2.new(0.05, 0, 0.3, 0)
label2.Size = UDim2.new(0.7, 0, 0, 50)
label2.Parent = Main
label2.ZIndex = 10

--// DRAGGING FOR MAIN FRAME
local dragging, dragStart, startPos
topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

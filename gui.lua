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
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

--// TOP BAR - SIMPLE TEST
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- RED for visibility
topBar.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "HUB N YURI - VISIBLE?"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = topBar

--// SIDEBAR - SIMPLE TEST
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 80, 0, 240)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- GREEN for visibility
sidebar.Parent = frame

local sidebarText = Instance.new("TextLabel")
sidebarText.Size = UDim2.new(1, 0, 1, 0)
sidebarText.BackgroundTransparency = 1
sidebarText.Text = "SIDEBAR\nVISIBLE?"
sidebarText.TextColor3 = Color3.fromRGB(255, 255, 255)
sidebarText.Font = Enum.Font.GothamBold
sidebarText.TextSize = 18
sidebarText.TextXAlignment = Enum.TextXAlignment.Center
sidebarText.Parent = sidebar

--// BODY - SIMPLE TEST
local body = Instance.new("Frame")
body.Size = UDim2.new(0, 338, 0, 240)
body.Position = UDim2.new(0, 80, 0, 40)
body.BackgroundColor3 = Color3.fromRGB(0, 0, 255) -- BLUE for visibility
body.Parent = frame

local bodyText = Instance.new("TextLabel")
bodyText.Size = UDim2.new(1, 0, 1, 0)
bodyText.BackgroundTransparency = 1
bodyText.Text = "BODY\nVISIBLE?"
bodyText.TextColor3 = Color3.fromRGB(255, 255, 255)
bodyText.Font = Enum.Font.GothamBold
bodyText.TextSize = 18
bodyText.TextXAlignment = Enum.TextXAlignment.Center
bodyText.Parent = body

--// SEPARATOR - SIMPLE TEST
local separator = Instance.new("Frame")
separator.Size = UDim2.new(0, 2, 0, 240)
separator.Position = UDim2.new(0, 80, 0, 40)
separator.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- YELLOW for visibility
separator.Parent = frame

--// NEON BORDER
local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(180, 80, 255)
stroke.Parent = frame

print("YuriHub GUI created - check for RED/GREEN/BLUE/YELLOW blocks!")

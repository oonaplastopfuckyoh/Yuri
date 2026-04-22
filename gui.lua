-- LocalScript (StarterPlayerScripts)

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlackPurpleGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 180)
frame.Position = UDim2.new(0.5, -160, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true -- REQUIRED FOR DRAG
frame.Draggable = true -- makes it draggable
frame.Parent = screenGui

-- Rounded corners
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Purple border
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(170, 0, 255)
stroke.Thickness = 2
stroke.Parent = frame

-- Title text
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 0.5, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "hello, testing."
textLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
textLabel.TextScaled = true
textLabel.Font = Enum.Font.GothamBold
textLabel.Parent = frame

-- BUTTON 1: Change Text
local button1 = Instance.new("TextButton")
button1.Size = UDim2.new(0.4, 0, 0.3, 0)
button1.Position = UDim2.new(0.1, 0, 0.6, 0)
button1.Text = "Change Text"
button1.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
button1.TextColor3 = Color3.fromRGB(255, 255, 255)
button1.Font = Enum.Font.Gotham
button1.TextScaled = true
button1.Parent = frame
Instance.new("UICorner", button1)

-- BUTTON 2: Close GUI
local button2 = Instance.new("TextButton")
button2.Size = UDim2.new(0.4, 0, 0.3, 0)
button2.Position = UDim2.new(0.5, 0, 0.6, 0)
button2.Text = "Close"
button2.BackgroundColor3 = Color3.fromRGB(90, 0, 120)
button2.TextColor3 = Color3.fromRGB(255, 255, 255)
button2.Font = Enum.Font.Gotham
button2.TextScaled = true
button2.Parent = frame
Instance.new("UICorner", button2)

-- FUNCTIONALITY

-- Change text when clicked
button1.MouseButton1Click:Connect(function()
	textLabel.Text = "you clicked the button 😎"
end)

-- Close GUI when clicked
button2.MouseButton1Click:Connect(function()
	screenGui.Enabled = false
end)

-- Optional gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 0, 60)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10))
}
gradient.Rotation = 90
gradient.Parent = frame

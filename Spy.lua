--// SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DebugLogger"
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 250)
main.Position = UDim2.new(0, 20, 0.5, -125)
main.BackgroundColor3 = Color3.fromRGB(20,20,25)

Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

-- Toggle button
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0,40,0,40)
toggle.Position = UDim2.new(0,20,0.5,-20)
toggle.Text = "L"
toggle.BackgroundColor3 = Color3.fromRGB(170,90,255)

Instance.new("UICorner", toggle)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Remote Logs"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold

-- Scroll logs
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1,-10,1,-70)
scroll.Position = UDim2.new(0,5,0,35)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,5)

-- Clear button
local clear = Instance.new("TextButton", main)
clear.Size = UDim2.new(0,80,0,25)
clear.Position = UDim2.new(1,-90,1,-30)
clear.Text = "Clear"
clear.BackgroundColor3 = Color3.fromRGB(60,30,110)

Instance.new("UICorner", clear)

-- Toggle logic
main.Visible = true
toggle.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- Add log function
local function addLog(text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1,-10,0,20)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Text = text
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.fromRGB(200,200,200)
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 13
	lbl.Parent = scroll
	
	task.wait()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
	scroll.CanvasPosition = Vector2.new(0, layout.AbsoluteContentSize.Y)
end

-- Clear logs
clear.MouseButton1Click:Connect(function()
	for _, v in pairs(scroll:GetChildren()) do
		if v:IsA("TextLabel") then
			v:Destroy()
		end
	end
end)

--// REMOTE LOGGER (YOUR GAME ONLY)
for _, v in pairs(game:GetDescendants()) do
	if v:IsA("RemoteEvent") then
		v.OnClientEvent:Connect(function(...)
			addLog("[RemoteEvent] "..v.Name.." fired → "..game:GetService("HttpService"):JSONEncode({...}))
		end)
	end
	
	if v:IsA("RemoteFunction") then
		-- note: client can only log invoke responses if used locally
		addLog("[RemoteFunction Found] "..v.Name)
	end
end

addLog("Logger initialized.")

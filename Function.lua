--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// CONFIG
local CONFIG = {
	COLORS = {
		MAIN = Color3.fromRGB(170, 90, 255),
		BG = Color3.fromRGB(15, 15, 20),
		SIDEBAR_BG = Color3.fromRGB(12, 12, 16),
		DARK = Color3.fromRGB(10, 10, 14),
		BTN_INACTIVE = Color3.fromRGB(18, 18, 22),
		BTN_ACTIVE = Color3.fromRGB(60, 30, 110),
		CLOSE_BTN = Color3.fromRGB(255, 70, 120),
	},
	SIZES = {
		W = 430,
		H = 290,
		SIDE = 125,
		R = 12
	}
}

--// CLEAN OLD GUI
local old = playerGui:FindFirstChild("YuriHub")
if old then old:Destroy() end

--// GUI ROOT
local gui = Instance.new("ScreenGui")
gui.Name = "YuriHub"
gui.ResetOnSpawn = false
gui.Parent = playerGui

--// STATE
local running, paused, loopMode = false, false, false
local interval = 0.25

--// SAFE TELEPORT MODULE
local Movement = {}
function Movement.move(pos)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	hrp.AssemblyLinearVelocity = Vector3.zero
	hrp.AssemblyAngularVelocity = Vector3.zero
	hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
end

--// WORLD DATA
local World1 = {
	{Name="Lawless",Pos=Vector3.new(52.3,0.6,1814.5)},
	{Name="Ninja",Pos=Vector3.new(-1344.1,1604.4,1590.8)},
	{Name="Judgement",Pos=Vector3.new(-1265.8,1.4,-1191.8)},
	{Name="Academy",Pos=Vector3.new(1074.6,1.8,1276.2)},
	{Name="Slime",Pos=Vector3.new(-1124.2,13.9,372.6)},
}

local World2 = {
	{Name="Punch",Pos=Vector3.new(-1578.9,2.7,1847.7)},
	{Name="Bizarre",Pos=Vector3.new(-3075.8,7.5,-668.2)},
	{Name="Starter",Pos=Vector3.new(-325.4,-3.7,-122.0)},
}

--// UI HELPERS
local function mkFrame(p,s,pos,c)
	local f = Instance.new("Frame")
	f.Size = s
	f.Position = pos
	f.BackgroundColor3 = c
	f.BorderSizePixel = 0
	f.Parent = p
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, CONFIG.SIZES.R)
	return f
end

local function mkButton(p,s,pos,text)
	local b = Instance.new("TextButton")
	b.Size = s
	b.Position = pos
	b.Text = text
	b.BackgroundColor3 = CONFIG.COLORS.BTN_INACTIVE
	b.TextColor3 = CONFIG.COLORS.MAIN
	b.BorderSizePixel = 0
	b.Parent = p
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	return b
end

local function mkLabel(p,text,pos)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1,0,0,25)
	l.Position = pos
	l.Text = text
	l.BackgroundTransparency = 1
	l.TextColor3 = CONFIG.COLORS.MAIN
	l.Font = Enum.Font.Gotham
	l.TextSize = 14
	l.Parent = p
	return l
end

--// MAIN UI
local frame = mkFrame(gui,
	UDim2.new(0, CONFIG.SIZES.W, 0, CONFIG.SIZES.H),
	UDim2.new(0.5, -215, 0.5, -145),
	CONFIG.COLORS.BG
)

--// TOP
local top = mkFrame(frame, UDim2.new(1,0,0.18,0), UDim2.new(), CONFIG.COLORS.DARK)
mkLabel(top, "Hub ni Yuri", UDim2.new(0,10,0,0))

--// CLOSE / MINI
local close = mkButton(top, UDim2.new(0,25,0,25), UDim2.new(1,-40,0.5,-12), "X")

local mini = Instance.new("ImageButton")
mini.Size = UDim2.new(0,42,0,42)
mini.Position = UDim2.new(0,20,0.5,-21)
mini.BackgroundColor3 = CONFIG.COLORS.MAIN
mini.Visible = false
mini.Parent = gui
Instance.new("UICorner", mini).CornerRadius = UDim.new(0,6)

--// DRAG
local dragging, start, startPos

top.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		start = i.Position
		startPos = frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local d = i.Position - start
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + d.X,
			startPos.Y.Scale,
			startPos.Y.Offset + d.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

--// BODY
local body = mkFrame(frame, UDim2.new(1,0,0.82,0), UDim2.new(0,0,0.18,0), CONFIG.COLORS.BG)
body.BackgroundTransparency = 1

--// SIDEBAR
local sidebar = mkFrame(body, UDim2.new(0,CONFIG.SIZES.SIDE,1,0), UDim2.new(), CONFIG.COLORS.SIDEBAR_BG)

--// PAGE SYSTEM
local pageHolder = mkFrame(body, UDim2.new(1,-CONFIG.SIZES.SIDE,1,0), UDim2.new(0,CONFIG.SIZES.SIDE,0,0), CONFIG.COLORS.BG)

local pages = {}
local function newPage(name)
	local p = mkFrame(pageHolder, UDim2.new(1,0,1,0), UDim2.new(), CONFIG.COLORS.BG)
	p.Visible = false
	pages[name] = p
	return p
end

local Auto = newPage("Auto")
Auto.Visible = true

local function switch(tab)
	for n,p in pairs(pages) do
		p.Visible = (n == tab)
	end
end

--// TELEPORT SYSTEM
local function runWorld(world)
	running = true
	paused = false

	while running do
		for _,v in ipairs(world) do
			if not running then return end
			while paused do task.wait() end

			Movement.move(v.Pos)
			task.wait(interval)
		end

		if not loopMode then running = false end
	end
end

--// AUTO UI
mkButton(Auto, UDim2.new(0,200,0,35), UDim2.new(0,10,0,10), "World 1").MouseButton1Click:Connect(function()
	task.spawn(function() runWorld(World1) end)
end)

mkButton(Auto, UDim2.new(0,200,0,35), UDim2.new(0,10,0,55), "World 2").MouseButton1Click:Connect(function()
	task.spawn(function() runWorld(World2) end)
end)

mkButton(Auto, UDim2.new(0,200,0,35), UDim2.new(0,10,0,100), "Pause").MouseButton1Click:Connect(function()
	paused = not paused
end)

mkButton(Auto, UDim2.new(0,200,0,35), UDim2.new(0,10,0,145), "Stop").MouseButton1Click:Connect(function()
	running = false
	paused = false
end)

mkButton(Auto, UDim2.new(0,200,0,35), UDim2.new(0,10,0,190), "Loop").MouseButton1Click:Connect(function()
	loopMode = not loopMode
end)

--// INTERVAL CONTROL
mkLabel(Auto, "Interval: "..interval, UDim2.new(0,10,0,230))

mkButton(Auto, UDim2.new(0,95,0,30), UDim2.new(0,10,0,255), "-").MouseButton1Click:Connect(function()
	interval = math.clamp(interval - 0.05, 0.05, 2)
end)

mkButton(Auto, UDim2.new(0,95,0,30), UDim2.new(0,115,0,255), "+").MouseButton1Click:Connect(function()
	interval = math.clamp(interval + 0.05, 0.05, 2)
end)

--// CLOSE / MINI
close.MouseButton1Click:Connect(function()
	frame.Visible = false
	mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
	frame.Visible = true
	mini.Visible = false
end)

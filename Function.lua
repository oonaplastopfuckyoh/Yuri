--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

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
		FRAME_WIDTH = 430,
		FRAME_HEIGHT = 290,
		SIDEBAR_WIDTH = 125,
		CORNER_RADIUS = 12,
	}
}

--// PREVENT DUPLICATE GUI
local old = player:WaitForChild("PlayerGui"):FindFirstChild("YuriHub")
if old then old:Destroy() end

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "YuriHub"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

--// UI HELPERS
local function createFrame(parent, size, pos, bgColor, corner)
	local f = Instance.new("Frame")
	f.Size = size
	f.Position = pos
	f.BackgroundColor3 = bgColor
	f.BorderSizePixel = 0
	f.Parent = parent
	if corner then
		Instance.new("UICorner", f).CornerRadius = UDim.new(0, corner)
	end
	return f
end

local function createButton(parent, size, pos, text, bg, textColor, corner)
	local b = Instance.new("TextButton")
	b.Size = size
	b.Position = pos
	b.Text = text
	b.BackgroundColor3 = bg
	b.TextColor3 = textColor
	b.BorderSizePixel = 0
	b.Parent = parent
	if corner then
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, corner)
	end
	return b
end

local function createLabel(parent, text, size, pos, font, textSize, color)
	local l = Instance.new("TextLabel")
	l.Size = size
	l.Position = pos
	l.Text = text
	l.Font = font
	l.TextSize = textSize
	l.TextColor3 = color
	l.BackgroundTransparency = 1
	l.Parent = parent
	return l
end

--// MAIN FRAME
local frame = createFrame(
	gui,
	UDim2.new(0, CONFIG.SIZES.FRAME_WIDTH, 0, CONFIG.SIZES.FRAME_HEIGHT),
	UDim2.new(0.5, -215, 0.5, -145),
	CONFIG.COLORS.BG,
	CONFIG.SIZES.CORNER_RADIUS
)

--// TOP BAR
local topBar = createFrame(frame, UDim2.new(1,0,0.18,0), UDim2.new(), CONFIG.COLORS.DARK, CONFIG.SIZES.CORNER_RADIUS)
createLabel(topBar, "Hub ni Yuri", UDim2.new(1,0,1,0), UDim2.new(), Enum.Font.Arcade, 22, CONFIG.COLORS.MAIN)

--// CLOSE + MINI
local closeBtn = createButton(topBar, UDim2.new(0,24,0,24), UDim2.new(1,-40,0.5,-12), "×", CONFIG.COLORS.CLOSE_BTN, Color3.new(1,1,1), 6)

local mini = Instance.new("ImageButton")
mini.Size = UDim2.new(0,42,0,42)
mini.Position = UDim2.new(0,20,0.5,-21)
mini.BackgroundColor3 = CONFIG.COLORS.MAIN
mini.Visible = false
mini.Parent = gui
Instance.new("UICorner", mini).CornerRadius = UDim.new(0,6)

mini.Image = "rbxassetid://129240920074049"

--// BODY
local body = createFrame(frame, UDim2.new(1,0,0.82,0), UDim2.new(0,0,0.18,0), CONFIG.COLORS.BG)
local sidebar = createFrame(body, UDim2.new(0,CONFIG.SIZES.SIDEBAR_WIDTH,1,0), UDim2.new(), CONFIG.COLORS.SIDEBAR_BG, 10)

local pageHolder = createFrame(body, UDim2.new(1,-CONFIG.SIZES.SIDEBAR_WIDTH,1,0), UDim2.new(CONFIG.SIZES.SIDEBAR_WIDTH,0,0,0), CONFIG.COLORS.BG, 0)
pageHolder.BackgroundTransparency = 1

--// PAGES
local pages = {}

local function newPage(name)
	local p = createFrame(pageHolder, UDim2.new(1,0,1,0), UDim2.new(), CONFIG.COLORS.BG, 0)
	p.BackgroundTransparency = 1
	p.Visible = false
	pages[name] = p
	return p
end

local mainPage = newPage("main")
local Auto = newPage("Auto")
mainPage.Visible = true

--// SWITCH SYSTEM (FIXED)
local function switch(tab)
	for n,p in pairs(pages) do
		p.Visible = (n == tab)
	end
end

--// TELEPORT DATA
local World1 = {
	{Name="Lawless",Pos=Vector3.new(52.3,0.6,1814.5)},
	{Name="Ninja",Pos=Vector3.new(-1344.1,1604.4,1590.8)},
	{Name="Judgement",Pos=Vector3.new(-1265.8,1.4,-1191.8)},
}

local World2 = {
	{Name="Punch",Pos=Vector3.new(-1578.9,2.7,1847.7)},
	{Name="Bizarre",Pos=Vector3.new(-3075.8,7.5,-668.2)},
	{Name="Starter",Pos=Vector3.new(-325.4,-3.7,-122.0)},
}

--// TELEPORT
local function teleport(pos)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	hrp.AssemblyLinearVelocity = Vector3.zero
	hrp.AssemblyAngularVelocity = Vector3.zero
	hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
end

--// SYSTEM STATE
local running = false
local paused = false
local loopMode = false

--// FIXED FUNCTIONS (THIS WAS MISSING BEFORE)
local function startAuto(world)
	task.spawn(function()
		running = true
		paused = false

		while running do
			for _,v in ipairs(world) do
				if not running then return end
				while paused do task.wait(0.1) end
				teleport(v.Pos)
				task.wait(0.25)
			end
			if not loopMode then running = false end
		end
	end)
end

local function startInstant(world)
	task.spawn(function()
		for _,v in ipairs(world) do
			teleport(v.Pos)
			task.wait(0.1)
		end
	end)
end

local function pauseToggle()
	paused = not paused
end

local function stopAuto()
	running = false
	paused = false
end

local function toggleLoop()
	loopMode = not loopMode
end

--// AUTO BUTTONS
local function createAutoButton(text, y, callback)
	local btn = createButton(Auto, UDim2.new(0,200,0,35), UDim2.new(0,10,0,y), text, CONFIG.COLORS.BTN_INACTIVE, CONFIG.COLORS.MAIN, 6)
	btn.MouseButton1Click:Connect(callback)
end

createAutoButton("World 1 Auto TP", 10, function() startAuto(World1) end)
createAutoButton("World 2 Auto TP", 55, function() startAuto(World2) end)
createAutoButton("World 1 Instant TP", 100, function() startInstant(World1) end)
createAutoButton("World 2 Instant TP", 145, function() startInstant(World2) end)
createAutoButton("Pause / Resume", 190, pauseToggle)
createAutoButton("Stop", 235, stopAuto)
createAutoButton("Loop Toggle", 280, toggleLoop)

--// SIDEBAR BUTTON
local tabBtn = createButton(sidebar, UDim2.new(1,-10,0,30), UDim2.new(0,5,0,10), "Auto", CONFIG.COLORS.BTN_INACTIVE, CONFIG.COLORS.MAIN, 6)
tabBtn.MouseButton1Click:Connect(function()
	switch("Auto")
end)

--// CLOSE / MINI
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
	frame.Visible = true
	mini.Visible = false
end)

--// DRAG
local dragging, start, startPos

topBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		start = i.Position
		startPos = frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local d = i.Position - start
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)

UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

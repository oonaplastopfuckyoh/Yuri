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

--// REMOVE OLD GUI
local old = player:WaitForChild("PlayerGui"):FindFirstChild("YuriHub")
if old then old:Destroy() end

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "YuriHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// HELPERS
local function createFrame(parent, size, pos, bg, radius)
	local f = Instance.new("Frame")
	f.Size = size
	f.Position = pos
	f.BackgroundColor3 = bg
	f.BorderSizePixel = 0
	f.Parent = parent
	if radius then
		Instance.new("UICorner", f).CornerRadius = UDim.new(0, radius)
	end
	return f
end

local function createButton(parent, size, pos, text, bg, textColor, radius)
	local b = Instance.new("TextButton")
	b.Size = size
	b.Position = pos
	b.Text = text
	b.BackgroundColor3 = bg
	b.TextColor3 = textColor
	b.BorderSizePixel = 0
	b.Parent = parent
	if radius then
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, radius)
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
local frame = createFrame(gui,
	UDim2.new(0, CONFIG.SIZES.FRAME_WIDTH, 0, CONFIG.SIZES.FRAME_HEIGHT),
	UDim2.new(0.5, -215, 0.5, -145),
	CONFIG.COLORS.BG,
	CONFIG.SIZES.CORNER_RADIUS
)

--// TOPBAR
local topBar = createFrame(frame, UDim2.new(1,0,0.18,0), UDim2.new(0,0,0,0), CONFIG.COLORS.DARK, CONFIG.SIZES.CORNER_RADIUS)
createLabel(topBar, "Hub ni Yuri", UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), Enum.Font.Arcade, 22, CONFIG.COLORS.MAIN)

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
local body = createFrame(frame, UDim2.new(1,0,0.82,0), UDim2.new(0,0,0.18,0), CONFIG.COLORS.BG, 0)

--// SIDEBAR
local sidebar = createFrame(body, UDim2.new(0,CONFIG.SIZES.SIDEBAR_WIDTH,1,0), UDim2.new(0,0,0,0), CONFIG.COLORS.SIDEBAR_BG, 10)

local pageHolder = createFrame(body, UDim2.new(1,-CONFIG.SIZES.SIDEBAR_WIDTH,1,0), UDim2.new(0,CONFIG.SIZES.SIDEBAR_WIDTH,0,0), CONFIG.COLORS.BG, 0)
pageHolder.BackgroundTransparency = 1

local pages = {}

local function newPage(name)
	local p = createFrame(pageHolder, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), CONFIG.COLORS.BG, 0)
	p.BackgroundTransparency = 1
	p.Visible = false
	pages[name] = p
	return p
end

local main = newPage("main")
local Auto = newPage("Auto")
local PlayerP = newPage("Player")
local Webhook = newPage("Webhook")
local Misc = newPage("Misc")
local Config = newPage("Config")

main.Visible = true

local function switch(tab)
	for n,p in pairs(pages) do
		p.Visible = (n == tab)
	end
end

--// TELEPORT SYSTEM (AUTO FEATURE ADDED)
local function teleport(pos)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
end

--// WORLDS
local World1 = {
	{Name="Lawless",Pos=Vector3.new(52.3,0.6,1814.5)},
	{Name="Ninja",Pos=Vector3.new(-1344.1,1604.4,1590.8)},
	{Name="Judgement",Pos=Vector3.new(-1265.8,1.4,-1191.8)},
	{Name="Academy",Pos=Vector3.new(1074.6,1.8,1276.2)},
	{Name="Slime",Pos=Vector3.new(-1124.2,13.9,372.6)},
	{Name="Shinjaku 1",Pos=Vector3.new(-16.5,1.9,-1840.6)},
	{Name="Shinjaku 2",Pos=Vector3.new(668.3,1.9,-1696.0)},
	{Name="Shibuya",Pos=Vector3.new(1398.3,8.5,492.0)},
}

local World2 = {
	{Name="Punch",Pos=Vector3.new(-1578.9,2.7,1847.7)},
	{Name="Bizarre",Pos=Vector3.new(-3075.8,7.5,-668.2)},
	{Name="Starter",Pos=Vector3.new(-325.4,-3.7,-122.0)},
}

--// AUTO STATE
local running = false
local paused = false
local loopMode = false

--// AUTO LOOP (0.1s TP INTERVAL)
local function runWorld(world)
	running = true
	paused = false

	while running do
		for i=1,#world do
			if not running then return end

			while paused do task.wait(0.1) end

			teleport(world[i].Pos)
			task.wait(0.1)
		end

		if not loopMode then running = false end
	end
end

--// AUTO BUTTONS
local function makeBtn(text,y,func)
	local b = createButton(Auto,
		UDim2.new(0,200,0,35),
		UDim2.new(0,10,0,y),
		text,
		CONFIG.COLORS.BTN_INACTIVE,
		CONFIG.COLORS.MAIN,
		6
	)
	b.MouseButton1Click:Connect(func)
end

makeBtn("World 1 TP",10,function() runWorld(World1) end)
makeBtn("World 2 TP",55,function() runWorld(World2) end)

makeBtn("Pause / Resume",100,function()
	paused = not paused
end)

makeBtn("Stop",145,function()
	running = false
	paused = false
end)

makeBtn("Loop Mode",190,function()
	loopMode = not loopMode
end)

--// SIDEBAR TABS
local tabs = {
	{"🏠","main","Home"},
	{"⚡","Auto","Auto"},
	{"👤","Player","Player"},
	{"🌐","Webhook","Webhook"},
	{"•••","Misc","Misc"},
	{"⚙️","Config","Config"}
}

for _,t in ipairs(tabs) do
	local btn = createButton(sidebar,UDim2.new(1,-10,0,30),UDim2.new(0,0,0,0),
	"",CONFIG.COLORS.BTN_INACTIVE,CONFIG.COLORS.MAIN,8)

	createLabel(btn,t[1],UDim2.new(0,22,1,0),UDim2.new(0,8,0,0),Enum.Font.Gotham,14,CONFIG.COLORS.MAIN)
	createLabel(btn,t[3],UDim2.new(1,-40,1,0),UDim2.new(0,35,0,0),Enum.Font.Gotham,14,CONFIG.COLORS.MAIN)

	btn.MouseButton1Click:Connect(function()
		switch(t[2])
	end)
end

--// CLOSE / MINI
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
	frame.Visible = true
	mini.Visible = false
end)

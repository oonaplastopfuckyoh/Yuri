
--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "YuriHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

------------------------------------------------
--// UI SCALE SYSTEM
------------------------------------------------
local uiScale = Instance.new("UIScale")
uiScale.Parent = gui

local currentScale = 1
local function applyScale()
	uiScale.Scale = currentScale
end
applyScale()

------------------------------------------------
--// COLORS
------------------------------------------------
local FRAME_PURPLE = Color3.fromRGB(170,90,255)
local TEXT_PURPLE = Color3.fromRGB(210,170,255)

------------------------------------------------
--// MAIN FRAME
------------------------------------------------
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,420,0,280)
frame.Position = UDim2.new(0.5,-210,0.5,-140)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke")
stroke.Color = FRAME_PURPLE
stroke.Transparency = 0.4
stroke.Thickness = 2
stroke.Parent = frame

------------------------------------------------
--// TOP BAR
------------------------------------------------
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0.18,0)
topBar.BackgroundColor3 = Color3.fromRGB(0,0,0)
topBar.Parent = frame
Instance.new("UICorner",topBar).CornerRadius = UDim.new(0,12)

local topStroke = Instance.new("UIStroke")
topStroke.Color = FRAME_PURPLE
topStroke.Transparency = 0.8
topStroke.Thickness = 1
topStroke.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.Text = "Hub ni Yuri"
title.Font = Enum.Font.Arcade
title.TextSize = 22
title.TextColor3 = FRAME_PURPLE
title.BackgroundTransparency = 1
title.Parent = topBar

------------------------------------------------
--// MINIMIZED ICON (DRAGGABLE)
------------------------------------------------
local miniIcon = Instance.new("TextButton")
miniIcon.Size = UDim2.new(0,40,0,40)
miniIcon.Position = UDim2.new(0,20,0.5,-20)
miniIcon.Text = "Y"
miniIcon.BackgroundColor3 = FRAME_PURPLE
miniIcon.TextColor3 = Color3.fromRGB(255,255,255)
miniIcon.Font = Enum.Font.GothamBold
miniIcon.TextSize = 18
miniIcon.Visible = false
miniIcon.Parent = gui
Instance.new("UICorner",miniIcon).CornerRadius = UDim.new(1,0)

do
	local dragging=false
	local start,pos

	miniIcon.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			dragging=true
			start=i.Position
			pos=miniIcon.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
			local d=i.Position-start
			miniIcon.Position=UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			dragging=false
		end
	end)
end

------------------------------------------------
--// CLOSE BUTTON
------------------------------------------------
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,22,0,22)
closeBtn.Position = UDim2.new(1,-30,0.5,-11)
closeBtn.Text = "×"
closeBtn.BackgroundColor3 = Color3.fromRGB(255,70,120)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = topBar
Instance.new("UICorner",closeBtn).CornerRadius = UDim.new(1,0)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible=false
	miniIcon.Visible=true
end)

miniIcon.MouseButton1Click:Connect(function()
	frame.Visible=true
	miniIcon.Visible=false
end)

------------------------------------------------
--// BODY
------------------------------------------------
local body = Instance.new("Frame")
body.Size = UDim2.new(1,0,0.82,0)
body.Position = UDim2.new(0,0,0.18,0)
body.BackgroundColor3 = Color3.fromRGB(5,5,5)
body.Parent = frame

------------------------------------------------
--// SIDEBAR (PURPLE GRADIENT + LEFT ALIGN)
------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0.22,0,1,0)
sidebar.BackgroundColor3 = Color3.fromRGB(10,10,10)
sidebar.Parent = body

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20,10,35)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(45,20,70))
})
grad.Rotation = 90
grad.Parent = sidebar

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0,6)
list.HorizontalAlignment = Enum.HorizontalAlignment.Left
list.VerticalAlignment = Enum.VerticalAlignment.Center
list.Parent = sidebar

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0,10)
pad.PaddingLeft = UDim.new(0,6)
pad.Parent = sidebar

------------------------------------------------
--// PAGES
------------------------------------------------
local pages = {}

local function newPage(name)
	local p = Instance.new("Frame")
	p.Size = UDim2.new(0.78,0,1,0)
	p.Position = UDim2.new(0.22,0,0,0)
	p.BackgroundTransparency = 1
	p.Visible = false
	p.Parent = body
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
--// SIDEBAR BUTTONS (ICONS + LEFT ALIGN)
------------------------------------------------
local items = {
	{"Main","Main"},
	{"⚡ Auto","Auto"},
	{"👤 Player","Player"},
	{"🌐 Webhook","Webhook"},
	{"••• Misc","Misc"},
	{"⚙️ Config","Config"}
}

for _,v in ipairs(items) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.95,0,0,28)
	b.BackgroundColor3 = Color3.fromRGB(20,10,30)
	b.Text = "   " .. v[1]
	b.TextXAlignment = Enum.TextXAlignment.Left
	b.TextColor3 = TEXT_PURPLE
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.Parent = sidebar
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)

	if v[2] == "Main" then
		b.TextColor3 = FRAME_PURPLE
		b.BackgroundColor3 = Color3.fromRGB(35,15,60)
	end

	b.MouseButton1Click:Connect(function()
		switch(v[2])
	end)
end

------------------------------------------------
--// SIMPLE TOGGLES
------------------------------------------------
local function addToggle(parent,text,y)
	local f=Instance.new("Frame")
	f.Size=UDim2.new(0.9,0,0,30)
	f.Position=UDim2.new(0.05,0,0,y)
	f.BackgroundColor3=Color3.fromRGB(20,20,20)
	f.Parent=parent
	Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)

	local l=Instance.new("TextLabel")
	l.Size=UDim2.new(0.7,0,1,0)
	l.Text=text
	l.TextColor3=Color3.fromRGB(255,255,255)
	l.BackgroundTransparency=1
	l.Font=Enum.Font.Gotham
	l.TextSize=12
	l.TextXAlignment=Enum.TextXAlignment.Left
	l.Parent=f

	local b=Instance.new("TextButton")
	b.Size=UDim2.new(0,50,0,20)
	b.Position=UDim2.new(1,-60,0.5,-10)
	b.Text="OFF"
	b.BackgroundColor3=Color3.fromRGB(120,120,120)
	b.Parent=f
	Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)

	local state=false
	b.MouseButton1Click:Connect(function()
		state=not state
		if state then
			b.Text="ON"
			b.BackgroundColor3=FRAME_PURPLE
		else
			b.Text="OFF"
			b.BackgroundColor3=Color3.fromRGB(120,120,120)
		end
	end)
end

addToggle(Main,"Main Feature",20)
addToggle(Auto,"Auto Farm",20)
addToggle(PlayerP,"Speed",20)
addToggle(Webhook,"Webhook",20)
addToggle(Misc,"Misc",20)
addToggle(Config,"Config Save",90)

------------------------------------------------
--// UI SCALE SLIDER
------------------------------------------------
local label = Instance.new("TextLabel")
label.Size=UDim2.new(0.9,0,0,20)
label.Position=UDim2.new(0.05,0,0,20)
label.Text="UI Scale: 100%"
label.TextColor3=TEXT_PURPLE
label.BackgroundTransparency=1
label.Font=Enum.Font.Gotham
label.Parent=Config

local minus=Instance.new("TextButton")
minus.Size=UDim2.new(0,25,0,25)
minus.Position=UDim2.new(0.05,0,0,50)
minus.Text="-"
minus.Parent=Config

local plus=Instance.new("TextButton")
plus.Size=UDim2.new(0,25,0,25)
plus.Position=UDim2.new(0.15,0,0,50)
plus.Text="+"
plus.Parent=Config

local function update()
	uiScale.Scale=currentScale
	label.Text="UI Scale: "..math.floor(currentScale*100).."%"
end

minus.MouseButton1Click:Connect(function()
	currentScale=math.clamp(currentScale-0.1,0.5,1.5)
	update()
end)

plus.MouseButton1Click:Connect(function()
	currentScale=math.clamp(currentScale+0.1,0.5,1.5)
	update()
end)

update()

------------------------------------------------
--// DRAG UI
------------------------------------------------
do
	local dragging=false
	local start,pos

	topBar.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			dragging=true
			start=i.Position
			pos=frame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
			local d=i.Position-start
			frame.Position=UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			dragging=false
		end
	end)
end

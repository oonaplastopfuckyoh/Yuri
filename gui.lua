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

--// NOTIFICATION SYSTEM
local function notify(text)
	local n = Instance.new("Frame")
	n.Size = UDim2.new(0, 220, 0, 40)
	n.Position = UDim2.new(1, 0, 0, 20)
	n.BackgroundColor3 = Color3.fromRGB(30,30,45)
	n.Parent = gui
	Instance.new("UICorner", n).CornerRadius = UDim.new(0,10)

	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1,-10,1,0)
	t.Position = UDim2.new(0,10,0,0)
	t.BackgroundTransparency = 1
	t.Text = text
	t.TextColor3 = Color3.fromRGB(255,255,255)
	t.Font = Enum.Font.Gotham
	t.TextSize = 12
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = n

	TweenService:Create(n, TweenInfo.new(0.3), {
		Position = UDim2.new(1,-230,0,20)
	}):Play()

	task.delay(2, function()
		TweenService:Create(n, TweenInfo.new(0.3), {
			Position = UDim2.new(1,0,0,20),
			BackgroundTransparency = 1
		}):Play()
		task.wait(0.3)
		n:Destroy()
	end)
end

--// MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,420,0,280)
frame.Position = UDim2.new(0.5,-210,0.5,-140)
frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(180,120,255)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = frame

--// TOP BAR
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0.2,0)
topBar.BackgroundColor3 = Color3.fromRGB(35,25,55)
topBar.Parent = frame
Instance.new("UICorner",topBar).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "✨ Hub ni Yuri"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-32,0.5,-14)
closeBtn.Text = "×"
closeBtn.BackgroundColor3 = Color3.fromRGB(255,80,120)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = topBar
Instance.new("UICorner",closeBtn).CornerRadius = UDim.new(1,0)

--// BODY
local body = Instance.new("Frame")
body.Size = UDim2.new(1,0,0.8,0)
body.Position = UDim2.new(0,0,0.2,0)
body.BackgroundTransparency = 1
body.Parent = frame

--// SIDEBAR
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0.2,0,1,0)
sidebar.BackgroundColor3 = Color3.fromRGB(30,30,45)
sidebar.Parent = body
Instance.new("UICorner",sidebar).CornerRadius = UDim.new(0,10)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,6)
layout.Parent = sidebar

--// PAGES
local pages = {}

local function page(name)
	local p = Instance.new("Frame")
	p.Size = UDim2.new(0.8,0,1,0)
	p.Position = UDim2.new(0.2,0,0,0)
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

local function switch(tab)
	currentTab = tab
	for n,p in pairs(pages) do
		p.Visible = (n == tab)
	end
end

--// SIDEBAR BUTTONS
for _,t in ipairs({"Main","Auto","Player","Webhook","Misc","Config"}) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.9,0,0,28)
	b.BackgroundColor3 = Color3.fromRGB(45,45,70)
	b.Text = t
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.Parent = sidebar
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)

	b.MouseButton1Click:Connect(function()
		switch(t)
	end)
end

--// TOGGLES
local function toggle(parent,text,y)
	local state=false

	local f=Instance.new("Frame")
	f.Size=UDim2.new(1,-10,0,30)
	f.Position=UDim2.new(0,5,0,y)
	f.BackgroundColor3=Color3.fromRGB(40,40,60)
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
	b.TextColor3=Color3.fromRGB(255,255,255)
	b.Parent=f
	Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)

	b.MouseButton1Click:Connect(function()
		state=not state
		if state then
			b.Text="ON"
			b.BackgroundColor3=Color3.fromRGB(120,80,255)
		else
			b.Text="OFF"
			b.BackgroundColor3=Color3.fromRGB(120,120,120)
		end
	end)
end

--// WEBHOOK
local hookBox=Instance.new("TextBox")
hookBox.Size=UDim2.new(0.9,0,0,25)
hookBox.Position=UDim2.new(0.05,0,0,10)
hookBox.PlaceholderText="Webhook URL"
hookBox.Parent=Webhook

local msgBox=Instance.new("TextBox")
msgBox.Size=UDim2.new(0.9,0,0,25)
msgBox.Position=UDim2.new(0.05,0,0,45)
msgBox.PlaceholderText="Message"
msgBox.Parent=Webhook

local send=Instance.new("TextButton")
send.Size=UDim2.new(0.9,0,0,30)
send.Position=UDim2.new(0.05,0,0,80)
send.Text="Send Discord"
send.BackgroundColor3=Color3.fromRGB(120,80,255)
send.Parent=Webhook

send.MouseButton1Click:Connect(function()
	pcall(function()
		HttpService:PostAsync(
			hookBox.Text,
			HttpService:JSONEncode({content = msgBox.Text}),
			Enum.HttpContentType.ApplicationJson
		)
	end)
	notify("Sent to Discord")
end)

toggle(Webhook,"Testing 1",130)
toggle(Webhook,"Testing 2",165)
toggle(Webhook,"Testing 3",200)
toggle(Webhook,"Testing 4",235)

--// CLOSE
local open=true
closeBtn.MouseButton1Click:Connect(function()
	open=not open
	body.Visible=open
end)

--// DRAG
local dragging,st,pos

topBar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		dragging=true
		st=i.Position
		pos=frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(i)
	if dragging then
		local d=i.Position-st
		frame.Position=UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
	end
end)

UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		dragging=false
	end
end)

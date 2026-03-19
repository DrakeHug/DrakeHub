--
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--
local savedHive = nil
local open = true

--
local function getRoot()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end

local function saveHive()
	local root = getRoot()

	local closest
	local distance = math.huge

	for _, v in pairs(workspace:GetDescendants()) do
		if v.Name == "OriginPart" and v:IsA("BasePart") then
			local dist = (v.Position - root.Position).Magnitude
			if dist < distance then
				distance = dist
				closest = v
			end
		end
	end

	if closest then
		savedHive = closest
		print("Đã lưu hive!")
	else
		warn("Không tìm thấy hive!")
	end
end

local function teleportHive()
	if savedHive then
		local root = getRoot()
		root.CFrame = savedHive.CFrame + Vector3.new(0,3,0)
	else
		warn("Chưa lưu hive!")
	end
end

local function teleportTo(name)
	local root = getRoot()

	local obj = workspace:FindFirstChild(name, true)

	if obj then
		local part =
			obj:FindFirstChild("Platform", true)
			or (obj:IsA("BasePart") and obj)
			or obj:FindFirstChildWhichIsA("BasePart")

		if part then
			root.CFrame = part.CFrame + Vector3.new(0,5,0)
		else
			warn("Không tìm thấy part của:", name)
		end
	else
		warn("Không tìm thấy:", name)
	end
end

--GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProHub"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 650, 0, 400)
Main.Position = UDim2.new(0.5, -325, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

-- Gradient
local grad = Instance.new("UIGradient", Main)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,150)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,120,255))
}

-- Top
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1,0,0,40)
Top.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.Text = "Drake Hub"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0,160,1,-40)
Sidebar.Position = UDim2.new(0,0,0,40)
Sidebar.BackgroundColor3 = Color3.fromRGB(15,15,15)

-- Buttons
local function createSidebarButton(text, posY)
	local btn = Instance.new("TextButton", Sidebar)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, posY)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
	return btn
end

local saveBtn = createSidebarButton("💾 Lưu Spawn", 260)
local goBtn   = createSidebarButton("🚀 Về Spawn", 300)

saveBtn.MouseButton1Click:Connect(saveHive)
goBtn.MouseButton1Click:Connect(teleportHive)

-- Tabs
local function tabButton(text, y)
	local btn = Instance.new("TextButton", Sidebar)
	btn.Size = UDim2.new(1,-10,0,40)
	btn.Position = UDim2.new(0,5,0,y)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(35,35,40)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 15
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
	return btn
end

local TeleportTab = tabButton("🌍 Fields", 15)
local NPCTab = tabButton("🐻 NPC", 60)

-- Content
local Content = Instance.new("ScrollingFrame", Main)
Content.Position = UDim2.new(0, 160, 0, 40)
Content.Size = UDim2.new(1, -160, 1, -40)
Content.BackgroundTransparency = 1
Content.CanvasSize = UDim2.new(0,0,0,0)

local layout = Instance.new("UIListLayout", Content)
layout.Padding = UDim.new(0,5)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- Utils
local function clear()
	for _,v in pairs(Content:GetChildren()) do
		if not v:IsA("UIListLayout") then
			v:Destroy()
		end
	end
end

local function createItem(name)
	local btn = Instance.new("TextButton", Content)
	btn.Size = UDim2.new(1,-10,0,40)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(40,40,45)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

	btn.MouseButton1Click:Connect(function()
		teleportTo(name)
	end)
end

-- DATA
local fields = {
	"Bamboo Field","Blue Flower Field","Cactus Field","Coconut Field",
	"Clover Field","Dandelion Field","Sunflower Field","Mushroom Field",
	"Mountain Top Field","Spider Field","Strawberry Field","Rose Field",
	"Pine Tree Forest","Pumpkin Patch","Pepper Patch"
}

local npcs = {
	"Black Bear","Science Bear","Brown Bear","Spirit Bear",
	"Panda Bear","Polar Bear","Mother Bear","Honey Bee"
}

-- Loaders
local function loadFields()
	clear()
	Content.CanvasPosition = Vector2.new(0, 0)
	for _,v in pairs(fields) do
		createItem(v)
	end
end

local function loadNPC()
	clear()
	Content.CanvasPosition = Vector2.new(0, 0)
	for _,v in pairs(npcs) do
		createItem(v)
	end
end

TeleportTab.MouseButton1Click:Connect(loadFields)
NPCTab.MouseButton1Click:Connect(loadNPC)

loadFields()

--  (F1)
UIS.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.F1 then
		open = not open
		ScreenGui.Enabled = open
	end
end)

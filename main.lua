--
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--
local savedHive = nil
local open = true
--speed
local speedEnabled = false
local currentSpeed = 50
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
local function applySpeed()
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")

	if speedEnabled then
		humanoid.WalkSpeed = currentSpeed
	else
		humanoid.WalkSpeed = 16
	end
end

player.CharacterAdded:Connect(function()
	task.wait(1)
	applySpeed()
end)
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
Title.Text = "Drake Hug"
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
local MiscTab = tabButton("⚙️ Misc", 105)

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
local function loadMisc()
	clear()
	Content.CanvasPosition = Vector2.new(0, 0)

	--  (căn giữa)
	local frame = Instance.new("Frame", Content)
	frame.Size = UDim2.new(1, -10, 0, 60)
	frame.BackgroundTransparency = 1

	-- Toggle
	local toggle = Instance.new("TextButton", frame)
	toggle.Size = UDim2.new(0, 120, 0, 40)
	toggle.AnchorPoint = Vector2.new(0.5, 0.5)
	toggle.Position = UDim2.new(0.3, 0, 0.5, 0)
	toggle.Text = "Speed: OFF"
	toggle.BackgroundColor3 = Color3.fromRGB(40,40,45)
	toggle.TextColor3 = Color3.new(1,1,1)
	toggle.Font = Enum.Font.Gotham
	toggle.TextSize = 14

	local corner1 = Instance.new("UICorner")
	corner1.CornerRadius = UDim.new(0,8)
	corner1.Parent = toggle

	-- Input speed
	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(0, 100, 0, 40)
	box.AnchorPoint = Vector2.new(0.5, 0.5)
	box.Position = UDim2.new(0.7, 0, 0.5, 0)
	box.Text = tostring(currentSpeed)
	box.PlaceholderText = "Speed"
	box.BackgroundColor3 = Color3.fromRGB(30,30,30)
	box.TextColor3 = Color3.new(1,1,1)
	box.ClearTextOnFocus = false
	box.Font = Enum.Font.Gotham
	box.TextSize = 14

	local corner2 = Instance.new("UICorner")
	corner2.CornerRadius = UDim.new(0,8)
	corner2.Parent = box

	-- Toggle logic
	toggle.MouseButton1Click:Connect(function()
		speedEnabled = not speedEnabled
		toggle.Text = speedEnabled and "Speed: ON" or "Speed: OFF"
		applySpeed()
	end)

	-- Input logic
	box.FocusLost:Connect(function()
		local num = tonumber(box.Text)
		if num then
			currentSpeed = math.clamp(num, 16, 300)
			box.Text = tostring(currentSpeed)
			applySpeed()
		else
			box.Text = tostring(currentSpeed)
		end
	end)
end
MiscTab.MouseButton1Click:Connect(loadMisc)
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
applySpeed()
